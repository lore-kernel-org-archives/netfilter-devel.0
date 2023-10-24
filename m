Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92E07C07545
	for <netfilter-devel@archiver.kernel.org>; Tue, 24 Oct 2023 10:47:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234140AbjJXKrh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 24 Oct 2023 06:47:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232042AbjJXKrg (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 24 Oct 2023 06:47:36 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C341E5
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Oct 2023 03:47:34 -0700 (PDT)
Received: from [78.30.35.151] (port=45136 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qvEwZ-0060c4-20; Tue, 24 Oct 2023 12:47:32 +0200
Date:   Tue, 24 Oct 2023 12:47:26 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] check-tree.sh: check and flag /bin/sh usage
Message-ID: <ZTegvleAvSb4mNUg@calendula>
References: <20231024104044.18669-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231024104044.18669-1-fw@strlen.de>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Oct 24, 2023 at 12:40:40PM +0200, Florian Westphal wrote:
> Almost all shell tests use /bin/bash already.
> 
> In some cases we've had shell tests use /bin/sh, but still having
> a bashism.  This causes failures on systems where sh is dash or another,
> strict bourne shell.
> 
> Flag those via check-tree.sh.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  tests/shell/testcases/sets/elem_opts_compat_0 | 2 +-
>  tools/check-tree.sh                           | 1 +
>  2 files changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/tests/shell/testcases/sets/elem_opts_compat_0 b/tests/shell/testcases/sets/elem_opts_compat_0
> index e0129536fcb7..3467cc07e646 100755
> --- a/tests/shell/testcases/sets/elem_opts_compat_0
> +++ b/tests/shell/testcases/sets/elem_opts_compat_0
> @@ -1,4 +1,4 @@
> -#!/bin/sh
> +#!/bin/bash
>  
>  # ordering of element options and expressions has changed, make sure parser
>  # accepts both ways

Amend before applying, I was too fast to push out the fix for
elem_opts_compat_0.

Thanks.

> diff --git a/tools/check-tree.sh b/tools/check-tree.sh
> index c3aaa08d05ce..e3ddf8bdea58 100755
> --- a/tools/check-tree.sh
> +++ b/tools/check-tree.sh
> @@ -68,6 +68,7 @@ if [ "${#SHELL_TESTS[@]}" -eq 0 ] ; then
>  fi
>  for t in "${SHELL_TESTS[@]}" ; do
>  	check_shell_dumps "$t"
> +	head -n 1 "$t" |grep -q  '^#!/bin/sh' && echo "$t uses sh instead of bash" && EXIT_CODE=1
>  done
>  
>  ##############################################################################
> -- 
> 2.41.0
> 
