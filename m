Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E95A4C072A2
	for <netfilter-devel@archiver.kernel.org>; Sat, 18 Nov 2023 02:36:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232181AbjKRCgf (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 17 Nov 2023 21:36:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230036AbjKRCge (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 17 Nov 2023 21:36:34 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E5E6A7
        for <netfilter-devel@vger.kernel.org>; Fri, 17 Nov 2023 18:36:30 -0800 (PST)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1r4BC8-0004u0-AQ; Sat, 18 Nov 2023 03:36:28 +0100
Date:   Sat, 18 Nov 2023 03:36:28 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Thomas Haller <thaller@redhat.com>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft 1/1] tests/shell: sanitize "handle" in JSON output
Message-ID: <ZVgjLFGvHqoXXvjd@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Thomas Haller <thaller@redhat.com>,
        NetFilter <netfilter-devel@vger.kernel.org>
References: <20231117171948.897229-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231117171948.897229-1-thaller@redhat.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Nov 17, 2023 at 06:18:45PM +0100, Thomas Haller wrote:
> The "handle" in JSON output is not stable. Sanitize/normalizeit to 1216.
> 
> The number is chosen arbitrarily, but it's somewhat unique in the code
> base. So when you see it, you may guess it originates from sanitization.

Valid handles are monotonic starting at 1. Using 0 as a replacement is
too simple?

> Signed-off-by: Thomas Haller <thaller@redhat.com>
> ---
> Note that only a few .json-nft files are adjusted, because otherwise the
> patch is too large. Before applying, you need to adjust them all, by
> running `./tests/shell/run-tests.sh -g`.

Just put the bulk change into a second patch?

[...]
> diff --git a/tests/shell/helpers/json-sanitize-ruleset.sh b/tests/shell/helpers/json-sanitize-ruleset.sh
> index 270a6107e0aa..3b66adabf055 100755
> --- a/tests/shell/helpers/json-sanitize-ruleset.sh
> +++ b/tests/shell/helpers/json-sanitize-ruleset.sh
> @@ -6,7 +6,14 @@ die() {
>  }
>  
>  do_sed() {
> -	sed '1s/\({"nftables": \[{"metainfo": {"version": "\)[0-9.]\+\(", "release_name": "\)[^"]\+\(", "\)/\1VERSION\2RELEASE_NAME\3/' "$@"
> +	# Normalize the "version"/"release_name", otherwise we have to regenerate the
> +	# JSON output upon new release.
> +	#
> +	# Also, "handle" are not stable. Normalize them to 1216 (arbitrarily chosen).
> +	sed \
> +		-e '1s/\({"nftables": \[{"metainfo": {"version": "\)[0-9.]\+\(", "release_name": "\)[^"]\+\(", "\)/\1VERSION\2RELEASE_NAME\3/' \
> +		-e '1s/"handle": [0-9]\+\>/"handle": 1216/g' \
> +		"$@"
>  }

Why not just drop the whole metainfo object? A dedicated test could
still ensure its existence.

Also, scoping these replacements to line 1 is funny with single line
input. Worse is identifying the change in the resulting diff. Maybe
write a helper in python which lets you more comfortably sanitize input,
sort attributes by key and output pretty-printed?

In general, the long lines in your scripts make them quite hard to read.
Any particular reason why you don't stick to the 80 columns maxim?

Cheers, Phil
