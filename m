Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF71CCDB465
	for <netfilter-devel@archiver.kernel.org>; Thu, 19 Oct 2023 11:59:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345474AbjJSL7P (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 19 Oct 2023 07:59:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345482AbjJSL7N (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 19 Oct 2023 07:59:13 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73965134
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Oct 2023 04:59:11 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1qtRgD-0007pt-Qr; Thu, 19 Oct 2023 13:59:09 +0200
Date:   Thu, 19 Oct 2023 13:59:09 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Phil Sutter <phil@nwl.cc>, Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org
Subject: Re: [nf-next PATCH v3 3/3] netfilter: nf_tables: Add locking for
 NFT_MSG_GETRULE_RESET requests
Message-ID: <20231019115909.GH12544@breakpoint.cc>
References: <20231019113347.8753-1-phil@nwl.cc>
 <20231019113347.8753-4-phil@nwl.cc>
 <ZTEVHOLSk/SSMJNM@calendula>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZTEVHOLSk/SSMJNM@calendula>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Thu, Oct 19, 2023 at 01:33:47PM +0200, Phil Sutter wrote:
> > Rule reset is not concurrency-safe per-se, so multiple CPUs may reset
> > the same rule at the same time. At least counter and quota expressions
> > will suffer from value underruns in this case.
> > 
> > Prevent this by introducing dedicated locking callbacks for nfnetlink
> > and the asynchronous dump handling to serialize access.
> > 
> > Signed-off-by: Phil Sutter <phil@nwl.cc>
> > ---
> > Changes since v2:
> > - Keep local variable 'nft_net' in nf_tables_getrule_reset()
> > - No need for local variable 'family' in same function (used only once
> >   after all the churn)
> > ---
> >  net/netfilter/nf_tables_api.c | 74 ++++++++++++++++++++++++++++-------
> >  1 file changed, 60 insertions(+), 14 deletions(-)
> > 
> > diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> > index 584d3b204372..fbb688c9903c 100644
> > --- a/net/netfilter/nf_tables_api.c
> > +++ b/net/netfilter/nf_tables_api.c
> [...]
> > +static int nf_tables_dumpreset_rules(struct sk_buff *skb,
> > +				     struct netlink_callback *cb)
> > +{
> > +	struct nftables_pernet *nft_net = nft_pernet(sock_net(skb->sk));
> > +	int ret;
> > +
> > +	mutex_lock(&nft_net->commit_mutex);
> > +	ret = nf_tables_dump_rules(skb, cb);
> > +	mutex_unlock(&nft_net->commit_mutex);
> 
> NACK.
> 
> This just mitigates the problem we are discussing, when there is an
> interference with an ongoing transaction.

It resolves corrupting the internal state when two parallel resets
are done.

If you believe that we have to make entire dump consistent even
when reset flag is given I see no choice but to completely remove
reset-from-dump support.

What is you suggested solution?

AFAICS, with this series, userspace can, in theory, merge partial
dumps into consistent output by manually collecting the partial
dumps.

That said, I think its not very realistic that userspace will
get this right.

That leaves: userspace does a dump (without reset), and if that
was consistent walk it and do a per-handle get-with-reset request
for each rule, then update the (not-yet-printed) dump with the
newly obtained stateful results.
