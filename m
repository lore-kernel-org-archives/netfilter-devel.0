Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D17AE7AD75
	for <netfilter-devel@archiver.kernel.org>; Tue,  3 Oct 2023 15:58:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232181AbjJCP6F (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 3 Oct 2023 11:58:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237235AbjJCP6F (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 3 Oct 2023 11:58:05 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24D8D9E
        for <netfilter-devel@vger.kernel.org>; Tue,  3 Oct 2023 08:58:01 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1qnhmZ-0003B2-6d; Tue, 03 Oct 2023 17:57:59 +0200
Date:   Tue, 3 Oct 2023 17:57:59 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: nf_tables: do not refresh timeout when
 resetting element
Message-ID: <ZRw6B+28jT/uJxJP@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20231002090516.3200649-1-pablo@netfilter.org>
 <ZRsGslT23xzSsbgd@orbyte.nwl.cc>
 <ZRs7H7C/Xr7dbRc7@calendula>
 <ZRtBkeP9TYJ10Nrm@calendula>
 <ZRtKbZmqr4uZRT9Y@orbyte.nwl.cc>
 <ZRvG5vesKHRyUvzx@calendula>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZRvG5vesKHRyUvzx@calendula>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Oct 03, 2023 at 09:46:46AM +0200, Pablo Neira Ayuso wrote:
> On Tue, Oct 03, 2023 at 12:55:41AM +0200, Phil Sutter wrote:
> > On Tue, Oct 03, 2023 at 12:17:53AM +0200, Pablo Neira Ayuso wrote:
> > > On Mon, Oct 02, 2023 at 11:50:25PM +0200, Pablo Neira Ayuso wrote:
> > > > On Mon, Oct 02, 2023 at 08:06:42PM +0200, Phil Sutter wrote:
> > > > > On Mon, Oct 02, 2023 at 11:05:16AM +0200, Pablo Neira Ayuso wrote:
> > > > > > The dump and reset command should not refresh the timeout, this command
> > > > > > is intended to allow users to list existing stateful objects and reset
> > > > > > them, element expiration should be refresh via transaction instead with
> > > > > > a specific command to achieve this, otherwise this is entering combo
> > > > > > semantics that will be hard to be undone later (eg. a user asking to
> > > > > > retrieve counters but _not_ requiring to refresh expiration).
> > > > > 
> > > > > From a users' perspective, what is special about the element expires
> > > > > value disqualifying it from being reset along with any counter/quota
> > > > > values?
> > > > >
> > > > > Do you have a PoC for set element reset via transaction yet? Can we
> > > > > integrate non-timeout resets with it, too? Because IIUC, that's an
> > > > > alternative to the pending reset locking.
> > > > 
> > > > Problem is listing is not supported from transaction path, this is
> > > > using existing netlink dump infrastructure which runs lockless via
> > > > rcu. So we could support reset, but we could not use netlink dump
> > > > semantics to fetch the values, and user likely wants this to
> > > > fetch-and-reset as in ctnetlink.
> > > 
> > > Well, with NLM_F_ECHO, it should be possible to explore reset under
> > > commit_mutex, but is it really worth the effort?
> > 
> > I don't understand. Wasn't it your proposal to move things into the
> > transaction? Above you write: "element expiration should be refresh via
> > transaction instead". I asked what is special about timeout, why not
> > handle all element state reset the same way?
> > 
> > > With two concurrent threads, we just want to ensure that no invalid
> > > state shows in the listing (you mentioned it is possible to list
> > > negative values with two threads listing-and-resetting at the same
> > > time).
> > 
> > It's not just in the listing, the actual values underrun. A quota e.g.
> > will immediately deny.
> > 
> > > I think we should just make sure something valid is included in the
> > > listing, but as for the two threads performing list-and-reset, why
> > > ensure strict serialization?
> > 
> > I seem to lack context here. Is there an alternative to "strict"
> > serializing? Expressions' dump+reset callbacks must not run multiple
> > times at the same time for the same expression. At least not how they
> > are currently implemented.
> > 
> > > This is a rare operation to fetch statistics, most likely having a
> > > single process performing this in place? So we are currently
> > > discussing how to fix the (negative) non-sense in the listing.
> > > 
> > > > > What we have now is a broad 'reset element', not specifying what to
> > > > > reset. If the above is a feature being asked for, I'd rather implement
> > > > > 'reset element counter', 'reset element timeout', 'reset element quota',
> > > > > etc. commands.
> > > > 
> > > > We are currently discussing how to implement refresh timeout into the
> > > > transaction model.
> > > > 
> > > > I would suggest we keep this chunk away by now for the _RESET command,
> > > > until we agree on next steps.
> > 
> > I would suggest to leave things as-is until there's hard evidence why it
> > has to change now or there is a viable alternative implementation.
> 
> Leave things as is means we will have this implicit refresh in the
> element refresh. We have no such semantics in conntrack, for example,
> and conntrack can be seen as a hardcoded set with a fixed number of
> tuples.

It's just as implicit as counter or quota reset. I define "reset
element" command as "reset any state in given element", so from my
perspective it makes perfectly sense to reset the timeout as well.

> > It's your call to make since you're the maintainer of the project, but
> > please stick to the standards you demand from other contributors.
> 
> We are discussing a very specific topic here and I am expecting to get
> some kind of acknowledgement from you that this revert of this
> specific chunk is good to have.

Given the data you provided: No, I don't see any sense in this change.

Cheers, Phil
