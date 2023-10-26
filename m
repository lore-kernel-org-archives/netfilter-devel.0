Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65C54C25B6B
	for <netfilter-devel@archiver.kernel.org>; Thu, 26 Oct 2023 08:26:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344564AbjJZI0j (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 26 Oct 2023 04:26:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344565AbjJZI0j (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 26 Oct 2023 04:26:39 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DA6C1B2
        for <netfilter-devel@vger.kernel.org>; Thu, 26 Oct 2023 01:26:37 -0700 (PDT)
Received: from [78.30.35.151] (port=48330 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qvvhJ-001IXc-69; Thu, 26 Oct 2023 10:26:35 +0200
Date:   Thu, 26 Oct 2023 10:26:32 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org, fw@strlen.de
Subject: Re: [nf-next PATCH v3 3/3] netfilter: nf_tables: Add locking for
 NFT_MSG_GETOBJ_RESET requests
Message-ID: <ZToiuHuyJs0mo4Bc@calendula>
References: <20231025200828.5482-1-phil@nwl.cc>
 <20231025200828.5482-4-phil@nwl.cc>
 <ZTmB2yBSAa1KVexW@calendula>
 <ZTogIgkfTpZAJy30@calendula>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZTogIgkfTpZAJy30@calendula>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Oct 26, 2023 at 10:15:33AM +0200, Pablo Neira Ayuso wrote:
> Cc'ing Florian.
> 
> On Wed, Oct 25, 2023 at 11:00:14PM +0200, Pablo Neira Ayuso wrote:
> > On Wed, Oct 25, 2023 at 10:08:28PM +0200, Phil Sutter wrote:
> > > Objects' dump callbacks are not concurrency-safe per-se with reset bit
> > > set. If two CPUs perform a reset at the same time, at least counter and
> > > quota objects suffer from value underrun.
> > > 
> > > Prevent this by introducing dedicated locking callbacks for nfnetlink
> > > and the asynchronous dump handling to serialize access.
> > > 
> > > Signed-off-by: Phil Sutter <phil@nwl.cc>
> > > ---
> > >  net/netfilter/nf_tables_api.c | 72 ++++++++++++++++++++++++++++-------
> > >  1 file changed, 59 insertions(+), 13 deletions(-)
> > > 
> > > diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> > > index 5f84bdd40c3f..245a2c5be082 100644
> > > --- a/net/netfilter/nf_tables_api.c
> > > +++ b/net/netfilter/nf_tables_api.c
> > [...]
> > > @@ -7832,16 +7876,18 @@ static int nf_tables_getobj(struct sk_buff *skb, const struct nfnl_info *info,
> > >  		return nft_netlink_dump_start_rcu(info->sk, skb, info->nlh, &c);
> > >  	}
> > >  
> > > -	if (NFNL_MSG_TYPE(info->nlh->nlmsg_type) == NFT_MSG_GETOBJ_RESET)
> > > -		reset = true;
> > > +	if (!try_module_get(THIS_MODULE))
> > > +		return -EINVAL;
> > 
> > For netlink dump path, __netlink_dump_start() already grabs a
> > reference module this via c->module.
> > 
> > Why is this module reference needed for getting one object? This does
> > not follow netlink dump path, it creates the skb and it returns
> > inmediately.
> 
> nfnetlink callbacks use nfnetlink_get_subsys() which use
> rcu_dereference() to fetch the nfnetlink_subsystem callbacks. In
> nfnetlink_rcv_batch() the ss pointer is fetched at the beginning of
> the batch processing.

Correction: This is nfnetlink_rcv_msg() path, not nfnetlink_rcv_batch()
path because this is a _GET command which should not ever follow
nfnetlink_rcv_batch() path.

But still the reason below is possible, considering a skb that
contains two _GET requests (which is possible because netlink supports
for non-atomic batches, ie. stacking several netlink messages in one
sendmsg() call).

> But then, if rcu_read_unlock() is released, then:
> 
>         const struct nfnetlink_subsystem *ss;
> 
> could become stale and refetch is needed because rcu read side lock
> was released, so next iteration on the skb to process the next
> nlmsghdr could be using stale pointers.
> 
> Could you please have a second look to confirm this?
> 
> Thanks!
