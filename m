Return-Path: <SRS0=xYYy=UR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A1A2C31E5E
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 Jun 2019 09:37:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 03A18206B7
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 Jun 2019 09:37:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729582AbfFRJhy (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 18 Jun 2019 05:37:54 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:51402 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729256AbfFRJhx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 18 Jun 2019 05:37:53 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hdAYm-0007Jk-O4; Tue, 18 Jun 2019 11:37:48 +0200
Date:   Tue, 18 Jun 2019 11:37:48 +0200
From:   Florian Westphal <fw@strlen.de>
To:     wenxu <wenxu@ucloud.cn>
Cc:     Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] netfilter: nft_paylaod: add base type
 NFT_PAYLOAD_LL_HEADER_NO_TAG
Message-ID: <20190618093748.dydodhngydfcfmeh@breakpoint.cc>
References: <1560151280-28908-1-git-send-email-wenxu@ucloud.cn>
 <20190610094433.3wjmpfiph7iwguan@breakpoint.cc>
 <20190617223004.tnqz2bl7qp63fcfy@salvia>
 <20190617224232.55hldt4bw2qcmnll@breakpoint.cc>
 <22ab95cb-9dca-1e48-4ca0-965d340e7d32@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <22ab95cb-9dca-1e48-4ca0-965d340e7d32@ucloud.cn>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

wenxu <wenxu@ucloud.cn> wrote:
> On 6/18/2019 6:42 AM, Florian Westphal wrote:
> > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> >>> Subject: Change bridge l3 dependency to meta protocol
> >>>
> >>> This examines skb->protocol instead of ethernet header type, which
> >>> might be different when vlan is involved.
> >>>  
> >>> +	if (ctx->pctx.family == NFPROTO_BRIDGE && desc == &proto_eth) {
> >>> +		if (expr->payload.desc == &proto_ip ||
> >>> +		    expr->payload.desc == &proto_ip6)
> >>> +			desc = &proto_metaeth;
> >>> +	}i
> >> Is this sufficient to restrict the matching? Is this still buggy from
> >> ingress?
> > This is what netdev family uses as well (skb->protocol i mean).
> > I'm not sure it will work for output however (haven't checked).
> >
> >> I wonder if an explicit NFT_PAYLOAD_CHECK_VLAN flag would be useful in
> >> the kernel, if so we could rename NFTA_PAYLOAD_CSUM_FLAGS to
> >> NFTA_PAYLOAD_FLAGS and place it there. Just an idea.
> >
> > Another unresolved issue is presence of multiple vlan tags, so we might
> > have to add yet another meta key to retrieve the l3 protocol in use
> 
> Maybe add a l3proto meta key can handle the multiple vlan tags case with the l3proto dependency.  It
> should travese all the vlan tags and find the real l3 proto.

Yes, something like this.

We also need to audit netdev and bridge expressions (reject is known broken)
to handle vlans properly.

Still, switching nft to prefer skb->protocol instead of eth_hdr->type
for dependencies would be good as this doesn't need kernel changes and solves
the immediate problem of 'ip ...' not matching in case of vlan.

If you have time, could you check if using skb->protocol works for nft
bridge in output, i.e. does 'nft ip protocol icmp' match when its used
from bridge output path with meta protocol dependency with and without
vlan in use?

