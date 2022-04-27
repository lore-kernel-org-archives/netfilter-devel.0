Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DEC3C433FE
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Apr 2022 14:10:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237404AbiD0ONn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 27 Apr 2022 10:13:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237329AbiD0ONm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Apr 2022 10:13:42 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B9FF15004E
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Apr 2022 07:10:30 -0700 (PDT)
Date:   Wed, 27 Apr 2022 16:10:27 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     wenxu@chinatelecom.cn
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next] nf_flow_table_offload: offload the vlan encap in
 the flowtable
Message-ID: <YmlO009uqhJNnBq7@salvia>
References: <1649169515-4337-1-git-send-email-wenx05124561@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1649169515-4337-1-git-send-email-wenx05124561@163.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Apr 05, 2022 at 10:38:35AM -0400, wenx05124561@163.com wrote:
> From: wenxu <wenxu@chinatelecom.cn>
> 
> This patch put the vlan dev process in the FLOW_OFFLOAD_XMIT_DIRECT
> mode. Xmit the packet with vlan can offload to the real dev directly.
> 
> It can support all kinds of VLAN dev path:
> br0.100-->br0(vlan filter enable)-->eth
> br0(vlan filter enable)-->eth
> br0(vlan filter disable)-->eth.100-->eth

I assume this eth is a bridge port.

> The packet xmit and recv offload to the 'eth' in both original and
> reply direction.

This is an enhancement or fix?

Is this going to work for VLAN + PPP?

Would you update tools/testing/selftests/netfilter/nft_flowtable.sh to
cover bridge filtering usecase? It could be done in a follow up patch.

> Signed-off-by: wenxu <wenxu@chinatelecom.cn>
> ---
>  net/netfilter/nf_flow_table_ip.c | 19 +++++++++++++++++++
>  net/netfilter/nft_flow_offload.c |  7 +++++--
>  2 files changed, 24 insertions(+), 2 deletions(-)
> 
> diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
> index 32c0eb1..99ae2550 100644
> --- a/net/netfilter/nf_flow_table_ip.c
> +++ b/net/netfilter/nf_flow_table_ip.c
> @@ -282,6 +282,23 @@ static bool nf_flow_skb_encap_protocol(const struct sk_buff *skb, __be16 proto,
>  	return false;
>  }
>  
> +static void nf_flow_encap_push(struct sk_buff *skb,
> +			       struct flow_offload_tuple_rhash *tuplehash)
> +{
> +	int i;
> +
> +	for (i = 0; i < tuplehash->tuple.encap_num; i++) {
> +		switch (tuplehash->tuple.encap[i].proto) {
> +		case htons(ETH_P_8021Q):
> +		case htons(ETH_P_8021AD):
> +			skb_vlan_push(skb,
> +				      tuplehash->tuple.encap[i].proto,
> +				      tuplehash->tuple.encap[i].id);
> +			break;
> +		}
> +	}
> +}
> +
>  static void nf_flow_encap_pop(struct sk_buff *skb,
>  			      struct flow_offload_tuple_rhash *tuplehash)
>  {
> @@ -403,6 +420,7 @@ static unsigned int nf_flow_queue_xmit(struct net *net, struct sk_buff *skb,
>  		ret = NF_STOLEN;
>  		break;
>  	case FLOW_OFFLOAD_XMIT_DIRECT:
> +		nf_flow_encap_push(skb, &flow->tuplehash[!dir]);
>  		ret = nf_flow_queue_xmit(state->net, skb, tuplehash, ETH_P_IP);
>  		if (ret == NF_DROP)
>  			flow_offload_teardown(flow);
> @@ -659,6 +677,7 @@ static int nf_flow_tuple_ipv6(struct sk_buff *skb, const struct net_device *dev,
>  		ret = NF_STOLEN;
>  		break;
>  	case FLOW_OFFLOAD_XMIT_DIRECT:
> +		nf_flow_encap_push(skb, &flow->tuplehash[!dir]);
>  		ret = nf_flow_queue_xmit(state->net, skb, tuplehash, ETH_P_IPV6);
>  		if (ret == NF_DROP)
>  			flow_offload_teardown(flow);
> diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
> index 900d48c..f9837c9 100644
> --- a/net/netfilter/nft_flow_offload.c
> +++ b/net/netfilter/nft_flow_offload.c
> @@ -119,12 +119,15 @@ static void nft_dev_path_info(const struct net_device_path_stack *stack,
>  				info->indev = NULL;
>  				break;
>  			}
> -			info->outdev = path->dev;
>  			info->encap[info->num_encaps].id = path->encap.id;
>  			info->encap[info->num_encaps].proto = path->encap.proto;
>  			info->num_encaps++;
> -			if (path->type == DEV_PATH_PPPOE)
> +			if (path->type == DEV_PATH_PPPOE) {
> +				info->outdev = path->dev;
>  				memcpy(info->h_dest, path->encap.h_dest, ETH_ALEN);
> +			}
> +			if (path->type == DEV_PATH_VLAN)
> +				info->xmit_type = FLOW_OFFLOAD_XMIT_DIRECT;
>  			break;
>  		case DEV_PATH_BRIDGE:
>  			if (is_zero_ether_addr(info->h_source))
> -- 
> 1.8.3.1
> 
