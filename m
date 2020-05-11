Return-Path: <SRS0=NFxu=6Z=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 389D9C47255
	for <netfilter-devel@archiver.kernel.org>; Mon, 11 May 2020 13:31:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0ED59206DD
	for <netfilter-devel@archiver.kernel.org>; Mon, 11 May 2020 13:31:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728367AbgEKNbM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 11 May 2020 09:31:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726013AbgEKNbM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 11 May 2020 09:31:12 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03459C061A0C
        for <netfilter-devel@vger.kernel.org>; Mon, 11 May 2020 06:31:11 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1jY8WU-0001z4-74; Mon, 11 May 2020 15:31:10 +0200
Date:   Mon, 11 May 2020 15:31:10 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [nf PATCH] netfilter: nft_set_rbtree: Add missing expired checks
Message-ID: <20200511133110.GG17795@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20200506111107.29778-1-phil@nwl.cc>
 <20200510220356.GA10133@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200510220356.GA10133@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

On Mon, May 11, 2020 at 12:03:56AM +0200, Pablo Neira Ayuso wrote:
> On Wed, May 06, 2020 at 01:11:07PM +0200, Phil Sutter wrote:
> > Expired intervals would still match and be dumped to user space until
> > garbage collection wiped them out. Make sure they stop matching and
> > disappear (from users' perspective) as soon as they expire.
> > 
> > Fixes: 8d8540c4f5e03 ("netfilter: nft_set_rbtree: add timeout support")
> > Signed-off-by: Phil Sutter <phil@nwl.cc>
> > ---
> >  net/netfilter/nft_set_rbtree.c | 10 ++++++++--
> >  1 file changed, 8 insertions(+), 2 deletions(-)
> > 
> > diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
> > index 3ffef454d4699..8efcea03a4cbb 100644
> > --- a/net/netfilter/nft_set_rbtree.c
> > +++ b/net/netfilter/nft_set_rbtree.c
> > @@ -75,7 +75,8 @@ static bool __nft_rbtree_lookup(const struct net *net, const struct nft_set *set
> >  		} else if (d > 0)
> >  			parent = rcu_dereference_raw(parent->rb_right);
> >  		else {
> > -			if (!nft_set_elem_active(&rbe->ext, genmask)) {
> > +			if (!nft_set_elem_active(&rbe->ext, genmask) ||
> > +			    nft_set_elem_expired(&rbe->ext)) {
> 
> It seems _insert() does not allow for duplicates. I think it's better
> if you just:
> 
>         return false;
> 
> in case in case the element has expired, right?

Ah yes, thanks. I'll send a v2.

Thanks, Phil
