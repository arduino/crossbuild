# Check
set(FTDI_BUILD_CPP False PARENT_SCOPE)

option ( FTDIPP "Build C++ binding library libftdi1++" ON )

# Targets
set(cpp_sources   ${CMAKE_CURRENT_SOURCE_DIR}/ftdi.cpp CACHE INTERNAL "List of cpp sources" )
set(cpp_headers   ${CMAKE_CURRENT_SOURCE_DIR}/ftdi.hpp CACHE INTERNAL "List of cpp headers" )
        
if (FTDIPP)

  if(Boost_FOUND)

    # Includes
    include_directories(BEFORE ${CMAKE_CURRENT_BINARY_DIR}
                        ${CMAKE_CURRENT_SOURCE_DIR}
                        ${CMAKE_SOURCE_DIR}/src)

    include_directories(${Boost_INCLUDE_DIRS})



    set(FTDI_BUILD_CPP True PARENT_SCOPE)
    message(STATUS "Building libftdi1++")
    if ( SHAREDLIBS )
      # Shared library
      add_library(ftdipp1 SHARED ${cpp_sources})

      math(EXPR VERSION_FIXUP "${MAJOR_VERSION} + 1")    # Compatiblity with previous releases
      set_target_properties(ftdipp1 PROPERTIES VERSION ${VERSION_FIXUP}.${MINOR_VERSION}.0 SOVERSION 3)

      # Prevent clobbering each other during the build
      set_target_properties(ftdipp1 PROPERTIES CLEAN_DIRECT_OUTPUT 1)

      # Dependencies
      target_link_libraries(ftdipp1 ftdi1 ${LIBUSB_LIBRARIES} ${BOOST_LIBRARIES})

      
      install ( TARGETS ftdipp1
                RUNTIME DESTINATION bin
                LIBRARY DESTINATION lib${LIB_SUFFIX}
                ARCHIVE DESTINATION lib${LIB_SUFFIX}
              )
    endif ()
            
    # Static library
    if ( STATICLIBS )
      add_library(ftdipp1-static STATIC ${cpp_sources})
      set_target_properties(ftdipp1-static PROPERTIES OUTPUT_NAME "ftdipp1")
      set_target_properties(ftdipp1-static PROPERTIES CLEAN_DIRECT_OUTPUT 1)

      install ( TARGETS ftdipp1-static
                ARCHIVE DESTINATION lib${LIB_SUFFIX}
                COMPONENT staticlibs
              )
    endif ()

    install ( FILES ${cpp_headers}
              DESTINATION include/${PROJECT_NAME}
              COMPONENT headers
            )

  else ()
    message(STATUS "Boost not found, won't build libftdi1++")
  endif ()

else ()
  message(STATUS "Not building libftdi1++")
endif ()
