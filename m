From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 5/7] extensions: support for per-extension instance "global" variable space
Date: Tue, 21 Jun 2011 17:53:32 +0200
Message-ID: <1308671615-17505-6-git-send-email-jengelh@medozas.de>
References: <1308671615-17505-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:40644 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756743Ab1FUPxm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 21 Jun 2011 11:53:42 -0400
In-Reply-To: <1308671615-17505-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/xtables.h.in |   18 +++++++++++++++---
 iptables/xshared.c   |   18 ++++++++++++++++++
 iptables/xtoptions.c |    4 ++++
 3 files changed, 37 insertions(+), 3 deletions(-)

diff --git a/include/xtables.h.in b/include/xtables.h.in
index 2565dd2..0dead26 100644
--- a/include/xtables.h.in
+++ b/include/xtables.h.in
@@ -137,11 +137,13 @@ struct xt_option_entry {
  * @arg:	input from command line
  * @ext_name:	name of extension currently being processed
  * @entry:	current option being processed
- * @data:	per-extension data block
+ * @data:	per-extension kernel data block
  * @xflags:	options of the extension that have been used
  * @invert:	whether option was used with !
  * @nvals:	number of results in uXX_multi
  * @val:	parsed result
+ * @udata:	per-extension private scratch area
+ * 		(cf. xtables_{match,target}->udata_size)
  */
 struct xt_option_call {
 	const char *arg, *ext_name;
@@ -174,16 +176,19 @@ struct xt_option_call {
 		struct xt_entry_target **target;
 	};
 	void *xt_entry;
+	void *udata;
 };
 
 /**
  * @ext_name:	name of extension currently being processed
- * @data:	per-extension data block
+ * @data:	per-extension (kernel) data block
+ * @udata:	per-extension private scratch area
+ * 		(cf. xtables_{match,target}->udata_size)
  * @xflags:	options of the extension that have been used
  */
 struct xt_fcheck_call {
 	const char *ext_name;
-	void *data;
+	void *data, *udata;
 	unsigned int xflags;
 };
 
@@ -254,7 +259,11 @@ struct xtables_match
 	void (*x6_fcheck)(struct xt_fcheck_call *);
 	const struct xt_option_entry *x6_options;
 
+	/* Size of per-extension instance extra "global" scratch space */
+	size_t udata_size;
+
 	/* Ignore these men behind the curtain: */
+	void *udata;
 	unsigned int option_offset;
 	struct xt_entry_match *m;
 	unsigned int mflags;
@@ -318,7 +327,10 @@ struct xtables_target
 	void (*x6_fcheck)(struct xt_fcheck_call *);
 	const struct xt_option_entry *x6_options;
 
+	size_t udata_size;
+
 	/* Ignore these men behind the curtain: */
+	void *udata;
 	unsigned int option_offset;
 	struct xt_entry_target *t;
 	unsigned int tflags;
diff --git a/iptables/xshared.c b/iptables/xshared.c
index 55ce550..79da507 100644
--- a/iptables/xshared.c
+++ b/iptables/xshared.c
@@ -209,12 +209,30 @@ int subcmd_main(int argc, char **argv, const struct subcommand *cb)
 
 void xs_init_target(struct xtables_target *target)
 {
+	if (target->udata_size != 0) {
+		free(target->udata);
+		target->udata = calloc(1, target->udata_size);
+		if (target->udata == NULL)
+			xtables_error(RESOURCE_PROBLEM, "malloc");
+	}
 	if (target->init != NULL)
 		target->init(target->t);
 }
 
 void xs_init_match(struct xtables_match *match)
 {
+	if (match->udata_size != 0) {
+		/*
+		 * As soon as a subsequent instance of the same match
+		 * is used, e.g. "-m time -m time", the first instance
+		 * is no longer reachable anyway, so we can free udata.
+		 * Same goes for target.
+		 */
+		free(match->udata);
+		match->udata = calloc(1, match->udata_size);
+		if (match->udata == NULL)
+			xtables_error(RESOURCE_PROBLEM, "malloc");
+	}
 	if (match->init != NULL)
 		match->init(match->m);
 }
diff --git a/iptables/xtoptions.c b/iptables/xtoptions.c
index ac0601f..1423724 100644
--- a/iptables/xtoptions.c
+++ b/iptables/xtoptions.c
@@ -908,6 +908,7 @@ void xtables_option_tpcall(unsigned int c, char **argv, bool invert,
 	cb.xflags   = t->tflags;
 	cb.target   = &t->t;
 	cb.xt_entry = fw;
+	cb.udata    = t->udata;
 	t->x6_parse(&cb);
 	t->tflags = cb.xflags;
 }
@@ -943,6 +944,7 @@ void xtables_option_mpcall(unsigned int c, char **argv, bool invert,
 	cb.xflags   = m->mflags;
 	cb.match    = &m->m;
 	cb.xt_entry = fw;
+	cb.udata    = m->udata;
 	m->x6_parse(&cb);
 	m->mflags = cb.xflags;
 }
@@ -1028,6 +1030,7 @@ void xtables_option_tfcall(struct xtables_target *t)
 		cb.ext_name = t->name;
 		cb.data     = t->t->data;
 		cb.xflags   = t->tflags;
+		cb.udata    = t->udata;
 		t->x6_fcheck(&cb);
 	} else if (t->final_check != NULL) {
 		t->final_check(t->tflags);
@@ -1048,6 +1051,7 @@ void xtables_option_mfcall(struct xtables_match *m)
 		cb.ext_name = m->name;
 		cb.data     = m->m->data;
 		cb.xflags   = m->mflags;
+		cb.udata    = m->udata;
 		m->x6_fcheck(&cb);
 	} else if (m->final_check != NULL) {
 		m->final_check(m->mflags);
-- 
1.7.3.4

