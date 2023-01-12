Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC866C61DB3
	for <netfilter-devel@archiver.kernel.org>; Thu, 12 Jan 2023 22:55:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240437AbjALWzg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 12 Jan 2023 17:55:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240344AbjALWzf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 12 Jan 2023 17:55:35 -0500
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46910F73
        for <netfilter-devel@vger.kernel.org>; Thu, 12 Jan 2023 14:55:31 -0800 (PST)
Received: by a3.inai.de (Postfix, from userid 65534)
        id AE22C587AFE95; Thu, 12 Jan 2023 23:55:28 +0100 (CET)
Received: from a4.inai.de (a4.inai.de [IPv6:2a01:4f8:10b:45d8::f8])
        by a3.inai.de (Postfix) with ESMTP id 12134587AFE94;
        Thu, 12 Jan 2023 23:55:21 +0100 (CET)
From:   Jan Engelhardt <jengelh@inai.de>
To:     phil@nwl.cc
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH] build: put xtables.conf in EXTRA_DIST
Date:   Thu, 12 Jan 2023 23:55:17 +0100
Message-Id: <20230112225517.31560-1-jengelh@inai.de>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

To make distcheck succeed, disting it is enough; it does not need
to be installed.

Fixes: v1.8.8-150-g3822a992
Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 Makefile.am | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Makefile.am b/Makefile.am
index 451c3cb2..10198753 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -16,11 +16,11 @@ SUBDIRS         += extensions
 # Depends on extensions/libext.a:
 SUBDIRS         += iptables
 
-EXTRA_DIST	= autogen.sh iptables-test.py xlate-test.py
+EXTRA_DIST	= autogen.sh iptables-test.py xlate-test.py etc/xtables.conf
 
 if ENABLE_NFTABLES
 confdir		= $(sysconfdir)
-dist_conf_DATA	= etc/ethertypes etc/xtables.conf
+dist_conf_DATA	= etc/ethertypes
 endif
 
 .PHONY: tarball
-- 
2.39.0

