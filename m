From: "Tony.Ho" <iptables@iblink.com.cn>
Subject: Re: libxt_recent: do not allow both --set and --rttl
Date: Thu, 21 Aug 2008 01:10:26 +0800
Message-ID: <48AC5002.2070401@iblink.com.cn>
References: <alpine.LNX.1.10.0808031503320.6502@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Jan Engelhardt <jengelh@medozas.de>,
	netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from [61.128.196.5] ([61.128.196.5]:6900 "EHLO mail.iblink.com.cn"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752005AbYHTRSI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 20 Aug 2008 13:18:08 -0400
In-Reply-To: <alpine.LNX.1.10.0808031503320.6502@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

+	if ((flags & IPT_RECENT_TTL) &&
+	    (flags & (IPT_RECENT_SET | IPT_RECENT_REMOVE | IPT_RECENT_UPDATE)))

I think there should be:

+	if ((flags & IPT_RECENT_TTL) &&
+	    (flags & (IPT_RECENT_SET | IPT_RECENT_REMOVE)))

Is it rhght? 



Jan Engelhardt wrote:
> commit a49a4695616dd8c467360af5447869e3a68c4f4d
> Author: Jan Engelhardt <jengelh@medozas.de>
> Date:   Sun Aug 3 15:03:27 2008 -0400
>
> libxt_recent: do not allow both --set and --rttl
>
> Reported-by: Erich Schubert <erich@debian.org>
> Reference: Debian bug #346034
>
> "I was using the --rttl option in my --set line; this caused all
> incoming ssh connections to be rejected; --rttl is only to be used
> with --rcheck and --update."
>
> Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
> ---
>  extensions/libipt_recent.c |   33 +++++++++++++++++++++++----------
>  1 files changed, 23 insertions(+), 10 deletions(-)
>
> diff --git a/extensions/libipt_recent.c b/extensions/libipt_recent.c
> index 51b0d15..108de2f 100644
> --- a/extensions/libipt_recent.c
> +++ b/extensions/libipt_recent.c
> @@ -75,6 +75,10 @@ static void recent_init(struct xt_entry_match *match)
>  	info->side = IPT_RECENT_SOURCE;
>  }
>  
> +#define RECENT_CMDS \
> +	(IPT_RECENT_SET | IPT_RECENT_CHECK | \
> +	IPT_RECENT_UPDATE | IPT_RECENT_REMOVE)
> +
>  /* Function which parses command options; returns true if it
>     ate an option */
>  static int recent_parse(int c, char **argv, int invert, unsigned int *flags,
> @@ -83,43 +87,47 @@ static int recent_parse(int c, char **argv, int invert, unsigned int *flags,
>  	struct ipt_recent_info *info = (struct ipt_recent_info *)(*match)->data;
>  	switch (c) {
>  		case 201:
> -			if (*flags) exit_error(PARAMETER_PROBLEM,
> +			if (*flags & RECENT_CMDS)
> +				exit_error(PARAMETER_PROBLEM,
>  					"recent: only one of `--set', `--rcheck' "
>  					"`--update' or `--remove' may be set");
>  			check_inverse(optarg, &invert, &optind, 0);
>  			info->check_set |= IPT_RECENT_SET;
>  			if (invert) info->invert = 1;
> -			*flags = 1;
> +			*flags |= IPT_RECENT_SET;
>  			break;
>  			
>  		case 202:
> -			if (*flags) exit_error(PARAMETER_PROBLEM,
> +			if (*flags & RECENT_CMDS)
> +				exit_error(PARAMETER_PROBLEM,
>  					"recent: only one of `--set', `--rcheck' "
>  					"`--update' or `--remove' may be set");
>  			check_inverse(optarg, &invert, &optind, 0);
>  			info->check_set |= IPT_RECENT_CHECK;
>  			if(invert) info->invert = 1;
> -			*flags = 1;
> +			*flags |= IPT_RECENT_CHECK;
>  			break;
>  
>  		case 203:
> -			if (*flags) exit_error(PARAMETER_PROBLEM,
> +			if (*flags & RECENT_CMDS)
> +				exit_error(PARAMETER_PROBLEM,
>  					"recent: only one of `--set', `--rcheck' "
>  					"`--update' or `--remove' may be set");
>  			check_inverse(optarg, &invert, &optind, 0);
>  			info->check_set |= IPT_RECENT_UPDATE;
>  			if (invert) info->invert = 1;
> -			*flags = 1;
> +			*flags |= IPT_RECENT_UPDATE;
>  			break;
>  
>  		case 206:
> -			if (*flags) exit_error(PARAMETER_PROBLEM,
> +			if (*flags & RECENT_CMDS)
> +				exit_error(PARAMETER_PROBLEM,
>  					"recent: only one of `--set', `--rcheck' "
>  					"`--update' or `--remove' may be set");
>  			check_inverse(optarg, &invert, &optind, 0);
>  			info->check_set |= IPT_RECENT_REMOVE;
>  			if (invert) info->invert = 1;
> -			*flags = 1;
> +			*flags |= IPT_RECENT_REMOVE;
>  			break;
>  
>  		case 204:
> @@ -132,6 +140,7 @@ static int recent_parse(int c, char **argv, int invert, unsigned int *flags,
>  
>  		case 207:
>  			info->check_set |= IPT_RECENT_TTL;
> +			*flags |= IPT_RECENT_TTL;
>  			break;
>  
>  		case 208:
> @@ -157,11 +166,15 @@ static int recent_parse(int c, char **argv, int invert, unsigned int *flags,
>  /* Final check; must have specified a specific option. */
>  static void recent_check(unsigned int flags)
>  {
> -
> -	if (!flags)
> +	if (!(flags & RECENT_CMDS))
>  		exit_error(PARAMETER_PROBLEM,
>  			"recent: you must specify one of `--set', `--rcheck' "
>  			"`--update' or `--remove'");
> +	if ((flags & IPT_RECENT_TTL) &&
> +	    (flags & (IPT_RECENT_SET | IPT_RECENT_REMOVE | IPT_RECENT_UPDATE)))
> +		exit_error(PARAMETER_PROBLEM,
> +		           "recent: --rttl may only be used with --rcheck or "
> +		           "--update");
>  }
>  
>  /* Prints out the matchinfo. */
>
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>   

