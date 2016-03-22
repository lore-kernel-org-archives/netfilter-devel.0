From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 5/5] netfilter: x_tables: don't move to non-existant next
 rule
Date: Tue, 22 Mar 2016 18:22:09 +0100
Message-ID: <20160322172209.GA1975@salvia>
References: <1458666173-24318-1-git-send-email-fw@strlen.de>
 <1458666173-24318-6-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55897 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752666AbcCVRWV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 Mar 2016 13:22:21 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id A16C01BFA95
	for <netfilter-devel@vger.kernel.org>; Tue, 22 Mar 2016 18:22:16 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 8F71DDA38A
	for <netfilter-devel@vger.kernel.org>; Tue, 22 Mar 2016 18:22:16 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 47791DA8FA
	for <netfilter-devel@vger.kernel.org>; Tue, 22 Mar 2016 18:22:14 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1458666173-24318-6-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Mar 22, 2016 at 06:02:53PM +0100, Florian Westphal wrote:
> Ben Hawkes reported an out-of-bounds write in mark_source_chains().
> This was caused by improper underflow check -- we should have bailed
> earlier.
> 
> The underflow check has been fixed in the preceeding change
> ("netfilter: x_tables: fix unconditional helper").
> 
> Just to be safe also add checks to mark_source_chains() in case we have other
> bugs that would cause such a condition.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  net/ipv4/netfilter/arp_tables.c | 8 +++++---
>  net/ipv4/netfilter/ip_tables.c  | 4 ++++
>  net/ipv6/netfilter/ip6_tables.c | 4 ++++
>  3 files changed, 13 insertions(+), 3 deletions(-)
> 
> diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
> index a2002ff..13266f4 100644
> --- a/net/ipv4/netfilter/arp_tables.c
> +++ b/net/ipv4/netfilter/arp_tables.c
> @@ -439,6 +439,8 @@ static int mark_source_chains(const struct xt_table_info *newinfo,
>  				size = e->next_offset;
>  				e = (struct arpt_entry *)
>  					(entry0 + pos + size);
> +				if (pos + size >= newinfo->size)
> +					return 0;
>  				e->counters.pcnt = pos;
>  				pos += size;
>  			} else {
> @@ -461,6 +463,8 @@ static int mark_source_chains(const struct xt_table_info *newinfo,
>  				} else {
>  					/* ... this is a fallthru */
>  					newpos = pos + e->next_offset;
> +					if (newpos >= newinfo->size)
> +						return 0;
>  				}
>  				e = (struct arpt_entry *)
>  					(entry0 + newpos);
> @@ -682,10 +686,8 @@ static int translate_table(struct xt_table_info *newinfo, void *entry0,
>  		}
>  	}
>  
> -	if (!mark_source_chains(newinfo, repl->valid_hooks, entry0)) {
> -		duprintf("Looping hook\n");
> +	if (!mark_source_chains(newinfo, repl->valid_hooks, entry0))
>  		return -ELOOP;
> -	}
>  
>  	/* Finally, each sanity check must pass */
>  	i = 0;
> diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
> index 45b1d97..c4836f0 100644
> --- a/net/ipv4/netfilter/ip_tables.c
> +++ b/net/ipv4/netfilter/ip_tables.c
> @@ -520,6 +520,8 @@ mark_source_chains(const struct xt_table_info *newinfo,
>  				size = e->next_offset;
>  				e = (struct ipt_entry *)
>  					(entry0 + pos + size);
> +				if (WARN_ON(pos + size >= newinfo->size))
> +					return 0;

This got WARN_ON(), but not in other spots.

I'll place 1 to 4 in the nf tree, then I suggest we take a little bit
more time to follow up to validate that we can actually trigger from
all possible corners.

Thanks Florian!
