From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 3/8] libxtables: centralize checking for a .save
 function
Date: Mon, 28 Jan 2013 12:35:13 +0100
Message-ID: <20130128113513.GB15781@1984>
References: <1359056278-27618-1-git-send-email-jengelh@inai.de>
 <1359056278-27618-4-git-send-email-jengelh@inai.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40544 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932129Ab3A1LfU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 Jan 2013 06:35:20 -0500
Content-Disposition: inline
In-Reply-To: <1359056278-27618-4-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jan 24, 2013 at 08:37:53PM +0100, Jan Engelhardt wrote:
> Both iptables.c and ip6tables.c check for target->save == NULL, which
> can be consolidated. In fact, we should also check for match->save ==
> NULL, which this patch addds to libxtables.
> 
> Signed-off-by: Jan Engelhardt <jengelh@inai.de>
> ---
>  extensions/libxt_standard.c |    6 ++++++
>  iptables/ip6tables.c        |   12 ------------
>  iptables/iptables.c         |   12 ------------
>  libxtables/xtables.c        |   21 +++++++++++++++++++++
>  4 files changed, 27 insertions(+), 24 deletions(-)
> 
> diff --git a/extensions/libxt_standard.c b/extensions/libxt_standard.c
> index c64ba29..dd367d2 100644
> --- a/extensions/libxt_standard.c
> +++ b/extensions/libxt_standard.c
> @@ -9,12 +9,18 @@ static void standard_help(void)
>  "(If target is DROP, ACCEPT, RETURN or nothing)\n");
>  }
>  
> +static void standard_save(const void *ip, const struct xt_entry_target *t)
> +{
> +	/* "standard" is special ... */

I like this patch, but please, better add some more specific
description, eg. Tell where the real output save of the standard
target is done. A couple of lines won't hurt.

> +}
> +
>  static struct xtables_target standard_target = {
>  	.family		= NFPROTO_UNSPEC,
>  	.name		= "standard",
>  	.version	= XTABLES_VERSION,
>  	.size		= XT_ALIGN(sizeof(int)),
>  	.userspacesize	= XT_ALIGN(sizeof(int)),
> +	.save		= standard_save,
>  	.help		= standard_help,
>  };
>  
> diff --git a/iptables/ip6tables.c b/iptables/ip6tables.c
> index 556647f..371d700 100644
> --- a/iptables/ip6tables.c
> +++ b/iptables/ip6tables.c
> @@ -1112,18 +1112,6 @@ void print_rule6(const struct ip6t_entry *e,
>  
>  		if (target->save)
>  			target->save(&e->ipv6, t);
> -		else {
> -			/* If the target size is greater than xt_entry_target
> -			 * there is something to be saved, we just don't know
> -			 * how to print it */
> -			if (t->u.target_size !=
> -			    sizeof(struct xt_entry_target)) {
> -				fprintf(stderr, "Target `%s' is missing "
> -						"save function\n",
> -					t->u.user.name);
> -				exit(1);
> -			}
> -		}
>  	}
>  	printf("\n");
>  }
> diff --git a/iptables/iptables.c b/iptables/iptables.c
> index 00e3f01..6e5250e 100644
> --- a/iptables/iptables.c
> +++ b/iptables/iptables.c
> @@ -1103,18 +1103,6 @@ void print_rule4(const struct ipt_entry *e,
>  
>  		if (target->save)
>  			target->save(&e->ip, t);
> -		else {
> -			/* If the target size is greater than xt_entry_target
> -			 * there is something to be saved, we just don't know
> -			 * how to print it */
> -			if (t->u.target_size !=
> -			    sizeof(struct xt_entry_target)) {
> -				fprintf(stderr, "Target `%s' is missing "
> -						"save function\n",
> -					t->u.user.name);
> -				exit(1);
> -			}
> -		}
>  	}
>  	printf("\n");
>  }
> diff --git a/libxtables/xtables.c b/libxtables/xtables.c
> index 009ab91..b81013a 100644
> --- a/libxtables/xtables.c
> +++ b/libxtables/xtables.c
> @@ -852,6 +852,16 @@ void xtables_register_match(struct xtables_match *me)
>  		xtables_option_metavalidate(me->name, me->x6_options);
>  	if (me->extra_opts != NULL)
>  		xtables_check_options(me->name, me->extra_opts);
> +	if (me->userspacesize > 0 && me->save == NULL &&
> +	    me->real_name == NULL) {
> +		/*
> +		 * Catch extensions that have data to be saved, but which
> +		 * forgot to define a save method.
> +		 */
> +		fprintf(stderr, "Match \"%s\" is missing a save function\n",
> +		        me->name);
> +		exit(1);
> +	}
>  
>  	/* ignore not interested match */
>  	if (me->family != afinfo->family && me->family != AF_UNSPEC)
> @@ -1010,6 +1020,17 @@ void xtables_register_target(struct xtables_target *me)
>  		xtables_option_metavalidate(me->name, me->x6_options);
>  	if (me->extra_opts != NULL)
>  		xtables_check_options(me->name, me->extra_opts);
> +	if (me->userspacesize > 0 && me->save == NULL &&
> +	    me->real_name == NULL) {
> +		/*
> +		 * Catch extensions that have data to be saved, but which
> +		 * forgot to define a save method. This only applies to true
> +		 * modules (real_name==NULL), not aliases.
> +		 */
> +		fprintf(stderr, "Target \"%s\" is missing a save function\n",
> +		        me->name);
> +		exit(1);
> +	}
>  
>  	/* ignore not interested target */
>  	if (me->family != afinfo->family && me->family != AF_UNSPEC)
> -- 
> 1.7.10.4
> 
