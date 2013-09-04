From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nftables tool v2 PATCH 1/4] src: Wrap netfilter hooks around
 human readable strings
Date: Wed, 4 Sep 2013 12:44:55 +0200
Message-ID: <20130904104455.GA8768@localhost>
References: <1378288222-13182-1-git-send-email-tomasz.bursztyka@linux.intel.com>
 <1378288222-13182-2-git-send-email-tomasz.bursztyka@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56112 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934537Ab3IDKpG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 4 Sep 2013 06:45:06 -0400
Content-Disposition: inline
In-Reply-To: <1378288222-13182-2-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Sep 04, 2013 at 12:50:19PM +0300, Tomasz Bursztyka wrote:
> This allows to use unique, human readable, hook names for the command
> line and let the user being unaware of the complex netfilter's hook
> names and there difference depending on the netfilter family.
> 
> So:
> add chain foo bar { type route hook NF_INET_LOCAL_IN 0; }
> 
> becomes:
> add chain foo bar { type route hook input 0; }
> 
> It also fixes then the difference in hook values between families.
> I.e. ARP family has different values for input, forward and output
> compared to IPv4, IPv6 or BRIDGE.

Applied with changes.

> Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
> ---
>  include/rule.h |  3 +++
>  src/evaluate.c | 44 ++++++++++++++++++++++++++++++++++
>  src/parser.y   | 21 +++++++++++++----
>  src/rule.c     | 74 +++++++++++++++++++++++++++++++++++++++++++++++-----------
>  src/scanner.l  |  6 -----
>  5 files changed, 123 insertions(+), 25 deletions(-)
> 
> diff --git a/include/rule.h b/include/rule.h
> index 4f68431..14a3958 100644
> --- a/include/rule.h
> +++ b/include/rule.h
> @@ -98,6 +98,7 @@ enum chain_flags {
>   * @handle:	chain handle
>   * @location:	location the chain was defined at
>   * @flags:	chain flags
> + * @hookstr:	unified and human readable hook name (base chains)
>   * @hooknum:	hook number (base chains)
>   * @priority:	hook priority (base chains)
>   * @type:	chain type
> @@ -108,6 +109,7 @@ struct chain {
>  	struct handle		handle;
>  	struct location		location;
>  	uint32_t		flags;
> +	const char		*hookstr;
>  	unsigned int		hooknum;
>  	unsigned int		priority;
>  	const char		*type;
> @@ -115,6 +117,7 @@ struct chain {
>  	struct list_head	rules;
>  };
>  
> +extern const char *chain_hook_name_lookup(const char *name);
>  extern struct chain *chain_alloc(const char *name);
>  extern void chain_free(struct chain *chain);
>  extern void chain_add_hash(struct chain *chain, struct table *table);
> diff --git a/src/evaluate.c b/src/evaluate.c
> index 85c647e..470e141 100644
> --- a/src/evaluate.c
> +++ b/src/evaluate.c
> @@ -14,6 +14,8 @@
>  #include <stdint.h>
>  #include <string.h>
>  #include <arpa/inet.h>
> +#include <linux/netfilter.h>
> +#include <linux/netfilter_arp.h>
>  #include <linux/netfilter/nf_tables.h>
>  
>  #include <expression.h>
> @@ -54,6 +56,8 @@ static int __fmtstring(4, 5) __stmt_binary_error(struct eval_ctx *ctx,
>  	__stmt_binary_error(ctx, &(s1)->location, NULL, fmt, ## args)
>  #define stmt_binary_error(ctx, s1, s2, fmt, args...) \
>  	__stmt_binary_error(ctx, &(s1)->location, &(s2)->location, fmt, ## args)
> +#define chain_error(ctx, s1, fmt, args...) \
> +	__stmt_binary_error(ctx, &(s1)->location, NULL, fmt, ## args)
>  
>  static int __fmtstring(3, 4) set_error(struct eval_ctx *ctx,
>  				       const struct set *set,
> @@ -1247,10 +1251,50 @@ static int rule_evaluate(struct eval_ctx *ctx, struct rule *rule)
>  	return 0;
>  }
>  
> +static uint32_t hookname2nfhook(uint32_t family, const char *hook)
> +{
> +	switch (family) {
> +	case NFPROTO_IPV4:
> +	case NFPROTO_BRIDGE:
> +	case NFPROTO_IPV6:
> +		/* All these 3 families share actually
> +		 * the same values for each hook */
> +		if (!strcmp(hook, "prerouting"))
> +			return NF_INET_PRE_ROUTING;
> +		else if (!strcmp(hook, "in"))

"input"

> +			return NF_INET_LOCAL_IN;
> +		else if (!strcmp(hook, "forward"))
> +			return NF_INET_FORWARD;
> +		else if (!strcmp(hook, "postrouting"))
> +			return NF_INET_POST_ROUTING;
> +		return NF_INET_LOCAL_OUT;

better explicitly check for "output" and fall back to error otherwise.
