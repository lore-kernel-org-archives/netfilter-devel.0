From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 01/10] Resolve warnings on 64-bit compile
Date: Tue, 15 Apr 2008 12:33:19 +0200
Message-ID: <0e1521015bea15f495f191fa5534eb65ad9bd43f.1208255176.git.jengelh@computergmbh.de>
References: <1208255608-8044-1-git-send-email-jengelh@computergmbh.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:34593 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753935AbYDOKd3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Apr 2008 06:33:29 -0400
In-Reply-To: <1208255608-8044-1-git-send-email-jengelh@computergmbh.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

---
 xtables.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/xtables.c b/xtables.c
index 21da4b5..b988054 100644
--- a/xtables.c
+++ b/xtables.c
@@ -318,7 +318,7 @@ static void *load_extension(const char *search_path, const char *prefix,
 		if (next == NULL)
 			next = dir + strlen(dir);
 		snprintf(path, sizeof(path), "%.*s/libxt_%s.so",
-		         next - dir, dir, name);
+		         (unsigned int)(next - dir), dir, name);
 
 		if (dlopen(path, RTLD_NOW) != NULL) {
 			/* Found library.  If it didn't register itself,
@@ -335,7 +335,7 @@ static void *load_extension(const char *search_path, const char *prefix,
 			return ptr;
 
 		snprintf(path, sizeof(path), "%.*s/%s%s.so",
-		         next - dir, dir, prefix, name);
+		         (unsigned int)(next - dir), dir, prefix, name);
 		if (dlopen(path, RTLD_NOW) != NULL) {
 			if (is_target)
 				ptr = find_target(name, DONT_LOAD);
-- 
1.5.5.rc3

