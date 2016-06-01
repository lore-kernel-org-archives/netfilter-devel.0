From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft] Bump version to v0.6
Date: Wed,  1 Jun 2016 11:38:44 +0200
Message-ID: <1464773924-3641-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52912 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757490AbcFAJiw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 1 Jun 2016 05:38:52 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 08FE05B2CC2
	for <netfilter-devel@vger.kernel.org>; Wed,  1 Jun 2016 11:38:51 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id EF76A9EBB2
	for <netfilter-devel@vger.kernel.org>; Wed,  1 Jun 2016 11:38:50 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id AAAD59EBA3
	for <netfilter-devel@vger.kernel.org>; Wed,  1 Jun 2016 11:38:48 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 configure.ac | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/configure.ac b/configure.ac
index 0d7e6ed..0e7edcf 100644
--- a/configure.ac
+++ b/configure.ac
@@ -4,7 +4,7 @@
 AC_PREREQ(2.61)
 
 AC_COPYRIGHT([Copyright (c) 2008 Patrick McHardy <kaber@trash.net>])
-AC_INIT([nftables], [0.5], [netfilter-devel@vger.kernel.org])
+AC_INIT([nftables], [0.6], [netfilter-devel@vger.kernel.org])
 AC_DEFINE([RELEASE_NAME], ["Support Edward Snowden"], [Release name])
 
 AC_CONFIG_AUX_DIR([build-aux])
-- 
2.1.4

