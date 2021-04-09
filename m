Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADDCEC433B4
	for <netfilter-devel@archiver.kernel.org>; Fri,  9 Apr 2021 09:31:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7683E61182
	for <netfilter-devel@archiver.kernel.org>; Fri,  9 Apr 2021 09:31:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232770AbhDIJbX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 9 Apr 2021 05:31:23 -0400
Received: from mail.netfilter.org ([217.70.188.207]:42148 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232763AbhDIJbW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 9 Apr 2021 05:31:22 -0400
Received: from us.es (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 2F16462C1A;
        Fri,  9 Apr 2021 11:30:47 +0200 (CEST)
Date:   Fri, 9 Apr 2021 11:31:06 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     wenxu@ucloud.cn
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf v2] netfilter: nft_payload: fix the
 h_vlan_encapsulated_proto flow_dissector vlaue
Message-ID: <20210409093106.GA10639@salvia>
References: <1617944629-10338-1-git-send-email-wenxu@ucloud.cn>
 <20210409082717.GA9793@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210409082717.GA9793@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Apr 09, 2021 at 10:27:17AM +0200, Pablo Neira Ayuso wrote:
> On Fri, Apr 09, 2021 at 01:03:49PM +0800, wenxu@ucloud.cn wrote:
> > From: wenxu <wenxu@ucloud.cn>
> > 
> > For the vlan packet the h_vlan_encapsulated_proto should be set
> > on the flow_dissector_key_basic->n_porto flow_dissector.
> > 
> > Fixes: a82055af5959 ("netfilter: nft_payload: add VLAN offload support")
> > Fixes: 89d8fd44abfb ("netfilter: nft_payload: add C-VLAN offload support")
> > Signed-off-by: wenxu <wenxu@ucloud.cn>
> > ---
> >  net/netfilter/nft_payload.c | 8 ++++----
> >  1 file changed, 4 insertions(+), 4 deletions(-)
> > 
> > diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
> > index cb1c8c2..84c5ecc 100644
> > --- a/net/netfilter/nft_payload.c
> > +++ b/net/netfilter/nft_payload.c
> > @@ -233,8 +233,8 @@ static int nft_payload_offload_ll(struct nft_offload_ctx *ctx,
> >  		if (!nft_payload_offload_mask(reg, priv->len, sizeof(__be16)))
> >  			return -EOPNOTSUPP;
> >  
> > -		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_VLAN, vlan,
> > -				  vlan_tpid, sizeof(__be16), reg);
> > +		NFT_OFFLOAD_MATCH(FLOW_DISSECTOR_KEY_BASIC, basic,
> > +				  n_proto, sizeof(__be16), reg);
> 
> nftables already sets KEY_BASIC accordingly to 0x8100.
> 
> # nft --debug=netlink add rule netdev x y vlan id 100
> netdev
>   [ meta load iiftype => reg 1 ]
>   [ cmp eq reg 1 0x00000001 ]
>   [ payload load 2b @ link header + 12 => reg 1 ]
>   [ cmp eq reg 1 0x00000081 ] <----------------------------- HERE
>   [ payload load 2b @ link header + 14 => reg 1 ]
>   [ bitwise reg 1 = ( reg 1 & 0x0000ff0f ) ^ 0x00000000 ]
>   [ cmp eq reg 1 0x00006400 ]
> 
> What are you trying to fix?

Could you provide a rule that works for tc offload with vlan? I'd like
to check what internal representation is triggering in the kernel.
