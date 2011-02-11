From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH] iptables: fix segfault target option parsing
Date: Fri, 11 Feb 2011 02:07:26 +0100
Message-ID: <1297386447-30546-2-git-send-email-jengelh@medozas.de>
References: <1297386447-30546-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:52922 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756940Ab1BKBHa (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 10 Feb 2011 20:07:30 -0500
In-Reply-To: <1297386447-30546-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

With v1.4.10-58-g94e247b, target option parsing started to happen in the
wrong case.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 ip6tables.c |    6 +++---
 iptables.c  |    6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/ip6tables.c b/ip6tables.c
index 5561a7d..9f0b892 100644
--- a/ip6tables.c
+++ b/ip6tables.c
@@ -1245,9 +1245,9 @@ static void command_default(struct iptables_command_state *cs)
 	struct xtables_rule_match *matchp;
 	struct xtables_match *m;
 
-	if (cs->target == NULL || cs->target->parse == NULL ||
-	    cs->c < cs->target->option_offset ||
-	    cs->c >= cs->target->option_offset + XT_OPTION_OFFSET_SCALE) {
+	if (cs->target != NULL && cs->target->parse != NULL &&
+	    cs->c >= cs->target->option_offset &&
+	    cs->c < cs->target->option_offset + XT_OPTION_OFFSET_SCALE) {
 		cs->target->parse(cs->c - cs->target->option_offset, cs->argv,
 				  cs->invert, &cs->target->tflags, &cs->fw6,
 				  &cs->target->t);
diff --git a/iptables.c b/iptables.c
index 33fd882..a73df3e 100644
--- a/iptables.c
+++ b/iptables.c
@@ -1269,9 +1269,9 @@ static void command_default(struct iptables_command_state *cs)
 	struct xtables_rule_match *matchp;
 	struct xtables_match *m;
 
-	if (cs->target == NULL || cs->target->parse == NULL ||
-	    cs->c < cs->target->option_offset ||
-	    cs->c >= cs->target->option_offset + XT_OPTION_OFFSET_SCALE) {
+	if (cs->target != NULL && cs->target->parse != NULL &&
+	    cs->c >= cs->target->option_offset &&
+	    cs->c < cs->target->option_offset + XT_OPTION_OFFSET_SCALE) {
 		cs->target->parse(cs->c - cs->target->option_offset, cs->argv,
 				  cs->invert, &cs->target->tflags, &cs->fw,
 				  &cs->target->t);
-- 
1.7.1

