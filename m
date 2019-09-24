Return-Path: <SRS0=Dg9R=XT=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52CD6C432C1
	for <netfilter-devel@archiver.kernel.org>; Tue, 24 Sep 2019 14:43:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2F44820640
	for <netfilter-devel@archiver.kernel.org>; Tue, 24 Sep 2019 14:43:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728950AbfIXOn6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 24 Sep 2019 10:43:58 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:42300 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726130AbfIXOn6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 24 Sep 2019 10:43:58 -0400
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1iCm2n-0004PC-4F; Tue, 24 Sep 2019 16:43:57 +0200
Date:   Tue, 24 Sep 2019 16:43:57 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH 08/14] xtables-restore: Avoid cache population
 when flushing
Message-ID: <20190924144357.GB22129@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20190916165000.18217-1-phil@nwl.cc>
 <20190916165000.18217-9-phil@nwl.cc>
 <20190920115702.tn4xp5gltcejk6sy@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190920115702.tn4xp5gltcejk6sy@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

On Fri, Sep 20, 2019 at 01:57:02PM +0200, Pablo Neira Ayuso wrote:
[...]
> Looking at patches from 8/24 onwards, I think it's time to introduce
> cache flags logic to iptables.
> 
> In patch 9/14 there is a new field have_chain_cache.
> 
> In patch 10/14 there is have_rule_cache.
> 
> Then moving on, the logic is based on checking for this booleans and
> then checking if the caches are initialized or not.
> 
> I think if we move towards cache flags logic (the flags tell us what
> if we need no cache, partial cache (only tables, tables + chains) or
> full cache.
> 
> This would make this logic easier to understand and more maintainable.

I am not entirely sure this is a feasible approach:

On one hand, we certainly can introduce cache "levels" to distinguish
between:

- no cache
- tables
- chains
- rules

simply because all these naturally build upon each others. On the other
hand, in my series I pushed the envelope (and watched it bend) a bit
further: There are basically two modes of caching:

- "traditional" breadth-first, compatible with above: e.g. all tables,
  if needed all chains as well, etc.

- a new depth-first mode which allows to fetch e.g. a certain chain's
  rules but no other chains/rules.

While the first mode is fine, second one really gives us the edge in
situations where legacy iptables is faster simply because "number
crunching" is more optimized there.

This second mode doesn't have explicit completion indicators like the
first one (with 'have_cache', etc.). In fact, the code treats it like a
fire-and-forget situation: If e.g. the same chain is requested twice,
the second time cache is simply fetched again but nftnl_chain_list_cb()
discards the fetched chain if one with same name already exists in
table's chain list.

Actually, the only application which requires more attention is
xtables-restore with --noflush. It is able to run multiple commands
consecutively and these may need kernel ruleset as context. Still we
don't want to fetch the full kernel ruleset upon each invocation because
it's how users speed up their ruleset manipulations.

In summary, things boil down to the following options:

A) Avoid caching, fetch only the most necessary things to do the job.
B) Build a full cache if needed anyway or if we can't predict.
C) Create a fake cache if we know kernel's ruleset is irrelevant.

I'll give it another try, aligning cache update logic to the above and
see if things become clean enough to be considered maintainable.

Cheers, Phil
