Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A225DC77B73
	for <netfilter-devel@archiver.kernel.org>; Wed, 31 May 2023 09:02:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235296AbjEaJCq (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 31 May 2023 05:02:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235314AbjEaJCb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 31 May 2023 05:02:31 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D56C10C6
        for <netfilter-devel@vger.kernel.org>; Wed, 31 May 2023 02:02:10 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1q4HiZ-0003b7-MP; Wed, 31 May 2023 11:02:07 +0200
Date:   Wed, 31 May 2023 11:02:07 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Eric Garver <e@erig.me>, danw@redhat.com, aauren@gmail.com
Subject: Re: [iptables PATCH 3/4] Add --compat option to *tables-nft and
 *-nft-restore commands
Message-ID: <ZHcNDxfJmxcEEDB8@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Eric Garver <e@erig.me>, danw@redhat.com, aauren@gmail.com
References: <20230505183446.28822-1-phil@nwl.cc>
 <20230505183446.28822-4-phil@nwl.cc>
 <ZHaR1M+EFjUHLOc/@calendula>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZHaR1M+EFjUHLOc/@calendula>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

On Wed, May 31, 2023 at 02:16:20AM +0200, Pablo Neira Ayuso wrote:
> On Fri, May 05, 2023 at 08:34:45PM +0200, Phil Sutter wrote:
> > The flag sets nft_handle::compat boolean, indicating a compatible rule
> > implementation is wanted. Users expecting their created rules to be
> > fetched from kernel by an older version of *tables-nft may use this to
> > avoid potential compatibility issues.
> 
> This would require containers to be updated to use this new option or
> maybe there is a transparent way to invoke this new --compat option?

It does not require a container update, merely the host (or whatever
runs the newer iptables-nft binary) must be adjusted. The idea is to
provide the ruleset in a compatible way so old userspace will parse it
correctly.

> I still think using userdata for this is the way to address I call it
> "forward compatibility" issue, that is: old iptables binaries can
> interpret what new iptables binary generates.

But it requires to update the "old iptables binaries", no? If so, are
they still "old" then? ;)

> I am afraid this new option does not handle these two scenarios?
> 
> - new match/target that is not supported by older iptables version
>   could not be printed.
> - match/target from xtables-addons that is not supported by different
>   iptables without these extensions.

That's correct. Both these limitations apply to legacy iptables as well,
and there's a third one, namely new match/target revision.

I could introduce a flag for extensions to disqualify them for use with
--compat if required. On the other hand, new extensions (or revisions)
are not as common anymore since we instruct people to add new features
to nftables instead.

> I read the notes we collected during NFWS and we seem to agree at that
> time. Maybe some of the requirements have changed since NFWS?

During NFWS, Florian suggested to just add the rule in textual
representation to userdata. Though this is ugly as there are two
different formats (save and print) so user space has to parse and
reprint the rule.

Then I revived my "rule bytecode for output" approach and got it working
apart from lookup expression. But finally you axed it since it requires
kernel adjustments.

From my perspective though, all solutions divide into good and bad ones:
The bad ones are those requiring to touch the old binaries. So if
acceptable, I'd much rather go with any of the "good" ones even though
it has obvious drawbacks.

> Apologies in advance if you feel we are going a bit into circles with
> this.

No worries! All this could be clarified over the course of two beers in
a pub. This medium is less lossy, though. :D

Cheers, Phil
