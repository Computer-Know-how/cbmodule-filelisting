<cfoutput>
	#renderView( "viewlets/assets" )#
	<div class="row-fluid">
		<div class="col-md-9">
			<div class="box">
				<!--- Body --->
				<div class="body">
					<h3>No File Listing tables found</h3>
					#getInstance( "MessageBox@cbmessagebox" ).renderMessage( "warning", "There are no tables or data setup for File Listing, please install them manually or switch your ORM setting to update in your application CFC and reload ORM" )#
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
