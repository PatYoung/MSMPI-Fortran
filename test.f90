PROGRAM test
    USE mpi
    IMPLICIT NONE
    INTEGER :: cpuid, num, ierr
    CHARACTER (MPI_MAX_PROCESSOR_NAME) :: host
    INTEGER :: hostlen
	INTEGER, PARAMETER :: m = 10, n = 10
    REAL(KIND = 8) :: a(m, n), b(m, n)
    INTEGER :: i,j,k
	INTEGER :: source, ndest
	INTEGER :: cols, avecol, extra, set, status(MPI_STATUS_SIZE)
	INTEGER :: numa, lastset, mtype
    CALL MPI_INIT(ierr)
    CALL MPI_COMM_SIZE(MPI_COMM_WORLD, num, ierr)
    CALL MPI_COMM_RANK(MPI_COMM_WORLD, cpuid, ierr)
    CALL MPI_GET_PROCESSOR_NAME(host,hostlen,ierr)
    
    IF (cpuid == 0) WRITE(*,*) "Read data."

	
	
    IF (cpuid == 0) THEN

    OPEN(UNIT = 10, FILE = "1.dat")
  
    DO j = 1, n
        READ(10,*) (a(i, j), i = 1, m)
    END DO
    CLOSE(10)
   
    !OPEN(UNIT = 11, FILE = "2.dat", STATUS = "REPLACE")
    DO i = 1, m
        WRITE(*,"(10(1X,F4.2))") (a(i,j), j = 1, n)
    END DO
    !CLOSE(11)

	END IF

	DO k = 1, n	

		IF (cpuid == 0) THEN	
		!WRITE(*,*) "CPU = ", cpuid	   
			set = 1
			mtype = 1
			extra = MOD(m, num)
			avecol = m/num
			numa = num - 1
    
			DO  ndest = 1, numa
	
				IF (ndest .le. extra) THEN
					cols = avecol + 1
				ELSE
					cols = avecol
				END IF

				CALL MPI_SEND(set,1, MPI_INTEGER, ndest, mtype, MPI_COMM_WORLD, ierr )
				CALL MPI_SEND(cols,1,MPI_INTEGER, ndest, mtype, MPI_COMM_WORLD, ierr )
				set = set + cols
 
			END DO
	
			lastset = m - avecol + 1
	
			DO i = lastset, m
				b(i, k) = a(i, k)
			END DO
	
			DO i = lastset, m

				WRITE(*,"(1X,A1,I2,1X,A1,I2,A1,3X,F4.2)") "(",i,",",k,")",b(i, k)
			END DO
		END IF		
		
		IF (cpuid > 0) THEN
			!WRITE(*,*) "CPU = ", cpuid
			mtype = 1
			CALL MPI_RECV(set,1,MPI_INTEGER,0,mtype,MPI_COMM_WORLD,status,ierr)
			CALL MPI_RECV(cols,1,MPI_INTEGER,0,mtype,MPI_COMM_WORLD,status,ierr)
			
			OPEN(UNIT = 10, FILE = "1.dat")
			DO j = 1, n
				READ(10,*) (a(i, j), i = 1, m)
			END DO
			CLOSE(10)
			
			!WRITE(*,*) "set = ",set,"cols = ",cols
			DO i = set , set - 1 + cols
				b(i, k) = a(i, k)
			END DO	

			DO i = set , set - 1 + cols

				WRITE(*,"(1X,A1,I2,1X,A1,I2,A1,3X,F4.2)") "(",i,",",k,")",b(i, k)
			END DO			
		
		END IF

	END DO

	
	
    CALL MPI_FINALIZE(ierr)
END PROGRAM
