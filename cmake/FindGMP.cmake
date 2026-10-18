# Locate GMP library (or MPIR on Windows)
# This module defines
#   GMP_FOUND
#   GMP_INCLUDE_DIR
#   GMP_LIBRARIES

find_path(GMP_INCLUDE_DIR NAMES gmp.h mpir.h)
find_library(GMP_LIBRARIES NAMES gmp libgmp mpir libmpir)
find_library(GMPXX_LIBRARIES NAMES gmpxx libgmpxx mpirxx libmpirxx)

include(FindPackageHandleStandardArgs)
# Only require GMP_INCLUDE_DIR and GMP_LIBRARIES (GMPXX is optional as the server uses only C gmp.h/mpz_t)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(GMP DEFAULT_MSG GMP_INCLUDE_DIR GMP_LIBRARIES)

mark_as_advanced(GMP_INCLUDE_DIR GMP_LIBRARIES GMPXX_LIBRARIES)
