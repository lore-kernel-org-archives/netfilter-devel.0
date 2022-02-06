Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1364C433EF
	for <netfilter-devel@archiver.kernel.org>; Sun,  6 Feb 2022 09:47:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232672AbiBFJrZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 6 Feb 2022 04:47:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232006AbiBFJrY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 6 Feb 2022 04:47:24 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEC31C06173B
        for <netfilter-devel@vger.kernel.org>; Sun,  6 Feb 2022 01:47:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=cGYiJZMgnpIC6/CyK9eISUgUhxTSq5uxl9Wa4xZQMCI=; b=fSgPhrpOR/MLMIAMlbfzXkzMvW
        YF4JTXSZnB8iW+tP5i9lEyT1dhRIZG4mUYp2QZsLNTFgS1m2kRKHwCWuypiuH60uDABuhNTAtVpyx
        pn6kzWmd6A5NGsQyaEd8sdbvzJF16SjvnjqgVzGg14S7WE/nMM92mMrdPPviROkIpgUmsXacwxh3Y
        icsKrkX5Hnrqx3Juhz8nuvZ8saJx6XvDu1ISSsSIsy30n2CNIWQNC19otw5+E7FE+BKB0EXyrG8x7
        +2yq7iOozkq64PiSkCuMwEqmm3RiI9KIlk49AUO7x+eOKYbKi74IBkp4NXocbwg9SjIr4OBJ+9qL8
        LwDvjWaQ==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1nGe8b-00DGt2-GE
        for netfilter-devel@vger.kernel.org; Sun, 06 Feb 2022 09:47:17 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [libnetfilter_conntrack PATCH] build: update obsolete autoconf macros
Date:   Sun,  6 Feb 2022 09:47:02 +0000
Message-Id: <20220206094702.1513892-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

`AC_CONFIG_HEADER` has been superseded by `AC_CONFIG_HEADERS`.

`AM_PROG_LIBTOOL` has been superseded by `LT_INIT`.

`AC_DISABLE_STATIC` can be replaced by an argument to `LT_INIT`.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 configure.ac | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/configure.ac b/configure.ac
index 060f3076cbdc..98d64d485a16 100644
--- a/configure.ac
+++ b/configure.ac
@@ -3,7 +3,7 @@ dnl Process this file with autoconf to create configure.
 AC_INIT([libnetfilter_conntrack], [1.0.8])
 AC_CONFIG_AUX_DIR([build-aux])
 AC_CANONICAL_HOST
-AC_CONFIG_HEADER([config.h])
+AC_CONFIG_HEADERS([config.h])
 AC_CONFIG_MACRO_DIR([m4])
 
 AM_INIT_AUTOMAKE([-Wall foreign subdir-objects
@@ -14,8 +14,7 @@ dnl kernel style compile messages
 m4_ifdef([AM_SILENT_RULES], [AM_SILENT_RULES([yes])])
 
 AC_PROG_CC
-AC_DISABLE_STATIC
-AM_PROG_LIBTOOL
+LT_INIT([disable-static])
 AC_PROG_INSTALL
 AC_PROG_LN_S
 
-- 
2.34.1

