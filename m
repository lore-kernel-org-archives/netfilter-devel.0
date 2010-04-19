From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/4] netfilter: xtables2: make ip_tables reentrant
Date: Mon, 19 Apr 2010 14:22:49 +0200
Message-ID: <4BCC4B19.7040805@trash.net>
References: <1271373909-6959-1-git-send-email-jengelh@medozas.de> <1271373909-6959-3-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:55812 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754098Ab0DSMWt (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 19 Apr 2010 08:22:49 -0400
In-Reply-To: <1271373909-6959-3-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> Currently, the table traverser stores return addresses in the ruleset
> itself (struct ip6t_entry->comefrom). This has a well-known drawback:
> the jumpstack is overwritten on reentry, making it necessary for
> targets to return absolute verdicts. Also, the ruleset (which might
> be heavy memory-wise) needs to be replicated for each CPU that can
> possibly invoke ip6t_do_table.
> 
> This patch decouples the jumpstack from struct ip6t_entry and instead
> puts it into xt_table_info. Not being restricted by 'comefrom'
> anymore, we can set up a stack as needed. By default, there is room
> allocated for two entries into the traverser. The setting is
> configurable at runtime through sysfs and will take effect when a
> table is replaced by a new one.

The changelog is not up to date anymore, but ...

> 
> diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
> index 26ced0c..50c8672 100644
> --- a/include/linux/netfilter/x_tables.h
> +++ b/include/linux/netfilter/x_tables.h
> @@ -401,6 +401,13 @@ struct xt_table_info {
>  	unsigned int hook_entry[NF_INET_NUMHOOKS];
>  	unsigned int underflow[NF_INET_NUMHOOKS];
>  
> +	/*
> +	 * Number of user chains. Since tables cannot have loops, at most
> +	 * @stacksize jumps (number of user chains) can possibly be made.
> +	 */
> +	unsigned int stacksize;
> +	unsigned int *stackptr;
> +	void ***jumpstack;
...
> diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
> index 8e23d8f..edde5c6 100644
> --- a/net/netfilter/x_tables.c
> +++ b/net/netfilter/x_tables.c
> @@ -62,6 +62,9 @@ static const char *const xt_prefix[NFPROTO_NUMPROTO] = {
>  	[NFPROTO_IPV6]   = "ip6",
>  };
>  
> +/* Allow this many total (re)entries. */
> +static const unsigned int xt_jumpstack_multiplier = 2;
> +

Why aren't you using a define instead of saving the stack size
in the table info?
