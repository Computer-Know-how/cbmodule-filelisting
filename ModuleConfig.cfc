/**
********************************************************************************
Copyright 2017 File Listing by Mark Skelton and Computer Know How, LLC
compknowhow.com
********************************************************************************

Author: Mark Skelton
Description: Creates File Listings for your ContentBox website
*/
component {

	// Module Properties
	this.title 				= "File Listing";
	this.author 			= "Computer Know How, LLC";
	this.webURL 			= "https://compknowhow.com";
	this.description 		= "A file listing for your ContentBox website";
	this.version			= "1.1";
	// If true, looks for views in the parent first, if not found, then in the module. Else vice-versa
	this.viewParentLookup 	= true;
	// If true, looks for layouts in the parent first, if not found, then in module. Else vice-versa
	this.layoutParentLookup = true;
	// Module Entry Point
	this.entryPoint			= "fileListing";

	function configure(){

		// module settings - stored in modules.name.settings
		settings = {
			folders: ""
		};

		// SES Routes
		routes = [
			{pattern="/", handler="metadata",action="index"},
			// Convention Route
			{pattern="/:handler/:action?"}
		];

		// Interceptors
		interceptors = [
			{
				class="#moduleMapping#.interceptors.FileBrowser",
				properties={ entryPoint="cbadmin" },
				name="FileBrowser@"
			}
		];
	}

	/**
	* Fired when the module is registered and activated.
	*/
	function onLoad(){
		// ContentBox loading
		if( structKeyExists( controller.getSetting("modules"), "contentbox" ) ){
			var menuService = controller.getWireBox().getInstance("AdminMenuService@cb");

			// Add the 'File Listing' contribution to the module menu
			menuService.addSubMenu(
				topMenu=menuService.MODULES,
				name="FileListing",
				label="File Listing",
				href="#menuService.buildModuleLink('FileListing', 'metadata.index')#"
			);
		}
	}

	/**
	* Fired when the module is activated by ContentBox
	*/
	function onActivate(){
		var settingService = controller.getWireBox().getInstance("SettingService@cb");

		// Store default settings
		var findArgs = {name="fileListing"};
		var setting = settingService.findWhere(criteria=findArgs);
		if( isNull(setting) ){
			var args = {name="fileListing", value=serializeJSON( settings )};
			var fileListingSettings = settingService.new(properties=args);
			settingService.save( fileListingSettings );
		}

		// Flush the settings cache so our new settings are reflected
		settingService.flushSettingsCache();
	}

	/**
	* Fired when the module is unregistered and unloaded
	*/
	function onUnload(){
		// ContentBox unloading
		if( structKeyExists( controller.getSetting("modules"), "contentbox" ) ){
			var menuService = controller.getWireBox().getInstance("AdminMenuService@cb");

			// Remove the 'File Listing' contribution from the module menu
			menuService.removeSubMenu(topMenu=menuService.MODULES,name="FileListing");
		}
	}

	/**
	* Fired when the module is deactivated by ContentBox
	*/
	function onDeactivate(){
		var settingService = controller.getWireBox().getInstance("SettingService@cb");

		var args = {name="fileListing"};
		var setting = settingService.findWhere(criteria=args);
		if( !isNull(setting) ){
			settingService.delete( setting );
		}

		// Flush the settings cache so our new settings are reflected
		settingService.flushSettingsCache();
	}

}
