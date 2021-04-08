Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 944D4C433ED
	for <netfilter-devel@archiver.kernel.org>; Thu,  8 Apr 2021 22:48:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5B42661008
	for <netfilter-devel@archiver.kernel.org>; Thu,  8 Apr 2021 22:48:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232404AbhDHWst (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 8 Apr 2021 18:48:49 -0400
Received: from mail.netfilter.org ([217.70.188.207]:41358 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232265AbhDHWss (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 8 Apr 2021 18:48:48 -0400
Received: from us.es (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 7EA8663E42;
        Fri,  9 Apr 2021 00:48:14 +0200 (CEST)
Date:   Fri, 9 Apr 2021 00:48:33 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     wenxu <wenxu@ucloud.cn>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: nft_payload: fix vlan_tpid get from
 h_vlan_proto
Message-ID: <20210408224833.GA8340@salvia>
References: <1617347632-19283-1-git-send-email-wenxu@ucloud.cn>
 <20210402195403.GA22049@salvia>
 <6ce0f16c-69ae-265a-bea8-bc2c4705dd5b@ucloud.cn>
 <920cc175-3bc9-912c-6d00-5e6bd02d546a@ucloud.cn>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="wRRV7LY7NUeQGEoC"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <920cc175-3bc9-912c-6d00-5e6bd02d546a@ucloud.cn>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--wRRV7LY7NUeQGEoC
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Sat, Apr 03, 2021 at 10:59:59PM +0800, wenxu wrote:
> 
> 在 2021/4/3 21:33, wenxu 写道:
> > 在 2021/4/3 3:54, Pablo Neira Ayuso 写道:
> >> On Fri, Apr 02, 2021 at 03:13:52PM +0800, wenxu@ucloud.cn wrote:
> >>> From: wenxu <wenxu@ucloud.cn>
> >>>
> >>> vlan_tpid of flow_dissector_key_vlan should be set as h_vlan_proto
> >>> but not h_vlan_encapsulated_proto.
> >> Probably this patch instead?
> > I don't think so.  The vlan_tpid in flow_dissector_key_vlan should be the
> >
> > vlan proto (such as ETH_P_8021Q or ETH_P_8021AD) but not h_vlan_encapsulated_proto (for next header proto).
> >
> > But this is a problem that the vlan_h_proto is the same as offsetof(struct ethhdr, h_proto)
> 
> The design of flow_dissector_key_basic->n_porto should be set as next header proto(ipv4/6)
> 
> for vlan packet which is h_vlan_encapsulated_proto in the vlan header. (check from fl_set_key and skb_flow_dissect)
> 
> Maybe the patch should as following?
>
> diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
> index cb1c8c2..84c5ecc 100644
> --- a/net/netfilter/nft_payload.c
> +++ b/net/netfilter/nft_payload.c
> @@ -233,8 +233,8 @@ static int nft_payload_offload_ll(struct nft_offload_ctx *ctx,
>                 if (!nft_payload_offload_mask(reg, priv->len, sizeof(__be16)))
>                         return -EOPNOTSUPP;
>  
> -               NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_VLAN, vlan,
> -                                 vlan_tpid, sizeof(__be16), reg);
> +               NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_BASIC, basic,
> +                                 n_proto, sizeof(__be16), reg);

Maybe.

Certainly, the patch that I'm attaching seems to be needed. Otherwise,
vlan id match does not work.

--wRRV7LY7NUeQGEoC
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment; filename="x.patch"

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index d157d1b9cad6..b7c1c91d7abd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1942,23 +1942,25 @@ static int mlx5e_flower_parse_meta(struct net_device *filter_dev,
 		return 0;
 
 	flow_rule_match_meta(rule, &match);
-	if (match.mask->ingress_ifindex != 0xFFFFFFFF) {
-		NL_SET_ERR_MSG_MOD(extack, "Unsupported ingress ifindex mask");
-		return -EOPNOTSUPP;
-	}
+	if (match.mask->ingress_ifindex) {
+		if (match.mask->ingress_ifindex != 0xFFFFFFFF) {
+			NL_SET_ERR_MSG_MOD(extack, "Unsupported ingress ifindex mask");
+			return -EOPNOTSUPP;
+		}
 
-	ingress_dev = __dev_get_by_index(dev_net(filter_dev),
-					 match.key->ingress_ifindex);
-	if (!ingress_dev) {
-		NL_SET_ERR_MSG_MOD(extack,
-				   "Can't find the ingress port to match on");
-		return -ENOENT;
-	}
+		ingress_dev = __dev_get_by_index(dev_net(filter_dev),
+						 match.key->ingress_ifindex);
+		if (!ingress_dev) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Can't find the ingress port to match on");
+			return -ENOENT;
+		}
 
-	if (ingress_dev != filter_dev) {
-		NL_SET_ERR_MSG_MOD(extack,
-				   "Can't match on the ingress filter port");
-		return -EOPNOTSUPP;
+		if (ingress_dev != filter_dev) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Can't match on the ingress filter port");
+			return -EOPNOTSUPP;
+		}
 	}
 
 	return 0;

--wRRV7LY7NUeQGEoC--
