locals {
  streams = {
    "vector": {
      "stream_type": "logs"
      "index_fields": ["service_stream"]
    },
    "host_boot_time": {
      "stream_type": "metrics"
    },
    "host_cpu_seconds_total": {
      "stream_type": "metrics"
    },
    "host_disk_read_bytes_total": {
      "stream_type": "metrics"
    },
    "host_disk_reads_completed_total": {
      "stream_type": "metrics"
    },
    "host_disk_writes_completed_total": {
      "stream_type": "metrics"
    },
    "host_disk_written_bytes_total": {
      "stream_type": "metrics"
    },
    "host_load1": {
      "stream_type": "metrics"
    },
    "host_load15": {
      "stream_type": "metrics"
    },
    "host_load5": {
      "stream_type": "metrics"
    },
    "host_logical_cpus": {
      "stream_type": "metrics"
    },
    "host_memory_active_bytes": {
      "stream_type": "metrics"
    },
    "host_memory_available_bytes": {
      "stream_type": "metrics"
    },
    "host_memory_buffers_bytes": {
      "stream_type": "metrics"
    },
    "host_memory_cached_bytes": {
      "stream_type": "metrics"
    },
    "host_memory_free_bytes": {
      "stream_type": "metrics"
    },
    "host_memory_oom_kill_events_total": {
      "stream_type": "metrics"
    },
    "host_memory_shared_bytes": {
      "stream_type": "metrics"
    },
    "host_memory_swap_free_bytes": {
      "stream_type": "metrics"
    },
    "host_memory_swap_total_bytes": {
      "stream_type": "metrics"
    },
    "host_memory_swap_used_bytes": {
      "stream_type": "metrics"
    },
    "host_memory_swapped_in_bytes_total": {
      "stream_type": "metrics"
    },
    "host_memory_swapped_out_bytes_total": {
      "stream_type": "metrics"
    },
    "host_memory_total_bytes": {
      "stream_type": "metrics"
    },
    "host_memory_used_bytes": {
      "stream_type": "metrics"
    },
    "host_network_receive_bytes_total": {
      "stream_type": "metrics"
    },
    "host_network_receive_errs_total": {
      "stream_type": "metrics"
    },
    "host_network_receive_packets_total": {
      "stream_type": "metrics"
    },
    "host_network_transmit_bytes_total": {
      "stream_type": "metrics"
    },
    "host_network_transmit_errs_total": {
      "stream_type": "metrics"
    },
    "host_network_transmit_packets_drop_total": {
      "stream_type": "metrics"
    },
    "host_network_transmit_packets_total": {
      "stream_type": "metrics"
    },
    "host_physical_cpus": {
      "stream_type": "metrics"
    },
    "host_uptime": {
      "stream_type": "metrics"
    },
    "nginx_connections_accepted_total": {
      "stream_type": "metrics"
    },
    "nginx_connections_active": {
      "stream_type": "metrics"
    },
    "nginx_connections_handled_total": {
      "stream_type": "metrics"
    },
    "nginx_connections_reading": {
      "stream_type": "metrics"
    },
    "nginx_connections_waiting": {
      "stream_type": "metrics"
    },
    "nginx_connections_writing": {
      "stream_type": "metrics"
    },
    "nginx_http_requests_total": {
      "stream_type": "metrics"
    },
    "nginx_up": {
      "stream_type": "metrics"
    },
  }
}

resource "openobserve_function" "vector_clear" {
  name = "vector_clear"

  function = <<-VRL
    del(.dropped_attributes_count)
    del(.instrumentation_library_name)
    del(.instrumentation_library_version)
    .
  VRL
}

resource "openobserve_stream" "streams" {
  for_each = local.streams

  name = each.key
  stream_type = each.value.stream_type

  data_retention = 0

  index_fields = try(each.value.index_fields, null)
}

resource "openobserve_pipeline" "streams_clear" {
  for_each = local.streams
  name        = "${each.key}_clear"
  description = "Strips unecessary fields from ${each.key} stream"
  stream_name = openobserve_stream.streams[each.key].name
  stream_type = openobserve_stream.streams[each.key].stream_type

  node {
    id          = "in"
    type        = "stream"
    stream_name = openobserve_stream.streams[each.key].name
    stream_type = openobserve_stream.streams[each.key].stream_type
  }

  node {
    id            = "clear"
    type          = "function"
    function_name = openobserve_function.vector_clear.name
  }

  node {
    id          = "out"
    type        = "stream"
    stream_name = openobserve_stream.streams[each.key].name
    stream_type = openobserve_stream.streams[each.key].stream_type
  }

  edge {
    from = "in"
    to   = "clear"
  }

  edge {
    from = "clear"
    to   = "out"
  }
}
