Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAA80C83F38
	for <netfilter-devel@archiver.kernel.org>; Thu, 31 Aug 2023 18:18:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244232AbjHaSS1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 31 Aug 2023 14:18:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233004AbjHaSS1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 31 Aug 2023 14:18:27 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E82CFE63
        for <netfilter-devel@vger.kernel.org>; Thu, 31 Aug 2023 11:18:23 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1qbmFJ-0001xD-Uc; Thu, 31 Aug 2023 20:18:21 +0200
Date:   Thu, 31 Aug 2023 20:18:21 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Thomas Haller <thaller@redhat.com>
Cc:     Florian Westphal <fw@strlen.de>,
        NetFilter <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft] tests/shell: allow running tests as non-root users
Message-ID: <20230831181821.GH15759@breakpoint.cc>
References: <20230830113153.877968-1-thaller@redhat.com>
 <20230831160838.GG15759@breakpoint.cc>
 <092e55f0000bee0383f50fd9eea26a4f8dbfc41f.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <092e55f0000bee0383f50fd9eea26a4f8dbfc41f.camel@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Thomas Haller <thaller@redhat.com> wrote:
> On Thu, 2023-08-31 at 18:08 +0200, Florian Westphal wrote:
> > > For that to be useful, we must also unshare the PID and user
> > > namespace
> > > and map the root user inside that namespace.
> > 
> > Are you sure PIDNS unshare is needed for this?
> 
> Probably not, but does it hurt? I think it should be
> 
>   unshare -f -p -U -n --mount-proc --map-root-user \
>       bash -xc 'whoami; ip link; sleep 1 & ps aux'

Its an extra kernel option that needs to be enabled for this to work.
Probably on for all distro kernels by now but whats the added benefit?

> > > Test that don't work without real root should check for
> > > [ "$NFT_TEST_HAVE_REALROOT" != 1 ] and skip gracefully.
> > 
> > Thats fine, see my recent RFC to add such environment
> > variables to check if a particular feature is supported or not.
> > 
> > What I don't like here is the NFT_TEST_ROOTLESS environment
> > variable to alter behaviour of run-tests.sh behavior, but see below.
> 
> If you don't run with real-root, then you are maybe not testing the
> full thing and miss something. Hence, you have to opt-in to the new
> rootless functionality with NFT_TEST_ROOTLESS=1.

I disagree, I think a notice is fine, this disclaimer could be
repeated after test summary.

Especially if we start skipping tests we should also have
an indication that not all tests were run (ideally, we'd see which
ones and how many...).

> The check is to preserve the previous behavior, which failed without
> real-root.

If you absolutely insist then fine.

> > Why not get rid of the check?  Just auto-switch to unpriv userns and
> > error out if that fails.  You could just print a warning/notice here
> > and
> > then try userns mode.  And/or print a notice at the together with the
> > test summary.
> 
> Which check? About NFT_TEST_HAVE_REALROOT?

I meant $(id) -eq 0 || barf

I think the best is to:
./run-tests.sh called with uid 0   -> no changes
./run-tests.sh called with uid > 0 -> try unpriv netns and set
NFT_TEST_HAVE_USERNS=1 in the environment to allow test cases to adjust
if needed (e.g. bail out early).

>      podman run --privileged -ti fedora:latest
> 
> then `id -u` would wrongly indicate that the test has real-root. You
> can override that with `export  NFT_TEST_HAVE_REALROOT=0` to run in
> rootless mode.

Ah.  Well, with my proposal above you can still set
NFT_TEST_HAVE_USERNS=1 manually before ./run-tests.sh if uid 0 isn't
really uid 0.

> > > +if [ "$NFT_TEST_NO_UNSHARE" = 1 ]; then
> > > +       # The user opts-out from unshare. Proceed without.
> > 
> > Whats the use case?  If there is a good one, then i'd prefer a
> > command
> > line switch rather than environment.
> 
> I think command line switches are inferior. They are cumbersome to
> implement (in the script, the order of options surprisingly matters).
> They are also more limited in their usage. The script should integrate
> with a `make check-xyz` step or be called from others scripts, where
> the command line is not directly editable. Also, the name
> NFT_TEST_NO_UNSHARE is something unique that you can grep for (unlike
> the "-g" command line switch.

Yuck.  Do we need a totally different script then?

./run-tests.sh is for humans, not machines. I want sane defaults.

> also expected a failure to `unshare`, then printed a warning and
> proceeded without separate namespace. I think that fallback is
> undesirable, I would not want to run the test accidentally in the main
> namespace.

Then add a warning?  I very much dislike these environment variables,
developers will add them to their bash init scripts and then there is
big surprise why someone reports unexpected results/behaviours.

Command line options are typically known, environment not.
Don't get me wrong, environment variables are good, I have no objections
to setting NFT_TEST_HAVE_USERNS or the like for the individual tests to
consume.

> Now, by default it always tries to unshare, and aborts on failure. The
> variable is there to opt-out from that.

Can't we have a sane default without a need for new command line options
or enviroment variables?

> I'd like to integrate tests more into `make check-*`. I'd also like to
> add unit tests (that is, both statically and dynamically link with
> libnftables and to be able to unit test code specifically). As a
> developer, I'd like to type `make check` to run the the unit tests and
> have a clear make target for the integration tests.

Thats a good thing.  I do not care if I have to call ./run-tests.sh
or 'make tests', but please, sane defaults without code path explosion.
