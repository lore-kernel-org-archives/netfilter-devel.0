Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9975DC433EF
	for <netfilter-devel@archiver.kernel.org>; Tue, 22 Feb 2022 07:41:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229931AbiBVHmD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 22 Feb 2022 02:42:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229889AbiBVHmD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 22 Feb 2022 02:42:03 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F1548D5F6B
        for <netfilter-devel@vger.kernel.org>; Mon, 21 Feb 2022 23:35:00 -0800 (PST)
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 5BCBC64384;
        Tue, 22 Feb 2022 08:34:01 +0100 (CET)
Date:   Tue, 22 Feb 2022 08:34:57 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] build: add missing AM_CPPFLAGS to examples/
Message-ID: <YhSSIanp3mA+F8R9@salvia>
References: <20220222044643.25214-1-jengelh@inai.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220222044643.25214-1-jengelh@inai.de>
User-Agent: Alpine 2.23 (DEB 453 2020-06-18)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Feb 22, 2022 at 05:46:43AM +0100, Jan Engelhardt wrote:
> examples$ make V=1
> depbase=`echo nft-buffer.o | sed 's|[^/]*$|.deps/&|;s|\.o$||'`;\
> gcc -DHAVE_CONFIG_H -I. -I..     -g -O2 -MT nft-buffer.o -MD -MP -MF $depbase.Tpo -c -o nft-buffer.o nft-buffer.c &&\
> mv -f $depbase.Tpo $depbase.Po
> nft-buffer.c:3:10: fatal error: nftables/libnftables.h: No such file or directory

Right. I also moved the compilation of these example out of the
standard build path.

https://patchwork.ozlabs.org/project/netfilter-devel/patch/20220222000049.303303-1-pablo@netfilter.org/

> Signed-off-by: Jan Engelhardt <jengelh@inai.de>
> ---
>  nftables 1.0.2 would not build successfully by default.
> 
>  examples/Makefile.am | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/examples/Makefile.am b/examples/Makefile.am
> index c972170d..d7234ce4 100644
> --- a/examples/Makefile.am
> +++ b/examples/Makefile.am
> @@ -1,3 +1,4 @@
> +AM_CPPFLAGS = -I$(top_srcdir)/include
>  noinst_PROGRAMS	= nft-buffer		\
>  		  nft-json-file
>  
> -- 
> 2.35.1
> 
