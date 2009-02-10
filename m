From: Amos Jeffries <squid3@treenet.co.nz>
Subject: Re: [PATCH 06/16] libxtables: prefix/order - libdir
Date: Tue, 10 Feb 2009 19:38:34 +1300
Message-ID: <499120EA.3000108@treenet.co.nz>
References: <1234200900-5964-1-git-send-email-jengelh@medozas.de> <1234200900-5964-7-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ip-58-28-153-233.static-xdsl.xnet.co.nz ([58.28.153.233]:38763
	"EHLO treenet.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837AbZBJGi3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 10 Feb 2009 01:38:29 -0500
In-Reply-To: <1234200900-5964-7-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> Consolidate the libdir variable initialization code into xtables.c.
> 
> Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
> ---
>  include/xtables.h.in       |    1 +
>  include/xtables/internal.h |    2 --
>  ip6tables-restore.c        |   11 +----------
>  ip6tables-save.c           |   11 +----------
>  ip6tables-standalone.c     |   11 +----------
>  iptables-restore.c         |   11 +----------
>  iptables-save.c            |   11 +----------
>  iptables-standalone.c      |   11 +----------
>  xtables.c                  |   23 ++++++++++++++++++++---
>  9 files changed, 27 insertions(+), 65 deletions(-)
> 
> diff --git a/include/xtables.h.in b/include/xtables.h.in
> index 02a832d..268c42e 100644
> --- a/include/xtables.h.in
> +++ b/include/xtables.h.in
> @@ -159,6 +159,7 @@ extern const char *xtables_modprobe_program;
>  extern struct xtables_match *xtables_matches;
>  extern struct xtables_target *xtables_targets;
>  
> +extern void xtables_init(void);
>  extern void *xtables_calloc(size_t, size_t);
>  extern void *xtables_malloc(size_t);
>  
> diff --git a/include/xtables/internal.h b/include/xtables/internal.h
> index 60375cd..21c4401 100644
> --- a/include/xtables/internal.h
> +++ b/include/xtables/internal.h
> @@ -26,8 +26,6 @@ struct afinfo {
>  	int so_rev_target;
>  };
>  
> -extern char *lib_dir;
> -
>  /* This is decleared in ip[6]tables.c */
>  extern struct afinfo afinfo;
>  
> diff --git a/ip6tables-restore.c b/ip6tables-restore.c
> index 097711f..6be1a36 100644
> --- a/ip6tables-restore.c
> +++ b/ip6tables-restore.c
> @@ -130,16 +130,7 @@ int main(int argc, char *argv[])
>  	program_version = XTABLES_VERSION;
>  	line = 0;
>  
> -	lib_dir = getenv("XTABLES_LIBDIR");
> -	if (lib_dir == NULL) {
> -		lib_dir = getenv("IP6TABLES_LIB_DIR");
> -		if (lib_dir != NULL)
> -			fprintf(stderr, "IP6TABLES_LIB_DIR is deprecated, "
> -			        "use XTABLES_LIBDIR.\n");
> -	}
> -	if (lib_dir == NULL)
> -		lib_dir = XTABLES_LIBDIR;
> -
> +	xtables_init();
>  #ifdef NO_SHARED_LIBS
>  	init_extensions();
>  #endif
> diff --git a/ip6tables-save.c b/ip6tables-save.c
> index 11ef8c4..1b9d00a 100644
> --- a/ip6tables-save.c
> +++ b/ip6tables-save.c
> @@ -139,16 +139,7 @@ int main(int argc, char *argv[])
>  	program_name = "ip6tables-save";
>  	program_version = XTABLES_VERSION;
>  
> -	lib_dir = getenv("XTABLES_LIBDIR");
> -	if (lib_dir == NULL) {
> -		lib_dir = getenv("IP6TABLES_LIB_DIR");
> -		if (lib_dir != NULL)
> -			fprintf(stderr, "IP6TABLES_LIB_DIR is deprecated, "
> -			        "use XTABLES_LIBDIR.\n");
> -	}
> -	if (lib_dir == NULL)
> -		lib_dir = XTABLES_LIBDIR;
> -
> +	xtables_init();
>  #ifdef NO_SHARED_LIBS
>  	init_extensions();
>  #endif

...

>  
> +void xtables_init(void)
> +{
> +	xtables_libdir = getenv("XTABLES_LIBDIR");
> +	if (xtables_libdir != NULL)
> +		return;
> +	xtables_libdir = getenv("IPTABLES_LIB_DIR");
> +	if (xtables_libdir != NULL) {
> +		fprintf(stderr, "IPTABLES_LIB_DIR is deprecated, "
> +		        "use XTABLES_LIBDIR.\n");
> +		return;
> +	}
> +	xtables_libdir = XTABLES_LIBDIR;
> +}

You appear to be consolidating both IPTABLES_LIB_DIR and 
IP6TABLES_LIB_DIR into this function, yet it does not handle the 
IP6TABLES_LIB_DIR cases.

/2c

AYJ
