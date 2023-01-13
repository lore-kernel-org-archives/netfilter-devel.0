Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00080C678D8
	for <netfilter-devel@archiver.kernel.org>; Fri, 13 Jan 2023 11:52:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240555AbjAMLw1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 13 Jan 2023 06:52:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239906AbjAMLva (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 13 Jan 2023 06:51:30 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5B06306
        for <netfilter-devel@vger.kernel.org>; Fri, 13 Jan 2023 03:47:34 -0800 (PST)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1pGIWw-0003eE-TG; Fri, 13 Jan 2023 12:47:30 +0100
Date:   Fri, 13 Jan 2023 12:47:30 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Arturo Borrero Gonzalez <arturo@netfilter.org>
Subject: Re: [PATCH] build: put xtables.conf in EXTRA_DIST
Message-ID: <Y8FE0vEvtZhY6LCv@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Jan Engelhardt <jengelh@inai.de>, netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Arturo Borrero Gonzalez <arturo@netfilter.org>
References: <20230112225517.31560-1-jengelh@inai.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230112225517.31560-1-jengelh@inai.de>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Jan,

On Thu, Jan 12, 2023 at 11:55:17PM +0100, Jan Engelhardt wrote:
> To make distcheck succeed, disting it is enough; it does not need
> to be installed.

Instead of preventing it from being installed, how about dropping it
altogether?

The last code using it was dropped by me three years ago, apparently
after decision at NFWS[1]. Pablo removed the standalone 'xtables-config'
utility back in 2015[2], yet I see a remaining xtables_config_main
prototype in xtables-multi.h which seems to have been missed back then.

> 
> Fixes: v1.8.8-150-g3822a992
> Signed-off-by: Jan Engelhardt <jengelh@inai.de>
> ---
>  Makefile.am | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/Makefile.am b/Makefile.am
> index 451c3cb2..10198753 100644
> --- a/Makefile.am
> +++ b/Makefile.am
> @@ -16,11 +16,11 @@ SUBDIRS         += extensions
>  # Depends on extensions/libext.a:
>  SUBDIRS         += iptables
>  
> -EXTRA_DIST	= autogen.sh iptables-test.py xlate-test.py
> +EXTRA_DIST	= autogen.sh iptables-test.py xlate-test.py etc/xtables.conf
>  
>  if ENABLE_NFTABLES
>  confdir		= $(sysconfdir)
> -dist_conf_DATA	= etc/ethertypes etc/xtables.conf
> +dist_conf_DATA	= etc/ethertypes
>  endif

While being at it, I wonder about ethertypes: At least on the distros I
run locally, the file is provided by other packages than iptables. Do we
still need it? (It was added by Arturo for parity with legacy ebtables
in [3].)

Thanks, Phil

[1] 06fd5e46d46f7 ("xtables: Drop support for /etc/xtables.conf")
[2] 7462e4aa757dc ("iptables-compat: Keep xtables-config and xtables-events out from tree")
[3] 3397fb3be98ff ("ebtables-compat: include /etc/ethertypes in tarball")
