From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH 5/5] libxtables: constify xtables_option_[mt]fcall argument
Date: Tue,  5 Mar 2013 02:08:15 +0100
Message-ID: <1362445695-15952-6-git-send-email-jengelh@inai.de>
References: <1362445695-15952-1-git-send-email-jengelh@inai.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:45720 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932354Ab3CEBIS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 4 Mar 2013 20:08:18 -0500
In-Reply-To: <1362445695-15952-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Nothing modifies the match/target, so we can mark it const.

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 include/xtables.h      |    4 ++--
 libxtables/xtoptions.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/xtables.h b/include/xtables.h
index c35a6e6..f14914c 100644
--- a/include/xtables.h
+++ b/include/xtables.h
@@ -535,8 +535,8 @@ extern void xtables_option_tpcall(unsigned int, char **, bool,
 				  struct xtables_target *, void *);
 extern void xtables_option_mpcall(unsigned int, char **, bool,
 				  struct xtables_match *, void *);
-extern void xtables_option_tfcall(struct xtables_target *);
-extern void xtables_option_mfcall(struct xtables_match *);
+extern void xtables_option_tfcall(const struct xtables_target *);
+extern void xtables_option_mfcall(const struct xtables_match *);
 extern void xtables_options_fcheck(const char *, unsigned int,
 				   const struct xt_option_entry *);
 
diff --git a/libxtables/xtoptions.c b/libxtables/xtoptions.c
index 452e0fe..01c626c 100644
--- a/libxtables/xtoptions.c
+++ b/libxtables/xtoptions.c
@@ -1034,7 +1034,7 @@ void xtables_options_fcheck(const char *name, unsigned int xflags,
  * Dispatch arguments to the appropriate final_check function, based upon the
  * extension's choice of API.
  */
-void xtables_option_tfcall(struct xtables_target *t)
+void xtables_option_tfcall(const struct xtables_target *t)
 {
 	if (t->x6_fcheck != NULL) {
 		struct xt_fcheck_call cb;
@@ -1055,7 +1055,7 @@ void xtables_option_tfcall(struct xtables_target *t)
  * Dispatch arguments to the appropriate final_check function, based upon the
  * extension's choice of API.
  */
-void xtables_option_mfcall(struct xtables_match *m)
+void xtables_option_mfcall(const struct xtables_match *m)
 {
 	if (m->x6_fcheck != NULL) {
 		struct xt_fcheck_call cb;
-- 
1.7.10.4

