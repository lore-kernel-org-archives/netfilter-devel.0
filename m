Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CF9AC433F5
	for <netfilter-devel@archiver.kernel.org>; Sun, 14 Nov 2021 14:15:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F111E603E5
	for <netfilter-devel@archiver.kernel.org>; Sun, 14 Nov 2021 14:15:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233961AbhKNORw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 14 Nov 2021 09:17:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236147AbhKNORm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 14 Nov 2021 09:17:42 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D933DC061746
        for <netfilter-devel@vger.kernel.org>; Sun, 14 Nov 2021 06:14:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ONepf3pISGvyVbAbbX5ppobFRD13w2Y1xOwvn42GVr4=; b=j95jf7exJvNR3P6Ozs9afMYYj3
        9D0ciguiACLiwTMYQn9z4fwLSDG1GFwMgM2GIlHBLvdi8Uj6lvJg53smTkMJj5DUaqfJKhjqMOTHh
        XgKj9xD+Ciw9/R2pPe5+eYX0e6HiSObZn59+hiXyOElBpVTpORl8zBHzMhwS3b7EjlQgqMLDLGmLo
        9Usk3koL+eC4FZehZpFKjXSZpg/jZb+/pRwvSf3zS2X44pVqilVbjwyJvb62sbfDnzde7O6uL6XGz
        xuQN0fu0GQDhmRYgZtZl1qORnjS33NCunXwz9oYHA0vav+/i8st+Jc79WF0ENYebgA1T033my6HXw
        xil4yyZw==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mmG4G-00Cdsh-Sr
        for netfilter-devel@vger.kernel.org; Sun, 14 Nov 2021 14:01:12 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH v3 13/16] build: remove commented-out code
Date:   Sun, 14 Nov 2021 14:00:55 +0000
Message-Id: <20211114140058.752394-14-jeremy@azazel.net>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211114140058.752394-1-jeremy@azazel.net>
References: <20211114140058.752394-1-jeremy@azazel.net>
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

