Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D129C433EF
	for <netfilter-devel@archiver.kernel.org>; Tue, 30 Nov 2021 22:16:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231491AbhK3WTj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 30 Nov 2021 17:19:39 -0500
Received: from mail.netfilter.org ([217.70.188.207]:52088 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230215AbhK3WTj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 30 Nov 2021 17:19:39 -0500
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id E01E8607C3;
        Tue, 30 Nov 2021 23:14:02 +0100 (CET)
Date:   Tue, 30 Nov 2021 23:16:14 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, Amish Chana <amish@3g.co.za>
Subject: Re: [PATCH nf] netfilter: bridge: add support for ppoe filtering
Message-ID: <YaairnnpCs3pd+Y3@salvia>
References: <20211123115031.2304-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211123115031.2304-1-fw@strlen.de>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Nov 23, 2021 at 12:50:31PM +0100, Florian Westphal wrote:
> This makes 'bridge-nf-filter-pppoe-tagged' sysctl work for
> bridged traffic.
> 
> Looking at the original commit it doesn't appear this ever worked:
> 
>  static unsigned int br_nf_post_routing(unsigned int hook, struct sk_buff **pskb,
> [..]
>         if (skb->protocol == htons(ETH_P_8021Q)) {
>                 skb_pull(skb, VLAN_HLEN);
>                 skb->network_header += VLAN_HLEN;
> +       } else if (skb->protocol == htons(ETH_P_PPP_SES)) {
> +               skb_pull(skb, PPPOE_SES_HLEN);
> +               skb->network_header += PPPOE_SES_HLEN;
>         }
>  [..]
> 	NF_HOOK(... POST_ROUTING, ...)
> 
> ... but the adjusted offsets are never restored.
> 
> The alternative would be to rip this code out for good,
> but otoh we'd have to keep this anyway for the vlan handling
> (which works because vlan tag info is in the skb, not the packet
>  payload).

If this has never worked (day 0), then I'm inclined to apply this to
nf-next.

Applied, thanks
