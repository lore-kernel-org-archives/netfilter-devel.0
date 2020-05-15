Return-Path: <SRS0=dCSv=65=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC66FC433DF
	for <netfilter-devel@archiver.kernel.org>; Fri, 15 May 2020 16:31:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 869E32076A
	for <netfilter-devel@archiver.kernel.org>; Fri, 15 May 2020 16:31:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="uG9nI+Wu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726278AbgEOQb6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 15 May 2020 12:31:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726227AbgEOQb5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 15 May 2020 12:31:57 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF5A2C061A0C
        for <netfilter-devel@vger.kernel.org>; Fri, 15 May 2020 09:31:56 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id w7so4200035wre.13
        for <netfilter-devel@vger.kernel.org>; Fri, 15 May 2020 09:31:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=cct1G452LRiaI8QdPbLk4hmOE/uauLEm/jpXUcZS3hU=;
        b=uG9nI+WusN/w5UTZafkluw6WhpNZE3/1jtRl+hiwdFpFCCI4qXLPd1V0vUgUCvUBH4
         ly1Xst4DtvG5ziVlNFp4zsRt67wA4b1038Q5tVbw66mnbPh5wPibETdFkqeRxhqpBIGA
         vV7jhjgl9necw7mr+bKm7sdS5uV9j3TRipGmwjC179IFf49Pt6vGUHmYkGiNSWpZ58wB
         BxUND9G/BlixvIuGuw9mceys5IStuyu0Oe1PKZJsb9CEW+2XTak+eHUG2Ln54e211ko9
         tc5YzXVWlBKQCM1O16tTJcCERlW8lqeq7FOSsaNiFtDTujwVkBawSICRv9Yle8kn4Rsx
         MqPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=cct1G452LRiaI8QdPbLk4hmOE/uauLEm/jpXUcZS3hU=;
        b=tZ+1UHp6NKW2OPfVQTbgQCkbYWAZEH9M+bC4Hatwmz4mvqX6h2S5EMTXhQEKgiDV54
         US1bYOtJX7heRfWLF1hlwPrRaVKhDx4UQJnyhJOvx54p37gd6TYLO4+DO1iLjGT5BjBv
         CCiWzi8kdGqqU2yFDTAPysSVksK9jbXTnPWaidviiTxWz/+8WVVGvL/0/nGqx8qTvF20
         u6G5OAl5veFKgpQJHFv5HW/eI7vlLmdXtanSwzeNLHNbD/pFecGCfjwXC41Iufwz/Ahu
         kA1Rb82XhRYadF2LXa6cwUwU8G9Hx9Y2TXqyw79FW+rVra7Hepg2c32wsmtg9MgB71MO
         E7Ww==
X-Gm-Message-State: AOAM533nC7h5ggEcKDFQnIgzf7zyDxraSdhDGP02cj3l5rh77tX7srZc
        AXmseizFIr0jaUysI+TzkcnxEDjb5ns=
X-Google-Smtp-Source: ABdhPJykYPHFI+bOAoJBge6CP3XnCeJgA8m0PPna9ShR+iyMucYiOXMt13VJ5lOhCU5mu/TNZWJz4w==
X-Received: by 2002:a5d:46c6:: with SMTP id g6mr5245496wrs.139.1589560315153;
        Fri, 15 May 2020 09:31:55 -0700 (PDT)
Received: from nevthink ([91.126.71.247])
        by smtp.gmail.com with ESMTPSA id c193sm4182600wme.37.2020.05.15.09.31.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2020 09:31:54 -0700 (PDT)
Date:   Fri, 15 May 2020 18:31:51 +0200
From:   Laura Garcia Liebana <nevola@gmail.com>
To:     netfilter-devel@vger.kernel.org
Cc:     pablo@netfilter.org, mattst88@gmail.com, devel@zevenet.com
Subject: [PATCH nft] build: fix tentative generation of nft.8 after disabled
 doc
Message-ID: <20200515163151.GA19398@nevthink>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Despite doc generation is disabled, the makefile is trying to build it.

$ ./configure --disable-man-doc
$ make
Making all in doc
make[2]: Entering directory '/workdir/build-pkg/workdir/doc'
make[2]: *** No rule to make target 'nft.8', needed by 'all-am'.  Stop.
make[2]: Leaving directory '/workdir/build-pkg/workdir/doc'
make[1]: *** [Makefile:479: all-recursive] Error 1
make[1]: Leaving directory '/workdir/build-pkg/workdir'
make: *** [Makefile:388: all] Error 2

Fixes: 4f2813a313ae0 ("build: Include generated man pages in dist tarball")

Reported-by: Adan Marin Jacquot <adan.marin@zevenet.com>
Signed-off-by: Laura Garcia Liebana <nevola@gmail.com>
---
 doc/Makefile.am | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/doc/Makefile.am b/doc/Makefile.am
index 6bd90aa6..21482320 100644
--- a/doc/Makefile.am
+++ b/doc/Makefile.am
@@ -1,3 +1,4 @@
+if BUILD_MAN
 man_MANS = nft.8 libnftables-json.5 libnftables.3
 
 A2X_OPTS_MANPAGE = -L --doctype manpage --format manpage -D ${builddir}
@@ -16,7 +17,6 @@ EXTRA_DIST = ${ASCIIDOCS} ${man_MANS} libnftables-json.adoc libnftables.adoc
 CLEANFILES = \
 	*~
 
-if BUILD_MAN
 nft.8: ${ASCIIDOCS}
 	${AM_V_GEN}${A2X} ${A2X_OPTS_MANPAGE} $<
 
-- 
2.20.1

