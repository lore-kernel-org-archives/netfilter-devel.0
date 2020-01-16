Return-Path: <SRS0=22nV=3F=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6660C33CB1
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 Jan 2020 11:37:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8A59C20730
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 Jan 2020 11:37:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726160AbgAPLhz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 16 Jan 2020 06:37:55 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:34138 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725999AbgAPLhz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 16 Jan 2020 06:37:55 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1is3TF-0004a4-78; Thu, 16 Jan 2020 12:37:53 +0100
Date:   Thu, 16 Jan 2020 12:37:53 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [RFC nf-next 0/4] netfilter: conntrack: allow insertion of
 clashing entries
Message-ID: <20200116113753.GR795@breakpoint.cc>
References: <20200108134500.31727-1-fw@strlen.de>
 <20200113235309.GM795@breakpoint.cc>
 <20200116111915.d7ddcc2lavocvzrq@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200116111915.d7ddcc2lavocvzrq@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Tue, Jan 14, 2020 at 12:53:09AM +0100, Florian Westphal wrote:
> > Florian Westphal <fw@strlen.de> wrote:
> > > This entire series isn't nice but so far I did not find a better
> > > solution.
> > 
> > I did consider getting rid of the unconfirmed list, but this is also
> > problematic.
> 
> Another proposal:
> 
> I think the percpu unconfirmed list should become a hashtable.
> 
> From resolve_normal_ct(), if __nf_conntrack_find_get() returns NULL,
> this can fall back to make a rcu lookless lookup on the unconfirmed
> hashtable.

Unconfirmed entries can't be processed in parallel.

I.e., we can detect the race (there is an unconfirmed entry in the
unconfirmed table matching original tuple), but we can't do anything about
it until that result has been confirmed.

We could allow processing unconfirmed entries in parallel but it will
require taking ct->lock in all places that add/change extensions.

And we would need to do so unconditionally.

At this point I'm considering to send patches to iptables and kernel
that document that -m statistics can't be used for udp NAT and
another patch to add a l4 hash mode to -m cluster, I don't like this
series either and all alternatives are even worse.
