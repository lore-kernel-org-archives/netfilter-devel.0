Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BE83C41513
	for <netfilter-devel@archiver.kernel.org>; Thu, 19 Oct 2023 12:34:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345513AbjJSMeA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 19 Oct 2023 08:34:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345654AbjJSMdz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 19 Oct 2023 08:33:55 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CFDAAB
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Oct 2023 05:33:53 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1qtSDm-0001FW-Lf; Thu, 19 Oct 2023 14:33:50 +0200
Date:   Thu, 19 Oct 2023 14:33:50 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [nf-next PATCH v3 3/3] netfilter: nf_tables: Add locking for
 NFT_MSG_GETRULE_RESET requests
Message-ID: <ZTEiLqJuiq5karTL@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <20231019113347.8753-1-phil@nwl.cc>
 <20231019113347.8753-4-phil@nwl.cc>
 <ZTEVHOLSk/SSMJNM@calendula>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZTEVHOLSk/SSMJNM@calendula>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Oct 19, 2023 at 01:38:04PM +0200, Pablo Neira Ayuso wrote:
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

This fixes for user space's ability to underrun counters and quotas
because expressions' dump callbacks are not concurrency safe in reset
mode.

What you're concerned with is a different issue.
