Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 666C2C47072
	for <netfilter-devel@archiver.kernel.org>; Wed, 15 Nov 2023 10:02:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235037AbjKOKCw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 15 Nov 2023 05:02:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234995AbjKOKCg (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 Nov 2023 05:02:36 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D02A1985
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Nov 2023 02:01:04 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1r3Chh-0006JJ-PW; Wed, 15 Nov 2023 11:01:01 +0100
Date:   Wed, 15 Nov 2023 11:01:01 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>,
        Thomas Haller <thaller@redhat.com>,
        NetFilter <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft v3 2/6] tests/shell: check and generate JSON dump
 files
Message-ID: <20231115100101.GA23742@breakpoint.cc>
References: <20231114153150.406334-1-thaller@redhat.com>
 <20231114160903.409552-1-thaller@redhat.com>
 <20231115082427.GC14621@breakpoint.cc>
 <ZVSVPgRFv9tTF4yQ@calendula>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZVSVPgRFv9tTF4yQ@calendula>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Wed, Nov 15, 2023 at 09:24:27AM +0100, Florian Westphal wrote:
> > Thomas Haller <thaller@redhat.com> wrote:
> > > The rules after a successful test are good opportunity to test
> > > `nft -j list ruleset` and `nft -j --check`. This quite possibly touches
> > > code paths that are not hit by other tests yet.
> > 
> > This series looks good to me, I'll apply it in the next few hours if
> > noone else takes any action by then.
> 
> Just a question, patch 3 is missing in patchwork. I guess it is too
> big.
> 
> My understanding is that this performs the json tests if nft comes with
> json support.
> 
> I wanted to give this a run, description says a few tests are failing.

... but it says that no dump files are added for the failing test cases.

I'll double check this of course before pushing this out.
