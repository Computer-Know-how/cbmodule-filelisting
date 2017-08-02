/**
********************************************************************************
Copyright 2017 File Listing by Mark Skelton and Computer Know How, LLC
compknowhow.com
********************************************************************************

Author: Mark Skelton
Description: Base handler for the file listing module
*/
component{

	// pre handler
	function preHandler(event,action,eventArguments){
		var rc 	= event.getCollection();
		var prc = event.getCollection(private=true);

		// Get module root
		prc.moduleRoot = event.getModuleRoot("fileListing");

		// Exit points
		prc.xehMetadata = "metadata.index";
		prc.xehMetadataEditor = "metadata.editor";
		prc.xehMetadataSave = "metadata.save";
		prc.xehMetadataRemove = "metadata.remove";

		// Exit points
		prc.xehFolders = "folders.index";
		prc.xehFoldersSave = "folders.save";
	}
}
