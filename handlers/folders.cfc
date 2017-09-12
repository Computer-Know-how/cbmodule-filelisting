/**
********************************************************************************
Copyright 2017 File Listing by Mark Skelton and Computer Know How, LLC
compknowhow.com
********************************************************************************

Author: Mark Skelton
Description: Folders handler
*/
component extends="base" {
	property name="settingService"		inject="settingService@cb";
	property name="cb"					inject="cbHelper@cb";
	property name="metadataService"		inject="entityService:Metadata";

	function index(event,rc,prc){
		var cbSettings = event.getValue(name="cbSettings", private=true);
		var oSetting = settingService.findWhere( { name="fileListing" } );
		var settings = deserializeJSON(oSetting.getValue());

		// Get the paths
		prc.mediaRoot = expandPath(cbSettings.cb_media_directoryRoot & "\");
		prc.folders = settings.folders;

		// Get the directory listing of our media root
		var mediaRootDirectories = directoryList(prc.mediaRoot, true, "query", "*", "Directory ASC");

		// Setup a new query to filter the media root results
		var query = new Query();
		query.setAttributes(directoryListing = mediaRootDirectories);
		var qryFilteredFolderList = query.execute(sql="select directory + '\' + name as path from directoryListing where type = 'Dir'", dbtype="query");
		prc.contentFolders = qryFilteredFolderList.getResult();

		event.setView("folders/index");
	}

	function save(event,rc,prc){
		param name="rc.folders" default="";
		var cbSettings = event.getValue(name="cbSettings", private=true);
		var oSetting = settingService.findWhere( { name="fileListing" } );

		incomingSetting = serializeJSON({ "folders" = rc.folders });

		var newSetting = deserializeJSON(incomingSetting);
		var existingSettings = deserializeJSON(oSetting.getValue());

		// Append the new settings sent in to the existing settings (overwrite)
		structAppend(existingSettings, newSetting);

		oSetting.setValue( serializeJSON(existingSettings) );
		settingService.save( oSetting );

		// Flush the settings cache so our new settings are reflected
		settingService.flushSettingsCache();

		addMetadata(rc.folders, cbSettings);

		getInstance("messageBox@cbMessageBox").info("Folders Saved & Updated!");
		cb.setNextModuleEvent("fileListing", "folders.index");
	}

	private function addMetadata(folders, cbSettings) {
		var mediaRoot = expandPath(cbSettings.cb_media_directoryRoot & "\");

		for (var folder in arguments.folders) {
			var fileList = directoryList(mediaRoot & folder, false, "query");

			for (var file in fileList) {
				if (file.type == "File" && !fileMetadataExists(folder, file.name)) {
					var oMetadata = metadataService.get(0);
					oMetadata.setFolder(getRelativeMediaRoot(folder));
					oMetadata.setFilename(file.name);
					oMetadata.setModified(createODBCDate(now()));
					oMetadata.setSize(file.size);
					metadataService.save(oMetadata);
				}
			}
		}
	}

	private function fileMetadataExists( folder, filename ) {
		var metaData = metadataService.list(criteria={
			folder=getRelativeMediaRoot(arguments.folder),
			filename=arguments.filename
		}, asQuery=false);

		return len(metaData);
	}

	private function getRelativeMediaRoot( folder ) {
		arguments.folder = replace(arguments.folder, "\", "/", "all");
		var mediaRoot = replace(expandPath(settingService.getSetting('cb_media_directoryRoot')), "\", "/", "all");
		return replace(arguments.folder, mediaRoot, "", "all");
	}
}
