From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [pablo@netfilter.org: Re: [netfilter-core] Patch for ULOGD]
Date: Tue, 18 Sep 2012 21:37:08 +0200
Message-ID: <20120918193708.GA2498@1984>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="uAKRQypu60I7Lcqm"
Cc: netfilter-devel@vger.kernel.org
To: anders@anduras.de
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52164 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754085Ab2IRThN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 18 Sep 2012 15:37:13 -0400
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--uAKRQypu60I7Lcqm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

This contribution reached netfilter-core mailing list.

I'm resending this email to you and the mailing list, so we don't lost
track of it, in case anyone finds this interesting.

I contacted the original author but the mailserver rejects my email
telling that the address does not exists.

--uAKRQypu60I7Lcqm
Content-Type: message/rfc822
Content-Disposition: inline

Date: Thu, 6 Sep 2012 20:24:54 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Gerfried Essler <essler@anduras.de>
Cc: coreteam@netfilter.org
Subject: Re: [netfilter-core] Patch for ULOGD
Message-ID: <20120906182454.GA25233@1984>
References: <5047576C.9020006@anduras.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5047576C.9020006@anduras.de>
User-Agent: Mutt/1.5.20 (2009-06-14)

Hi,

On Wed, Sep 05, 2012 at 03:45:16PM +0200, Gerfried Essler wrote:
> 
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Hello,
> 
> I wrote a patch for ULOGD for creating logfiles in a syslog style (with
> strftime macros),
> for example: "/var/log/ulogd/%Y/%m/%d/ulogd_syslogemu.log"  to organize
> the logfiles
> in a Year/month/day directory structure.
> 
> Compile ULOG with the --enable-logname-expansion flag to use it.
> 
> If you have any questions please send an e-mail to me or to Sven Anders
> <anders@anduras.de>

Please, send this patch to netfilter-devel mailing list.

A couple of quick comments:

> with kind regards,
> Gerfried Essler
> <essler@anduras.de>
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1.4.11 (GNU/Linux)
> Comment: Using GnuPG with Mozilla - http://www.enigmail.net/
> 
> iQEcBAEBAgAGBQJQR1dsAAoJEC/R0e/1eoMpIf0H/jJZ60BKNTsPzN0tNH5T9XE3
> MjOcJrz/VpprLStP/g+fMkZHQOe1OI5kJ6avWXCiDGiRDdniI+Ju7Nm9iXhY05jp
> HLW+BAKj36PLu4qSpWgYrZbIsb8Zsb9SlBGK4PS7kA63YVSIlPy7dvrZbU3NbWCT
> meEkeKZa5RWKx18DP/x/4LYr1tQueXHJWFAnDZgnwEmXq0yNT4x0H3TCoVReysK8
> oMAzJVfRh7j5WBXG6qrfRf0kye1nfk4IZADtC5QKX9HbiKvl1krYV7+tZLtccE7/
> MPPKslH+Uc7lKBWbYstJfRSt59rrE86ZoxEd8IGYOgeQNGgtzoVhEz5NVYugBNY=
> =H1PU
> -----END PGP SIGNATURE-----
> 

> --- ulogd-2.0.0.orig/configure.ac	2012-06-17 13:01:58.000000000 +0200
> +++ ulogd-2.0.0/configure.ac	2012-08-29 13:11:01.000000000 +0200
> @@ -2,7 +2,7 @@
>  AC_PREREQ([2.50])
>  AC_INIT([ulogd], [2.0.0])
>  AC_CONFIG_AUX_DIR([build-aux])
> -AM_INIT_AUTOMAKE([-Wall foreign tar-pax no-dist-gzip dist-bzip2 1.10b])
> +AM_INIT_AUTOMAKE([-Wall foreign tar-pax no-dist-gzip dist-bzip2 1.10])
>  AC_CONFIG_HEADER([config.h])
>  AC_CONFIG_MACRO_DIR([m4])
>  
> @@ -60,7 +60,13 @@
>  CT_CHECK_DBI()
>  AM_CONDITIONAL(HAVE_DBI, test "x$DBI_LIB" != "x")
>  
> -
> +dnl
> +dnl test for logname expansion support
> +dnl
> +AC_ARG_ENABLE(logname-expansion,
> +[  --enable-logname-expansion enables logname expansion],[
> +CFLAGS="${CFLAGS} -DLOGNAME_EXPANSION"
> +])

Please, no conditional compilation options. This has to be there by
default and make sure this new parameters are optional and backward
compatibility is not broken.


>  dnl AC_SUBST(DATABASE_DIR)
>  dnl AC_SUBST(DATABASE_LIB)
> --- ulogd-2.0.0.orig/ulogd.conf.in	2012-05-18 02:49:10.000000000 +0200
> +++ ulogd-2.0.0/ulogd.conf.in	2012-09-05 15:06:42.000000000 +0200
> @@ -7,6 +7,7 @@
>  # GLOBAL OPTIONS
>  ######################################################################
>  
> +nlgroup=1
>  
>  # logfile for status messages
>  logfile="/var/log/ulogd.log"
> @@ -171,6 +172,18 @@
>  file="/var/log/ulogd_syslogemu.log"
>  sync=1
>  
> +# The --enable-logname-expansion flag must be enabled to use these options
> +[emu2]
> +file="/var/log/ulogd/%Y/%m/%d/ulogd_syslogemu.log"
> +create_dirs=
> +uid=
> +gid=
> +dir_uid=
> +dir_gid=
> +mode=
> +dir_mode=
> +syslogsync=1
> +
>  [op1]
>  file="/var/log/ulogd_oprint.log"
>  sync=1
> --- ulogd-2.0.0.orig/output/ulogd_output_LOGEMU.c	2011-01-28 01:14:37.000000000 +0100
> +++ ulogd-2.0.0/output/ulogd_output_LOGEMU.c	2012-09-05 15:23:26.000000000 +0200
> @@ -7,6 +7,11 @@
>   *
>   * (C) 2000-2005 by Harald Welte <laforge@gnumonks.org>
>   *
> + *  05 Sep 2012, Gerfried Essler <essler@anduras.de>,
> + *  Sven Anders <anders@anduras.de>:
> + *  Added macros (for date/time) in filename/directories and
> + *  automatic creation of it. Additional behaviour like syslog-ng.

These credits will show up in the git changelog, not good to add
history there. You may still add your copyright if you want.

> + * 
>   *  This program is free software; you can redistribute it and/or modify
>   *  it under the terms of the GNU General Public License version 2 
>   *  as published by the Free Software Foundation
> @@ -30,6 +35,10 @@
>  #include <string.h>
>  #include <errno.h>
>  #include <time.h>
> +#include <string.h>
> +#include <sys/stat.h>
> +#include <sys/types.h>
> +#include <unistd.h>
>  #include <ulogd/ulogd.h>
>  #include <ulogd/conffile.h>
>  
> @@ -58,10 +67,26 @@
>  		.flags = ULOGD_KEYF_OPTIONAL,
>  		.name = "oob.time.sec",
>  	},
> +#ifdef LOGNAME_EXPANSION
> +	{ 
> +		.type = ULOGD_RET_UINT32,
> +		.flags = ULOGD_KEYF_OPTIONAL,
> +		.name = "local.time",
> +	},
> +	{ 
> +		.type = ULOGD_RET_STRING,
> +		.flags = ULOGD_KEYF_OPTIONAL,
> +		.name = "local.hostname",
> +	},
> +#endif /*LOGNAME_EXPANSION*/
>  };
>  
>  static struct config_keyset logemu_kset = {
> +#ifdef LOGNAME_EXPANSION
> +	.num_ces = 9,
> +#else
>  	.num_ces = 2,
> +#endif /*LOGNAME_EXPANSION*/
>  	.ces = {
>  		{
>  			.key 	 = "file",
> @@ -75,13 +100,155 @@
>  			.options = CONFIG_OPT_NONE,
>  			.u	 = { .value = ULOGD_LOGEMU_SYNC_DEFAULT },
>  		},
> +#ifdef LOGNAME_EXPANSION
> +		{
> +			.key     = "create_dirs",
> +                        .type	 = CONFIG_TYPE_INT,
> +			.options = CONFIG_OPT_NONE, 
> +                        .u       = { .value = 0 },
> +		},
> +		{
> +			.key     = "uid",
> +                        .type	 = CONFIG_TYPE_INT,
> +			.options = CONFIG_OPT_NONE,
> +                        .u       = { .value = -1 },
> +		},
> +                {
> +			.key     = "gid",
> +                        .type	 = CONFIG_TYPE_INT,
> +			.options = CONFIG_OPT_NONE,
> +                        .u       = { .value = -1 },
> +		},
> +                {
> +			.key     = "dir_uid",
> +                        .type	 = CONFIG_TYPE_INT,
> +			.options = CONFIG_OPT_NONE,
> +                        .u       = { .value = -1 },
> +		},
> +                {
> +			.key     = "dir_gid",
> +                        .type	 = CONFIG_TYPE_INT,
> +			.options = CONFIG_OPT_NONE,
> +                        .u       = { .value = -1 },
> +		},
> +                {
> +			.key     = "mode",
> +                        .type	 = CONFIG_TYPE_INT,
> +			.options = CONFIG_OPT_NONE,
> +                        .u       = { .value = 0400 },
> +		},
> +                {
> +			.key     = "dir_mode",
> +                        .type	 = CONFIG_TYPE_INT,
> +			.options = CONFIG_OPT_NONE,
> +                        .u       = { .value = 0700 },
> +		},
> +                
> +#endif /*LOGNAME_EXPANSION*/
>  	},
>  };
>  
>  struct logemu_instance {
>  	FILE *of;
> +#ifdef LOGNAME_EXPANSION
> +	int macros;
> +	char filename[PATH_MAX];
> +#endif /*LOGNAME_EXPANSION*/
>  };
>  
> +#ifdef LOGNAME_EXPANSION
> +
> +static int open_file(struct ulogd_pluginstance *upi, char *filename, FILE **fd)
> +{
> +	/* Let ulog use unix file/folder privileges */
> +	int create_dirs = 0;
> +	int uid = 0; 
> +	int gid = 0;
> +	int mode = 0;
> +	int dir_uid = 0;
> +	int dir_gid = 0;
> +	int dir_mode = 0;
> +	mode_t old_umask = 0;
> +    
> +	/* set variables for easier access */
> +	create_dirs = upi->config_kset->ces[2].u.value;
> +	uid = upi->config_kset->ces[3].u.value;
> +	gid = upi->config_kset->ces[4].u.value;
> +	dir_uid = upi->config_kset->ces[5].u.value;
> +	dir_gid = upi->config_kset->ces[6].u.value;
> +	mode = upi->config_kset->ces[7].u.value;
> +	dir_mode = upi->config_kset->ces[8].u.value;
> +
> +	if (filename == NULL)
> +	    return 0;
> +
> +	old_umask = umask(0777);
> +    
> +	*fd = fopen(filename, "a");
> +    
> +	if (create_dirs && *fd == NULL && errno == ENOENT) {

On error, display a message and return -1.

You can avoid lots of nesting with that error treatment.

> +	    
> +	    /* directory does not exist */
> +	    char *p = filename + 1;
> +	    p = strchr(p, '/');
> +	    
> +	    while (p) {
> +		struct stat st;
> +		*p = 0;
> +		if (stat(filename, &st) == 0) {
> +		    

I can see lots of whitespace errors, ie. empty lines with tabs.
Please, fix those.

> +		    if (!S_ISDIR(st.st_mode))
> +			return 0;
> +		} else if (errno == ENOENT) {
> +		    
> +		    if (mkdir(filename, dir_mode) == -1) {
> +			ulogd_log(ULOGD_ERROR, "Couldn't create directory \"%s\": %s.\n",
> +				filename, strerror(errno));
> +			return 0;
> +		    }
> +		    
> +		    if (dir_uid != -1 || dir_gid != -1) {
> +			
> +			if (chown(filename, dir_uid, dir_gid) < 0) {
> +			    ulogd_log(ULOGD_NOTICE, "Couldn't set owner on directory \"%s\": %s.\n",
> +				    filename, strerror(errno));
> +  
> +			}
> +		    }
> +		    
> +		    if (chmod(filename, dir_mode) < 0) {
> +			ulogd_log(ULOGD_NOTICE, "Couldn't set permissions on directory \"%s\": %s.\n",
> +				filename, strerror(errno));
> +		    }
> +		}
> +		
> +		*p = '/';
> +		p = strchr(p + 1, '/');
> +	    }
> +	    
> +	    *fd = fopen(filename, "a");
> +	}
> +	
> +	if (uid != -1 || gid != -1) {
> +	    
> +	    if (chown(filename, uid, gid) < 0) {
> +		ulogd_log(ULOGD_NOTICE, "Couldn't set owner on file \"%s\": %s.\n",
> +			filename, strerror(errno));
> +	    }
> +	}
> +	
> +	if (chmod(filename, mode) < 0) {
> +	    ulogd_log(ULOGD_NOTICE, "Couldn't set permissions on file \"%s\": %s.\n",
> +		    filename, strerror(errno));
> +	}
> +	
> +	umask(old_umask);
> +	
> +	return (*fd != NULL);
> +}
> +
> +#endif /*LOGNAME_EXPANSION*/
> +
>  static int _output_logemu(struct ulogd_pluginstance *upi)
>  {
>  	struct logemu_instance *li = (struct logemu_instance *) &upi->private;
> @@ -100,12 +267,69 @@
>  		timestr = ctime(&now) + 4;
>  		if ((tmp = strchr(timestr, '\n')))
>  			*tmp = '\0';
> +	
> +#ifdef LOGNAME_EXPANSION
> +
> +	char new_filename[PATH_MAX];
> +	const struct tm *tm;
> +	/* convert time to tm structure */
> +	tm = localtime(&now);
> +
> +	// This contains the time macro path string the user has configured
> +	char* formatstring = upi->config_kset->ces[0].u.string;

We have to break lines at 80-chars.

And we use C comments, /* ... */, not C++ comments //


> +
> +	if (li->macros) { // do we use macros?

You can put this code below in some function, so you can save some
nesting levels. That's also good for code maintainability.

> +	    
> +	    // expand any macros in the file's name
> +		if (strftime(new_filename, PATH_MAX-1, formatstring, tm) > 0) {
> +
> +			// Do we need to open another log file?
> +			if ((li->filename == NULL) || 
> +				(strcmp(new_filename, li->filename) != 0)) {
> +
> +				// close the old file
> +				if (li->filename != NULL) {
> +					if (li->of != NULL) fclose(li->of);
> +					memset(li->filename, 0, PATH_MAX);
> +				}
> +		
> +				// copy new filename and create path, if necessary...
> +				memcpy(li->filename, new_filename, PATH_MAX);
> +				ulogd_log(ULOGD_INFO, "Opening new logfile '%s'.\n",
> +					li->filename);
> +			
> +				// open the new file
> +				if (!open_file(upi, li->filename, &li->of)) {
> +					ulogd_log(ULOGD_FATAL, "Couldn't open \"%s\": %s.\n",
> +						li->filename, strerror(errno));
> +				return -1;
> +				}
> +			}
> +		} else if (li->filename[0] == '\0')
> +		return -1;       
> +	}
> +                
> +#ifdef DEBUG_LOGEMU
> +	printf("%d:%d:%d %s %s",tm->tm_hour,tm->tm_min,
> +		tm->tm_sec,hostname, (char *) res[0].u.source->u.value.ptr);
> +#endif /*DEBUG_LOGEMU*/
> +
> +	/* Finally write our log to the file */
> +	fprintf(li->of, "%d:%d:%d %s %s",tm->tm_hour,tm->tm_min,
> +				tm->tm_sec,hostname,
> +				(char *) res[0].u.source->u.value.ptr);
> +                
> +	fflush(li->of);
> +                
> +#else
>  
>  		fprintf(li->of, "%.15s %s %s", timestr, hostname,
>  				(char *) res[0].u.source->u.value.ptr);
> +                 
> +       	if (upi->config_kset->ces[1].u.value)
> +			fflush(li->of);		
>  
> -		if (upi->config_kset->ces[1].u.value)
> -			fflush(li->of);
> +#endif /*LOGNAME_EXPANSION*/
>  	}
>  
>  	return ULOGD_IRET_OK;
> @@ -144,14 +368,31 @@
>  #ifdef DEBUG_LOGEMU
>  	li->of = stdout;
>  #else
> +#ifdef LOGNAME_EXPANSION
> +
> +	li->macros = 0;
> +	memset(li->filename, 0, PATH_MAX);
> +        
> +#endif /*LOGEMU_EXPANSION*/
> +        
>  	ulogd_log(ULOGD_DEBUG, "opening file: %s\n",
>  		  pi->config_kset->ces[0].u.string);
> +#ifdef LOGNAME_EXPANSION
> +	if (strchr(pi->config_kset->ces[0].u.string, '%') == NULL) {
> +#endif /*LOGNAME_EXPANSION*/
>  	li->of = fopen(pi->config_kset->ces[0].u.string, "a");
>  	if (!li->of) {
>  		ulogd_log(ULOGD_FATAL, "can't open syslogemu: %s\n", 
>  			  strerror(errno));
>  		return -errno;
> -	}		
> +}
> +#ifdef LOGNAME_EXPANSION
> +	} else {
> +		li->of = NULL;
> +		li->macros = 1;
> +	}
> +#endif /*LOGNAME_EXPANSION*/
> +
>  #endif
>  
>  	if (gethostname(hostname, sizeof(hostname)) < 0) {
> @@ -170,8 +411,15 @@
>  static int fini_logemu(struct ulogd_pluginstance *pi) {
>  	struct logemu_instance *li = (struct logemu_instance *) &pi->private;
>  
> +#ifdef LOGNAME_EXPANSION
> +
> +	if (li->of != stdout && li->of != NULL)
> +		fclose(li->of);
> +#else
> +
>  	if (li->of != stdout)
>  		fclose(li->of);
> +#endif /*LOGNAME_EXPANSION*/
>  
>  	return 0;
>  }


--uAKRQypu60I7Lcqm--
