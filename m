Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F69DC4332F
	for <netfilter-devel@archiver.kernel.org>; Fri,  3 Nov 2023 09:59:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347390AbjKCJ7f (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 3 Nov 2023 05:59:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347416AbjKCJ7e (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 3 Nov 2023 05:59:34 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EF8CBD
        for <netfilter-devel@vger.kernel.org>; Fri,  3 Nov 2023 02:59:30 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1qyqxZ-0008Ct-Rv; Fri, 03 Nov 2023 10:59:25 +0100
Date:   Fri, 3 Nov 2023 10:59:25 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Arturo Borrero Gonzalez <arturo@debian.org>,
        Jeremy Sowden <jeremy@azazel.net>,
        netfilter-devel@vger.kernel.org, fw@strlen.de
Subject: Re: [RFC] nftables 1.0.6 -stable backports
Message-ID: <ZUTEfXMw2e5kMJ5A@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Arturo Borrero Gonzalez <arturo@debian.org>,
        Jeremy Sowden <jeremy@azazel.net>, netfilter-devel@vger.kernel.org,
        fw@strlen.de
References: <ZSPZiekbEmjDfIF2@calendula>
 <ZSZWS7StJ9nSP6cK@calendula>
 <ZSa+h18/ZNRxLpzq@orbyte.nwl.cc>
 <ZSbD9fPv2Ltx8Cx2@calendula>
 <ZTE8xaZfFJoQRhjY@calendula>
 <ZTFJ4yXd7nZxjAJz@orbyte.nwl.cc>
 <ZUOJNnKJRKwj379J@calendula>
 <ZUOVrlIgCSIM8Ule@orbyte.nwl.cc>
 <ZUQTWSEXbw2paJ3v@calendula>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZUQTWSEXbw2paJ3v@calendula>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Nov 02, 2023 at 10:23:37PM +0100, Pablo Neira Ayuso wrote:
> On Thu, Nov 02, 2023 at 01:27:26PM +0100, Phil Sutter wrote:
> > On Thu, Nov 02, 2023 at 12:34:14PM +0100, Pablo Neira Ayuso wrote:
> > > On Thu, Oct 19, 2023 at 05:23:15PM +0200, Phil Sutter wrote:
> > > > Kindly find attached my collect_backports.sh. I keep it in an unused
> > > > sub-directory (~/git/nftables/stable_tooling), but it's not necessary.
> > > > It creates $(dirname $0)/backports directory containing a list of
> > > > potential backports for each tag in the range defined by the variables
> > > > in the script's header.
> > > 
> > > I have integrated the pending fixes identified by your script. I have
> > > refreshed 1.0.6.y branch and pushed it out.
> > 
> > Thanks for doing this!
> > 
> > > If anyone find more candidates to be merged into 1.0.6, Let me know.
> > 
> > My script found two missing ones. Not sure if they came in late or if
> > you explicitly omitted them:
> > 
> > - 8519ab031d8022999603a69ee9f18e8cfb06645d
> 
> I could not trigger the bug that this fixes here, I tried several
> rules but I failed. It was deliberate to skip it.

I can reproduce it on current 1.0.6.y branch (HEAD at 3bd7fec6245f):

| # nft -f - <<EOF
| p ipfoo {
| 	map y {
| 		type ipv4_addr : ipv4_addr . inet_service
| 		elements = { 192.168.7.2 : 10.1.1.1 . 4242 }
| 	}
| 
| 	chain c {
| 	}
| }
| # valgrind --leak-check=full nft add rule ip ipfoo c dnat to ip daddr map @y

It reports:

| ==10404== 187 (104 direct, 83 indirect) bytes in 1 blocks are definitely lost in loss record 3 of 3
| ==10404==    at 0x48456FF: calloc (vg_replace_malloc.c:1554)
| ==10404==    by 0x48A33CD: xmalloc (utils.c:36)
| ==10404==    by 0x48A33CD: xzalloc (utils.c:75)
| ==10404==    by 0x487A3EB: dtype_alloc (datatype.c:1102)
| ==10404==    by 0x487A3EB: concat_type_alloc (datatype.c:1185)
| ==10404==    by 0x4880A0F: stmt_evaluate_nat_map (evaluate.c:3562)
| ==10404==    by 0x4880A0F: stmt_evaluate_nat (evaluate.c:3668)
| ==10404==    by 0x4880A0F: stmt_evaluate (evaluate.c:4222)
| ==10404==    by 0x488200E: rule_evaluate (evaluate.c:4728)
| ==10404==    by 0x48AD562: nft_evaluate (libnftables.c:537)
| ==10404==    by 0x48AE5FF: nft_run_cmd_from_buffer (libnftables.c:573)
| ==10404==    by 0x10AA17: main (main.c:521)

> > - f65b2d12236174d477c55e96c4027cd51185ba5e
> 
> I am currently run tests for git/HEAD on this 1.0.6.y, but I can
> collect it too if you like. So not very useful for my approach.

Oh, indeed, this is non-sense. I doubt the Fixes: tag is appropriate even.

> > As you know, my script relies upon Fixes: tags. I use git-notes to help
> > it here and there. This way I added extra Fixes: tags with correct
> > hashes for:
> > 
> > - 818cc223b052b9a3b0bc3fc28a4b7036b5898408
> > - 8a9f48515fb8f9aed0af04e05f4528aa0e32116f
> > - b4c9900c895fd55788912d62063cf107a27b68e0
> > - b593378b9b2470213af1892053af519801053a7e
> > 
> > (The list may very well be incomplete.)
> > 
> > Another case for git-notes is missing Fixes: tags in fixing commits.
> > They are important in two ways:
> > 
> > - Without a Fixes: tag, the script won't find the backport candidate.
> > - If backported manually, the script won't find potential follow-ups
> >   (fixes may have fixes, too).
> > 
> > In 1.0.6.y, I see 33 commits having no Fixes: tag. Did you solve this
> > locally with git-notes?
> 
> No, I did not.
> 
> > Assuming history rewriting is allowed in the stable branch, one
> > could update the backports with Fixes: tags as needed and write a
> > custom collect_backports.sh which operates on the stable branch
> > directly.
> 
> That requires looking for each of those 33 commits that got no Fixes:
> tag in first place, mangle original patches in such way.

Yes, this is the script taking its toll. ;)

> Maybe modify the script to parse the
> 
>         commit ID upstream.
> 
> text to track down this dependencies?

That alone is not enough: The script works based on tags, i.e. for each tag it
checks if origin/master has a commit with a Fixes: tag referencing a commit
contained in that tag or in the list of potential backports identified via the
same method.

One would have to change it to work based on *.y branches and the actual
commits in there. I'll give it a quick try, shouldn't be too hard
indeed.

Cheers, Phil
