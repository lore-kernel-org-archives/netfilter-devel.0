Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B4BCCE79D6
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Sep 2023 14:20:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234684AbjITOUR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 20 Sep 2023 10:20:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233786AbjITOUR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 Sep 2023 10:20:17 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C75B8AD;
        Wed, 20 Sep 2023 07:20:11 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1qiy3l-0003mT-7u; Wed, 20 Sep 2023 16:20:09 +0200
Date:   Wed, 20 Sep 2023 16:20:09 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Sam James <sam@gentoo.org>
Cc:     netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org,
        Jan Engelhardt <jengelh@inai.de>,
        Florian Westphal <fw@strlen.de>,
        Jozsef Kadlecsik <kadlec@netfilter.org>
Subject: Re: [PATCH] build: Fix double-prefix w/ pkgconfig
Message-ID: <ZQr/mYzd1cM2gIrX@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>, Sam James <sam@gentoo.org>,
        netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org,
        Jan Engelhardt <jengelh@inai.de>, Florian Westphal <fw@strlen.de>,
        Jozsef Kadlecsik <kadlec@netfilter.org>
References: <20230920133418.1893675-1-sam@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230920133418.1893675-1-sam@gentoo.org>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Sep 20, 2023 at 02:34:17PM +0100, Sam James wrote:
> First, apologies - 326932be0c4f47756f9809cad5a103ac310f700d clearly introduced
> a double prefix and I can't tell you what my thought process was 9 months ago
> but it was obviously wrong (my guess is I rebased some old patch and didn't
> think properly, no idea).

Not much use having this in the commit message. Maybe state the actual
problem you're trying to solve instead?

> Anyway, let's just drop the extraneous pkgconfigdir definition and use the
> proper one from pkg.m4 via PKG_INSTALLDIR.
> 
> Fixes: 326932be0c4f47756f9809cad5a103ac310f700d
> Signed-off-by: Sam James <sam@gentoo.org>
> ---
>  configure.ac    | 1 +
>  lib/Makefile.am | 1 -
>  2 files changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/configure.ac b/configure.ac
> index cad93af..6c26645 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -14,6 +14,7 @@ LT_CONFIG_LTDL_DIR([libltdl])
>  LTDL_INIT([nonrecursive])
>  
>  PKG_PROG_PKG_CONFIG
> +PKG_INSTALLDIR
>  
>  dnl Shortcut: Linux supported alone
>  case "$host" in
> diff --git a/lib/Makefile.am b/lib/Makefile.am
> index 50d937d..a9edf95 100644
> --- a/lib/Makefile.am
> +++ b/lib/Makefile.am
> @@ -46,7 +46,6 @@ EXTRA_libipset_la_SOURCES = \
>  
>  EXTRA_DIST = $(IPSET_SETTYPE_LIST) libipset.map
>  
> -pkgconfigdir = $(prefix)/$(libdir)/pkgconfig
>  pkgconfig_DATA = libipset.pc
>  
>  dist_man_MANS = libipset.3
> -- 
> 2.42.0
> 
> 
