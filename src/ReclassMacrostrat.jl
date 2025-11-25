## --- Set up 
    # LAST RUN: 3/29/25 -> DONE

    using RockWeatheringFlux
    using HDF5, Dates

    dir = "output/macrostrat/parsed"
    target = readdir(dir)

    for fname in target 
        @info "Starting: $fname $(Dates.format(now(), "HH:MM"))"

        oldfname = "$dir/$fname"
        newfname = "$dir/$(fname[1:end-3] * "_temp.h5")"

        oldfid = h5open(oldfname, "r")
        newfid = h5open(newfname, "w")

        # If the number of (lat,lon) points matches the number of data points, copy over 
        # If they're different, than truncate those values 
        if length(read(oldfid["vars"]["rocklat"])) == length(read(oldfid["vars"]["age"]))
            copy_object(oldfid, "vars", newfid, "vars")
        else 
            # Update lengths of lat, lon, elevations, and value of npoints 
            npoints = length(read(oldfid["vars"]["age"]))
            g = create_group(newfid, "vars")

            g["rocklat"] = read(oldfid["vars"]["rocklat"])[1:npoints]
            g["rocklon"] = read(oldfid["vars"]["rocklon"])[1:npoints]
            g["elevation"] = read(oldfid["vars"]["elevation"])[1:npoints]
            g["npoints"]  = npoints

            # Copy everything else 
            copy_object(oldfid, "vars/agemax", newfid, "vars/agemax")
            copy_object(oldfid, "vars/agemin", newfid, "vars/agemin")
            copy_object(oldfid, "vars/age", newfid, "vars/age")
            copy_object(oldfid, "vars/rocktype", newfid, "vars/rocktype")
            copy_object(oldfid, "vars/rockname", newfid, "vars/rockname")
            copy_object(oldfid, "vars/rockdescrip", newfid, "vars/rockdescrip")
            copy_object(oldfid, "vars/rockstratname", newfid, "vars/rockstratname")
            copy_object(oldfid, "vars/rockcomments", newfid, "vars/rockcomments")
            copy_object(oldfid, "vars/reference", newfid, "vars/reference")
        end

        # Just redo the type classification. This will make things easier if we decide to 
        # change how we classify rock types 
        bulktypes = create_group(newfid, "type")

        macrostrat = (
            rocktype = read(oldfid["vars"]["rocktype"]),
            rockname = read(oldfid["vars"]["rockname"]),
            rockdescrip = read(oldfid["vars"]["rockdescrip"]),
        )
        macro_cats = match_rocktype(macrostrat.rocktype, macrostrat.rockname, 
            macrostrat.rockdescrip, showprogress=false)
        metamorph_cats = find_metamorphics(macrostrat.rocktype, macrostrat.rockname, 
            macrostrat.rockdescrip, showprogress=false)

        a, head = cats_to_array(macro_cats)
        bulktypes["macro_cats"] = a
        bulktypes["macro_cats_head"] = head
        
        a, head = cats_to_array(metamorph_cats)
        bulktypes["metamorphic_cats"] = a

        # Close everything 
        close(oldfid)
        close(newfid)

        # Then delete the old file, and rename the new file 
        run(`rm $oldfname`)
        run(`mv $newfname $oldfname`)

        @info "Ended: $fname $(Dates.format(now(), "HH:MM"))"
    end


## --- End of file 