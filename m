Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E6B2C433EF
	for <netfilter-devel@archiver.kernel.org>; Wed, 25 May 2022 18:46:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344133AbiEYSqL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 25 May 2022 14:46:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343850AbiEYSpB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 25 May 2022 14:45:01 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A3B4BA186
        for <netfilter-devel@vger.kernel.org>; Wed, 25 May 2022 11:44:59 -0700 (PDT)
Date:   Wed, 25 May 2022 20:44:56 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     wenxu@chinatelecom.cn
Cc:     netfilter-devel@vger.kernel.org, sven.auhagen@voleatech.de
Subject: Re: [PATCH nf-next] netfilter: flowtable: fix nft_flow_route use
 saddr for reverse route
Message-ID: <Yo55KCPBfIk46hxv@salvia>
References: <1653495837-75877-1-git-send-email-wenxu@chinatelecom.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1653495837-75877-1-git-send-email-wenxu@chinatelecom.cn>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, May 25, 2022 at 12:23:57PM -0400, wenxu@chinatelecom.cn wrote:
> From: wenxu <wenxu@chinatelecom.cn>
> 
> The nf_flow_tabel get route through ip_route_output_key which
> the saddr should be local ones. For the forward case it always
> can't get the other_dst and can't offload any flows
> 
> Fixes: 3412e1641828 (netfilter: flowtable: nft_flow_route use more data for reverse route)
> Signed-off-by: wenxu <wenxu@chinatelecom.cn>
> ---
>  net/netfilter/nft_flow_offload.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
> index 40d18aa..742a494 100644
> --- a/net/netfilter/nft_flow_offload.c
> +++ b/net/netfilter/nft_flow_offload.c
> @@ -230,7 +230,6 @@ static int nft_flow_route(const struct nft_pktinfo *pkt,
>  	switch (nft_pf(pkt)) {
>  	case NFPROTO_IPV4:
>  		fl.u.ip4.daddr = ct->tuplehash[dir].tuple.src.u3.ip;
> -		fl.u.ip4.saddr = ct->tuplehash[dir].tuple.dst.u3.ip;

I think this should be instead:

                fl.u.ip4.saddr = ct->tuplehash[!dir].tuple.src.u3.ip;

to accordingly deal with snat and dnat.

>  		fl.u.ip4.flowi4_oif = nft_in(pkt)->ifindex;
>  		fl.u.ip4.flowi4_iif = this_dst->dev->ifindex;
>  		fl.u.ip4.flowi4_tos = RT_TOS(ip_hdr(pkt->skb)->tos);
> @@ -238,7 +237,6 @@ static int nft_flow_route(const struct nft_pktinfo *pkt,
>  		break;
>  	case NFPROTO_IPV6:
>  		fl.u.ip6.daddr = ct->tuplehash[dir].tuple.src.u3.in6;
> -		fl.u.ip6.saddr = ct->tuplehash[dir].tuple.dst.u3.in6;

                fl.u.ip6.saddr = ct->tuplehash[!dir].tuple.src.u3.in6;

>  		fl.u.ip6.flowi6_oif = nft_in(pkt)->ifindex;
>  		fl.u.ip6.flowi6_iif = this_dst->dev->ifindex;
>  		fl.u.ip6.flowlabel = ip6_flowinfo(ipv6_hdr(pkt->skb));
> -- 
> 1.8.3.1
> 
