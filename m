Return-Path: <SRS0=KBuM=BW=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A815EC433E0
	for <netfilter-devel@archiver.kernel.org>; Wed, 12 Aug 2020 08:48:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 87B7B2076B
	for <netfilter-devel@archiver.kernel.org>; Wed, 12 Aug 2020 08:48:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726565AbgHLIso (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 12 Aug 2020 04:48:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726255AbgHLIso (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 12 Aug 2020 04:48:44 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB2C7C06174A
        for <netfilter-devel@vger.kernel.org>; Wed, 12 Aug 2020 01:48:43 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1k5mR4-0001I9-KO; Wed, 12 Aug 2020 10:48:38 +0200
Date:   Wed, 12 Aug 2020 10:48:38 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Maciej =?utf-8?Q?=C5=BBenczykowski?= <zenczykowski@gmail.com>
Cc:     Florian Westphal <fw@strlen.de>,
        Netfilter Development Mailinglist 
        <netfilter-devel@vger.kernel.org>, Ioannis Ilkos <ilkos@google.com>
Subject: Re: iptables memory leak
Message-ID: <20200812084838.GE23632@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Maciej =?utf-8?Q?=C5=BBenczykowski?= <zenczykowski@gmail.com>,
        Florian Westphal <fw@strlen.de>,
        Netfilter Development Mailinglist <netfilter-devel@vger.kernel.org>,
        Ioannis Ilkos <ilkos@google.com>
References: <CAHo-Oowt08J-zcLPgXkpiUd9x57qHJ7nnE3Ko9uiApFMZ254uA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHo-Oowt08J-zcLPgXkpiUd9x57qHJ7nnE3Ko9uiApFMZ254uA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Maciej,

On Tue, Aug 11, 2020 at 12:07:12PM -0700, Maciej Żenczykowski wrote:
> We've gotten reports of a persistent memory leak in long running
> ip{,6}tables-restore processes on Android R (where we merged in a
> newer iptables release).
> 
> Memory usage has been seen to hit 100MB each.

Did you test current code? I fixed quite a bunch of memleaks recently.
Did you capture iptables-restore input so we could build a reproducer?

> As a reminder, android runs iptables-restore/ip6tables-restore as a
> long running child process of netd (to eliminate process startup
> overhead, which is not insignificant) and communicates to it over a
> pipe.  We don't use 'nft' nor 'ebtables'.
> 
> To quote/paraphrase a coworker: "I got a heap profile while playing
> around with the networking config (connect & disconnect from wifi,
> change hotspot params etc) which repros a leak. It looks like
> xtables_find_target can malloc, but we don't free the results."
> 
> We believe (unconfirmed) it's likely due to this commit:
>   commit 148131f20421046fea028e638581e938ec985783[log] [tgz]
>   author Phil Sutter <phil@nwl.cc>Mon Feb 04 21:52:53 2019 +0100
>   committer Florian Westphal <fw@strlen.de>Tue Feb 05 16:09:41 2019 +0100
>   xtables: Fix for false-positive rule matching
> 
> Is this known? Fixed?  I don't really understand what the commit is
> trying to accomplish/fix.  Could we just revert that commit (or the
> libxtables/xtables.c portion there of)?  Or is it perhaps obvious
> where the free should be happening?

Not explicitly, but maybe the following commits are worth a try:

432a5ecfa7890bd3495bb1ab5e34c2258090133f
b199aca80da5741add50cce244492cc005230b66

Not sure if they apply to your code-base, though.

> (and is there a similar problem with matches? the target and match
> code seem equivalent wrt. to this clone behaviour, maybe there's a
> similar issue)

Not to my knowledge. FWIW, I enhanced iptables/tests/shell for leak
checking, all iptables command calls exiting 0 properly free all memory
now. Of course this is not guaranteed to catch problems in
iptables-restore not exiting but reiterating over the same tables again
and again.

BTW: The commit you refer to fixes a problem where iptables would
incorrectly match a rule as equal although it's not. So without it, if
you have two rules which only differ in target payload (e.g., value of
MARK target), a rule delete command will always drop the first one found
no matter the target payload you passed. If you only delete by rule
number, you shouldn't need it.

Cheers, Phil
