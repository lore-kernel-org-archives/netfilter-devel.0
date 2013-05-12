From: Eric Leblond <eric@regit.org>
Subject: Re: [PATCH 2/2] ulogd: Implement PID file writing
Date: Sun, 12 May 2013 11:53:32 +0200
Message-ID: <1368352412.22387.21.camel@ice-age.regit.org>
References: <1368291713-40132-1-git-send-email-bootc@bootc.net>
	 <1368291713-40132-3-git-send-email-bootc@bootc.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-3uLKes0QwNqISZoPOMKI"
Cc: netfilter-devel@vger.kernel.org
To: Chris Boot <bootc@bootc.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:38534 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753629Ab3ELJxi (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 12 May 2013 05:53:38 -0400
In-Reply-To: <1368291713-40132-3-git-send-email-bootc@bootc.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-3uLKes0QwNqISZoPOMKI
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable

Hi,

Some comments inline.

Le samedi 11 mai 2013 =E0 18:01 +0100, Chris Boot a =E9crit :
> The deamon currently does not have the ability to write a PID file to tra=
ck its
> process ID. This is very useful to an init script and to ensure there is =
only
> one running instance. This patch implements this functionality.
>=20
> Signed-off-by: Chris Boot <bootc@bootc.net>
> ---
>  src/ulogd.c |   75 +++++++++++++++++++++++++++++++++++++++++++++++++++++=
+++++-
>  1 file changed, 74 insertions(+), 1 deletion(-)
>=20
> diff --git a/src/ulogd.c b/src/ulogd.c
> index 8a144e3..982663f 100644
> --- a/src/ulogd.c
> +++ b/src/ulogd.c
> @@ -4,6 +4,7 @@
>   *
>   * (C) 2000-2005 by Harald Welte <laforge@gnumonks.org>
>   * (C) 2013 by Eric Leblond <eric@regit.org>
> + * (C) 2013 Chris Boot <bootc@bootc.net>
>   *
>   *  This program is free software; you can redistribute it and/or modify
>   *  it under the terms of the GNU General Public License version 2=20
> @@ -55,12 +56,14 @@
>  #include <signal.h>
>  #include <dlfcn.h>
>  #include <sys/types.h>
> +#include <fcntl.h>
>  #include <dirent.h>
>  #include <getopt.h>
>  #include <pwd.h>
>  #include <grp.h>
>  #include <syslog.h>
>  #include <sys/time.h>
> +#include <sys/stat.h>
>  #include <ulogd/conffile.h>
>  #include <ulogd/ulogd.h>
>  #ifdef DEBUG
> @@ -78,6 +81,7 @@
>  static FILE *logfile =3D NULL;		/* logfile pointer */
>  static char *ulogd_logfile =3D NULL;
>  static const char *ulogd_configfile =3D ULOGD_CONFIGFILE;
> +static const char *ulogd_pidfile =3D NULL;
>  static FILE syslog_dummy;
> =20
>  static int info_mode =3D 0;
> @@ -94,6 +98,7 @@ static LLIST_HEAD(ulogd_pi_stacks);
>  static int load_plugin(const char *file);
>  static int create_stack(const char *file);
>  static int logfile_open(const char *name);
> +static void cleanup_pidfile();
> =20
>  static struct config_keyset ulogd_kset =3D {
>  	.num_ces =3D 4,
> @@ -457,6 +462,8 @@ void __ulogd_log(int level, char *file, int line, con=
st char *format, ...)
> =20
>  static void warn_and_exit(int daemonize)
>  {
> +	cleanup_pidfile();
> +
>  	if (!daemonize) {
>  		if (logfile && !verbose) {
>  			fprintf(stderr, "Fatal error, check logfile \"%s\""
> @@ -1002,6 +1009,62 @@ static int parse_conffile(const char *section, str=
uct config_keyset *ce)
>  	return 1;
>  }
> =20
> +static int write_pidfile()
> +{
> +	struct stat pid_st;
> +	int pid_fp;
> +	char pidtext[16];
> +	int len;
> +
> +	if (!ulogd_pidfile)
> +		return 0;
> +
> +	if (stat(ulogd_pidfile, &pid_st) =3D=3D 0 || errno !=3D ENOENT) {
> +		ulogd_log(ULOGD_FATAL, "PID file %s exists, not starting\n",
> +				ulogd_pidfile);
> +		return -1;
> +	}

If the file existe, an interesting improvement would be to test if the
ulogd is really running. The following code do something like that:

  if (fscanf(pf, "%d", &pidv) =3D=3D 1 && kill(pidv, 0) =3D=3D 0)
	printf("already running");

If it is not the case, we can remove continue to proceed as we just have
a ghost pidfile.

> +
> +	pid_fp =3D open(ulogd_pidfile, O_WRONLY | O_CREAT | O_EXCL, 0644);
> +	if (pid_fp < 0) {
> +		ulogd_log(ULOGD_FATAL, "PID file %s could not be opened: %d\n",
> +				ulogd_pidfile, errno);
> +		return -1;
> +	}
> +	if (ftruncate(pid_fp, 0) !=3D 0) {
> +		close(pid_fp);
> +		unlink(ulogd_pidfile);
> +		ulogd_log(ULOGD_FATAL, "PID file %s could not be truncated: %d\n",
> +				ulogd_pidfile, errno);
> +		return -1;
> +	}
> +
> +	len =3D snprintf(pidtext, sizeof(pidtext), "%ld\n", (long)getpid());
> +
> +	if (write(pid_fp, pidtext, len) !=3D len) {
> +		close(pid_fp);
> +		unlink(ulogd_pidfile);
> +		ulogd_log(ULOGD_FATAL, "PID file %s could not be written: %d\n",
> +				ulogd_pidfile, errno);
> +		return -1;
> +	}
> +
> +	/* deliberately leave PID file open */

Why are you doing this ?

> +	return 0;
> +}
> +
> +static void cleanup_pidfile()
> +{
> +	if (!ulogd_pidfile)
> +		return;
> +
> +	if (unlink(ulogd_pidfile) !=3D 0)
> +		ulogd_log(ULOGD_ERROR, "PID file %s could not be deleted: %d\n",
> +				ulogd_pidfile, errno);
> +}
> +
>  static void deliver_signal_pluginstances(int signal)
>  {
>  	struct ulogd_pluginstance_stack *stack;
> @@ -1080,6 +1143,8 @@ static void sigterm_handler(int signal)
> =20
>  	config_stop();
> =20
> +	cleanup_pidfile();
> +
>  	exit(0);
>  }
> =20
> @@ -1121,6 +1186,7 @@ static void print_usage(void)
>  	printf("\t-v --verbose\tOutput info on standard output\n");
>  	printf("\t-l --loglevel\tSet log level\n");
>  	printf("\t-c --configfile\tUse alternative Configfile\n");
> +	printf("\t-p --pidfile\tRecord ulogd PID in file\n");
>  	printf("\t-u --uid\tChange UID/GID\n");
>  	printf("\t-i --info\tDisplay infos about plugin\n");
>  }
> @@ -1134,6 +1200,7 @@ static struct option opts[] =3D {
>  	{ "info", 1, NULL, 'i' },
>  	{ "verbose", 0, NULL, 'v' },
>  	{ "loglevel", 1, NULL, 'l' },
> +	{ "pidfile", 1, NULL, 'p' },
>  	{NULL, 0, NULL, 0}
>  };
> =20
> @@ -1150,7 +1217,7 @@ int main(int argc, char* argv[])
> =20
>  	ulogd_logfile =3D strdup(ULOGD_LOGFILE_DEFAULT);
> =20
> -	while ((argch =3D getopt_long(argc, argv, "c:dvl:h::Vu:i:", opts, NULL)=
) !=3D -1) {
> +	while ((argch =3D getopt_long(argc, argv, "c:p:dvl:h::Vu:i:", opts, NUL=
L)) !=3D -1) {
>  		switch (argch) {
>  		default:
>  		case '?':
> @@ -1179,6 +1246,9 @@ int main(int argc, char* argv[])
>  		case 'c':
>  			ulogd_configfile =3D optarg;
>  			break;
> +		case 'p':
> +			ulogd_pidfile =3D optarg;
> +			break;
>  		case 'u':
>  			change_uid =3D 1;
>  			user =3D strdup(optarg);
> @@ -1280,6 +1350,9 @@ int main(int argc, char* argv[])
>  		setsid();
>  	}
> =20
> +	if (write_pidfile() < 0)

As said in a previous mail, test that ulogd_pidfile is non NULL before
calling the function.

BR,
--
Eric


--=-3uLKes0QwNqISZoPOMKI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iD8DBQBRj2acnxA7CdMWjzIRAiNcAJ4igGW4hu2BYJyIqKQ0hsJhilLRTgCeJn9F
RcftKN3BIUGZR8FSD3exW/c=
=zFuU
-----END PGP SIGNATURE-----

--=-3uLKes0QwNqISZoPOMKI--

