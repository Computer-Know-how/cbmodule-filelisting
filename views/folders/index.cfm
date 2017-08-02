<cfoutput>
	#renderView( "viewlets/assets" )#
	<!--============================Main Column============================-->
	<div class="row">
		<div class="col-md-12">
			<h1 class="h1">
				<i class="fa fa-folder-open-o"></i> Folders
			</h1>
		</div>
	</div>

	<div class="row">
		<div class="col-md-9">
			<div class="panel panel-default">
				<div class="panel-body">
					<!--- MessageBox --->
					#getInstance("MessageBox@cbMessageBox").renderit()#

					<!--- Folders --->
					#html.startForm(action="#cb.buildModuleLink('fileListing', prc.xehFoldersSave)#")#
						#html.startFieldset(legend="<i class='fa fa-folder-open-o'></i> Folders")#
							<cfif prc.contentFolders.recordCount GT 0>
								<ul class="galleryFolderTree">
									<cfloop query="prc.contentFolders">
										<li>
											<cfset folder = ReplaceNoCase(replace(lcase(path),"\","/","all"), replace(lcase(prc.mediaRoot),"\","/","all"), "")>

											<cfif listFindNoCase(prc.folders, folder)>
												<input type="checkbox" name="folders" value="#folder#" checked> #folder#
											<cfelse>
												<input type="checkbox" name="folders" value="#folder#"> #folder#
											</cfif>
										</li>
									</cfloop>
								</ul>
							<cfelse>
								<div class="alert alert-error clearfix">
									<i class="icon-warning-sign icon-large"></i>
									<i>Sorry, no folders to list. Add folders to your "Media Manager" and then select those folders as galleries here.</i>
								</div>
							</cfif>
						#html.endFieldSet()#

						<cfif prc.contentFolders.recordCount GT 0>
							<!--- Button Bar --->
							<div class="form-actions">
								#html.submitButton(value="Save Folders", class="btn btn-danger")#
							</div>
						</cfif>
					#html.endForm()#
				</div>
			</div>
		</div>

		<!--============================ Sidebar ============================-->
		<div class="col-md-3" id="main-sidebar">
			<cfinclude template="../sidebar/actions.cfm">
			<cfinclude template="../sidebar/about.cfm">
		</div>
	</div>
</cfoutput>
