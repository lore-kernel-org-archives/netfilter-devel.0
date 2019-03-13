Return-Path: <SRS0=37vH=RQ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1906CC10F03
	for <netfilter-devel@archiver.kernel.org>; Wed, 13 Mar 2019 11:34:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DC9FE2147C
	for <netfilter-devel@archiver.kernel.org>; Wed, 13 Mar 2019 11:34:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726011AbfCMLeN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 13 Mar 2019 07:34:13 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:38699 "EHLO
        smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725868AbfCMLeN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 13 Mar 2019 07:34:13 -0400
Received: from cpe-2606-a000-111b-405a-9816-2c85-c514-8f7a.dyn6.twc.com ([2606:a000:111b:405a:9816:2c85:c514:8f7a] helo=localhost)
        by smtp.tuxdriver.com with esmtpsa (TLSv1:AES256-SHA:256)
        (Exim 4.63)
        (envelope-from <nhorman@tuxdriver.com>)
        id 1h4299-0006FL-Fz; Wed, 13 Mar 2019 07:34:10 -0400
Date:   Wed, 13 Mar 2019 07:33:33 -0400
From:   Neil Horman <nhorman@tuxdriver.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>,
        netfilter-devel@vger.kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        pablo@netfilter.org, fw@strlen.de
Subject: Re: [PATCH net] netfilter: bridge: set skb transport_header before
 entering NF_INET_PRE_ROUTING
Message-ID: <20190313113333.GB16434@hmswarspite.think-freely.org>
References: <35febf82503a4126b5ba28b02a0ca6e8f37a2765.1552466009.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <35febf82503a4126b5ba28b02a0ca6e8f37a2765.1552466009.git.lucien.xin@gmail.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Mar 13, 2019 at 04:33:29PM +0800, Xin Long wrote:
> Since Commit 21d1196a35f5 ("ipv4: set transport header earlier"),
> skb->transport_header has been always set before entering INET
> netfilter. This patch is to set skb->transport_header for bridge
> before entering INET netfilter by bridge-nf-call-iptables.
> 
> It also fixes an issue that sctp_error() couldn't compute a right
> csum due to unset skb->transport_header.
> 
> Fixes: e6d8b64b34aa ("net: sctp: fix and consolidate SCTP checksumming code")
> Reported-by: Li Shuang <shuali@redhat.com>
> Suggested-by: Pablo Neira Ayuso <pablo@netfilter.org>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---
>  net/bridge/br_netfilter_hooks.c | 1 +
>  net/bridge/br_netfilter_ipv6.c  | 2 ++
>  2 files changed, 3 insertions(+)
> 
> diff --git a/net/bridge/br_netfilter_hooks.c b/net/bridge/br_netfilter_hooks.c
> index c93c35b..4d09a33 100644
> --- a/net/bridge/br_netfilter_hooks.c
> +++ b/net/bridge/br_netfilter_hooks.c
> @@ -502,6 +502,7 @@ static unsigned int br_nf_pre_routing(void *priv,
>  	nf_bridge->ipv4_daddr = ip_hdr(skb)->daddr;
>  
>  	skb->protocol = htons(ETH_P_IP);
> +	skb->transport_header = skb->network_header + ip_hdr(skb)->ihl * 4;
>  
>  	NF_HOOK(NFPROTO_IPV4, NF_INET_PRE_ROUTING, state->net, state->sk, skb,
>  		skb->dev, NULL,
> diff --git a/net/bridge/br_netfilter_ipv6.c b/net/bridge/br_netfilter_ipv6.c
> index 564710f..e88d664 100644
> --- a/net/bridge/br_netfilter_ipv6.c
> +++ b/net/bridge/br_netfilter_ipv6.c
> @@ -235,6 +235,8 @@ unsigned int br_nf_pre_routing_ipv6(void *priv,
>  	nf_bridge->ipv6_daddr = ipv6_hdr(skb)->daddr;
>  
>  	skb->protocol = htons(ETH_P_IPV6);
> +	skb->transport_header = skb->network_header + sizeof(struct ipv6hdr);
> +
>  	NF_HOOK(NFPROTO_IPV6, NF_INET_PRE_ROUTING, state->net, state->sk, skb,
>  		skb->dev, NULL,
>  		br_nf_pre_routing_finish_ipv6);
> -- 
> 2.1.0
> 
> 
Acked-by: Neil Horman <nhorman@tuxdriver.com>
