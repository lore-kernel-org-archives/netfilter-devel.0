Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08714C48BD1
	for <netfilter-devel@archiver.kernel.org>; Fri, 11 Jun 2021 10:26:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D2CD6613E7
	for <netfilter-devel@archiver.kernel.org>; Fri, 11 Jun 2021 10:26:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229480AbhFKK2a (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 11 Jun 2021 06:28:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230346AbhFKK22 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 11 Jun 2021 06:28:28 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99D2DC0617AF
        for <netfilter-devel@vger.kernel.org>; Fri, 11 Jun 2021 03:26:28 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1lreMq-0002KI-8T; Fri, 11 Jun 2021 12:26:24 +0200
Date:   Fri, 11 Jun 2021 12:26:24 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
Subject: Re: [nf-next PATCH] netfilter: nft_exthdr: Search chunks in SCTP
 packets only
Message-ID: <20210611102624.GI22614@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
References: <20210610142316.24354-1-phil@nwl.cc>
 <20210610174334.GA24536@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210610174334.GA24536@salvia>
Sender:  <n0-1@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Jun 10, 2021 at 07:43:34PM +0200, Pablo Neira Ayuso wrote:
> On Thu, Jun 10, 2021 at 04:23:16PM +0200, Phil Sutter wrote:
> > Since user space does not generate a payload dependency, plain sctp
> > chunk matches cause searching in non-SCTP packets, too. Avoid this
> > potential mis-interpretation of packet data by checking pkt->tprot.
> > 
> > Fixes: 133dc203d77df ("netfilter: nft_exthdr: Support SCTP chunks")
> > Signed-off-by: Phil Sutter <phil@nwl.cc>
> > ---
> >  net/netfilter/nft_exthdr.c | 5 ++++-
> >  1 file changed, 4 insertions(+), 1 deletion(-)
> > 
> > diff --git a/net/netfilter/nft_exthdr.c b/net/netfilter/nft_exthdr.c
> > index 7f705b5c09de8..1093bb83f8aeb 100644
> > --- a/net/netfilter/nft_exthdr.c
> > +++ b/net/netfilter/nft_exthdr.c
> > @@ -312,6 +312,9 @@ static void nft_exthdr_sctp_eval(const struct nft_expr *expr,
> >  	const struct sctp_chunkhdr *sch;
> >  	struct sctp_chunkhdr _sch;
> >  
> > +	if (!pkt->tprot_set || pkt->tprot != IPPROTO_SCTP)
> > +		goto err;
> 
> nft_set_pktinfo_unspec() already initializes pkt->tprot to zero.
> 
> I think it's safe to simplify this to:
> 
> 	if (pkt->tprot != IPPROTO_SCTP)

Are you sure? Checking the spots that (should) initialize
tprot/tprot_set, in nft_do_chain_inet() it seems that if state->pf is
neither NFPROTO_IPV4 nor NFPROTO_IPV6, nft_do_chain() is called without
prior init. Maybe default case should call nft_set_pktinfo_unspec()?

BTW: The final return call in nft_do_chain_inet_ingress() is dead code,
right?

Thanks, Phil
