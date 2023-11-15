Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 097C3C07548
	for <netfilter-devel@archiver.kernel.org>; Wed, 15 Nov 2023 10:05:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234829AbjKOKF7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 15 Nov 2023 05:05:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234680AbjKOKF6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 Nov 2023 05:05:58 -0500
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12810109
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Nov 2023 02:05:55 -0800 (PST)
Received: from [78.30.43.141] (port=37288 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1r3CmM-00BHhA-W2; Wed, 15 Nov 2023 11:05:53 +0100
Date:   Wed, 15 Nov 2023 11:05:50 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     Thomas Haller <thaller@redhat.com>,
        NetFilter <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft v3 2/6] tests/shell: check and generate JSON dump
 files
Message-ID: <ZVSX/lO7/0sOmHQS@calendula>
References: <20231114153150.406334-1-thaller@redhat.com>
 <20231114160903.409552-1-thaller@redhat.com>
 <20231115082427.GC14621@breakpoint.cc>
 <ZVSVPgRFv9tTF4yQ@calendula>
 <20231115100101.GA23742@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231115100101.GA23742@breakpoint.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Nov 15, 2023 at 11:01:01AM +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Wed, Nov 15, 2023 at 09:24:27AM +0100, Florian Westphal wrote:
> > > Thomas Haller <thaller@redhat.com> wrote:
> > > > The rules after a successful test are good opportunity to test
> > > > `nft -j list ruleset` and `nft -j --check`. This quite possibly touches
> > > > code paths that are not hit by other tests yet.
> > > 
> > > This series looks good to me, I'll apply it in the next few hours if
> > > noone else takes any action by then.
> > 
> > Just a question, patch 3 is missing in patchwork. I guess it is too
> > big.
> > 
> > My understanding is that this performs the json tests if nft comes with
> > json support.
> > 
> > I wanted to give this a run, description says a few tests are failing.
> 
> ... but it says that no dump files are added for the failing test cases.

OK. Then json it is skipped in that case, that is fine.

> I'll double check this of course before pushing this out.

Then, please also disable json dump by now for:

        sets/sets_with_ifnames

because I am currently figuring out how to detach pipapo support from
it without losing coverage.
