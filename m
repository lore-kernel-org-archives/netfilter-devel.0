Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2748C433ED
	for <netfilter-devel@archiver.kernel.org>; Thu,  1 Apr 2021 10:31:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5E803606A5
	for <netfilter-devel@archiver.kernel.org>; Thu,  1 Apr 2021 10:31:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234120AbhDAKbQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 1 Apr 2021 06:31:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234103AbhDAKa7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 1 Apr 2021 06:30:59 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE3B3C061788
        for <netfilter-devel@vger.kernel.org>; Thu,  1 Apr 2021 03:30:58 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1lRubH-0008Rz-8M; Thu, 01 Apr 2021 12:30:55 +0200
Date:   Thu, 1 Apr 2021 12:30:55 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: iptables-nft fails to restore huge rulesets
Message-ID: <20210401103055.GW3158@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <20210331091331.GE7863@orbyte.nwl.cc>
 <20210331133510.GF17285@breakpoint.cc>
 <20210331144140.GV3158@orbyte.nwl.cc>
 <20210331205151.GA4773@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210331205151.GA4773@salvia>
Sender:  <n0-1@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Wed, Mar 31, 2021 at 10:51:51PM +0200, Pablo Neira Ayuso wrote:
> On Wed, Mar 31, 2021 at 04:41:40PM +0200, Phil Sutter wrote:
> > On Wed, Mar 31, 2021 at 03:35:10PM +0200, Florian Westphal wrote:
> > > Phil Sutter <phil@nwl.cc> wrote:
> > > > I'm currently trying to fix for an issue in Kubernetes realm[1]:
> > > > Baseline is they are trying to restore a ruleset with ~700k lines and it
> > > > fails. Needless to say, legacy iptables handles it just fine.
> > > > 
> > > > Meanwhile I found out there's a limit of 1024 iovecs when submitting the
> > > > batch to kernel, and this is what they're hitting.
> > > > 
> > > > I can work around that limit by increasing each iovec (via
> > > > BATCH_PAGE_SIZE) but keeping pace with legacy seems ridiculous:
> > > > 
> > > > With a scripted binary-search I checked the maximum working number of
> > > > restore items of:
> > > > 
> > > > (1) User-defined chains
> > > > (2) rules with merely comment match present
> > > > (3) rules matching on saddr, daddr, iniface and outiface
> > > > 
> > > > Here's legacy compared to nft with different factors in BATCH_PAGE_SIZE:
> > > > 
> > > > legacy		32 (stock)	  64		   128          256
> > > > ----------------------------------------------------------------------
> > > > 1'636'799	1'602'202	- NC -		  - NC -       - NC -
> > > > 1'220'159	  302'079	604'160		1'208'320      - NC -
> > > > 3'532'040	  242'688	485'376		  971'776    1'944'576
> > > 
> > > Can you explain that table? What does 1'636'799 mean? NC?
> > 
> > Ah, sorry: NC is "not care", I didn't consider those numbers relevant
> > given that iptables-nft has caught up to legacy previously already.
> > 
> > 1'636'799 is the max number of user-defined chains I can successfully
> > restore using iptables-legacy-restore. Looks like I dropped the rows'
> > description while reformatting by accident: the first row of that table
> > corresponds with test (1), second with test (2) and third with test (3).
> > 
> > So legacy may restore at once ~1.6M chains or ~1.2M comment rules or
> > ~3.5M rules with {s,d}{addr,iface} matches.
> > 
> > The following columns are for iptables-nft with varying BATCH_PAGE_SIZE
> > values. Each of the (max 1024) iovecs passed to kernel via sendmsg() is
> > 'N * getpagesize()' large.
> 
> Did you measure any slow down in the ruleset load time after selecting
> a larger batch chunk size?

Restoring 100k rules shows no significant difference in between stock
(32 * 8k) and 512 * 8k chunk sizes. So if you think it's acceptable to
allocate 4MB of buffer at once, I'd just send a patch.

Lifting that 1024 chunk count limit might be an alternative, but I guess
that sits in kernel space?

Cheers, Phil
