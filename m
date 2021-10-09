Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27053C4321E
	for <netfilter-devel@archiver.kernel.org>; Sat,  9 Oct 2021 11:42:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0AF4460E9B
	for <netfilter-devel@archiver.kernel.org>; Sat,  9 Oct 2021 11:42:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232865AbhJILo3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 9 Oct 2021 07:44:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232908AbhJILo0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 9 Oct 2021 07:44:26 -0400
Received: from kadath.azazel.net (kadath.azazel.net [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 720CBC061767
        for <netfilter-devel@vger.kernel.org>; Sat,  9 Oct 2021 04:42:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=zRfDeteTJeoNUe+EXf9y/AHrwnZImBH0v3K/qVu6XbI=; b=IGPqEEJrjlmMhfoInIu4SiVnIU
        xQKFvnhX38J5lK/xf7Cm/z0T1jeQYoo6uGnxd4/iMWKh/KBxfBKsJNXujYZ+9yvCuD+wJtRqyXslT
        XXfk1LZEaaoSMB5qSwv8ah623QZUfPSx17JSpr5LU4ygW1JDgyBdYbf7GnCL/e9wuayUeOjPshI3V
        b+RnNGMGB+EReprOS7x58/OeSDkywXAZF0ts3KyQaHhBGkO2fd3uK99PC9cpJ+VTGS/NYaZ2jePH8
        WKfreNUMxnmVAF2RBJh1lyBSsCwmGwD1FwTiFCfD7QtRQ1O0vvzzJ/wnX+W52v7STs4dPsUE8TELl
        TkWK6jSg==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mZAkF-00BfRm-Pw
        for netfilter-devel@vger.kernel.org; Sat, 09 Oct 2021 12:42:27 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [libnetfilter_log PATCH 7/9] build: replace `AM_PROG_LIBTOOL` and `AC_DISABLE_STATIC` with `LT_INIT`
Date:   Sat,  9 Oct 2021 12:38:37 +0100
Message-Id: <20211009113839.2765382-8-jeremy@azazel.net>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211009113839.2765382-1-jeremy@azazel.net>
References: <20211009113839.2765382-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

`AM_PROG_LIBTOOL` is superseded by `LT_INIT`, which also accepts options
to control the defaults for creating shared or static libraries.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 configure.ac | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/configure.ac b/configure.ac
index 1723426aa0c4..1dc9bc7847fa 100644
--- a/configure.ac
+++ b/configure.ac
@@ -14,8 +14,7 @@ m4_ifdef([AM_SILENT_RULES], [AM_SILENT_RULES([yes])])
 
 AC_PROG_CC
 AM_PROG_CC_C_O
-AC_DISABLE_STATIC
-AM_PROG_LIBTOOL
+LT_INIT([disable_static])
 AC_PROG_INSTALL
 AC_PROG_LN_S
 
-- 
2.33.0

