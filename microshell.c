# include<stdlib.h>
# include<unistd.h>
# include<sys/wait.h>
# include<signal.h>
# include<string.h>


#define std_err	2
#define std_in	0
#define	std_out	1

/*_________________________________________  C-D   ________________________________________________*/
void	b_cd(char *av[])
{
	if ((av[1] && av[2]) || !av[1])
	{
		write(std_err, "error: cd: bad arguments\n", 25);
	}
	if (chdir (av[1]))
	{
		write(std_err, "error: cd: cannot change directory to ", strlen("error: cd: cannot change directory to "));
		write(std_err, av[1], strlen(av[1]));
		write(std_err, "\n", 1);
	}
}

/*_________________________________________ COUNT EXEPTE ARGEMENT ______________________________________________*/
int		count_exp_arg(char** av, char* exp)
{
	int	cas_e = -1, c_pipe = 0;

	while (av[++cas_e])
	{
		if (strcmp(av[cas_e], exp) != 0)
			continue ;
		if (exp[0] == '|' && (!cas_e || !av[cas_e - 1]))
			exit (write(std_err, "error: fatal\n", 13));
		av[cas_e] = NULL;
		c_pipe++;
	}
	return c_pipe;
}

/*____________________________________________ EXEC CMD ______________________________________________*/
void	exec_cmd(char** av, char* env[])
{
	if (strcmp(av[0], "cd") == 0)
		exit (write(std_err, "error: fatal\n", 13));
	execve(av[0], av, env);
	write(std_err, "error: cannot execute ", strlen("error: cannot execute "));
	write(std_err, av[0], strlen(av[0]));
	write(std_err, "\n", 1);
	exit(-43);
}

void	close_fds(int fd1, int fd2)
{
	for (int fd = 3; fd < 255; fd++)
		if (fd != fd1 && fd != fd2)
			close(fd);
}

void	help_child(int rd_from, int fds[2], char** av, char** env)
{
	dup2(rd_from, std_in);
	dup2(fds[std_out], std_out);
	close_fds(fds[std_out], rd_from);
	exec_cmd (av, env);
}

/*____________________________ reqursion for semicolons______________________________________________*/
void	loop_sc(int c_sc, char** av, char** env)
{
	if (!av || c_sc < 0)
		return ;
	if (!*av)
		return loop_sc(c_sc - 1, &(av[1]), env);
	int	co_p = count_exp_arg(av, "|");/* count pipe */
	int rd_from = std_in;
	while (1)
	{
		int	fds[2] = {std_in, std_out};
		if (co_p && pipe(fds)) exit (write(std_err, "error: fatal\n", 13));
		if (co_p == 0 && strcmp(av[0] , "cd") == 0)
			b_cd(av);
		else if (fork() == 0)
			help_child(rd_from, fds, av, env);
		close_fds(fds[std_in], std_out);
		if (co_p-- <= 0)
		{
			if (fds[std_in] != std_in) close(fds[std_in]);
			break ;
		}
		rd_from = fds[std_in];
		while (*av++);
	}
	while (*av++);
	while (-1 != waitpid(0, &rd_from, WUNTRACED ));

	if (c_sc) loop_sc(c_sc - 1, av, env);
}

/*__________________________________________ MAIN ____________________________________________________*/
int main(int ac, char** av, char** env)
{
	if (!av || ac < 2)
		return (-1);/* END */

	int c_sc = count_exp_arg(av, ";");/* count semicolon */

	{
		loop_sc(c_sc, &(av[1]), env);
	}
	for (int fd = 3; fd < 255; fd++)
		close(fd);
	while (1);
	return 0;/* END */
}

