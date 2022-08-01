Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEA76C00144
	for <netfilter-devel@archiver.kernel.org>; Mon,  1 Aug 2022 10:31:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230012AbiHAKbm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 1 Aug 2022 06:31:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229819AbiHAKbl (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 1 Aug 2022 06:31:41 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5F4601F7
        for <netfilter-devel@vger.kernel.org>; Mon,  1 Aug 2022 03:31:40 -0700 (PDT)
Date:   Mon, 1 Aug 2022 12:31:35 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     wenxu@chinatelecom.cn
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next v2 1/3] nf_flow_table_offload: offload the vlan
 encap in the flowtable
Message-ID: <Yuerh8IrTVa35dIs@salvia>
References: <1653548252-2602-1-git-send-email-wenxu@chinatelecom.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1653548252-2602-1-git-send-email-wenxu@chinatelecom.cn>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, May 26, 2022 at 02:57:30AM -0400, wenxu@chinatelecom.cn wrote:
[...]
> diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
> index b350fe9..5da651d 100644
> --- a/net/netfilter/nf_flow_table_ip.c
> +++ b/net/netfilter/nf_flow_table_ip.c
> @@ -291,6 +291,23 @@ static bool nf_flow_skb_encap_protocol(const struct sk_buff *skb, __be16 proto,
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

Nit: skb_vlan_push() might fail.

> +				      tuplehash->tuple.encap[i].proto,
> +				      tuplehash->tuple.encap[i].id);
> +			break;
> +		}
> +	}
> +}

If I understand correctly, the goal of this patchset is to move the
existing vlan and ppp support to use the XMIT_DIRECT path?

So this already works but you would prefer to not use XMIT_NEIGH?

The scenarios you describe already work fine with the existing
codebase? I am assuming 'eth' provides Internet access? You refer to
this in the patch description:

 br0.100-->br0(vlan filter enable)-->eth
 br0(vlan filter enable)-->eth
 br0(vlan filter disable)-->eth.100-->eth
