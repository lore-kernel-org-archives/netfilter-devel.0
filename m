Return-Path: <SRS0=8OCJ=4F=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD466C34022
	for <netfilter-devel@archiver.kernel.org>; Mon, 17 Feb 2020 20:12:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 93F4B2070B
	for <netfilter-devel@archiver.kernel.org>; Mon, 17 Feb 2020 20:12:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729450AbgBQUMm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 17 Feb 2020 15:12:42 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:42840 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728991AbgBQUMm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 17 Feb 2020 15:12:42 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1j3mky-0003XU-6i; Mon, 17 Feb 2020 21:12:40 +0100
Date:   Mon, 17 Feb 2020 21:12:40 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf 0/4] netfilter: conntrack: allow insertion of clashing
 entries
Message-ID: <20200217201240.GH19559@breakpoint.cc>
References: <20200203163707.27254-1-fw@strlen.de>
 <20200217192546.pa26vfni4kmhlpng@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200217192546.pa26vfni4kmhlpng@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Mon, Feb 03, 2020 at 05:37:03PM +0100, Florian Westphal wrote:
> > This series allows conntrack to insert a duplicate conntrack entry
> > if the reply direction doesn't result in a clash with a different
> > original connection.
> 
> Applied, thanks for your patience.
> 
> I introduced the late clash resolution approach to deal with nfqueue,
> now this is extended to cover more cases, let's give it a try.

Yes, nfqueue is one way this can happen, changes to resolver libraries
to issue parallel requests have exposed this race for non-nfqueue case
too.

> >Alternatives considered were:
> >1.  Confirm ct entries at allocation time, not in postrouting.
> > a. will cause uneccesarry work when the skb that creates the
> >    conntrack is dropped by ruleset.
> > b. in case nat is applied, ct entry would need to be moved in
> >    the table, which requires another spinlock pair to be taken.
> > c. breaks the 'unconfirmed entry is private to cpu' assumption:
> >    we would need to guard all nfct->ext allocation requests with
> >    ct->lock spinlock.
> >
> >2. Make the unconfirmed list a hash table instead of a pcpu list.
> >   Shares drawback c) of the first alternative.
> 
> The spinlock would need to be grabbed rarely, right? My mean, most
> extension allocations happen before insertion to the unconfirmed list.
> Only _ext_add() invocations coming after init_conntrack() might
> require this.

Right, we could add __nf_ct_ext_add() which is unlocked and convert
the additions happening before unconfirmed list insertion there.

But there are additional problems that I forgot:
a) need for one additional lookup after negative result from main table
   (this time in unconfirmed list).
b) Need to asynchronously re-insert the skb at a later time, once
   the racing entry is confirmed.

We can't use the unconfirmed ct as-is, because it may be incomplete.
For instance, the racing skb might not yet have hit the nat table, so
the ct contains wrong NAT info.

I think b) is a non-starter for all of the alternatives, unfortunately.
