gfortran -o a.exe test.f90 libmsmpi.a -D INT_PTR_KIND()=8 -fno-range-check
