program hello_parallel

      use mpi
      !implicit none
      !include 'mpif.h'

      integer::procs,rank,ierr
      character(MPI_MAX_PROCESSOR_NAME)::host
      integer::hostlen
      call MPI_INIT(ierr)
      call MPI_COMM_SIZE(MPI_COMM_WORLD,procs,ierr) 
      call MPI_COMM_RANK(MPI_COMM_WORLD,rank,ierr)
      call MPI_GET_PROCESSOR_NAME(host,hostlen,ierr)

      print '(a,i3,a,i4,a,a)','hello mpi&fortran from rank',rank,'of  ',procs,' processes on ',trim(host)

      call MPI_FINALIZE(ierr)
end program
