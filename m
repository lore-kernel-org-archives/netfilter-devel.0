Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6076FC4338F
	for <netfilter-devel@archiver.kernel.org>; Sun, 22 Aug 2021 03:33:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 37BF5600D3
	for <netfilter-devel@archiver.kernel.org>; Sun, 22 Aug 2021 03:33:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232241AbhHVDdt (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 21 Aug 2021 23:33:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232345AbhHVDds (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 21 Aug 2021 23:33:48 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A83E2C061575
        for <netfilter-devel@vger.kernel.org>; Sat, 21 Aug 2021 20:33:08 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id t13so12269738pfl.6
        for <netfilter-devel@vger.kernel.org>; Sat, 21 Aug 2021 20:33:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:date:to:cc:subject:message-id:mail-followup-to
         :references:mime-version:content-disposition:in-reply-to;
        bh=/INWg4NPjw61nc+SMTSrRnkllAjJP707XyF8WzaE6L8=;
        b=J9oETTGc29PanVos9zQKB5q/dHAu7CITzU5nJSKS0tqfIjLFagvxg5ac/8BwJz89Ng
         Ax6Fv0sKwQDt5N8tYpsO2mJDO7xX8I2tuDkdNnmexAZkMwXzvguk7RFOPelb/jrT47GP
         O9rg+VdwvEqq5ZCG+v4uofxnaKz5g07q293rptW/XNx3CsK8MQmqmKeFqNuMCh7QfF4O
         G9/QtQPPraOLq1e9gd8CF5hsRvGrh59dl5ZRoJaUKS10HGtoUvVBbawOm+efAY3ZFfm+
         aTQKY2e/NRJSzUYR8NLfUIvxy8p7qMBDrtiC7USJSzVngZoaOXMKqpT8+4oCe3uDM2DN
         ZAfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=/INWg4NPjw61nc+SMTSrRnkllAjJP707XyF8WzaE6L8=;
        b=ikcR2gjGfTuAJ+FSxDE+j0fOimL9mGpiBWZ8Zan2GYdrBp9PkM50vaMLVo9UNivgIM
         Kbn0wkTWkP6ShiovzNuqRVn7t16cozuGrxaexfq3gZsjVq1loI+DM+LuX0NEaIVWudYN
         sP7AJeRxdSqnhlXUgcjyTkiAdztVyp0CTxnGi25mjel9S/9NpzhVoePWu4Mpi7HJRATr
         Cd+2NIY23e57A0W8bE9mLGd5uqWBgOMvXeSBIHPkgjUBMvKYQkWuFGgqyg622oHBFEFY
         fYYPwMe0JgA8Y/GpdXBxBDxK0rtET9BUlE8q60aTwjYi53MJNh+OaFm2/RAFQrdK9L0r
         axCQ==
X-Gm-Message-State: AOAM530QvjrGZjHD3fLFMQokgEdZCE9ipbdYaDKm8d7UTGyR2RDrS847
        tpcgoTRnQwf1sPAe7dt9wEU=
X-Google-Smtp-Source: ABdhPJzlwx7qealuaZH2H6NtQWOqldh7Pql2z4gpy+T5dmEqxc6sYjwmH9UK200P8YR7LLWencWJ9w==
X-Received: by 2002:aa7:9dce:0:b0:3e1:3c5d:640d with SMTP id g14-20020aa79dce000000b003e13c5d640dmr26977783pfq.25.1629603188231;
        Sat, 21 Aug 2021 20:33:08 -0700 (PDT)
Received: from slk1.local.net (n49-192-82-34.sun3.vic.optusnet.com.au. [49.192.82.34])
        by smtp.gmail.com with ESMTPSA id b20sm15217990pji.24.2021.08.21.20.33.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Aug 2021 20:33:07 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@slk1.local.net>
Date:   Sun, 22 Aug 2021 13:33:02 +1000
To:     Jeremy Sowden <jeremy@azazel.net>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libnetfilter_queue v3 1/3] build: doc: Fix NAME entry in
 man pages
Message-ID: <YSHFbmTDw1wb4Wvq@slk1.local.net>
Mail-Followup-To: Jeremy Sowden <jeremy@azazel.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
References: <20210821053805.6371-1-duncan_roe@optusnet.com.au>
 <YSDNkNFOfdyOKXh2@azazel.net>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="/PRKUY4fzH4+ZqeQ"
Content-Disposition: inline
In-Reply-To: <YSDNkNFOfdyOKXh2@azazel.net>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--/PRKUY4fzH4+ZqeQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Jeremy,

On Sat, Aug 21, 2021 at 10:55:28AM +0100, Jeremy Sowden wrote:
> On 2021-08-21, at 15:38:03 +1000, Duncan Roe wrote:
> > Add a post_process() function to the big shell script inside doxygen/Makefile.am
[...]
>
> Would it not make life easier to move all this shell-script into a
> build_man.sh and just call that from the make-file?  Patch attached.
>
> J.

Of course it would, and that's how it was at library release 1.0.5, but `make
distcheck` would not pass, as it doesn't pass with your patch as supplied.

Your patch inspired me to try one last time and, thanks to hours of grovelling
through `info autoconf`, `make distcheck` passes with the 1-line patch below.

Remarkably, the resulting tarball includes doxygen/build_man.sh even though
there is no EXTRA_DIST entry for it in Makefile.am.

VPATH builds still work (e.g. mkdir build; cd build; ../configure; make) and
`make distcleancheck` still passes afterward.

So, I'll push out another patch rev shortly. Thanks!

Cheers ... Duncan.

--/PRKUY4fzH4+ZqeQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-Replace-.-build_man.sh-with-abs_top_srcdir-doxygen-b.patch"

From a1795e7f1baff2d477d0a0a7e3058343baf3d85e Mon Sep 17 00:00:00 2001
From: Duncan Roe <duncan_roe@optusnet.com.au>
Date: Sun, 22 Aug 2021 11:19:22 +1000
Subject: [PATCH libnetfilter_queue] Replace ./build_man.sh with
 $(abs_top_srcdir)/doxygen/build_man.sh

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 doxygen/Makefile.am | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/doxygen/Makefile.am b/doxygen/Makefile.am
index 52dca07..aa19c5a 100644
--- a/doxygen/Makefile.am
+++ b/doxygen/Makefile.am
@@ -25,7 +25,7 @@ doxyfile.stamp: $(doc_srcs) Makefile.am
 # but not blank lines
 
 if BUILD_MAN
-	./build_man.sh
+	$(abs_top_srcdir)/doxygen/build_man.sh
 endif
 
 	touch doxyfile.stamp
-- 
2.17.5


--/PRKUY4fzH4+ZqeQ--
