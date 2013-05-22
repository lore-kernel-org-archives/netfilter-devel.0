From: Chris Boot <bootc@bootc.net>
Subject: Re: [Ulogd PATCH] Improve pid file handling.
Date: Wed, 22 May 2013 10:22:18 +0100
Message-ID: <519C8E4A.60405@bootc.net>
References: <1368991178.14976.4.camel@ice-age.regit.org> <1368991334-952-1-git-send-email-eric@regit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from kamaji.grokhost.net ([87.117.218.43]:45961 "EHLO
	kamaji.grokhost.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755199Ab3EVJWn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 22 May 2013 05:22:43 -0400
In-Reply-To: <1368991334-952-1-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 19/05/13 20:22, Eric Leblond wrote:
> This patch improves latest patch by splitting in two part the pid
> file creation. This allows to display a message to stdout when
> ulogd can not be started. Another linked improvement is that the
> plugin initialization is not done if the pid file existence will
> result in a ulogd exit.
> 
> Signed-off-by: Eric Leblond <eric@regit.org>
> ---
>  src/ulogd.c |   66 ++++++++++++++++++++++++++++++++++++++++++++++++-----------
>  1 file changed, 54 insertions(+), 12 deletions(-)
> 
> diff --git a/src/ulogd.c b/src/ulogd.c
> index 4309201..c1aba77 100644
> --- a/src/ulogd.c
> +++ b/src/ulogd.c
> @@ -82,6 +82,7 @@ static FILE *logfile = NULL;		/* logfile pointer */
>  static char *ulogd_logfile = NULL;
>  static const char *ulogd_configfile = ULOGD_CONFIGFILE;
>  static const char *ulogd_pidfile = NULL;
> +static int ulogd_pidfile_fd = -1;
>  static FILE syslog_dummy;
>  
>  static int info_mode = 0;
> @@ -1017,7 +1018,7 @@ static int parse_conffile(const char *section, struct config_keyset *ce)
>   * the GPL2+ license with the following copyright statement:
>   * Copyright (C) 1996 Thomas Koenig
>   */
> -static int lock_fd(int fd)
> +static int lock_fd(int fd, int wait)
>  {
>  	struct flock lock;
>  
> @@ -1026,7 +1027,10 @@ static int lock_fd(int fd)
>  	lock.l_start = 0;
>  	lock.l_len = 0;
>  
> -	return fcntl(fd, F_SETLK, &lock);
> +	if (wait)
> +		return fcntl(fd, F_SETLKW, &lock);
> +	else
> +		return fcntl(fd, F_SETLK, &lock);
>  }
>  
>  /*
> @@ -1036,12 +1040,15 @@ static int lock_fd(int fd)
>   * under the GPL2+ license with the following copyright statement:
>   * Copyright (C) 1996 Thomas Koenig
>   */
> -static int write_pidfile()
> +static int create_pidfile()
>  {
>  	int fd;
>  	FILE *fp;
>  	pid_t pid = -1;
>  
> +	if (!ulogd_pidfile)
> +		return 0;
> +
>  	fd = open(ulogd_pidfile, O_RDWR | O_CREAT | O_EXCL, 0644);
>  	if (fd < 0) {
>  		if (errno != EEXIST) {
> @@ -1061,13 +1068,14 @@ static int write_pidfile()
>  		if (fp == NULL) {
>  			ulogd_log(ULOGD_ERROR, "cannot fdopen %s: %d\n",
>  					ulogd_pidfile, errno);
> +			close(fd);
>  			return -1;
>  		}
>  
>  		if ((fscanf(fp, "%d", &pid) != 1) || (pid == getpid())
> -				|| (lock_fd(fd) == 0)) {
> +				|| (lock_fd(fd, 0) == 0)) {
>  			ulogd_log(ULOGD_NOTICE,
> -				"removing stale pidfile for pid %d\n", pid);
> +				  "removing stale pidfile for pid %d\n", pid);
>  
>  			if (unlink(ulogd_pidfile) < 0) {
>  				ulogd_log(ULOGD_ERROR, "cannot unlink %s: %d\n",
> @@ -1078,9 +1086,12 @@ static int write_pidfile()
>  			ulogd_log(ULOGD_FATAL,
>  				"another ulogd already running with pid %d\n",
>  				pid);
> +			fclose(fp);
> +			close(fd);
>  			return -1;
>  		}
>  
> +		close(fd);
>  		fclose(fp);
>  		unlink(ulogd_pidfile);
>  
> @@ -1094,16 +1105,42 @@ static int write_pidfile()
>  		}
>  	}
>  
> -	if (lock_fd(fd) < 0) {
> -		ulogd_log(ULOGD_ERROR, "cannot lock %s: %d\n", ulogd_pidfile,
> -				errno);
> +	if (lock_fd(fd, 0) < 0) {
> +		ulogd_log(ULOGD_ERROR, "cannot lock %s: %s\n", ulogd_pidfile,
> +				strerror(errno));
> +		close(fd);
> +		return -1;
> +	}
> +	ulogd_pidfile_fd = fd;
> +	return 0;
> +}
> +
> +static int write_pidfile(int daemonize)
> +{
> +	FILE *fp;
> +	if (!ulogd_pidfile)
> +		return 0;
> +
> +	if (ulogd_pidfile_fd == -1) {
> +		ulogd_log(ULOGD_ERROR, "unset pid file fd\n");
>  		return -1;
>  	}
>  
> -	fp = fdopen(fd, "w");
> +	if (daemonize) {
> +		/* relocking as lock is not inherited */
> +		if (lock_fd(ulogd_pidfile_fd, 1) < 0) {
> +			ulogd_log(ULOGD_ERROR, "cannot lock %s: %d\n", ulogd_pidfile,
> +					errno);
> +			close(ulogd_pidfile_fd);
> +			return -1;
> +		}
> +	}
> +
> +	fp = fdopen(ulogd_pidfile_fd, "w");
>  	if (fp == NULL) {
>  		ulogd_log(ULOGD_ERROR, "cannot fdopen %s: %d\n", ulogd_pidfile,
>  				errno);
> +		close(ulogd_pidfile_fd);
>  		return -1;
>  	}
>  
> @@ -1118,7 +1155,7 @@ static int write_pidfile()
>  	 * We do NOT close fd, since we want to keep the lock. However, we don't
>  	 * want to keep the file descriptor in case of an exec().
>  	 */
> -	fcntl(fd, F_SETFD, FD_CLOEXEC);
> +	fcntl(ulogd_pidfile_fd, F_SETFD, FD_CLOEXEC);
>  
>  	created_pidfile = 1;
>  
> @@ -1350,6 +1387,11 @@ int main(int argc, char* argv[])
>  		loglevel_ce.u.value = loglevel;
>  		loglevel_ce.flag |= CONFIG_FLAG_VAL_PROTECTED;
>  
> +	if (ulogd_pidfile) {
> +		if (create_pidfile() < 0)
> +			warn_and_exit(0);
> +	}
> +
>  	if (daemonize && verbose) {
>  		verbose = 0;
>  		ulogd_log(ULOGD_ERROR,
> @@ -1421,8 +1463,8 @@ int main(int argc, char* argv[])
>  	}
>  
>  	if (ulogd_pidfile) {
> -		if (write_pidfile() < 0)
> -			warn_and_exit(daemonize);
> +		if (write_pidfile(daemonize) < 0)
> +			warn_and_exit(0);
>  	}
>  
>  	signal(SIGTERM, &sigterm_handler);
> 

Hi Eric,

I have been testing ulogd with your patch on top for some time now, and
it looks good. Thanks for the comments, review and your follow-up patch
- they are much appreciated.

Best regards,
Chris

-- 
Chris Boot
bootc@bootc.net
