Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0ECDDEB8FA5
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 Sep 2023 10:05:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238591AbjIFKFf (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 6 Sep 2023 06:05:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238805AbjIFKF1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 6 Sep 2023 06:05:27 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67D5919BA
        for <netfilter-devel@vger.kernel.org>; Wed,  6 Sep 2023 03:04:43 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1qdpOq-0005e2-S2; Wed, 06 Sep 2023 12:04:40 +0200
Date:   Wed, 6 Sep 2023 12:04:40 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Thomas Haller <thaller@redhat.com>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH RFC] tests: add feature probing
Message-ID: <20230906100440.GD9603@breakpoint.cc>
References: <20230831135112.30306-1-fw@strlen.de>
 <c322af5a87a7a4b31d4c4897fe5c3059e9735b4e.camel@redhat.com>
 <20230904085301.GC11802@breakpoint.cc>
 <7731edd7662e606a06b1d4c60fb4cff9096fa758.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7731edd7662e606a06b1d4c60fb4cff9096fa758.camel@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Thomas Haller <thaller@redhat.com> wrote:
> On Mon, 2023-09-04 at 10:53 +0200, Florian Westphal wrote:
> > Thomas Haller <thaller@redhat.com> wrote:
> > > 
> > > 
> > > But why this "nft -f" specific detection? Why not just executable
> > > scripts?
> > 
> > Because I want it to be simple,
> 
> It does not seem "simple[r]" to me. The approach requires extra
> infrastructure in run-test.sh, while being less flexible.

I can add bla.nft and use nft --check -f bla.nft.

Or, I can add bla.sh, which does

exec $NFT -f - <<EOF
table ...
EOF

I see zero reason why we can't add scripts later on if there
are cases where flat-files don't work.

At this point, its just more boilerplate to add a script wrapper
around the .nft file.

> > I could do that, but I don't see the need for arbitrary scripts so
> > far.
> 
> When building without JSON support, various tests fail, but should be
> skipped.
> 
> Could we detect JSON support via .nft files? Would we drop then a JSON
> .nft file and change the check call to `nft --check -j`?).

No, but the test that should be skipped can do

$NFT -j list ruleset || exit 77

as first line of the script, no need to load any files, nft will fail
with error in case its not built with json support.

> Or maybe detection of JSON support needs to be a shell script (doing
> `ldd "$NFT_REAL" | greq libjansson`)? In that case, we would have
> features-as-shell-scripts very soon.

Sure, I see no reason why to not have both.  The flat files have the
'*nft' suffix for a reason...

I'll no longer work on this for the remainder of the month due to
time constraints.
