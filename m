Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA3C0C83F2F
	for <netfilter-devel@archiver.kernel.org>; Thu, 31 Aug 2023 16:08:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242070AbjHaQIo (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 31 Aug 2023 12:08:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346712AbjHaQIo (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 31 Aug 2023 12:08:44 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE389E53
        for <netfilter-devel@vger.kernel.org>; Thu, 31 Aug 2023 09:08:40 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1qbkDm-0001Hv-PF; Thu, 31 Aug 2023 18:08:38 +0200
Date:   Thu, 31 Aug 2023 18:08:38 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Thomas Haller <thaller@redhat.com>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft] tests/shell: allow running tests as non-root users
Message-ID: <20230831160838.GG15759@breakpoint.cc>
References: <20230830113153.877968-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230830113153.877968-1-thaller@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Thomas Haller <thaller@redhat.com> wrote:
> Allow to opt-out from the have-real-root check via
> 
>   NFT_TEST_ROOTLESS=1 ./run-tests.sh

I don't like this.  But its a step in the right direction.

To me run-tests.sh has following issues/pain points:
 - test duration is huge (>10m with debug kernels)
 - all tests run in same netns
 - tries to unloads kernel modules after each test

The need for uid 0 wasn't big on my problem list so far because
I mostly run the tests in a VM.  But I agree its an issue for
auto-build systems / CI and the like.

> For that to be useful, we must also unshare the PID and user namespace
> and map the root user inside that namespace.

Are you sure PIDNS unshare is needed for this?

> Test that don't work without real root should check for
> [ "$NFT_TEST_HAVE_REALROOT" != 1 ] and skip gracefully.

Thats fine, see my recent RFC to add such environment
variables to check if a particular feature is supported or not.

What I don't like here is the NFT_TEST_ROOTLESS environment
variable to alter behaviour of run-tests.sh behavior, but see below.

> -if [ "$(id -u)" != "0" ] ; then
> +if [ "$NFT_TEST_HAVE_REALROOT" = "" ] ; then
> +	# The caller can set NFT_TEST_HAVE_REALROOT to indicate us whether we
> +	# have real root. They usually don't need, and we detect it now based
> +	# on `id -u`. Note that we may unshare below, so the check inside the
> +	# new namespace won't be conclusive. We thus only detect once and export
> +	# the result.
> +	export NFT_TEST_HAVE_REALROOT="$(test "$(id -u)" = "0" && echo 1 || echo 0)"
> +fi
> +

Why not get rid of the check?  Just auto-switch to unpriv userns and
error out if that fails.  You could just print a warning/notice here and
then try userns mode.  And/or print a notice at the together with the
test summary.

> +if [ "$NFT_TEST_NO_UNSHARE" = 1 ]; then
> +	# The user opts-out from unshare. Proceed without.

Whats the use case?  If there is a good one, then i'd prefer a command
line switch rather than environment.

I think long term all of the following would be good to have:

1. run each test in its own netns
2. get rid of the forced 'nft flush ruleset' and the rmmod calls
3. Explore parallelisation of tests to reduce total test time
4. Add a SKIP return value, that tells that the test did not run
  (or some other means that allows run-tests.sh to figure out that
   a particular test did not run because its known to not work on
   current configuration).

This would avoid false-positive 'all tests passed' when in reality
some test had to 'exit 0' because of a missing feature or lack of real
root.

Alternatively we could just make these tests fail and leave it to the
user to figure it out, the normal expectation is for all tests to pass,
its mostly when run-tests.sh is run on older kernel releases when it
starts acting up.
