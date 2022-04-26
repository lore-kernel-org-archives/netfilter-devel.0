Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35DF7C433FE
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 Apr 2022 11:21:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235688AbiDZLYU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 26 Apr 2022 07:24:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349500AbiDZLYT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 26 Apr 2022 07:24:19 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 18AFBCE10D
        for <netfilter-devel@vger.kernel.org>; Tue, 26 Apr 2022 04:21:12 -0700 (PDT)
Date:   Tue, 26 Apr 2022 13:21:09 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Ritaro Takenaka <ritarot634@gmail.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] nf_flowtable: ensure dst.dev is not blackhole
Message-ID: <YmfVpecE2UuiP6p8@salvia>
References: <20220425080835.5765-1-ritarot634@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220425080835.5765-1-ritarot634@gmail.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Mon, Apr 25, 2022 at 05:08:38PM +0900, Ritaro Takenaka wrote:
> Fixes sporadic IPv6 packet loss when flow offloading is enabled.
> IPv6 route GC calls dst_dev_put() which makes dst.dev blackhole_netdev
> even if dst is cached in flow offload. If a packet passes through this
> invalid flow, packet loss will occur.
> This is from Commit 227e1e4d0d6c (netfilter: nf_flowtable: skip device
> lookup from interface index), as outdev was cached independently before.
> Packet loss is reported on OpenWrt with Linux 5.4 and later.

dst_check() should deal with this.

In 5.4, this check is only enabled for xfrm.

> Signed-off-by: Ritaro Takenaka <ritarot634@gmail.com>
> ---
>  net/netfilter/nf_flow_table_ip.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
> index 32c0eb1b4..12f81661d 100644
> --- a/net/netfilter/nf_flow_table_ip.c
> +++ b/net/netfilter/nf_flow_table_ip.c
> @@ -624,6 +624,11 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
>  	if (nf_flow_state_check(flow, ip6h->nexthdr, skb, thoff))
>  		return NF_ACCEPT;
>  
> +	if (unlikely(tuplehash->tuple.dst_cache->dev == blackhole_netdev)) {
> +		flow_offload_teardown(flow);
> +		return NF_ACCEPT;
> +	}
> +
>  	if (skb_try_make_writable(skb, thoff + hdrsize))
>  		return NF_DROP;
>  
> -- 
> 2.25.1
> 
