!
! geometry.f90
! Molecular Dynamics Simulation of a Van der Waals Gas
! Ricard Rodriguez
!
! Contains all the subroutines dependent or related to the system geometry.
!

module geometry
    use global_vars

    implicit none

    contains
        ! Apply PBC conditions to the positions array.
        ! This subroutine must be run every time the positions of the particles are
        ! updated.
        subroutine apply_pbc(positions)
            use mpi

            implicit none

            real(8), allocatable, intent(inout) :: positions(:, :)

            integer :: i, j

            ! Apply PBC to the assigned chunk of positions
            do i = start, end
                do j = 1, 3
                    positions(i, j) = pbc(positions(i, j), system_size)
                end do
            end do

            ! Gather results back to the root process (rank 0)
            if (rank == 0) then
                ! Gather the results into the root process
                call mpi_gather( &
                    positions(start:end, :), end-start+1, MPI_REAL8, &
                    positions, end-start+1, MPI_REAL8, 0, MPI_COMM_WORLD, ierr &
                )
            else
                ! Other processes send their results to rank 0
                call mpi_gather( &
                    positions(start:end, :), end-start+1, MPI_REAL8, &
                    positions, end-start+1, MPI_REAL8, 0, MPI_COMM_WORLD, ierr &
                )
            end if
        end subroutine apply_pbc

        ! Apply PBC to a certain distance, given the box size.
        function pbc(distance, box_size)
            implicit none

            real(8) :: distance, box_size, pbc

            if (distance > box_size/2) then
                distance = distance - box_size
            else if (distance < -box_size/2) then
                distance = distance + box_size
            end if

            pbc = distance
        end function pbc
end module geometry
