Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF1F6CDB465
	for <netfilter-devel@archiver.kernel.org>; Thu, 19 Oct 2023 13:04:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345629AbjJSNEm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 19 Oct 2023 09:04:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345770AbjJSNEi (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 19 Oct 2023 09:04:38 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18043187
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Oct 2023 06:04:36 -0700 (PDT)
Received: from [78.30.34.192] (port=40402 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qtShT-0036T6-8W; Thu, 19 Oct 2023 15:04:34 +0200
Date:   Thu, 19 Oct 2023 15:04:30 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>, Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org
Subject: Re: [nf-next PATCH v3 3/3] netfilter: nf_tables: Add locking for
 NFT_MSG_GETRULE_RESET requests
Message-ID: <ZTEpXnJ1sWvB8rrt@calendula>
References: <20231019113347.8753-1-phil@nwl.cc>
 <20231019113347.8753-4-phil@nwl.cc>
 <ZTEVHOLSk/SSMJNM@calendula>
 <ZTEiLqJuiq5karTL@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZTEiLqJuiq5karTL@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Oct 19, 2023 at 02:33:50PM +0200, Phil Sutter wrote:
> On Thu, Oct 19, 2023 at 01:38:04PM +0200, Pablo Neira Ayuso wrote:
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
> This fixes for user space's ability to underrun counters and quotas
> because expressions' dump callbacks are not concurrency safe in reset
> mode.
> 
> What you're concerned with is a different issue.

I'd suggest you add comment to this code, feel free to add better
wording:

        /* Mutex is held is to prevent that two concurrent dump-and-reset calls
         * do not underrun counters and quotas. The commit_mutex is used for the
         * lack a better lock, this is not transaction path.
         */
        mutex_lock(&nft_net->commit_mutex);
        ret = nf_tables_dump_rules(skb, cb);
        mutex_unlock(&nft_net->commit_mutex);
