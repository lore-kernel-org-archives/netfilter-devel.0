Return-Path: <SRS0=1dHg=66=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42CD7C433E0
	for <netfilter-devel@archiver.kernel.org>; Sat, 16 May 2020 20:17:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1A34A206F4
	for <netfilter-devel@archiver.kernel.org>; Sat, 16 May 2020 20:17:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726642AbgEPURm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 16 May 2020 16:17:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726414AbgEPURm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 16 May 2020 16:17:42 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31C52C061A0C
        for <netfilter-devel@vger.kernel.org>; Sat, 16 May 2020 13:17:42 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1ja3Fa-0007mn-KY; Sat, 16 May 2020 22:17:38 +0200
Date:   Sat, 16 May 2020 22:17:38 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Laura Garcia Liebana <nevola@gmail.com>
Cc:     netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        mattst88@gmail.com, devel@zevenet.com
Subject: Re: [PATCH nft] build: fix tentative generation of nft.8 after
 disabled doc
Message-ID: <20200516201738.GD31506@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Laura Garcia Liebana <nevola@gmail.com>,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        mattst88@gmail.com, devel@zevenet.com
References: <20200515163151.GA19398@nevthink>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200515163151.GA19398@nevthink>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Laura,

On Fri, May 15, 2020 at 06:31:51PM +0200, Laura Garcia Liebana wrote:
> Despite doc generation is disabled, the makefile is trying to build it.
> 
> $ ./configure --disable-man-doc
> $ make
> Making all in doc
> make[2]: Entering directory '/workdir/build-pkg/workdir/doc'
> make[2]: *** No rule to make target 'nft.8', needed by 'all-am'.  Stop.
> make[2]: Leaving directory '/workdir/build-pkg/workdir/doc'
> make[1]: *** [Makefile:479: all-recursive] Error 1
> make[1]: Leaving directory '/workdir/build-pkg/workdir'
> make: *** [Makefile:388: all] Error 2
> 
> Fixes: 4f2813a313ae0 ("build: Include generated man pages in dist tarball")
> 
> Reported-by: Adan Marin Jacquot <adan.marin@zevenet.com>
> Signed-off-by: Laura Garcia Liebana <nevola@gmail.com>
> ---
>  doc/Makefile.am | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/doc/Makefile.am b/doc/Makefile.am
> index 6bd90aa6..21482320 100644
> --- a/doc/Makefile.am
> +++ b/doc/Makefile.am
> @@ -1,3 +1,4 @@
> +if BUILD_MAN
>  man_MANS = nft.8 libnftables-json.5 libnftables.3

Did you make sure that dist tarball still contains the generated man
pages after your change? Because that's what commit 4f2813a313ae0
("build: Include generated man pages in dist tarball") tried to fix and
apparently broke what you're fixing for.

Cheers, Phil
