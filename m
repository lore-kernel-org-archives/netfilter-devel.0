Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF31DE81DE9
	for <netfilter-devel@archiver.kernel.org>; Fri,  6 Oct 2023 11:51:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232038AbjJFLv7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 6 Oct 2023 07:51:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232127AbjJFLv6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 6 Oct 2023 07:51:58 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 369FCDB
        for <netfilter-devel@vger.kernel.org>; Fri,  6 Oct 2023 04:51:57 -0700 (PDT)
Received: from [78.30.34.192] (port=47722 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qojN0-008Ijz-Ny; Fri, 06 Oct 2023 13:51:53 +0200
Date:   Fri, 6 Oct 2023 13:51:49 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Thomas Haller <thaller@redhat.com>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Subject: Re: [nft PATCH 1/3] tests/shell: mount all of "/var/run" in
 "test-wrapper.sh"
Message-ID: <ZR/01bpbTAQY5QPc@calendula>
References: <20231006094226.711628-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231006094226.711628-1-thaller@redhat.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Thomas,

Series LGTM, one question below

On Fri, Oct 06, 2023 at 11:42:18AM +0200, Thomas Haller wrote:
> After reboot, "/var/run/netns" does not exist before we run the first
> `ip netns add` command. Previously, "test-wrapper.sh" would mount a
> tmpfs on that directory, but that fails, if the directory doesn't exist.
> You will notice this, by deleting /var/run/netns (which only root can
> delete or create, and which is wiped on reboot).
> 
> Instead, mount all of "/var/run". Then we can also create /var/run/netns
> directory.

Maybe create a specify mount point for this? This will be created
once, then it will remain there for those that run tests?

> This means, any other content from /var/run is hidden too. That's
> probably desirable, because it means we don't depend on stuff that
> happens to be there. If we would require other content in /var/run, then
> the test runner needs to be aware of the requirement and ensure it's
> present. But best is just to not require anything. It's only iproute2
> which insists on /var/run/netns.
> 
> Signed-off-by: Thomas Haller <thaller@redhat.com>
> ---
>  tests/shell/helpers/test-wrapper.sh | 26 +++++++++++++++-----------
>  1 file changed, 15 insertions(+), 11 deletions(-)
> 
> diff --git a/tests/shell/helpers/test-wrapper.sh b/tests/shell/helpers/test-wrapper.sh
> index e10360c9b266..13b918f8b8e1 100755
> --- a/tests/shell/helpers/test-wrapper.sh
> +++ b/tests/shell/helpers/test-wrapper.sh
> @@ -23,11 +23,11 @@ START_TIME="$(cut -d ' ' -f1 /proc/uptime)"
>  
>  export TMPDIR="$NFT_TEST_TESTTMPDIR"
>  
> -CLEANUP_UMOUNT_RUN_NETNS=n
> +CLEANUP_UMOUNT_VAR_RUN=n
>  
>  cleanup() {
> -	if [ "$CLEANUP_UMOUNT_RUN_NETNS" = y ] ; then
> -		umount "/var/run/netns" || :
> +	if [ "$CLEANUP_UMOUNT_VAR_RUN" = y ] ; then
> +		umount "/var/run" &>/dev/null || :
>  	fi
>  }
>  
> @@ -38,16 +38,20 @@ printf '%s\n' "$TEST" > "$NFT_TEST_TESTTMPDIR/name"
>  read tainted_before < /proc/sys/kernel/tainted
>  
>  if [ "$NFT_TEST_HAS_UNSHARED_MOUNT" = y ] ; then
> -	# We have a private mount namespace. We will mount /run/netns as a tmpfs,
> -	# this is useful because `ip netns add` wants to add files there.
> +	# We have a private mount namespace. We will mount /var/run/ as a tmpfs.
>  	#
> -	# When running as rootless, this is necessary to get such tests to
> -	# pass.  When running rootful, it's still useful to not touch the
> -	# "real" /var/run/netns of the system.
> -	mkdir -p /var/run/netns
> -	if mount -t tmpfs --make-private "/var/run/netns" ; then
> -		CLEANUP_UMOUNT_RUN_NETNS=y
> +	# The main purpose is so that we can create /var/run/netns, which is
> +	# required for `ip netns add` to work.  When running as rootless, this
> +	# is necessary to get such tests to pass. When running rootful, it's
> +	# still useful to not touch the "real" /var/run/netns of the system.
> +	#
> +	# Note that this also hides everything that might reside in /var/run.
> +	# That is desirable, as tests should not depend on content there (or if
> +	# they do, we need to explicitly handle it as appropriate).
> +	if mount -t tmpfs --make-private "/var/run" ; then
> +		CLEANUP_UMOUNT_VAR_RUN=y
>  	fi
> +	mkdir -p /var/run/netns
>  fi
>  
>  TEST_TAGS_PARSED=0
> -- 
> 2.41.0
> 
