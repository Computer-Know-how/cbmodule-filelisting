<cfoutput>
	#renderView( "viewlets/assets" )#
	<!--============================Main Column============================-->
	<div class="row">
		<div class="col-md-12">
			<h1 class="h1">
				<i class="fa fa-list"></i> Metadata
			</h1>
		</div>
	</div>

	<div class="row">
		<div class="col-md-9">
			<div class="panel panel-default">
				<div class="panel-body">
					<!--- MessageBox --->
					#getInstance("MessageBox@cbMessageBox").renderit()#

					<!--- Metadata --->
					#html.startForm(name="metadata",action="#cb.buildModuleLink('fileListing', prc.xehMetadataSave)#")#

					<!--- Filter Bar --->
					<div class="well well-sm">
						<div class="form-group form-inline no-margin">
							<input type="text"
								name="metadataFilter"
								size="30"
								class="form-control"
								placeholder="Quick Filter"
								id="metadataFilter">
						</div>
					</div>

					<!--- Metadata --->
					<table id="metadataTable" class="tablesorter table table-striped">
						<thead>
							<tr>
								<th>File Name</th>
								<th>Title</th>
								<th>Description</th>
								<th>Modified Date</th>
								<th width="75" class="center {sorter:false}">Actions</th>
							</tr>
						</thead>
						<tbody>
							<cfloop array="#prc.metadata#" index="file">
								<tr>
									<td>#file.getFileName()#</td>
									<td>#file.getTitle()#</td>
									<td>#file.getDescription()#</td>
									<td>#dateFormat(file.getModified(), "mm/dd/yyyy")#</td>
									<td class="center">
										<!--- Edit Command --->
										<div class="btn-group btn-group-sm">
											<a class="btn btn-primary" href="#cb.buildModuleLink('fileListing', prc.xehMetadataEditor)#/metadataID/#file.getMetadataID()#">
												<i class="fa fa-pencil"></i>
											</a>
										</div>

										<!--- Remove Command --->
										<div class="btn-group btn-group-sm">
											<a class="btn btn-danger" href="#cb.buildModuleLink('fileListing', prc.xehMetadataRemove)#/metadataID/#file.getMetadataID()#">
												<i class="fa fa-trash"></i>
											</a>
										</div>
									</td>
								</tr>
							</cfloop>
						</tbody>
					</table>
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
