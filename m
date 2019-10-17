Return-Path: <SRS0=wLp+=YK=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3266ECE58E
	for <netfilter-devel@archiver.kernel.org>; Thu, 17 Oct 2019 11:21:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D0BC12089C
	for <netfilter-devel@archiver.kernel.org>; Thu, 17 Oct 2019 11:21:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405493AbfJQLVk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 17 Oct 2019 07:21:40 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:41442 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728143AbfJQLVk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 17 Oct 2019 07:21:40 -0400
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1iL3qd-00046Y-53; Thu, 17 Oct 2019 13:21:39 +0200
Date:   Thu, 17 Oct 2019 13:21:39 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH v4 0/8] Improve iptables-nft performance with
 large rulesets
Message-ID: <20191017112139.GI12661@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20191015114152.25254-1-phil@nwl.cc>
 <20191017090332.erwubv7pzxbbowjg@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191017090332.erwubv7pzxbbowjg@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Thu, Oct 17, 2019 at 11:03:32AM +0200, Pablo Neira Ayuso wrote:
> On Tue, Oct 15, 2019 at 01:41:44PM +0200, Phil Sutter wrote:
> > Fourth try at caching optimizations implementation.
> > 
> > Changes since v3:
> > 
> > * Rebase onto current master after pushing the accepted initial three
> >   patches.
> > * Avoid cache inconsistency in __nft_build_cache() if kernel ruleset
> >   changed since last call.
> 
> I still hesitate with this cache approach.
> 
> Can this deal with this scenario? Say you have a ruleset composed on N
> rules.
> 
> * Rule 1..M starts using generation X for the evaluation, they pass
>   OK.
> 
> * Generation is bumped.
> 
> * Rule M..N is evaluated with a diferent cache.
> 
> So the ruleset evaluation is inconsistent itself since it is based on
> different caches for each rule in the batch.

Yes, that is possible. In a discussion with Florian back when he fixed
for concurrent xtables-restore calls, consensus was: If you use
--noflush and concurrent ruleset updates happen, you're screwed anyway.
(Meaning, results are not predictable and we can't do anything about
it.)

In comparison with current code which just fetches full cache upon
invocation of 'xtables-restore --noflush', problems might not be
detected during evaluation but only later when kernel rejects the
commands.

Eventually, commands have to apply to the ruleset as it is after opening
the transaction. If you cache everything first, you don't detect
incompatible ruleset changes at all. If you cache multiple times, you
may detect the incompatible changes while evaluating but the result is
the same, just with different error messages. :)

Cheers, Phil
