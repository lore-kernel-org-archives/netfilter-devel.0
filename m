Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6356BECAAD1
	for <netfilter-devel@archiver.kernel.org>; Wed, 31 Aug 2022 15:09:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231390AbiHaPJU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 31 Aug 2022 11:09:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231282AbiHaPJT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 31 Aug 2022 11:09:19 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A1420543FE;
        Wed, 31 Aug 2022 08:09:18 -0700 (PDT)
Date:   Wed, 31 Aug 2022 17:09:15 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@kernel.org>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
        bpf@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH nf-next] netfilter: nf_tables: add ebpf expression
Message-ID: <Yw95m0mcPeE68fRJ@salvia>
References: <20220831101617.22329-1-fw@strlen.de>
 <87v8q84nlq.fsf@toke.dk>
 <20220831125608.GA8153@breakpoint.cc>
 <87o7w04jjb.fsf@toke.dk>
 <20220831135757.GC8153@breakpoint.cc>
 <87ilm84goh.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87ilm84goh.fsf@toke.dk>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Aug 31, 2022 at 04:43:26PM +0200, Toke Høiland-Jørgensen wrote:
> Florian Westphal <fw@strlen.de> writes:
> 
> > Toke Høiland-Jørgensen <toke@kernel.org> wrote:
> >> >> It seems a bit odd to include the file path in the kernel as well.
> >> >
> >> > Its needed to be able to re-load the ruleset.
> >> 
> >> How does that work, exactly? Is this so that the userspace binary can
> >> query the current ruleset, and feed it back to the kernel expecting it
> >> to stay the same?
> >
> > Yes.
> >
> >> Because in that case, if the pinned object goes away
> >> in the meantime (or changes to a different program), this could lead to
> >> some really hard to debug errors, where a reload subtly changes the
> >> behaviour because the BPF program is not in fact the same.
> >
> > Correct, but thats kind of expected when the user changes programs
> > logic.
> >
> > Same with a 'nft list ruleset > /etc/nft.txt', reboot,
> > 'nft -f /etc/nft.txt' fails because user forgot to load/pin the program
> > first.
> 
> Right, so under what conditions is the identifier expected to survive,
> exactly? It's okay if it fails after a reboot, but it should keep
> working while the system is up?
> 
> >> > This way was the most simple solution.
> >> 
> >> My point here was more that if it's just a label for human consumption,
> >> the comment field should be fine, didn't realise it was needed for the
> >> tool operation (and see above re: that).
> >
> > Yes, this is unfortunate.  I would like to avoid introducing an
> > asymmetry between input and output (as in "... add rule ebpf pinned
> > bla', but 'nft list ruleset' showing 'ebpf id 42') or similar, UNLESS we
> > can somehow use that alternate output to reconstruct that was originally
> > intended.  And so far I can only see that happening with storing some
> > label in the kernel for userspace to consume (elf filename, pinned name,
> > program name ... ).
> >
> > To give an example:
> >
> > With 'ebpf id 42', we might be able to let this get echoed back as if
> > user would have said 'ebpf progname myfilter' (I am making this up!),
> > just to have a more 'stable' identifier.
> >
> > This would make it necessary to also support load-by-program-name, of
> > course.
> 
> Seems like this kind of mapping can be done in userspace without
> involving the kernel?
> 
> For example, the 'progname' thing could be implemented by defining an
> nft-specific pinning location so that 'ebpf progname myfilter' is
> equivalent to 'ebpf pinned /sys/bpf/nft/myfilter' and when nft receives
> an ID from the kernel it goes looking in /sys/bpf/nft to see if it can
> find the program with that ID and echoes it with the appropriate
> progname if it does exist?
> 
> This could also be extended, so that if a user does '... add rule ebpf
> file /usr/lib/bpf/myrule.o' the nft binary stashes the id -> .o file
> mapping somewhere (in /run for instance) so that it can echo back where
> it got it from later?
> 
> In either case I'm not really sure that there's much to be gained from
> asking the kernel to store an additional label with the program rule?

@Florian, could you probably use the object infrastructure to refer to
the program?

This might also allow you to refer to this new object type from
nf_tables maps.

It would be good to avoid linear rule-based matching to select what
program to run.

Maybe this also fits fine for your requirements?
