Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FAFBC433FE
	for <netfilter-devel@archiver.kernel.org>; Sun, 14 Nov 2021 16:14:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7558360FD7
	for <netfilter-devel@archiver.kernel.org>; Sun, 14 Nov 2021 16:14:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234572AbhKNQRt (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 14 Nov 2021 11:17:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233539AbhKNQRq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 14 Nov 2021 11:17:46 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5A7AC061766
        for <netfilter-devel@vger.kernel.org>; Sun, 14 Nov 2021 08:14:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ONepf3pISGvyVbAbbX5ppobFRD13w2Y1xOwvn42GVr4=; b=srY1Y/bAtfPdRcj0Gz0CTlTgOD
        ZPQlsbpUMUixUQCmuL1ffMfVV5x4jKKK9ofINOUUNBgYEmpZCp1OfYRoK8psQdexA/JkDPsZpuFDw
        Wf0+lG+nGGSlSK4z3emEovYZUcHgZ4jEbYbprauM4VUZ3S3xyzcGQsU6yydCXHXgHkd3+bHaZeaz4
        nv6/fJCGMSgvjyudsXGIq0zm/QvAZw0GqxGvNW9waiGoXX0DLCjPV5m2RwSS/qONGGhoTZHS4xvBS
        IUSFKCkF/Aq6gtkXU+MHjo6nZ0PdgQt/4yQCszHP9kaplFf+BTS9rFeuxCjRxoeWF5JPjWWLziXvZ
        qusNtSbQ==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mmHo9-00CfJ1-Oj
        for netfilter-devel@vger.kernel.org; Sun, 14 Nov 2021 15:52:41 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH v4 13/15] build: remove commented-out code
Date:   Sun, 14 Nov 2021 15:52:29 +0000
Message-Id: <20211114155231.793594-14-jeremy@azazel.net>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211114155231.793594-1-jeremy@azazel.net>
References: <20211114155231.793594-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

There are a couple of blocks of macros in configure.ac which were
commented out in 2006.  Remove them.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 configure.ac | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/configure.ac b/configure.ac
index b88c7a6d7708..268cd10de2da 100644
--- a/configure.ac
+++ b/configure.ac
@@ -155,18 +155,6 @@ AC_ARG_WITH([ulogd2libdir],
         [ulogd2libdir="${libdir}/ulogd"])
 AC_SUBST([ulogd2libdir])
 
-dnl AC_SUBST(DATABASE_DIR)
-dnl AC_SUBST(DATABASE_LIB)
-dnl AC_SUBST(DATABASE_LIB_DIR)
-dnl AC_SUBST(DB_DEF)
-dnl AC_SUBST(EXTRA_MYSQL_DEF)
-dnl AC_SUBST(EXTRA_PGSQL_DEF)
-
-dnl AC_SUBST(DATABASE_DRIVERS)
-
-dnl AM_CONDITIONAL(HAVE_MYSQL, test x$mysqldir != x)
-dnl AM_CONDITIONAL(HAVE_PGSQL, test x$pgsqldir != x)
-
 AC_CONFIG_FILES(include/Makefile include/ulogd/Makefile include/libipulog/Makefile \
 	  include/linux/Makefile include/linux/netfilter/Makefile \
 	  include/linux/netfilter_ipv4/Makefile libipulog/Makefile \
-- 
2.33.0

