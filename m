From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 02/10] Wrap dlopen code into NO_SHARED_LIBS
Date: Tue, 15 Apr 2008 12:33:20 +0200
Message-ID: <2727dbd1c9b79050133aa0a17fff819369c4f5ad.1208255176.git.jengelh@computergmbh.de>
References: <1208255608-8044-1-git-send-email-jengelh@computergmbh.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:34595 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753478AbYDOKd3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Apr 2008 06:33:29 -0400
In-Reply-To: <1208255608-8044-1-git-send-email-jengelh@computergmbh.de>
In-Reply-To: <0e1521015bea15f495f191fa5534eb65ad9bd43f.1208255176.git.jengelh@computergmbh.de>
References: <0e1521015bea15f495f191fa5534eb65ad9bd43f.1208255176.git.jengelh@computergmbh.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

---
 xtables.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/xtables.c b/xtables.c
index b988054..743c07b 100644
--- a/xtables.c
+++ b/xtables.c
@@ -305,6 +305,7 @@ void parse_interface(const char *arg, char *vianame, unsigned char *mask)
 	}
 }
 
+#ifndef NO_SHARED_LIBS
 static void *load_extension(const char *search_path, const char *prefix,
     const char *name, bool is_target)
 {
@@ -353,6 +354,7 @@ static void *load_extension(const char *search_path, const char *prefix,
 
 	return NULL;
 }
+#endif
 
 struct xtables_match *find_match(const char *name, enum xt_tryload tryload,
 				 struct xtables_rule_match **matches)
-- 
1.5.5.rc3

