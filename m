Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF498C433FE
	for <netfilter-devel@archiver.kernel.org>; Thu,  6 Jan 2022 21:10:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244126AbiAFVKL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 6 Jan 2022 16:10:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244122AbiAFVKI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 6 Jan 2022 16:10:08 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71EAFC061212
        for <netfilter-devel@vger.kernel.org>; Thu,  6 Jan 2022 13:10:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Oh+SauqZIdYQJd24jqpAHlTODbnzlNJwcoFW8b0W1cc=; b=lnFos5tV+rWQJsDO99Bi1545gz
        PExA/inWuXIRFNJlUopfGrTQ9IfzzyTfCWn1kSXB3sV3axM7TS02nOkOc53dxCShL8IPqm3lH7xMa
        m+nv6I/WmsvhvYUJ0raBsXPc6YcPAuitj+EIvB7pQNaiK5jBBVq2MRV5VNOl1pI6RDanKa6xsCDcQ
        FNG9LYJmOemS3eM8f7z8UvTgqG9tnNL3SfUPth/LElXdpR29R76DbvKr8aXl3SwU1guXr4xHkIBRT
        i0j0UOqbOO+Xesi0auXYtPnOuhM+LXHRKFU38d2OheBUt4Zn2aHwUawDdEKIt9/x9XlfOU7SgU7/1
        ED2lIdGw==;
Received: from ulthar.dreamlands ([192.168.96.2] helo=ulthar.dreamlands.azazel.net)
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1n5a1O-00H0N6-Pr
        for netfilter-devel@vger.kernel.org; Thu, 06 Jan 2022 21:10:06 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH 09/10] build: if `--enable-pgsql` is `yes` abort if libpq is not found
Date:   Thu,  6 Jan 2022 21:09:36 +0000
Message-Id: <20220106210937.1676554-10-jeremy@azazel.net>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220106210937.1676554-1-jeremy@azazel.net>
References: <20220106210937.1676554-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 192.168.96.2
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

If PostgreSQL support has been explicitly requested, abort if it is not
available.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 configure.ac | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/configure.ac b/configure.ac
index 4d65d234be69..fd033164b872 100644
--- a/configure.ac
+++ b/configure.ac
@@ -104,6 +104,12 @@ AS_IF([test "x$enable_pgsql" != "xno"], [
       AC_MSG_RESULT([no])
     ])
 
+    AS_IF([test "x$libpq_LIBS" = "x"], [
+      AS_IF([test "x$enable_pgsql" = "xyes"], [
+        AC_MSG_ERROR([libpq not found])
+      ])
+    ])
+
   ])
 
 ])
-- 
2.34.1

