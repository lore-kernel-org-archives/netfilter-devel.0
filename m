From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH libnftnl 3/3] src: no need to nul-terminate buffer for nftnl_fprintf() calls
Date: Wed,  4 Oct 2017 14:09:32 +0200
Message-ID: <1507118972-18478-3-git-send-email-pablo@netfilter.org>
References: <1507118972-18478-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:32772 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751910AbdJDMKB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 4 Oct 2017 08:10:01 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 1D4EE1C41D0
        for <netfilter-devel@vger.kernel.org>; Wed,  4 Oct 2017 14:10:00 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0DCFDDA87F
        for <netfilter-devel@vger.kernel.org>; Wed,  4 Oct 2017 14:10:00 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 71281DA8E9
        for <netfilter-devel@vger.kernel.org>; Wed,  4 Oct 2017 14:09:56 +0200 (CEST)
Received: from salvia.here (129.166.216.87.static.jazztel.es [87.216.166.129])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 33DB640584CD
        for <netfilter-devel@vger.kernel.org>; Wed,  4 Oct 2017 14:09:55 +0200 (CEST)
In-Reply-To: <1507118972-18478-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This function bails out with -1 if we cannot print, and this buffer is
internally allocated. No need for this overly deffensive initialization.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/chain.c    | 3 ---
 src/gen.c      | 3 ---
 src/object.c   | 3 ---
 src/rule.c     | 3 ---
 src/set.c      | 3 ---
 src/set_elem.c | 3 ---
 src/table.c    | 3 ---
 7 files changed, 21 deletions(-)

diff --git a/src/chain.c b/src/chain.c
index 6df871df4131..5e30a8016cac 100644
--- a/src/chain.c
+++ b/src/chain.c
@@ -867,9 +867,6 @@ EXPORT_SYMBOL(nftnl_chain_snprintf);
 static int nftnl_chain_do_snprintf(char *buf, size_t size, const void *c,
 				   uint32_t cmd, uint32_t type, uint32_t flags)
 {
-	if (size)
-		buf[0] = '\0';
-
 	return nftnl_chain_snprintf(buf, size, c, type, flags);
 }
 
diff --git a/src/gen.c b/src/gen.c
index a03648bba1c2..e42dd4055cb4 100644
--- a/src/gen.c
+++ b/src/gen.c
@@ -203,9 +203,6 @@ EXPORT_SYMBOL(nftnl_gen_snprintf);
 static int nftnl_gen_do_snprintf(char *buf, size_t size, const void *gen,
 				 uint32_t cmd, uint32_t type, uint32_t flags)
 {
-	if (size)
-		buf = '\0';
-
 	return nftnl_gen_snprintf(buf, size, gen, type, flags);
 }
 
diff --git a/src/object.c b/src/object.c
index 8dc83b36c32e..f907dd22d13a 100644
--- a/src/object.c
+++ b/src/object.c
@@ -488,9 +488,6 @@ EXPORT_SYMBOL(nftnl_obj_snprintf);
 static int nftnl_obj_do_snprintf(char *buf, size_t size, const void *obj,
 				 uint32_t cmd, uint32_t type, uint32_t flags)
 {
-	if (size)
-		buf[0] = '\0';
-
 	return nftnl_obj_snprintf(buf, size, obj, type, flags);
 }
 
diff --git a/src/rule.c b/src/rule.c
index f37806c0e07b..7cbd15bbd93c 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -836,9 +836,6 @@ EXPORT_SYMBOL(nftnl_rule_snprintf);
 static int nftnl_rule_do_snprintf(char *buf, size_t size, const void *r,
 				  uint32_t cmd, uint32_t type, uint32_t flags)
 {
-	if (size)
-		buf[0] = '\0';
-
 	return nftnl_rule_snprintf(buf, size, r, type, flags);
 }
 
diff --git a/src/set.c b/src/set.c
index a4e41d2a3547..36e59c38536c 100644
--- a/src/set.c
+++ b/src/set.c
@@ -939,9 +939,6 @@ EXPORT_SYMBOL(nftnl_set_snprintf);
 static int nftnl_set_do_snprintf(char *buf, size_t size, const void *s,
 				 uint32_t cmd, uint32_t type, uint32_t flags)
 {
-	if (size)
-		buf[0] = '\0';
-
 	return nftnl_set_snprintf(buf, size, s, type, flags);
 }
 
diff --git a/src/set_elem.c b/src/set_elem.c
index a8f88a4f1813..a99876a90cac 100644
--- a/src/set_elem.c
+++ b/src/set_elem.c
@@ -738,9 +738,6 @@ static int nftnl_set_elem_do_snprintf(char *buf, size_t size, const void *e,
 				      uint32_t cmd, uint32_t type,
 				      uint32_t flags)
 {
-	if (size)
-		buf[0] = '\0';
-
 	return nftnl_set_elem_snprintf(buf, size, e, type, flags);
 }
 
diff --git a/src/table.c b/src/table.c
index 4d8176c9be78..db870cd98437 100644
--- a/src/table.c
+++ b/src/table.c
@@ -417,9 +417,6 @@ EXPORT_SYMBOL(nftnl_table_snprintf);
 static int nftnl_table_do_snprintf(char *buf, size_t size, const void *t,
 				   uint32_t cmd, uint32_t type, uint32_t flags)
 {
-	if (size)
-		buf[0] = '\0';
-
 	return nftnl_table_snprintf(buf, size, t, type, flags);
 }
 
-- 
2.1.4

