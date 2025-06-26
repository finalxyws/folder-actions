on adding folder items to targetFolder after receiving addedItems
	-- Define the time thresholds.
	set sevenDaysAgo to (current date) - (7 * days)
	set fourWeeksAgo to (current date) - (4 * weeks)
	
	-- A counter to limit how many items are marked red in a single run.
	set redLabelCount to 0
	
	tell application "Finder"
		-- Step 1: Clean up and re-label old items.
		-- This section iterates through all items in the folder.
		try
			set allItems to every item of targetFolder
			repeat with currentItem in allItems
				set itemModDate to modification date of currentItem
				
				-- Condition for items older than 4 weeks.
				if itemModDate < fourWeeksAgo then
					-- Mark up to 5 items with a red label (index 2).
					if redLabelCount < 5 and label index of currentItem is not 2 then
						set label index of currentItem to 2
						set redLabelCount to redLabelCount + 1
					end if
					
					-- Condition for items older than 7 days (but not older than 4 weeks).
				else if itemModDate < sevenDaysAgo then
					-- If it has a blue label (index 4), remove it.
					if label index of currentItem is 4 then
						set label index of currentItem to 0
					end if
				end if
			end repeat
		on error errMsg
			-- If an error occurs, log it.
			log "Error during item processing: " & errMsg
		end try
		
		-- Step 2: Set the blue label for newly added items.
		repeat with newItem in addedItems
			try
				set the label index of newItem to 4
			on error errMsg
				-- If setting the label for a new item fails, log the error.
				log "Error setting label for new item: " & errMsg
			end try
		end repeat
	end tell
end adding folder items to