!
! io.f90
! Molecular Dynamics Simulation of a Van der Waals Gas
! Ricard Rodriguez, Itziar Rabal
!
! Contains all the subroutines related to writing to or reading from external
! files.
!

module io
    implicit none

    contains
        ! Ricard Rodriguez
        !
        ! Write the coordinates of all particles of the system in the current point of
        ! time in an specified external file with an XYZ format.
        ! The external file must already exist and results will be appended to it.
        subroutine write_positions_xyz(part_num, time, positions, atom_type, output_file)
            implicit none

            integer, intent(in) :: part_num
            real, intent(in) :: time
            character(2), intent(in) :: atom_type
            character(50), intent(in) :: output_file
            real, allocatable, intent(in) :: positions(:, :)

            integer :: i

            open(4, file = output_file, status = 'old', action = 'write', access = 'append')

            write(4, *) part_num
            write(4, *) time
            do i = 1, part_num
                write(4, *) trim(atom_type), positions(i, :)
            end do

            close(4)
        end subroutine write_positions_xyz

        ! Itziar Rabal, Ricard Rodriguez
        !
        ! Reads external input files that follow the structure of input_parameters.in
        subroutine read_input(input_file, part_num, atom_type, system_size, lattice_type, timestep, step_num, &
                temperature, collision_frequence, cutoff, test_mode)
            implicit none

            character(*), intent(in) :: input_file
            integer, intent(out) :: part_num, step_num
            real, intent(out) :: system_size, timestep, temperature, collision_frequence, cutoff
            character(2), intent(out) :: atom_type
            character(3), intent(out) :: test_mode
            character(6), intent(out) :: lattice_type

            integer :: ios

            open(10, file = input_file, status = 'old', action = 'read', iostat = ios)

            if (ios /= 0) then
                print *, 'Error reading input file ', input_file
                stop
            end if

            ! Read input file contents,
            ! Make sure these are in the same order that the ones defined in 'input_file'.
            ! In case you wish to add an extra variable to be read from the 'input_file',
            ! it should also be added here below and added as an
            ! argument of the subroutine as 'intent(out)'.
            read(10, fmt = *) part_num
            read(10, fmt = *) atom_type
            read(10, fmt = *) system_size
            read(10, fmt = *) lattice_type
            read(10, fmt = *) timestep
            read(10, fmt = *) step_num
            read(10, fmt = *) temperature
            read(10, fmt = *) collision_frequence
            read(10, fmt = *) cutoff
            read(10, fmt = *) test_mode

            close(10)
        end subroutine read_input
end module io
