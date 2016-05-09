From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2] xtables: Add a smaller delay option when waiting for
 xtables lock
Date: Mon, 9 May 2016 23:40:44 +0200
Message-ID: <20160509214044.GA23794@salvia>
References: <1462504699-14988-1-git-send-email-subashab@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Liping Zhang <zlpnobody@gmail.com>
To: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35568 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751468AbcEIVkx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 May 2016 17:40:53 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 63646EAA6C
	for <netfilter-devel@vger.kernel.org>; Mon,  9 May 2016 23:40:51 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 4FC2B134704
	for <netfilter-devel@vger.kernel.org>; Mon,  9 May 2016 23:40:51 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 1C2B1134704
	for <netfilter-devel@vger.kernel.org>; Mon,  9 May 2016 23:40:49 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1462504699-14988-1-git-send-email-subashab@codeaurora.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Subash,

On Thu, May 05, 2016 at 09:18:19PM -0600, Subash Abhinov Kasiviswanathan wrote:
> ip[6]tables currently waits for 1 second for the xtables lock to be
> freed if the -w option is used. We have seen that the lock is held
> much less than that resulting in unnecessary delay when trying to
> acquire the lock. This problem is even severe in case of latency
> sensitive applications.
> 
> Introduce an delay option with 10ms granularity (experimentally
> determined) by specifying the delay in [seconds.milliseconds] as
> an argument to -w. If milliseconds are not specified, the existing
> behavior of 1 second sleep is preserved.
> 
> v1->v2: Change behavior to take millisecond sleep as an argument to
> -w as suggested by Pablo. Also maintain current behavior for -w to
> sleep for 1 second as mentioned by Liping.

My impression after looking at this patch is that you can simplify it
using 'struct timeval' and use select() to wait for the time you need.

> Cc: Liping Zhang <zlpnobody@gmail.com>
> Cc: Pablo Neira Ayuso <pablo@netfilter.org>
> Signed-off-by: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
> ---
>  iptables/ip6tables.c | 12 +++++++-----
>  iptables/iptables.c  | 12 +++++++-----
>  iptables/xshared.c   | 27 ++++++++++++++++++++-------
>  iptables/xshared.h   |  2 +-
>  iptables/xtables.c   |  6 +++---
>  5 files changed, 38 insertions(+), 21 deletions(-)
> 
> diff --git a/iptables/ip6tables.c b/iptables/ip6tables.c
> index 2731209..d19c5d5 100644
> --- a/iptables/ip6tables.c
> +++ b/iptables/ip6tables.c
> @@ -259,7 +259,9 @@ exit_printhelp(const struct xtables_rule_match *matches)
>  "				network interface name ([+] for wildcard)\n"
>  "  --table	-t table	table to manipulate (default: `filter')\n"
>  "  --verbose	-v		verbose mode\n"
> -"  --wait	-w [seconds]	wait for the xtables lock\n"
> +"  --wait	-w [seconds.milliseconds]\n"
> +"				wait for the xtables lock\n"
> +"				10ms is the minimum millisecond resolution\n"
>  "  --line-numbers		print line numbers when listing\n"
>  "  --exact	-x		expand numbers (display exact values)\n"
>  /*"[!] --fragment	-f		match second or further fragments only\n"*/
> @@ -1324,7 +1326,7 @@ int do_command6(int argc, char *argv[], char **table,
>  	struct in6_addr *smasks = NULL, *dmasks = NULL;
>  
>  	int verbose = 0;
> -	int wait = 0;
> +	double wait = 0;
>  	const char *chain = NULL;
>  	const char *shostnetworkmask = NULL, *dhostnetworkmask = NULL;
>  	const char *policy = NULL, *newname = NULL;
> @@ -1606,12 +1608,12 @@ int do_command6(int argc, char *argv[], char **table,
>  			}
>  			wait = -1;
>  			if (optarg) {
> -				if (sscanf(optarg, "%i", &wait) != 1)
> +				if (sscanf(optarg, "%lf", &wait) != 1)
>  					xtables_error(PARAMETER_PROBLEM,
>  						"wait seconds not numeric");
>  			} else if (optind < argc && argv[optind][0] != '-'
>  						 && argv[optind][0] != '!')
> -				if (sscanf(argv[optind++], "%i", &wait) != 1)
> +				if (sscanf(argv[optind++], "%lf", &wait) != 1)
>  					xtables_error(PARAMETER_PROBLEM,
>  						"wait seconds not numeric");
>  			break;
> @@ -1768,7 +1770,7 @@ int do_command6(int argc, char *argv[], char **table,
>  		if (wait == 0)
>  			fprintf(stderr, "Perhaps you want to use the -w option?\n");
>  		else
> -			fprintf(stderr, "Stopped waiting after %ds.\n", wait);
> +			fprintf(stderr, "Stopped waiting after %fs.\n", wait);
>  		xtables_free_opts(1);
>  		exit(RESOURCE_PROBLEM);
>  	}
> diff --git a/iptables/iptables.c b/iptables/iptables.c
> index 91617c2..64bd1a1 100644
> --- a/iptables/iptables.c
> +++ b/iptables/iptables.c
> @@ -253,7 +253,9 @@ exit_printhelp(const struct xtables_rule_match *matches)
>  "				network interface name ([+] for wildcard)\n"
>  "  --table	-t table	table to manipulate (default: `filter')\n"
>  "  --verbose	-v		verbose mode\n"
> -"  --wait	-w [seconds]	wait for the xtables lock\n"
> +"  --wait	-w [seconds.milliseconds]\n"
> +"				wait for the xtables lock\n"
> +"				10ms is the minimum millisecond resolution\n"
>  "  --line-numbers		print line numbers when listing\n"
>  "  --exact	-x		expand numbers (display exact values)\n"
>  "[!] --fragment	-f		match second or further fragments only\n"
> @@ -1320,7 +1322,7 @@ int do_command4(int argc, char *argv[], char **table,
>  	struct in_addr *daddrs = NULL, *dmasks = NULL;
>  
>  	int verbose = 0;
> -	int wait = 0;
> +	double wait = 0;
>  	const char *chain = NULL;
>  	const char *shostnetworkmask = NULL, *dhostnetworkmask = NULL;
>  	const char *policy = NULL, *newname = NULL;
> @@ -1599,12 +1601,12 @@ int do_command4(int argc, char *argv[], char **table,
>  			}
>  			wait = -1;
>  			if (optarg) {
> -				if (sscanf(optarg, "%i", &wait) != 1)
> +				if (sscanf(optarg, "%lf", &wait) != 1)
>  					xtables_error(PARAMETER_PROBLEM,
>  						"wait seconds not numeric");
>  			} else if (optind < argc && argv[optind][0] != '-'
>  						 && argv[optind][0] != '!')
> -				if (sscanf(argv[optind++], "%i", &wait) != 1)
> +				if (sscanf(argv[optind++], "%lf", &wait) != 1)
>  					xtables_error(PARAMETER_PROBLEM,
>  						"wait seconds not numeric");
>  			break;
> @@ -1764,7 +1766,7 @@ int do_command4(int argc, char *argv[], char **table,
>  		if (wait == 0)
>  			fprintf(stderr, "Perhaps you want to use the -w option?\n");
>  		else
> -			fprintf(stderr, "Stopped waiting after %ds.\n", wait);
> +			fprintf(stderr, "Stopped waiting after %fs.\n", wait);
>  		xtables_free_opts(1);
>  		exit(RESOURCE_PROBLEM);
>  	}
> diff --git a/iptables/xshared.c b/iptables/xshared.c
> index 81c2581..2aeb8b8 100644
> --- a/iptables/xshared.c
> +++ b/iptables/xshared.c
> @@ -15,6 +15,8 @@
>  #include "xshared.h"
>  
>  #define XT_LOCK_NAME	"/run/xtables.lock"
> +#define BASE_MICROSECOND_WAIT	10000
> +#define WAIT_PRECISION	100
>  
>  /*
>   * Print out any special helps. A user might like to be able to add a --help
> @@ -244,9 +246,11 @@ void xs_init_match(struct xtables_match *match)
>  		match->init(match->m);
>  }
>  
> -bool xtables_lock(int wait)
> +bool xtables_lock(double wait)
>  {
> -	int fd, waited = 0, i = 0;
> +	int fd, waited = 0, i = 0, us_wait = 0, us_waited = 0;
> +
> +	us_wait = (((int)(wait*WAIT_PRECISION))%WAIT_PRECISION)*BASE_MICROSECOND_WAIT;
>  
>  	fd = open(XT_LOCK_NAME, O_CREAT, 0600);
>  	if (fd < 0)
> @@ -255,12 +259,21 @@ bool xtables_lock(int wait)
>  	while (1) {
>  		if (flock(fd, LOCK_EX | LOCK_NB) == 0)
>  			return true;
> -		else if (wait >= 0 && waited >= wait)
> +		else if (wait >= 0 && waited >= (int)wait && us_waited >= us_wait)
>  			return false;
> -		if (++i % 2 == 0)
> +		if ((++i % 2 == 0 && !us_wait) || (++i % 10 == 0))
>  			fprintf(stderr, "Another app is currently holding the xtables lock; "
> -				"waiting (%ds) for it to exit...\n", waited);
> -		waited++;
> -		sleep(1);
> +				"waiting (%ds %dms) for it to exit...\n", waited, us_waited/1000);
> +		if (us_wait) {
> +			us_waited += BASE_MICROSECOND_WAIT;
> +			usleep(BASE_MICROSECOND_WAIT);
> +			if (us_waited == 1000000) {
> +				waited++;
> +				us_waited = 0;
> +			}
> +		} else {
> +			waited++;
> +			sleep(1);
> +		}
>  	}
>  }
> diff --git a/iptables/xshared.h b/iptables/xshared.h
> index 40dd915..de4ae99 100644
> --- a/iptables/xshared.h
> +++ b/iptables/xshared.h
> @@ -85,7 +85,7 @@ extern struct xtables_match *load_proto(struct iptables_command_state *);
>  extern int subcmd_main(int, char **, const struct subcommand *);
>  extern void xs_init_target(struct xtables_target *);
>  extern void xs_init_match(struct xtables_match *);
> -extern bool xtables_lock(int wait);
> +extern bool xtables_lock(double wait);
>  
>  extern const struct xtables_afinfo *afinfo;
>  
> diff --git a/iptables/xtables.c b/iptables/xtables.c
> index ecd577c..d980060 100644
> --- a/iptables/xtables.c
> +++ b/iptables/xtables.c
> @@ -686,7 +686,7 @@ void do_parse(struct nft_handle *h, int argc, char *argv[],
>  	struct xtables_match *m;
>  	struct xtables_rule_match *matchp;
>  	struct xtables_target *t;
> -	int wait = 0;
> +	double wait = 0;
>  
>  	memset(cs, 0, sizeof(*cs));
>  	cs->jumpto = "";
> @@ -1009,12 +1009,12 @@ void do_parse(struct nft_handle *h, int argc, char *argv[],
>  					      "iptables-restore");
>  			}
>  			if (optarg) {
> -				if (sscanf(optarg, "%i", &wait) != 1)
> +				if (sscanf(optarg, "%lf", &wait) != 1)
>  					xtables_error(PARAMETER_PROBLEM,
>  						      "wait seconds not numeric");
>  			} else if (optind < argc && argv[optind][0] != '-'
>  				   && argv[optind][0] != '!')
> -				if (sscanf(argv[optind++], "%i", &wait) != 1)
> +				if (sscanf(argv[optind++], "%lf", &wait) != 1)
>  					xtables_error(PARAMETER_PROBLEM,
>  						      "wait seconds not numeric");
>  			break;
> -- 
> 1.8.2.1
> 
