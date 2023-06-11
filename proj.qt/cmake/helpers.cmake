function(MakeReadableListOfSources sources)
    set(result)
    foreach(source ${${sources}})
        set(item ${source})
        string(REPLACE "${CMAKE_SOURCE_DIR}/" "" item ${item})
        list(APPEND result
                ${item}
                )
    endforeach()
    SET(${sources} ${result} PARENT_SCOPE)
endfunction()