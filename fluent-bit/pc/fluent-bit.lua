function systemd_extractor(tag, timestamp, group, metadata, record)
    -- Maps PRIORITY to number and text
    local priority = record["PRIORITY"]
    if priority == nil then
        priority = 6
    else
        priority = tonumber(priority)
        record["PRIORITY"] = nil
    end

    local level_map = {
	    [0] = 24,
	    [1] = 21,
        [2] = 19,
	    [3] = 17,
	    [4] = 13,
	    [5] = 12,
	    [6] = 9,
	    [7] = 5
    }

    local severity_map = {
	    [0] = "FATAL",
	    [1] = "ALERT",
	    [2] = "CRITICAL",
	    [3] = "ERROR",
	    [4] = "WARN",
	    [5] = "NOTICE",
	    [6] = "INFO",
	    [7] = "DEBUG"
    }

    metadata["SeverityNumber"]= level_map[priority]
    metadata["SeverityText"]= severity_map[priority]

    --Rename per OTEL semantics
    local remapping_table = {
        ["HOSTNAME"] = "host.name",
        ["MACHINE_ID"] = "host.id",
        ["BOOT_ID"] = "boot_id",
        ["PID"] = "process.id",
        ["COMM"] = "process.title",
        ["EXE"] = "process.executable.path",
        ["CMDLINE"] = "process.command_line",
        ["SYSTEMD_UNIT"] = "process.linux.cgroup",
        ["CODE_FILE"] = "code.file.path",
        ["CODE_LINE"] = "code.line.number",
        ["CODE_FUNC"] = "code.function.name",
        ["TID"] = "thread.id",
        ["SYSLOG_IDENTIFIER"] = "service.name",
    }
    for key, value in pairs(remapping_table) do
        metadata[value] = record[key]
        record[key] = nil
    end

    -- Extract message's body and rest of attributes as `field.` prefixed attributes
    local message = {
    }
    for key, value in pairs(record) do
        if key == "MESSAGE" then
            message["message"] = value
        else
            metadata["field." .. string.lower(key)] = value
        end
    end


    return 2, timestamp, metadata, message
end
