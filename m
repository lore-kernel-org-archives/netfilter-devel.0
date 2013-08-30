From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nftables tool PATCH 2/5] src: Wrap netfilter hooks around human
 readable strings
Date: Sat, 31 Aug 2013 00:05:57 +0200
Message-ID: <20130830220557.GB5905@localhost>
References: <1377678791-7616-1-git-send-email-tomasz.bursztyka@linux.intel.com>
 <1377678791-7616-3-git-send-email-tomasz.bursztyka@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49311 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751791Ab3H3WGC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 30 Aug 2013 18:06:02 -0400
Content-Disposition: inline
In-Reply-To: <1377678791-7616-3-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Aug 28, 2013 at 11:33:08AM +0300, Tomasz Bursztyka wrote:
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
> I.e.: ARP family has different values for input, forward and output
> compared to IPv4, IPv6 or BRIDGE.

I get this error here if I use arp and prerouting:

nft add chain arp test test \{ type filter hook prerouting 0\; \}
<cmdline>:1:1-58: Error: Could not use hook "prerouting" with this
family
add chain arp test test { type filter hook prerouting 0; }
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

This can be done better by checking this in the evaluation step, in
chain_evaluate (you can reach the family via ctx).

Moreover, you can store the hook as string in the parser. Then, in the
evaluation step you validate that it is correct and convert it to
numeric value. That will require two fields in the chain, one for the
hookstr and one for hooknum.

With this approach, I think we can avoid having the intermediate enum
hook_numbers.

> Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
> ---
>  include/rule.h |  22 ++++++++++++
>  src/netlink.c  | 105 ++++++++++++++++++++++++++++++++++++++++++++++++++++++---
>  src/parser.y   |  21 +++++++++---
>  src/rule.c     |  28 ++++++++++-----
>  src/scanner.l  |   6 ----
>  5 files changed, 159 insertions(+), 23 deletions(-)
> 
> diff --git a/include/rule.h b/include/rule.h
> index 4f68431..97bace5 100644
> --- a/include/rule.h
> +++ b/include/rule.h
> @@ -82,6 +82,28 @@ extern void table_free(struct table *table);
>  extern void table_add_hash(struct table *table);
>  extern struct table *table_lookup(const struct handle *h);
>  
> +/*
> + * enum hook_numbers - family agnostic hook identifiers
> + *
> + * @HOOK_PREROUTING:	prerouting hook (NF_INET_LOCAL_PRE_ROUTING in ipv4)
> + * @HOOK_INPUT:		input hook (NF_INET_LOCAL_IN in ipv4)
> + * @HOOK_FORWARD:	forward hook (NF_INET_LOCAL_FORWARD in ipv4)
> + * @HOOK_OUTPUT:	output hook (NF_INET_LOCAL_OUT in ipv4)
> + * @HOOK_POSTROUTING:	postrouting hook (NF_INET_LOCAL_POST_ROUTING in ipv4)
> + * @HOOK_NUMHOOKS:	maximum number of hooks
> + */
> +enum hook_number {
> +	HOOK_PREROUTING		= 0,
> +	HOOK_INPUT		= 1,
> +	HOOK_FORWARD		= 2,
> +	HOOK_POSTROUTING	= 3,
> +	HOOK_OUTPUT		= 4,
> +	HOOK_NUMHOOKS		= 5,
> +};
