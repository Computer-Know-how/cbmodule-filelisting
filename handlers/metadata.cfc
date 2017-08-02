component extends="base" {

	// DI
	property name="settingService"		inject="settingService@cb";
	property name="metadataService"		inject="entityService:Metadata";
	property name="cb"					inject="cbHelper@cb";
	property name="messageBox"			inject="messageBox@cbMessageBox";

	function index(event,rc,prc){
		prc.metadata = metadataService.list(sortOrder="fileName ASC", asQuery=false);

		event.setView("metadata/index");
	}


	// metadata editor
	function editor(event,rc,prc){
		// get new or persisted metadata
		prc.metadata  = metadataService.get( event.getValue("metadataID", 0) );

		// view
		event.setView("metadata/editor");
	}


	// save metadata
	function save(event,rc,prc){
		if (structKeyExists(rc, "date")) {
			rc.date = createODBCDate(parseDateTime(rc.date, "mm/dd/yyyy"));
		}

		// get it and populate it
		var oMetadata = populateModel( metadataService.get(id=rc.metadataID) );

		// validate it
		var errors = oMetadata.validate();

		if( !arrayLen(errors) ){
			// save content
			metadataService.save( oMetadata );

			// message
			messageBox.info("metadata saved!");
			cb.setNextModuleEvent(module='fileListing', event=prc.xehMetadata);
		} else{
			flash.persistRC(exclude="event");
			messageBox.warn(messageArray=errors);
			cb.setNextModuleEvent(module='fileListing', event=prc.xehMetadataEditor, queryString="metadataID=#oMetadata.getMetadataID()#");
		}
	}


	// remove metadata
	function remove(event,rc,prc){
		var oMetadata = metadataService.get( rc.metadataID );

		if( isNull(oMetadata) ){
			messageBox.setMessage("warning", "Invalid metadata detected!");
			setNextEvent( prc.xehMetadata );
		}

		// remove
		metadataService.delete( oMetadata );

		// message
		messageBox.setMessage("info", "Metadata removed!");

		// redirect
		cb.setNextModuleEvent(module='fileListing', event=prc.xehmetadata);
	}


	// no data setup
	any function noDataSetup(event,rc,prc){
		event.setView("metadata/noDataSetup");
	}
}
