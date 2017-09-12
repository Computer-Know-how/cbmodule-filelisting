/**
********************************************************************************
Copyright 2017 Metadata Listing by Mark Skelton and Computer Know How, LLC
compknowhow.com
********************************************************************************

Author: Mark Skelton
Description: Metadata ORM object
*/
component persistent="true" table="cb_filelisting_metadata" {

	// Primary Key
	property name="metadataID" fieldtype="id" column="metadataID" generator="identity" setter="false";

	// Properties
	property name="folder" notnull="true" length="200" default="";
	property name="filename" notnull="true" length="200" default="";
	property name="title" notnull="false" length="200" default="";
	property name="description" notnull="false" length="2000" default="";
	property name="modified" notnull="false" ormType="timestamp";
	property name="size" notnull="false" length="20" default="";

	// Constructor
	function init(){
		return this;
	}

	boolean function isLoaded(){
		return len( getMetadataID() );
	}

	array function validate(){
		var errors = [];

		// Lengths
		if(len(folder) gt 200) { arrayAppend(errors, "Folder is too long"); }
		if(len(filename) gt 200) { arrayAppend(errors, "Filename is too long"); }
		if(len(title) gt 2000) { arrayAppend(errors, "Title is too long"); }
		if(len(description) gt 2000) { arrayAppend(errors, "Description is too long"); }
		if(len(size) gt 20) { arrayAppend(errors, "Size is too long"); }

		// Required
		if( !len(folder) ){ arrayAppend(errors, "Folder is required"); }
		if( !len(filename) ){ arrayAppend(errors, "Filename is required"); }

		return errors;
	}
}
