Return-Path: <SRS0=wFQz=7G=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9FD3C433E0
	for <netfilter-devel@archiver.kernel.org>; Sun, 24 May 2020 13:00:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB91220776
	for <netfilter-devel@archiver.kernel.org>; Sun, 24 May 2020 13:00:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IRcitDuB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387416AbgEXNAJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 24 May 2020 09:00:09 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:39876 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725873AbgEXNAJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 24 May 2020 09:00:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590325207;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=mu7qzasRYqHLzllbvcZIbW5L4x8O2Zzv16NJf3e045s=;
        b=IRcitDuBjNFDcNDEK/t/z6p1tixU1ch4guZk6tqqGYWdEL8pywjKphuuMJJKpG9LPIgEKB
        l/bj0CiCPaBAwHySrKo9yoRLYML5Ht1SmRRI+fheO2O1KiHcJXEDLvzj1ZaKD6E3LgGqaH
        4yHUca2o/cjIMfrFITs17gFQ36KPgJ0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-265-9r8kDHAFMe69jGtsMOA8jQ-1; Sun, 24 May 2020 08:59:52 -0400
X-MC-Unique: 9r8kDHAFMe69jGtsMOA8jQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3475980183C;
        Sun, 24 May 2020 12:59:51 +0000 (UTC)
Received: from epycfail.redhat.com (unknown [10.36.110.3])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2382760BF3;
        Sun, 24 May 2020 12:59:49 +0000 (UTC)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Matt Turner <mattst88@gmail.com>, netfilter-devel@vger.kernel.org
Subject: [PATCH nft] build: Fix doc build, restore A2X assignment for doc/Makefile
Date:   Sun, 24 May 2020 14:59:36 +0200
Message-Id: <8ef909eedea05cdd3072bea59d664e3a52e28dcd.1590320436.git.sbrivio@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Commit 4f2813a313ae ("build: Include generated man pages in dist
tarball") skips AC_CHECK_PROG for A2X altogether if doc/nft.8 is
already present.

Now, starting from a clean situation, we can have this sequence:
  ./configure	# doc/nft.8 not there, A2X set in doc/Makefile
  make		# builds doc/nft.8
  ./configure	# doc/nft.8 is there, A2X left empty in doc/Makefile
  make clean	# removes doc/nft.8
  make

resulting in:

  [...]
    GEN      nft.8
  /bin/sh: -L: command not found
  make[2]: *** [Makefile:639: nft.8] Error 127

and the only way to get out of this is to issue ./configure again
after make clean, which is rather unexpected.

Instead of skipping AC_CHECK_PROG when doc/nft.8 is present, keep
it and simply avoid returning failure if a2x(1) is not available but
doc/nft.8 was built, so that A2X is properly set in doc/Makefile
whenever needed.

Fixes: 4f2813a313ae ("build: Include generated man pages in dist tarball")
Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
---
 configure.ac | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/configure.ac b/configure.ac
index 3496e410dbbe..5a1f89a0104c 100644
--- a/configure.ac
+++ b/configure.ac
@@ -50,9 +50,9 @@ AC_EXEEXT
 AC_DISABLE_STATIC
 CHECK_GCC_FVISIBILITY
 
-AS_IF([test "x$enable_man_doc" = "xyes" -a ! -f "${srcdir}/doc/nft.8"], [
+AS_IF([test "x$enable_man_doc" = "xyes"], [
        AC_CHECK_PROG(A2X, [a2x], [a2x], [no])
-       AS_IF([test "$A2X" = "no"],
+       AS_IF([test "$A2X" = "no" -a ! -f "${srcdir}/doc/nft.8"],
 	     [AC_MSG_ERROR([a2x not found, please install asciidoc])])
 ])
 
-- 
2.26.2

