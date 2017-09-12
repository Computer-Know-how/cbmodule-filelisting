/**
* A widget that renders a listing of the files in a folder.
*/
component extends="contentbox.models.ui.BaseWidget" singleton{
	property name="metadataService" inject="entityService:Metadata";

	FileListing function init(controller){
		// super init
		super.init(controller);

		// Widget Properties
		setName("FileListing");
		setVersion("1.0");
		setDescription("A module that renders a listing of the files in a folder.");
		setForgeBoxSlug("cbmodule-filelisting");
		setAuthor("Computer Know How, LLC");
		setAuthorURL("https://compknowhow.com");
		setIcon("list");
		setCategory("Utilities");

		return this;
	}

	/**
	* Renders a file list
	* @folder.hint The folder (relative to the ContentBox content root) from which to list the files (meetings/minutes)
	* @filter.hint A file extension filter to apply (*.pdf)
	* @sort.hint The sort field (FileName, Title, Size, DateLastModified)
	* @order.hint The sort order of the files listed (ASC/DESC)
	* @class.hint Class(es) to apply to the listing table
	* @showIcons.hint Show file type icons (FontAwesome required)
	*/
	any function renderIt(
		string folder,
		string filter="*",
		string sort="FileName",
		string order="ASC",
		string class="",
		boolean showDescription=false,
		boolean showIcons=false
	){
		arguments.sort = (arguments.sort == "DateLastModified" ? "modified" : arguments.sort);

		var event = getRequestContext();
		var cbSettings = event.getValue(name="cbSettings",private=true);
		var sortOrder = arguments.sort & " " & arguments.order;
		var mediaRoot = expandPath(cbSettings.cb_media_directoryRoot);
		var mediaPath = cbSettings.cb_media_directoryRoot & "/" & arguments.folder;
		var mediaPathExpanded = expandPath(mediaPath);
		var displayMediaPath = "__media";
		if (arguments.folder neq "") { displayMediaPath &= "/" & arguments.folder; }

		//security check - can't be higher then the media root
		if(!findNoCase(mediaRoot, mediaPathExpanded)){
			return "This widget is restricted to the ContentBox media root.  All file lists must be contained within that directory.";
		}

		if (directoryExists(mediaPathExpanded)) {
			var listing = metadataService.findAllWhere({ folder: replace(arguments.folder, "\", "/", "all") }, sortOrder);

			// generate file listing
			saveContent variable="rString"{
				// container (start)
				writeOutput('<div class="cb-filelisting">');

				if( arrayLen(listing) gt 0 ){
					writeOutput('
						<table class="#class#">
							<thead>
								<tr>
									<th class="cb-filelisting-name">
										Name
									</th>
					');

					if (arguments.showDescription) {
						writeOutput('
							<th class="cb-filelisting-description">
								Description
							</th>
						');
					}

					writeOutput('
									<th class="cb-filelisting-size">
										Size
									</th>
									<th class="cb-filelisting-modified">
										Modified
									</th>
								</tr>
							</thead>
							<tbody>
					');

					for (var x=1; x lte arrayLen(listing); x++) {
						// row
						writeOutput('
							<tr>
								<td class="cb-filelisting-name">');

						var link = event.buildLink(displayMediaPath) & "/" & listing[x].getFileName();

						if(showIcons) {
							writeOutput('<a href="#link#" target="_blank">' & fileIcon(listLast(listing[x].getFileName(),".")) & '</a> <a href="#link#" target="_blank">');

							if (listing[x].getTitle() neq "") {
								writeOutput(listing[x].getTitle());
							} else {
								writeOutput(listing[x].getFileName());
							}

							writeOutput('</a>');
						} else {
							writeOutput('<a href="#link#" target="_blank">');

							if (listing[x].getTitle() neq "") {
								writeOutput(listing[x].getTitle());
							} else {
								writeOutput(listing[x].getFileName());
							}

							writeOutput('</a>');
						}

						if (arguments.showDescription) {
							writeOutput('<td class="cb-filelisting-description">');
								writeOutput(listing[x].getDescription());
							writeOutput('</td>');
						}

						writeOutput('
								</td>
								<td class="cb-filelisting-size">
									#formatFileSize(listing[x].getSize())#
								</td>
								<td class="cb-filelisting-modified">');

								writeOutput(dateFormat(listing[x].getModified(), 'm/d/yyyy'));
						writeOutput('
								</td>
							</tr>
						');
					}

					writeOutput('
							</tbody>
						</table>
					');
				} else {
					writeOutput('
						<div class="no-records">
							No files to display
						</div>
					');
				}

				// container (end)
				writeOutput('</div>');
			}

			return rString;

		} else {
			return "The folder could not be found for listing";
		}

	}

	private string function formatFilter(required filter){
		return REReplace(replace(arguments.filter," ",""),",","|");
	}

	private string function formatFileSize(required fileSize){
		var formattedFileSize = "";

		if (not isNumeric(arguments.fileSize)) {
			return "-----";
		}

		if( arguments.fileSize LT 1024 ) {
			formattedFileSize = decimalFormat(arguments.fileSize / 1024) & " KB"
		} else if( arguments.fileSize GTE 1024 and arguments.fileSize LT 1048576) {
			formattedFileSize = decimalFormat(arguments.fileSize / 1024) & " KB"
		} else if( arguments.fileSize GTE 1048576 and arguments.fileSize LT 1073741824) {
			formattedFileSize = decimalFormat(arguments.fileSize / 1048576) & " MB"
		} else if( arguments.fileSize GTE 1073741824) {
			formattedFileSize = decimalFormat(arguments.fileSize / 1073741824) & " GB"
		}

		return formattedFileSize;
	}

	private string function fileIcon(required fileExtension){
		var iconString = "";

		switch(arguments.fileExtension) {
			case "mp3": case "wav": case "m4a":
				iconString = "<i class='fa fa-file-audio-o'></i>";
				break;

			case "mp4": case "mpeg": case "mpg": case "wmv": case "mov":
				iconString = "<i class='fa fa-file-video-o'></i>";
				break;

			case "pdf":
				iconString = "<i class='fa fa-file-pdf-o'></i>";
				break;

			case "doc": case "docx":
				iconString = "<i class='fa fa-file-word-o'></i>";
				break;

			case "jpg": case "gif": case "png": case "bmp":
				iconString = "<i class='fa fa-file-image-o'></i>";
				break;

			case "ppt": case "pptx":
				iconString = "<i class='fa fa-file-powerpoint-o'></i>";
				break;

			case "doc": case "docx":
				iconString = "<i class='fa fa-file-word-o'></i>";
				break;

			case "xls": case "xlsx":
				iconString = "<i class='fa fa-file-excel-o'></i>";
				break;

			case "zip": case "gz":
				iconString = "<i class='fa fa-file-archive-o'></i>";
				break;

			case "html": case "htm":
				iconString = "<i class='fa fa-file-code-o'></i>";
				break;

			case "txt":
				iconString = "<i class='fa fa-file-text-o'></i>";
				break;

			default
				iconString = "<i class='fa fa-file-o'></i>";
		}

		return iconString;
	}

	private function getFileMetadata( mediaRoot, folder, filename ) {
		var metadata = metadataService.list(criteria={
			folder=getRelativeMediaRoot(arguments.mediaRoot, arguments.folder),
			filename=arguments.filename
		}, asQuery=false);

		return len(metadata) ? metadata[1] : metadataService.new();
	}

	private function getRelativeMediaRoot( mediaRoot, folder ) {
		arguments.folder = replace(arguments.folder, "\", "/", "all");
		var mediaRoot = replace(arguments.mediaRoot, "\", "/", "all");
		return replace(replace(arguments.folder, mediaRoot, "", "all"), "/", "", "all");
	}
}
