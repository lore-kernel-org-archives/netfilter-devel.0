From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 05/10] libxtables: provide better final_check
Date: Wed,  6 Apr 2011 13:31:12 +0200
Message-ID: <1302089478-15022-6-git-send-email-jengelh@medozas.de>
References: <1302089478-15022-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:46493 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755674Ab1DFLb0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 6 Apr 2011 07:31:26 -0400
In-Reply-To: <1302089478-15022-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This passes the per-extension data block to the new x6_fcheck function
pointer, which can then do last alterations without using hacks
like global variables (think libxt_statistic).

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/xtables.h.in |   15 +++++++++++++++
 ip6tables.c          |   18 ++++--------------
 iptables.c           |   18 ++++--------------
 xtoptions.c          |   40 ++++++++++++++++++++++++++++++++++++++++
 4 files changed, 63 insertions(+), 28 deletions(-)

diff --git a/include/xtables.h.in b/include/xtables.h.in
index 928f465..c281fed 100644
--- a/include/xtables.h.in
+++ b/include/xtables.h.in
@@ -103,6 +103,17 @@ struct xt_option_call {
 	} val;
 };
 
+/**
+ * @ext_name:	name of extension currently being processed
+ * @data:	per-extension data block
+ * @xflags:	options of the extension that have been used
+ */
+struct xt_fcheck_call {
+	const char *ext_name;
+	void *data;
+	unsigned int xflags;
+};
+
 /* Include file for additions: new matches and targets. */
 struct xtables_match
 {
@@ -157,6 +168,7 @@ struct xtables_match
 
 	/* New parser */
 	void (*x6_parse)(struct xt_option_call *);
+	void (*x6_fcheck)(struct xt_fcheck_call *);
 	const struct xt_option_entry *x6_options;
 
 	/* Ignore these men behind the curtain: */
@@ -220,6 +232,7 @@ struct xtables_target
 
 	/* New parser */
 	void (*x6_parse)(struct xt_option_call *);
+	void (*x6_fcheck)(struct xt_fcheck_call *);
 	const struct xt_option_entry *x6_options;
 
 	/* Ignore these men behind the curtain: */
@@ -380,6 +393,8 @@ extern void xtables_option_tpcall(unsigned int, char **, bool,
 				  struct xtables_target *, void *);
 extern void xtables_option_mpcall(unsigned int, char **, bool,
 				  struct xtables_match *, void *);
+extern void xtables_option_tfcall(struct xtables_target *);
+extern void xtables_option_mfcall(struct xtables_match *);
 extern void xtables_options_fcheck(const char *, unsigned int,
 				   const struct xt_option_entry *);
 
diff --git a/ip6tables.c b/ip6tables.c
index 83d2fae..3beeddf 100644
--- a/ip6tables.c
+++ b/ip6tables.c
@@ -1782,20 +1782,10 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 		cs.invert = FALSE;
 	}
 
-	for (matchp = cs.matches; matchp; matchp = matchp->next) {
-		if (matchp->match->x6_options != NULL)
-			xtables_options_fcheck(matchp->match->name,
-					       matchp->match->mflags,
-					       matchp->match->x6_options);
-		if (matchp->match->final_check != NULL)
-			matchp->match->final_check(matchp->match->mflags);
-	}
-
-	if (cs.target != NULL && cs.target->x6_options != NULL)
-		xtables_options_fcheck(cs.target->name, cs.target->tflags,
-				       cs.target->x6_options);
-	if (cs.target != NULL && cs.target->final_check != NULL)
-		cs.target->final_check(cs.target->tflags);
+	for (matchp = cs.matches; matchp; matchp = matchp->next)
+		xtables_option_mfcall(matchp->match);
+	if (cs.target != NULL)
+		xtables_option_tfcall(cs.target);
 
 	/* Fix me: must put inverse options checking here --MN */
 
diff --git a/iptables.c b/iptables.c
index 269a66f..2c1528e 100644
--- a/iptables.c
+++ b/iptables.c
@@ -1816,20 +1816,10 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 			"\nThe \"nat\" table is not intended for filtering, "
 		        "the use of DROP is therefore inhibited.\n\n");
 
-	for (matchp = cs.matches; matchp; matchp = matchp->next) {
-		if (matchp->match->x6_options != NULL)
-			xtables_options_fcheck(matchp->match->name,
-					       matchp->match->mflags,
-					       matchp->match->x6_options);
-		if (matchp->match->final_check != NULL)
-			matchp->match->final_check(matchp->match->mflags);
-	}
-
-	if (cs.target != NULL && cs.target->x6_options != NULL)
-		xtables_options_fcheck(cs.target->name, cs.target->tflags,
-				       cs.target->x6_options);
-	if (cs.target != NULL && cs.target->final_check != NULL)
-		cs.target->final_check(cs.target->tflags);
+	for (matchp = cs.matches; matchp; matchp = matchp->next)
+		xtables_option_mfcall(matchp->match);
+	if (cs.target != NULL)
+		xtables_option_tfcall(cs.target);
 
 	/* Fix me: must put inverse options checking here --MN */
 
diff --git a/xtoptions.c b/xtoptions.c
index 3286aa1..df917b6 100644
--- a/xtoptions.c
+++ b/xtoptions.c
@@ -297,3 +297,43 @@ void xtables_options_fcheck(const char *name, unsigned int xflags,
 		}
 	}
 }
+
+/**
+ * Dispatch arguments to the appropriate final_check function, based upon the
+ * extension's choice of API.
+ */
+void xtables_option_tfcall(struct xtables_target *t)
+{
+	if (t->x6_fcheck != NULL) {
+		struct xt_fcheck_call cb;
+
+		cb.ext_name = t->name;
+		cb.data     = t->t->data;
+		cb.xflags   = t->tflags;
+		t->x6_fcheck(&cb);
+	} else if (t->final_check != NULL) {
+		t->final_check(t->tflags);
+	}
+	if (t->x6_options != NULL)
+		xtables_options_fcheck(t->name, t->tflags, t->x6_options);
+}
+
+/**
+ * Dispatch arguments to the appropriate final_check function, based upon the
+ * extension's choice of API.
+ */
+void xtables_option_mfcall(struct xtables_match *m)
+{
+	if (m->x6_fcheck != NULL) {
+		struct xt_fcheck_call cb;
+
+		cb.ext_name = m->name;
+		cb.data     = m->m->data;
+		cb.xflags   = m->mflags;
+		m->x6_fcheck(&cb);
+	} else if (m->final_check != NULL) {
+		m->final_check(m->mflags);
+	}
+	if (m->x6_options != NULL)
+		xtables_options_fcheck(m->name, m->mflags, m->x6_options);
+}
-- 
1.7.1

