/**
********************************************************************************
Copyright 2017 File Listing by Mark Skelton and Computer Know How, LLC
compknowhow.com
********************************************************************************

Author: Mark Skelton
Description: Intercepts media manager events
*/
component extends="coldbox.system.Interceptor" {
	property name="settingService"		inject="settingService@cb";
	property name="metadataService"		inject="entityService:Metadata";

	//after a file is uploaded resize and crop into the listing temp folder
	function fb_postFileUpload(event,interceptData) {
		//if it is a file listing folder
		if ( isFileListingFolder( interceptData.results.serverDirectory ) ) {
			//create the thumbnail and file files
			processFile( interceptData.results.serverDirectory, interceptData.results.serverFile );
		}
	}

	//after a filename modification replicate the name change in the listing temp folder
	function fb_postFileRename(event,interceptData) {
		//if it is a file listing folder
		if ( isFileListingFolder( getDirectoryFromPath( interceptData.original ) ) ) {
			//rename the files
			renameFile( getDirectoryFromPath( interceptData.original ), getFileFromPath( interceptData.original ), interceptData.newName );
		}
	}

	//after a folder is removed remove the files from the listing temp folder
	function fb_postFileRemoval(event,interceptData) {
		//if it is a file listing folder
		if ( isFileListingFolder( getDirectoryFromPath( interceptData.path ) ) ) {
			//delete the files
			deleteFile( getDirectoryFromPath( interceptData.path ), getFileFromPath( interceptData.path ) );
		}
	}

	//add a message box that tells them that this folder is a file listing folder
	function fb_preFileListing(event, interceptData) {
		var prc = event.getCollection(private=true);

		if( isFileListingFolder( prc.fbCurrentRoot ) ) {
			appendToBuffer('<div class="alert alert-warning"><strong>This folder is setup as a file listing folder.</strong>  Any files that are added to this folder will be processed by the "File Listing" module.</div>');
		}
	}

	//PRIVATE FUNCTIONS
	private function getFileListingSettings() {
		return deserializeJSON(settingService.getSetting( "fileListing" ));
	}

	private function getMediaRoot() {
		return replace(expandPath(settingService.getSetting('cb_media_directoryRoot')), "\", "/", "all");
	}

	private function getRelativeMediaRoot( folder ) {
		arguments.folder = replace(arguments.folder, "\", "/", "all");
		return replace(replace(arguments.folder, getMediaRoot(), "", "all"), "/", "", "all");
	}

	private function fileMetadataExists( folder, filename ) {
		var metaData = metadataService.list(criteria={
			folder=getRelativeMediaRoot(arguments.folder),
			filename=arguments.filename
		}, asQuery=false);

		return len(metaData);
	}

	private function getRegisteredFolders() {
		var folders = listToArray(getFileListingSettings().folders);
		var registeredFolders = [];
		var path = ""

		//register our manually created folders
		for(var folder in folders) {
			path = getMediaRoot() & "/" & folder;
			arrayAppend(registeredFolders, path);
		}

		return registeredFolders;
	}

	private function isFileListingFolder( folder ) {
		//check up the folder and traverse up the tree to see if any are file folders
		var found = false;

		//convert all '\' to '/'
		var folderToCheck = replace(arguments.folder, "\", "/", "all");

		while ( !found AND folderToCheck NEQ getMediaRoot() AND len(folderToCheck) GT len(getMediaRoot()) ) {
			if ( arrayFindNoCase( getRegisteredFolders(), folderToCheck ) ) { found = true; }
			//traverse up the folder tree
			folderToCheck = GetDirectoryFromPath( folderToCheck ).replaceFirst( "[\\\/]{1}$", "" );
		}

		return found;
	}

	private function processFile( folder, filename ) {
		// save if it metadata doesn't already exist
		if(!fileMetadataExists(arguments.folder, arguments.filename)) {
			var oMetadata = metadataService.get(0);
			oMetadata.setFolder(getRelativeMediaRoot(arguments.folder));
			oMetadata.setFilename(arguments.filename);
			oMetadata.setModified(createODBCDate(now()));
			metadataService.save( oMetadata );
		}
	}

	private function renameFile( folder, oldFilename, newFilename ) {
		//adjust the metadata to reflect the new filename
		var metaData = metadataService.list(criteria={
			folder=getRelativeMediaRoot(arguments.folder),
			filename=arguments.oldFilename
		}, asQuery=false);

		for(var data in metadata) {
			data.setFilename(arguments.newFilename);
			data.setModified(createODBCDate(now()));
			metadataService.save( data );
		}
	}

	private function deleteFile( folder, filename ) {
		//delete the metadata for the file
		var metaData = metadataService.list(criteria={
			folder=getRelativeMediaRoot(arguments.folder),
			filename=arguments.filename
		}, asQuery=false);

		for(var data in metadata) {
			metadataService.delete( data );
		}
	}
}
