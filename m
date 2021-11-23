Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B6F6C433F5
	for <netfilter-devel@archiver.kernel.org>; Tue, 23 Nov 2021 13:30:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233631AbhKWNd4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 23 Nov 2021 08:33:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235803AbhKWNdz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 23 Nov 2021 08:33:55 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6345C061574
        for <netfilter-devel@vger.kernel.org>; Tue, 23 Nov 2021 05:30:47 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1mpVsj-0007sD-LZ; Tue, 23 Nov 2021 14:30:45 +0100
Date:   Tue, 23 Nov 2021 14:30:45 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
        Karel Rericha <karel@maxtel.cz>,
        Shmulik Ladkani <shmulik.ladkani@gmail.com>,
        Eyal Birger <eyal.birger@gmail.com>
Subject: Re: [PATCH nf-next] netfilter: conntrack: allow to tune gc behavior
Message-ID: <20211123133045.GM6326@breakpoint.cc>
References: <20211121170514.2595-1-fw@strlen.de>
 <YZzrgVYskeXzLuM5@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YZzrgVYskeXzLuM5@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Hi,
> 
> On Sun, Nov 21, 2021 at 06:05:14PM +0100, Florian Westphal wrote:
> > as of commit 4608fdfc07e1
> > ("netfilter: conntrack: collect all entries in one cycle")
> > conntrack gc was changed to run periodically every 2 minutes.
> > 
> > On systems where conntrack hash table is set to large value,
> > almost all evictions happen from gc worker rather than the packet
> > path due to hash table distribution.
> > 
> > This causes netlink event overflows when the events are collected.
> 
> If the issue is netlink, it should be possible to batch netlink
> events.

I do not see how.

> > 1. gc interval (milliseconds, default: 2 minutes)
> > 2. buckets per cycle (default: UINT_MAX / all)
> > 
> > This allows to increase the scan intervals but also to reduce bustiness
> > by switching to partial scans of the table for each cycle.
> 
> Is there a way to apply autotuning? I know, this question might be
> hard, but when does the user has update this new toggle?

Whenever you need to timely delivery of events, or you need timely
reaping of outdated entries.

And we can't increase scan frequency because that will cause
more wakeups on otherwise idle systems, that was the entire reason
for going with 2m.

> And do we
> know what value should be placed here?

I tried, did not work out (see history of gc worker).

Only alternative i see is to give up and revert back to
per ct-timers.
