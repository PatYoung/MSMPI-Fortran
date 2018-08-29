!随机数种子初始化子程序，时随机数与系统时间有关
SUBROUTINE init_random_seed()
    INTEGER :: i, n, clock
    INTEGER, ALLOCATABLE :: seed(:)
    CALL RANDOM_SEED(size = n)
    ALLOCATE(seed(n))
    CALL SYSTEM_CLOCK(COUNT = clock)
    seed = clock + 37 * (/(i - 1, i = 1, n)/)
    CALL RANDOM_SEED(put = seed)
    DEALLOCATE(seed)
END SUBROUTINE init_random_seed

PROGRAM main
    IMPLICIT NONE
    INTEGER m, n
    INTEGER,PARAMETER :: p = 10
    INTEGER,PARAMETER :: q = 10
    REAL(KIND = 8) :: S(p, q)
    REAL(KIND = 8) :: a
    CALL init_random_seed()
    
    OPEN(UNIT = 10, STATUS = 'REPLACE', FILE = '1.dat')
    DO n = 1, q
        DO m = 1,p
            CALL RANDOM_NUMBER(a)
            S(m, n) = a
        END DO
    END DO

    DO n = 1, q
        WRITE(10,"(10(1X,F4.2))") (S(m, n),m = 1, p)
    END DO

END PROGRAM
