From: Amos Jeffries <squid3@treenet.co.nz>
Subject: Re: [PATCH 07/11] netfilter: xtables: reduce indent level by one
Date: Sat, 09 May 2009 14:08:27 +1200
Message-ID: <4A04E59B.7040503@treenet.co.nz>
References: <1241774801-2315-1-git-send-email-jengelh@medozas.de> <1241774801-2315-8-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ip-58-28-153-233.static-xdsl.xnet.co.nz ([58.28.153.233]:57233
	"EHLO treenet.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751593AbZEICI3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 8 May 2009 22:08:29 -0400
In-Reply-To: <1241774801-2315-8-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> Cosmetic only. Transformation applied:
> 
> 	-if (foo) { long block; } else { short block; }
> 	+if (!foo) { short block; continue; } long block;
> 
> Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
> ---
>  net/ipv4/netfilter/arp_tables.c |  108 +++++++++++++++----------------
>  net/ipv4/netfilter/ip_tables.c  |  134 +++++++++++++++++++--------------------
>  net/ipv6/netfilter/ip6_tables.c |  132 +++++++++++++++++++--------------------
>  3 files changed, 181 insertions(+), 193 deletions(-)
> 
> diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
> index 940e54b..ecba246 100644
> --- a/net/ipv4/netfilter/arp_tables.c
> +++ b/net/ipv4/netfilter/arp_tables.c
> @@ -273,66 +273,62 @@ unsigned int arpt_do_table(struct sk_buff *skb,
>  
>  	arp = arp_hdr(skb);
>  	do {
> -		if (arp_packet_match(arp, skb->dev, indev, outdev, &e->arp)) {
> -			struct arpt_entry_target *t;
> -			int hdr_len;
> +		struct arpt_entry_target *t;
> +		int hdr_len;
>  
> -			hdr_len = sizeof(*arp) + (2 * sizeof(struct in_addr)) +
> -				(2 * skb->dev->addr_len);
> +		if (!arp_packet_match(arp, skb->dev, indev, outdev, &e->arp)) {
> +			e = arpt_next_entry(e);
> +			continue;
> +		}
>  
> -			ADD_COUNTER(e->counters, hdr_len, 1);
> +		hdr_len = sizeof(*arp) + (2 * sizeof(struct in_addr)) +
> +			(2 * skb->dev->addr_len);
> +		ADD_COUNTER(e->counters, hdr_len, 1);
>  
> -			t = arpt_get_target(e);
> +		t = arpt_get_target(e);
>  
> -			/* Standard target? */
> -			if (!t->u.kernel.target->target) {
> -				int v;
> +		/* Standard target? */
> +		if (!t->u.kernel.target->target) {
> +			int v;
>  
> -				v = ((struct arpt_standard_target *)t)->verdict;
> -				if (v < 0) {
> -					/* Pop from stack? */
> -					if (v != ARPT_RETURN) {
> -						verdict = (unsigned)(-v) - 1;
> -						break;
> -					}
> -					e = back;
> -					back = get_entry(table_base,
> -							 back->comefrom);
> -					continue;
> -				}
> -				if (table_base + v
> -				    != arpt_next_entry(e)) {
> -					/* Save old back ptr in next entry */
> -					struct arpt_entry *next
> -						= arpt_next_entry(e);
> -					next->comefrom =
> -						(void *)back - table_base;
> -
> -					/* set back pointer to next entry */
> -					back = next;
> -				}
> -
> -				e = get_entry(table_base, v);
> -			} else {
> -				/* Targets which reenter must return
> -				 * abs. verdicts
> -				 */
> -				tgpar.target   = t->u.kernel.target;
> -				tgpar.targinfo = t->data;
> -				verdict = t->u.kernel.target->target(skb,
> -								     &tgpar);
> -
> -				/* Target might have changed stuff. */
> -				arp = arp_hdr(skb);
> -
> -				if (verdict == ARPT_CONTINUE)
> -					e = arpt_next_entry(e);
> -				else
> -					/* Verdict */
> +			v = ((struct arpt_standard_target *)t)->verdict;
> +			if (v < 0) {
> +				/* Pop from stack? */
> +				if (v != ARPT_RETURN) {
> +					verdict = (unsigned)(-v) - 1;
>  					break;
> +				}
> +				e = back;
> +				back = get_entry(table_base, back->comefrom);
> +				continue;
>  			}
> +			if (table_base + v
> +			    != arpt_next_entry(e)) {
> +				/* Save old back ptr in next entry */
> +				struct arpt_entry *next = arpt_next_entry(e);
> +				next->comefrom = (void *)back - table_base;
> +
> +				/* set back pointer to next entry */
> +				back = next;
> +			}
> +
> +			e = get_entry(table_base, v);
>  		} else {
> -			e = arpt_next_entry(e);
> +			/* Targets which reenter must return
> +			 * abs. verdicts
> +			 */
> +			tgpar.target   = t->u.kernel.target;
> +			tgpar.targinfo = t->data;
> +			verdict = t->u.kernel.target->target(skb, &tgpar);
> +
> +			/* Target might have changed stuff. */
> +			arp = arp_hdr(skb);
> +
> +			if (verdict == ARPT_CONTINUE)
> +				e = arpt_next_entry(e);
> +			else
> +				/* Verdict */
> +				break;
>  		}
>  	} while (!hotdrop);
>  	xt_info_rdunlock_bh();
> diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
> index 7ec4e40..82888bc 100644
> --- a/net/ipv4/netfilter/ip_tables.c
> +++ b/net/ipv4/netfilter/ip_tables.c
> @@ -354,91 +354,87 @@ ipt_do_table(struct sk_buff *skb,
>  	back = get_entry(table_base, private->underflow[hook]);
>  
>  	do {
> +		struct ipt_entry_target *t;
> +
>  		IP_NF_ASSERT(e);
>  		IP_NF_ASSERT(back);
> -		if (ip_packet_match(ip, indev, outdev,
> +		if (!ip_packet_match(ip, indev, outdev,
>  		    &e->ip, mtpar.fragoff)) {
> -			struct ipt_entry_target *t;
> + no_match:
> +			e = ipt_next_entry(e);
> +			continue;
> +		}
>  
> -			if (IPT_MATCH_ITERATE(e, do_match, skb, &mtpar) != 0)
> -				goto no_match;
> +		if (IPT_MATCH_ITERATE(e, do_match, skb, &mtpar) != 0)
> +			goto no_match;
>  

Didn't your patch just earlier remove these no_match jumps from xtables?
Seems a bit odd to be adding them in here again and in the v6 tables as 
well.


Amos

