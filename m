From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: ipv4: Fix use-after-free in send_reset
Date: Wed, 1 Nov 2017 01:36:36 +0100
Message-ID: <20171101003636.GA29237@salvia>
References: <20171023061559.GA25493@tejaswit-linux.qualcomm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Tejaswi Tanikella <tejaswit@codeaurora.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47360 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750764AbdKAAgn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 31 Oct 2017 20:36:43 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 05D3C392E15
        for <netfilter-devel@vger.kernel.org>; Wed,  1 Nov 2017 01:36:42 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EA6AADA7E9
        for <netfilter-devel@vger.kernel.org>; Wed,  1 Nov 2017 01:36:41 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20171023061559.GA25493@tejaswit-linux.qualcomm.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Oct 23, 2017 at 11:46:03AM +0530, Tejaswi Tanikella wrote:
> niph is not updated after pskb_expand_head changes the skb head.
> It still points to the freed data, which is then used to update
> tot_len and checksum. This could cause use-after-free poison crash.
> 
> Update niph, if ip_route_me_harder does not fail.
> 
> Signed-off-by: Tejaswi Tanikella <tejaswit@codeaurora.org>
> ---
>  net/ipv4/netfilter/nf_reject_ipv4.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/net/ipv4/netfilter/nf_reject_ipv4.c b/net/ipv4/netfilter/nf_reject_ipv4.c
> index eeacbda..b2e0f90 100644
> --- a/net/ipv4/netfilter/nf_reject_ipv4.c
> +++ b/net/ipv4/netfilter/nf_reject_ipv4.c
> @@ -131,6 +131,8 @@ void nf_send_reset(struct net *net, struct sk_buff *oldskb, int hook)
>  
>  	if (ip_route_me_harder(net, nskb, RTN_UNSPEC))
>  		goto free_nskb;
> +	else
> +		niph = ip_hdr(nskb);

No need for else here, right? So we can just turn this into a one
liner to inconditionally reload this pointer.

>  	/* "Never happens" */
>  	if (nskb->len > dst_mtu(skb_dst(nskb)))
> -- 
> 1.9.1
> 
