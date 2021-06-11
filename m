Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB1D5C48BD1
	for <netfilter-devel@archiver.kernel.org>; Fri, 11 Jun 2021 14:54:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8F3C2613F3
	for <netfilter-devel@archiver.kernel.org>; Fri, 11 Jun 2021 14:54:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231231AbhFKO43 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 11 Jun 2021 10:56:29 -0400
Received: from mail.netfilter.org ([217.70.188.207]:37320 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230508AbhFKO43 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 11 Jun 2021 10:56:29 -0400
Received: from netfilter.org (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id BED2D6423A;
        Fri, 11 Jun 2021 16:53:14 +0200 (CEST)
Date:   Fri, 11 Jun 2021 16:54:26 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org,
        Florian Westphal <fw@strlen.de>
Subject: Re: [nf-next PATCH] netfilter: nft_exthdr: Search chunks in SCTP
 packets only
Message-ID: <20210611145426.GA6760@salvia>
References: <20210610142316.24354-1-phil@nwl.cc>
 <20210610174334.GA24536@salvia>
 <20210611102624.GI22614@orbyte.nwl.cc>
 <20210611115654.GA6356@salvia>
 <20210611125248.GL22614@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210611125248.GL22614@orbyte.nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Jun 11, 2021 at 02:52:48PM +0200, Phil Sutter wrote:
> On Fri, Jun 11, 2021 at 01:56:54PM +0200, Pablo Neira Ayuso wrote:
> > On Fri, Jun 11, 2021 at 12:26:24PM +0200, Phil Sutter wrote:
> > > On Thu, Jun 10, 2021 at 07:43:34PM +0200, Pablo Neira Ayuso wrote:
> > > > On Thu, Jun 10, 2021 at 04:23:16PM +0200, Phil Sutter wrote:
> > > > > Since user space does not generate a payload dependency, plain sctp
> > > > > chunk matches cause searching in non-SCTP packets, too. Avoid this
> > > > > potential mis-interpretation of packet data by checking pkt->tprot.
> > > > > 
> > > > > Fixes: 133dc203d77df ("netfilter: nft_exthdr: Support SCTP chunks")
> > > > > Signed-off-by: Phil Sutter <phil@nwl.cc>
> > > > > ---
> > > > >  net/netfilter/nft_exthdr.c | 5 ++++-
> > > > >  1 file changed, 4 insertions(+), 1 deletion(-)
> > > > > 
> > > > > diff --git a/net/netfilter/nft_exthdr.c b/net/netfilter/nft_exthdr.c
> > > > > index 7f705b5c09de8..1093bb83f8aeb 100644
> > > > > --- a/net/netfilter/nft_exthdr.c
> > > > > +++ b/net/netfilter/nft_exthdr.c
> > > > > @@ -312,6 +312,9 @@ static void nft_exthdr_sctp_eval(const struct nft_expr *expr,
> > > > >  	const struct sctp_chunkhdr *sch;
> > > > >  	struct sctp_chunkhdr _sch;
> > > > >  
> > > > > +	if (!pkt->tprot_set || pkt->tprot != IPPROTO_SCTP)
> > > > > +		goto err;
> > > > 
> > > > nft_set_pktinfo_unspec() already initializes pkt->tprot to zero.
> > > > 
> > > > I think it's safe to simplify this to:
> > > > 
> > > > 	if (pkt->tprot != IPPROTO_SCTP)
> > > 
> > > Are you sure? Checking the spots that (should) initialize
> > > tprot/tprot_set, in nft_do_chain_inet() it seems that if state->pf is
> > > neither NFPROTO_IPV4 nor NFPROTO_IPV6, nft_do_chain() is called without
> > > prior init. Maybe default case should call nft_set_pktinfo_unspec()?
> > 
> > state->pf in nft_do_chain_inet() can only be either NFPROTO_IPV4 or
> > NFPROTO_IPV6.
> 
> Shouldn't there be a WARN_ON_ONCE or something in the default case then?
> Looking at nf_hook(), it seems entirely possible to me that state->pf
> might be NFPROTO_ARP, for instance. That's probably just me not getting
> it, but things we rely upon shouldn't be hidden that well, right?

nft_do_chain_inet() is called from the NFPROTO_INET hook, which
results in either NFPROTO_IPV4 or NFPROTO_IPV6.

This is hot path, I would not add more code there. The default case is
just there to avoid a warning from gcc.

Probably a comment like /* Should not ever happen */ for the default
case in nft_do_chain_inet() is fine with you? :)

> > pkt->tprot_set is there to deal with a corner case: IPPROTO_IP (0).
> > If pkt->tprot_set == true and pkt->tprot == 0, it means: "match on
> > IPPROTO_IP". For other IPPROTO_*, checking pkt->tprot looks safe to me.
> 
> Ah, thanks for clarifying! So whenever I check a specific value that's
> non-zero, tprot_set doesn't matter. Should I send a patch for the same
> change in nft_tcp_header_pointer(), too? (That's where I copied the code
> from. ;)

I think so, that's fine indeed.
