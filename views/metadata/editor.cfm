<cfoutput>
	#renderView( "viewlets/assets" )#
	<!--============================Main Column============================-->
	<div class="row">
		<div class="col-md-12">
			<h1 class="h1">
				<i class="fa fa-file-o"></i>
				<cfif prc.metadata.isLoaded()>
					Editing "#prc.metadata.getFolder()#/#prc.metadata.getFilename()#"
				<cfelse>
					Create Metadata
				</cfif>
			</h1>
		</div>
	</div>

	<div class="row">
		<div class="col-md-9">
			<div class="panel panel-default">
				<div class="panel-body">
					#getInstance("messageBox@cbMessageBox").renderIt()#

					<!--- Metadata Details --->
					#html.startForm(name="metadata", action="#cb.buildModuleLink('fileListing',prc.xehMetadataSave)#", novalidate="novalidate")#
						#html.startFieldset(legend="Metadata Details")#
							#html.hiddenField(name="metadataID", bind=prc.metadata)#

							<div class="form-group">
								#html.textField(
									name="title",
									label="Title:",
									bind=prc.metadata,
									title="The title of the file.",
									class="form-control"
								)#
							</div>

							<div class="form-group">
								#html.textArea(
									name="description",
									label="Description:",
									bind=prc.metadata,
									title="The description of the file.",
									class="form-control"
								)#
							</div>

							<div class="form-group">
								#html.textField(
									name="modified",
									label="Modified Date:",
									value=dateFormat(prc.metadata.getModified(), "mm/dd/yyyy"),
									title="The modified date of the file.",
									class="form-control date-picker"
								)#
							</div>

							<div class="form-actions">
								<button class="btn" onclick="return to('#cb.buildModuleLink('fileListing', prc.xehMetadata)#')">Cancel</button>
								<input type="submit" value="Save" class="btn btn-danger">
							</div>
						#html.endFieldSet()#
					#html.endForm()#
				</div>
			</div>
		</div>

		<!--============================ Sidebar ============================-->
		<div class="col-md-3" id="main-sidebar">
			<cfinclude template="../sidebar/actions.cfm" >
			<cfinclude template="../sidebar/about.cfm" >
		</div>
	</div>
</cfoutput>
