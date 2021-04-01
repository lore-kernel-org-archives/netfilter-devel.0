Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6BF7C433B4
	for <netfilter-devel@archiver.kernel.org>; Thu,  1 Apr 2021 17:58:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8A22461001
	for <netfilter-devel@archiver.kernel.org>; Thu,  1 Apr 2021 17:58:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234363AbhDAR6T (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 1 Apr 2021 13:58:19 -0400
Received: from mail.netfilter.org ([217.70.188.207]:53110 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236600AbhDARyy (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 1 Apr 2021 13:54:54 -0400
Received: from us.es (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id D355263E43;
        Thu,  1 Apr 2021 13:44:39 +0200 (CEST)
Date:   Thu, 1 Apr 2021 13:44:52 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>, Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org
Subject: Re: iptables-nft fails to restore huge rulesets
Message-ID: <20210401114452.GA5950@salvia>
References: <20210331091331.GE7863@orbyte.nwl.cc>
 <20210331133510.GF17285@breakpoint.cc>
 <20210331144140.GV3158@orbyte.nwl.cc>
 <20210331205151.GA4773@salvia>
 <20210401103055.GW3158@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210401103055.GW3158@orbyte.nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Apr 01, 2021 at 12:30:55PM +0200, Phil Sutter wrote:
> Hi,
> 
> On Wed, Mar 31, 2021 at 10:51:51PM +0200, Pablo Neira Ayuso wrote:
> > On Wed, Mar 31, 2021 at 04:41:40PM +0200, Phil Sutter wrote:
> > > On Wed, Mar 31, 2021 at 03:35:10PM +0200, Florian Westphal wrote:
> > > > Phil Sutter <phil@nwl.cc> wrote:
> > > > > I'm currently trying to fix for an issue in Kubernetes realm[1]:
> > > > > Baseline is they are trying to restore a ruleset with ~700k lines and it
> > > > > fails. Needless to say, legacy iptables handles it just fine.
> > > > > 
> > > > > Meanwhile I found out there's a limit of 1024 iovecs when submitting the
> > > > > batch to kernel, and this is what they're hitting.
> > > > > 
> > > > > I can work around that limit by increasing each iovec (via
> > > > > BATCH_PAGE_SIZE) but keeping pace with legacy seems ridiculous:
> > > > > 
> > > > > With a scripted binary-search I checked the maximum working number of
> > > > > restore items of:
> > > > > 
> > > > > (1) User-defined chains
> > > > > (2) rules with merely comment match present
> > > > > (3) rules matching on saddr, daddr, iniface and outiface
> > > > > 
> > > > > Here's legacy compared to nft with different factors in BATCH_PAGE_SIZE:
> > > > > 
> > > > > legacy		32 (stock)	  64		   128          256
> > > > > ----------------------------------------------------------------------
> > > > > 1'636'799	1'602'202	- NC -		  - NC -       - NC -
> > > > > 1'220'159	  302'079	604'160		1'208'320      - NC -
> > > > > 3'532'040	  242'688	485'376		  971'776    1'944'576
> > > > 
> > > > Can you explain that table? What does 1'636'799 mean? NC?
> > > 
> > > Ah, sorry: NC is "not care", I didn't consider those numbers relevant
> > > given that iptables-nft has caught up to legacy previously already.
> > > 
> > > 1'636'799 is the max number of user-defined chains I can successfully
> > > restore using iptables-legacy-restore. Looks like I dropped the rows'
> > > description while reformatting by accident: the first row of that table
> > > corresponds with test (1), second with test (2) and third with test (3).
> > > 
> > > So legacy may restore at once ~1.6M chains or ~1.2M comment rules or
> > > ~3.5M rules with {s,d}{addr,iface} matches.
> > > 
> > > The following columns are for iptables-nft with varying BATCH_PAGE_SIZE
> > > values. Each of the (max 1024) iovecs passed to kernel via sendmsg() is
> > > 'N * getpagesize()' large.
> > 
> > Did you measure any slow down in the ruleset load time after selecting
> > a larger batch chunk size?
> 
> Restoring 100k rules shows no significant difference in between stock
> (32 * 8k) and 512 * 8k chunk sizes. So if you think it's acceptable to
> allocate 4MB of buffer at once, I'd just send a patch.

That's fine.

> Lifting that 1024 chunk count limit might be an alternative, but I guess
> that sits in kernel space?

That sits in the kernel, in the generic socket layer IIRC.

P.S: Would you mind to send a patch for nftables too to keep it in
sync? Thanks.
