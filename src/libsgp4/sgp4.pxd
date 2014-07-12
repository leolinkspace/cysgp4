from cython.operator cimport dereference as deref, preincrement as inc
from libcpp.string cimport string
from libcpp cimport bool
cimport cython


cdef extern from "Tle.h":
    cdef cppclass Tle:
        Tle(const string& name,const string& line_one, const string& line_two) except +
        string ToString() const
        string Name() const
        string Line1() const
        string Line2() const


cdef extern from "SGP4.h":
    cdef cppclass SGP4:
        SGP4(const Tle& tle) except +
        Eci FindPosition(const DateTime& date) const


cdef extern from "Observer.h":
    cdef cppclass Observer:
        Observer(const double latitude, const double longitude, const double altitude) except +
        CoordTopocentric GetLookAngle(const Eci &eci)
        void SetLocation(const CoordGeodetic& geo)
        CoordGeodetic GetLocation() const


cdef extern from "DateTime.h":
    cdef cppclass DateTime:
        DateTime() except +
        void Initialise(
            int year, int month, int day,
            int hour, int minute, int second, int microsecond
            )

        string ToString() const
        long long Ticks() const
    # how to wrap static c++ member functions???
    #cdef DateTime_Now 'DateTime::Now' (bool microseconds)


#cdef extern from "DateTime.h" namespace "DateTime":
    #DateTime Now(bool microseconds)


cdef extern from "Eci.h":
    cdef cppclass Eci:
        Eci(const DateTime& dt, const CoordGeodetic& geo) except +
        DateTime GetDateTime() const
        CoordGeodetic ToGeodetic() const


cdef extern from "CoordTopocentric.h":
    cdef cppclass CoordTopocentric:
        CoordTopocentric() except +
        CoordTopocentric(const CoordTopocentric& topo) except +
        string ToString() const
        # azimuth in radians
        double azimuth
        # elevations in radians
        double elevation
        # distance in kilometers
        double distance "range"
        # range rate in kilometers per second
        double distance_rate "range_rate"
        


cdef extern from "CoordGeodetic.h":
    cdef cppclass CoordGeodetic:
        CoordGeodetic() except +
        CoordGeodetic(const CoordGeodetic& geo) except +
        string ToString() const
        # latitude in radians (-PI >= latitude < PI)
        double latitude
        # latitude in radians (-PI/2 >= latitude <= PI/2)
        double longitude
        # altitude in kilometers
        double altitude




