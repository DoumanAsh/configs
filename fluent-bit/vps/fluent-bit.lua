function pri_extractor(tag, timestamp, group, metadata, record)
    priority = tonumber(record["pri"]);

    facility = math.floor(priority / 8)
    severity = priority % 8

    local level_map = {
	    [0] = "emerg",
	    [1] = "alert",
	    [2] = "critical",
	    [3] = "error",
	    [4] = "warning",
	    [5] = "notice",
	    [6] = "info",
	    [7] = "debug"
    }

    local facility_map = {
	    [0] = "kern",
	    [1] = "user",
	    [2] = "mail",
	    [3] = "daemon",
	    [4] = "auth",
	    [5] = "syslog",
	    [6] = "lpr",
	    [7] = "news",
	    [8] = "uucp",
	    [9] = "cron",
	    [10] = "authpriv",
	    [11] = "ftp",
	    [12] = "ntp",
	    [13] = "security",
	    [14] = "console",
	    [15] = "solaris-cron",
	    [16] = "local0",
	    [17] = "local1",
	    [18] = "local2",
	    [19] = "local3",
	    [20] = "local4",
	    [21] = "local5",
	    [22] = "local6",
	    [23] = "local7"
    }

    metadata["severity"]= level_map[severity]
    metadata["facility"]= facility_map[facility]
    return 2, timestamp, metadata, record
end
