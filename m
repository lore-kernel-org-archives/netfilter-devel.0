Return-Path: <SRS0=LKNA=RU=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 760D5C4360F
	for <netfilter-devel@archiver.kernel.org>; Sun, 17 Mar 2019 17:49:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 565BF20857
	for <netfilter-devel@archiver.kernel.org>; Sun, 17 Mar 2019 17:49:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727276AbfCQRtf (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 17 Mar 2019 13:49:35 -0400
Received: from wp260.webpack.hosteurope.de ([80.237.133.29]:53126 "EHLO
        wp260.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725946AbfCQRte (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 17 Mar 2019 13:49:34 -0400
Received: from p200300cb2706710199469a6c02ec47e3.dip0.t-ipconnect.de ([2003:cb:2706:7101:9946:9a6c:2ec:47e3] helo=deneb.skynet.aixah.de); authenticated
        by wp260.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        id 1h5ZRQ-0001qr-S2; Sun, 17 Mar 2019 18:19:20 +0100
Received: by deneb.skynet.aixah.de (Postfix, from userid 1000)
        id ABFCDC2D07; Sun, 17 Mar 2019 18:19:19 +0100 (CET)
From:   Luis Ressel <aranea@aixah.de>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 1/2] configure.ac: Fix a2x check
Date:   Sun, 17 Mar 2019 18:19:11 +0100
Message-Id: <20190317171912.14194-1-aranea@aixah.de>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-bounce-key: webpack.hosteurope.de;aranea@aixah.de;1552844974;82868ec9;
X-HE-SMSGID: 1h5ZRQ-0001qr-S2
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

* If enable_man_doc is set, but a2x can't be found, configure should
  fail instead of silently disabling man page creation.

* The AS_IF block checking $need_a2x is never active (need_a2x has been
  removed from configure.ac in 13e44a608 and a277479dc).

* AC_CHECK_PROG(VAR, ...) is a noop if VAR is already set, allowing the
  user to explicitly specify the (path to the) binary in VAR. Adjust the
  AS_IF check to account for this.

Signed-off-by: Luis Ressel <aranea@aixah.de>
---
 configure.ac | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/configure.ac b/configure.ac
index 9bbd9d3..ccf8db0 100644
--- a/configure.ac
+++ b/configure.ac
@@ -48,12 +48,9 @@ fi
 AM_PROG_AR
 AM_PROG_LIBTOOL
 
-AC_CHECK_PROG(A2X, [a2x], [a2x])
-AM_CONDITIONAL([BUILD_MAN], [test -n "$A2X"])
-
-AS_IF([test "$need_a2x" = "yes"], [
-       AC_CHECK_PROG(A2X, [a2x], [found], [no])
-       AS_IF([test "$A2X" != "found"],
+AS_IF([test "x$enable_man_doc" = "xyes"], [
+       AC_CHECK_PROG(A2X, [a2x], [a2x], [no])
+       AS_IF([test "$A2X" = "no"],
 	     [AC_MSG_ERROR([a2x not found, please install asciidoc])])
 ])
 
-- 
2.21.0

