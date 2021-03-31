Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08EABC43461
	for <netfilter-devel@archiver.kernel.org>; Wed, 31 Mar 2021 14:42:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD9B16100B
	for <netfilter-devel@archiver.kernel.org>; Wed, 31 Mar 2021 14:42:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236152AbhCaOmI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 31 Mar 2021 10:42:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235957AbhCaOln (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 31 Mar 2021 10:41:43 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09818C061574
        for <netfilter-devel@vger.kernel.org>; Wed, 31 Mar 2021 07:41:42 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1lRc2O-0003rc-AI; Wed, 31 Mar 2021 16:41:40 +0200
Date:   Wed, 31 Mar 2021 16:41:40 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Florian Westphal <fw@strlen.de>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: iptables-nft fails to restore huge rulesets
Message-ID: <20210331144140.GV3158@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20210331091331.GE7863@orbyte.nwl.cc>
 <20210331133510.GF17285@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210331133510.GF17285@breakpoint.cc>
Sender:  <n0-1@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Mar 31, 2021 at 03:35:10PM +0200, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > I'm currently trying to fix for an issue in Kubernetes realm[1]:
> > Baseline is they are trying to restore a ruleset with ~700k lines and it
> > fails. Needless to say, legacy iptables handles it just fine.
> > 
> > Meanwhile I found out there's a limit of 1024 iovecs when submitting the
> > batch to kernel, and this is what they're hitting.
> > 
> > I can work around that limit by increasing each iovec (via
> > BATCH_PAGE_SIZE) but keeping pace with legacy seems ridiculous:
> > 
> > With a scripted binary-search I checked the maximum working number of
> > restore items of:
> > 
> > (1) User-defined chains
> > (2) rules with merely comment match present
> > (3) rules matching on saddr, daddr, iniface and outiface
> > 
> > Here's legacy compared to nft with different factors in BATCH_PAGE_SIZE:
> > 
> > legacy		32 (stock)	  64		   128          256
> > ----------------------------------------------------------------------
> > 1'636'799	1'602'202	- NC -		  - NC -       - NC -
> > 1'220'159	  302'079	604'160		1'208'320      - NC -
> > 3'532'040	  242'688	485'376		  971'776    1'944'576
> 
> Can you explain that table? What does 1'636'799 mean? NC?

Ah, sorry: NC is "not care", I didn't consider those numbers relevant
given that iptables-nft has caught up to legacy previously already.

1'636'799 is the max number of user-defined chains I can successfully
restore using iptables-legacy-restore. Looks like I dropped the rows'
description while reformatting by accident: the first row of that table
corresponds with test (1), second with test (2) and third with test (3).

So legacy may restore at once ~1.6M chains or ~1.2M comment rules or
~3.5M rules with {s,d}{addr,iface} matches.

The following columns are for iptables-nft with varying BATCH_PAGE_SIZE
values. Each of the (max 1024) iovecs passed to kernel via sendmsg() is
'N * getpagesize()' large.

Cheers, Phil
