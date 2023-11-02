Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67B92C4332F
	for <netfilter-devel@archiver.kernel.org>; Thu,  2 Nov 2023 21:23:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229619AbjKBVXq (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 2 Nov 2023 17:23:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbjKBVXp (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 2 Nov 2023 17:23:45 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51B27FB
        for <netfilter-devel@vger.kernel.org>; Thu,  2 Nov 2023 14:23:43 -0700 (PDT)
Received: from [78.30.35.151] (port=53712 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qyfAB-00B7HZ-60; Thu, 02 Nov 2023 22:23:41 +0100
Date:   Thu, 2 Nov 2023 22:23:37 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>,
        Arturo Borrero Gonzalez <arturo@debian.org>,
        Jeremy Sowden <jeremy@azazel.net>,
        netfilter-devel@vger.kernel.org, fw@strlen.de
Subject: Re: [RFC] nftables 1.0.6 -stable backports
Message-ID: <ZUQTWSEXbw2paJ3v@calendula>
References: <ZSPZiekbEmjDfIF2@calendula>
 <ZSZWS7StJ9nSP6cK@calendula>
 <ZSa+h18/ZNRxLpzq@orbyte.nwl.cc>
 <ZSbD9fPv2Ltx8Cx2@calendula>
 <ZTE8xaZfFJoQRhjY@calendula>
 <ZTFJ4yXd7nZxjAJz@orbyte.nwl.cc>
 <ZUOJNnKJRKwj379J@calendula>
 <ZUOVrlIgCSIM8Ule@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZUOVrlIgCSIM8Ule@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Nov 02, 2023 at 01:27:26PM +0100, Phil Sutter wrote:
> On Thu, Nov 02, 2023 at 12:34:14PM +0100, Pablo Neira Ayuso wrote:
> > On Thu, Oct 19, 2023 at 05:23:15PM +0200, Phil Sutter wrote:
> > > Kindly find attached my collect_backports.sh. I keep it in an unused
> > > sub-directory (~/git/nftables/stable_tooling), but it's not necessary.
> > > It creates $(dirname $0)/backports directory containing a list of
> > > potential backports for each tag in the range defined by the variables
> > > in the script's header.
> > 
> > I have integrated the pending fixes identified by your script. I have
> > refreshed 1.0.6.y branch and pushed it out.
> 
> Thanks for doing this!
> 
> > If anyone find more candidates to be merged into 1.0.6, Let me know.
> 
> My script found two missing ones. Not sure if they came in late or if
> you explicitly omitted them:
> 
> - 8519ab031d8022999603a69ee9f18e8cfb06645d

I could not trigger the bug that this fixes here, I tried several
rules but I failed. It was deliberate to skip it.

> - f65b2d12236174d477c55e96c4027cd51185ba5e

I am currently run tests for git/HEAD on this 1.0.6.y, but I can
collect it too if you like. So not very useful for my approach.

> As you know, my script relies upon Fixes: tags. I use git-notes to help
> it here and there. This way I added extra Fixes: tags with correct
> hashes for:
> 
> - 818cc223b052b9a3b0bc3fc28a4b7036b5898408
> - 8a9f48515fb8f9aed0af04e05f4528aa0e32116f
> - b4c9900c895fd55788912d62063cf107a27b68e0
> - b593378b9b2470213af1892053af519801053a7e
> 
> (The list may very well be incomplete.)
> 
> Another case for git-notes is missing Fixes: tags in fixing commits.
> They are important in two ways:
> 
> - Without a Fixes: tag, the script won't find the backport candidate.
> - If backported manually, the script won't find potential follow-ups
>   (fixes may have fixes, too).
> 
> In 1.0.6.y, I see 33 commits having no Fixes: tag. Did you solve this
> locally with git-notes?

No, I did not.

> Assuming history rewriting is allowed in the stable branch, one
> could update the backports with Fixes: tags as needed and write a
> custom collect_backports.sh which operates on the stable branch
> directly.

That requires looking for each of those 33 commits that got no Fixes:
tag in first place, mangle original patches in such way.

Maybe modify the script to parse the

        commit ID upstream.

text to track down this dependencies?

> An alternative might be to publish notes somehow. According to the man
> page, it seems possible to keep them in a branch but I have no idea how
> this works.
