From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH] libxtables: change option precedence order to be intuitive
Date: Tue, 19 Oct 2010 17:16:27 +0200
Message-ID: <1287501388-5948-2-git-send-email-jengelh@medozas.de>
References: <1287501388-5948-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:35813 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751845Ab0JSPQb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Oct 2010 11:16:31 -0400
In-Reply-To: <1287501388-5948-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

When using `-m mark --mark 2 -m connmark --mark 2`, the user currently
gets an error about the (libxt_mark) --mark option being used twice.
This is because libxt_connmark's option table does not override any
previous options. This patch changes this behavior, since the current
behavior does not allow connmark's option to be used at all, which is
illogical.

Cc: Florian Westphal <fw@strlen.de>
Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/xtables.h.in |    5 +++--
 ip6tables.c          |    7 +++----
 iptables.c           |   13 +++++++++----
 xtables.c            |   50 ++++++++++++++++++++++++++++----------------------
 4 files changed, 43 insertions(+), 32 deletions(-)

diff --git a/include/xtables.h.in b/include/xtables.h.in
index 9e47c2d..c3d34af 100644
--- a/include/xtables.h.in
+++ b/include/xtables.h.in
@@ -219,8 +219,9 @@ extern int xtables_insmod(const char *, const char *, bool);
 extern int xtables_load_ko(const char *, bool);
 extern int xtables_set_params(struct xtables_globals *xtp);
 extern void xtables_free_opts(int reset_offset);
-extern struct option *xtables_merge_options(struct option *oldopts,
-	const struct option *newopts, unsigned int *option_offset);
+extern struct option *xtables_merge_options(struct option *origopts,
+	struct option *oldopts, const struct option *newopts,
+	unsigned int *option_offset);
 
 extern int xtables_init_all(struct xtables_globals *xtp, uint8_t nfproto);
 extern struct xtables_match *xtables_find_match(const char *name,
diff --git a/ip6tables.c b/ip6tables.c
index 15067da..150893d 100644
--- a/ip6tables.c
+++ b/ip6tables.c
@@ -147,7 +147,6 @@ void ip6tables_exit_error(enum xtables_exittype status, const char *msg, ...) __
 struct xtables_globals ip6tables_globals = {
 	.option_offset = 0,
 	.program_version = IPTABLES_VERSION,
-	.opts = original_opts,
 	.orig_opts = original_opts,
 	.exit_err = ip6tables_exit_error,
 };
@@ -1561,7 +1560,7 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 				target->t->u.user.revision = target->revision;
 				if (target->init != NULL)
 					target->init(target->t);
-				opts = xtables_merge_options(opts,
+				opts = xtables_merge_options(ip6tables_globals.orig_opts, opts,
 						     target->extra_opts,
 						     &target->option_offset);
 				if (opts == NULL)
@@ -1615,7 +1614,7 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 				m->init(m->m);
 			if (m != m->next)
 				/* Merge options for non-cloned matches */
-				opts = xtables_merge_options(opts, m->extra_opts, &m->option_offset);
+				opts = xtables_merge_options(ip6tables_globals.orig_opts, opts, m->extra_opts, &m->option_offset);
 		}
 		break;
 
@@ -1762,7 +1761,7 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 					if (m->init != NULL)
 						m->init(m->m);
 
-					opts = xtables_merge_options(opts,
+					opts = xtables_merge_options(ip6tables_globals.orig_opts, opts,
 					    m->extra_opts, &m->option_offset);
 
 					optind--;
diff --git a/iptables.c b/iptables.c
index 840dd3e..4c8bd77 100644
--- a/iptables.c
+++ b/iptables.c
@@ -147,7 +147,6 @@ void iptables_exit_error(enum xtables_exittype status, const char *msg, ...) __a
 struct xtables_globals iptables_globals = {
 	.option_offset = 0,
 	.program_version = IPTABLES_VERSION,
-	.opts = original_opts,
 	.orig_opts = original_opts,
 	.exit_err = iptables_exit_error,
 };
@@ -1576,7 +1575,9 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 				target->t->u.user.revision = target->revision;
 				if (target->init != NULL)
 					target->init(target->t);
-				opts = xtables_merge_options(opts,
+				opts = xtables_merge_options(
+						     iptables_globals.orig_opts,
+						     opts,
 						     target->extra_opts,
 						     &target->option_offset);
 				if (opts == NULL)
@@ -1636,7 +1637,9 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 				m->init(m->m);
 			if (m != m->next) {
 				/* Merge options for non-cloned matches */
-				opts = xtables_merge_options(opts,
+				opts = xtables_merge_options(
+						     iptables_globals.orig_opts,
+						     opts,
 						     m->extra_opts,
 						     &m->option_offset);
 				if (opts == NULL)
@@ -1790,7 +1793,9 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 					if (m->init != NULL)
 						m->init(m->m);
 
-					opts = xtables_merge_options(opts,
+					opts = xtables_merge_options(
+							     iptables_globals.orig_opts,
+							     opts,
 							     m->extra_opts,
 							     &m->option_offset);
 					if (opts == NULL)
diff --git a/xtables.c b/xtables.c
index 47a0d9c..7658038 100644
--- a/xtables.c
+++ b/xtables.c
@@ -73,44 +73,50 @@ void basic_exit_err(enum xtables_exittype status, const char *msg, ...)
 	exit(status);
 }
 
-
-void xtables_free_opts(int reset_offset)
+void xtables_free_opts(int unused)
 {
-	if (xt_params->opts != xt_params->orig_opts) {
-		free(xt_params->opts);
-		xt_params->opts = xt_params->orig_opts;
-		if (reset_offset)
-			xt_params->option_offset = 0;
-	}
+	free(xt_params->opts);
 }
 
-struct option *xtables_merge_options(struct option *oldopts,
+struct option *xtables_merge_options(struct option *orig_opts,
+				     struct option *oldopts,
 				     const struct option *newopts,
 				     unsigned int *option_offset)
 {
-	unsigned int num_old, num_new, i;
-	struct option *merge;
+	unsigned int num_oold = 0, num_old = 0, num_new = 0, i;
+	struct option *merge, *mp;
 
 	if (newopts == NULL)
 		return oldopts;
 
-	for (num_old = 0; oldopts[num_old].name; num_old++) ;
+	for (num_oold = 0; orig_opts[num_oold].name; num_oold++) ;
+	if (oldopts != NULL)
+		for (num_old = 0; oldopts[num_old].name; num_old++) ;
 	for (num_new = 0; newopts[num_new].name; num_new++) ;
 
+	merge = malloc(sizeof(*mp) * (num_oold + num_old + num_new + 1));
+	if (merge == NULL)
+		return NULL;
+
+	/* Let the base options -[ADI...] have precedence over everything */
+	memcpy(merge, orig_opts, sizeof(*mp) * num_oold);
+	mp = merge + num_oold;
+
+	/* Second, the new options */
 	xt_params->option_offset += 256;
 	*option_offset = xt_params->option_offset;
+	memcpy(mp, newopts, sizeof(*mp) * num_new);
 
-	merge = malloc(sizeof(struct option) * (num_new + num_old + 1));
-	if (merge == NULL)
-		return NULL;
-	memcpy(merge, oldopts, num_old * sizeof(struct option));
-	xtables_free_opts(0);	/* Release any old options merged  */
-	for (i = 0; i < num_new; i++) {
-		merge[num_old + i] = newopts[i];
-		merge[num_old + i].val += *option_offset;
-	}
-	memset(merge + num_old + num_new, 0, sizeof(struct option));
+	for (i = 0; i < num_new; ++i, ++mp)
+		mp->val += *option_offset;
+
+	/* Third, the old options */
+	memcpy(mp, oldopts, sizeof(*mp) * num_old);
+	mp += num_old;
+	xtables_free_opts(0);
 
+	/* Clear trailing entry */
+	memset(mp, 0, sizeof(*mp));
 	return merge;
 }
 
-- 
1.7.1

