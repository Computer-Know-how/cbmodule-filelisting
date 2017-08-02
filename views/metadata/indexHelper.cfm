<script>
	$(document).ready(function () {
		var $table = $('#metadataTable').DataTable({
			paging: false,
			info: false,
			columnDefs: [
				{
					orderable: false,
					targets: '{sorter:false}'
				}
			]
		})

		// quick filter
		$('#metadataFilter').on('keyup', function () {
			$table.search( this.value ).draw()
		})
	})
</script>
