Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81B09CDB465
	for <netfilter-devel@archiver.kernel.org>; Thu, 19 Oct 2023 13:38:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235397AbjJSNi3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 19 Oct 2023 09:38:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235394AbjJSNi3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 19 Oct 2023 09:38:29 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62683B6
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Oct 2023 06:38:26 -0700 (PDT)
Received: from [78.30.34.192] (port=44880 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qtTEE-003Iwe-KZ; Thu, 19 Oct 2023 15:38:24 +0200
Date:   Thu, 19 Oct 2023 15:38:21 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: [nf-next PATCH v3 3/3] netfilter: nf_tables: Add locking for
 NFT_MSG_GETRULE_RESET requests
Message-ID: <ZTExTRzJCp6VOKes@calendula>
References: <20231019113347.8753-1-phil@nwl.cc>
 <20231019113347.8753-4-phil@nwl.cc>
 <ZTEVHOLSk/SSMJNM@calendula>
 <20231019115909.GH12544@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231019115909.GH12544@breakpoint.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Oct 19, 2023 at 01:59:09PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Thu, Oct 19, 2023 at 01:33:47PM +0200, Phil Sutter wrote:
> > > Rule reset is not concurrency-safe per-se, so multiple CPUs may reset
> > > the same rule at the same time. At least counter and quota expressions
> > > will suffer from value underruns in this case.
> > > 
> > > Prevent this by introducing dedicated locking callbacks for nfnetlink
> > > and the asynchronous dump handling to serialize access.
> > > 
> > > Signed-off-by: Phil Sutter <phil@nwl.cc>
> > > ---
> > > Changes since v2:
> > > - Keep local variable 'nft_net' in nf_tables_getrule_reset()
> > > - No need for local variable 'family' in same function (used only once
> > >   after all the churn)
> > > ---
> > >  net/netfilter/nf_tables_api.c | 74 ++++++++++++++++++++++++++++-------
> > >  1 file changed, 60 insertions(+), 14 deletions(-)
> > > 
> > > diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> > > index 584d3b204372..fbb688c9903c 100644
> > > --- a/net/netfilter/nf_tables_api.c
> > > +++ b/net/netfilter/nf_tables_api.c
> > [...]
> > > +static int nf_tables_dumpreset_rules(struct sk_buff *skb,
> > > +				     struct netlink_callback *cb)
> > > +{
> > > +	struct nftables_pernet *nft_net = nft_pernet(sock_net(skb->sk));
> > > +	int ret;
> > > +
> > > +	mutex_lock(&nft_net->commit_mutex);
> > > +	ret = nf_tables_dump_rules(skb, cb);
> > > +	mutex_unlock(&nft_net->commit_mutex);
> > 
> > NACK.
> > 
> > This just mitigates the problem we are discussing, when there is an
> > interference with an ongoing transaction.
> 
> It resolves corrupting the internal state when two parallel resets
> are done.
> 
> If you believe that we have to make entire dump consistent even
> when reset flag is given I see no choice but to completely remove
> reset-from-dump support.

It is just the commit_mutex in this section that I don't like, but OK
this operation and scenario should be rare and adding yet another lock
for a rare case might make no sense.

> What is you suggested solution?
>
> AFAICS, with this series, userspace can, in theory, merge partial
> dumps into consistent output by manually collecting the partial
> dumps.
> 
> That said, I think its not very realistic that userspace will
> get this right.

I think this is possible, I would like to see userspace code (just
simple sketch) that shows how complicate this is.

> That leaves: userspace does a dump (without reset), and if that
> was consistent walk it and do a per-handle get-with-reset request
> for each rule, then update the (not-yet-printed) dump with the
> newly obtained stateful results.

Counter expressions in rules are probably the more complicated to
restore. Named objects should be rather easy.

Another possibility is to explore transaction control plane path and
use NLM_F_ECHO to get back the original counters, but I would not
really follow this path.

I have been considering netlink dump based on ruleset snapshots. The
idea is: Make a snapshot of the ruleset at the beginning of the
netlink dump, this requires a new class of objects that can be used as
container to store what is going to be. The snapshot should happen
right before initiating the netlink dump holding the commit_mutex, and
it would take memory to store this temporary ruleset snapshot. The
snapshot would be done per dump request.

This ensures no EINTR can happen, the ruleset at the end of the
netlink dump will be consistent, but it might be slightly behind the
real rule if updates have happened, but using the generation ID, it
should be possible to at least report it to the user.
