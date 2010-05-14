From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCHv2] netfilter: Remove skb_is_nonlinear check from
	nf_conntrack_sip
Date: Fri, 14 May 2010 12:26:01 -0600
Message-ID: <20100514182601.GJ15969@obsidianresearch.com>
References: <20100514180138.GF15969@obsidianresearch.com> <4BED92AF.50704@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from [139.142.54.143] ([139.142.54.143]:44484 "EHLO quartz.orcorp.ca"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752563Ab0ENS0C (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 14 May 2010 14:26:02 -0400
Content-Disposition: inline
In-Reply-To: <4BED92AF.50704@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, May 14, 2010 at 08:13:03PM +0200, Patrick McHardy wrote:
> Your patch is based on an old version, the current version also
> supports TCP. I'll commit this patch to my tree after some testing.

Thanks!

> diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
> index b20f427..45750cc 100644
> +++ b/net/netfilter/nf_conntrack_sip.c
> @@ -1393,10 +1393,8 @@ static int sip_help_tcp(struct sk_buff *skb, unsigned int protoff,
>  
>  	nf_ct_refresh(ct, skb, sip_timeout * HZ);
>  
> -	if (skb_is_nonlinear(skb)) {
> -		pr_debug("Copy of skbuff not supported yet.\n");
> +	if (unlikely(skb_linearize(skb)))
>  		return NF_ACCEPT;
> -	}

Should this be NF_DROP? As I understand it skb_linearize only failes
if it runs out of memory, which probably means dropping is OK. But
passing a packet that might need rewriting could be harmful..

Jason
