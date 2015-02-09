From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [ebtables-compat PATCH 1/2] ebtables-compat: add watchers support
Date: Mon, 09 Feb 2015 13:16:12 +0100
Message-ID: <20150209121612.13393.90335.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: giuseppelng@gmail.com, pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:55694 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932199AbbBIMQZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 Feb 2015 07:16:25 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

ebtables watchers are targets which always return EBT_CONTINUE.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 iptables/nft-bridge.c |   86 ++++++++++++++++++++++++++++++++++++-----
 iptables/nft-bridge.h |   13 ++++++
 iptables/nft-shared.c |    5 ++
 iptables/nft-shared.h |    1 
 iptables/xtables-eb.c |  104 ++++++++++++++++++++++++++++++++++++++++++++-----
 5 files changed, 190 insertions(+), 19 deletions(-)

diff --git a/iptables/nft-bridge.c b/iptables/nft-bridge.c
index 62aab04..4392d28 100644
--- a/iptables/nft-bridge.c
+++ b/iptables/nft-bridge.c
@@ -22,6 +22,21 @@
 #include "nft-bridge.h"
 #include "nft.h"
 
+void ebt_cs_clean(struct ebtables_command_state *cs)
+{
+	struct match *m, *nm;
+
+	xtables_rule_matches_free(&cs->matches);
+
+	for (m = cs->match_list; m;) {
+		nm = m->next;
+		if (!m->ismatch)
+			free(m->u.watcher->t);
+		free(m);
+		m = nm;
+	}
+}
+
 /* 0: default, print only 2 digits if necessary
  * 2: always print 2 digits, a printed mac address
  * then always has the same length
@@ -139,7 +154,7 @@ static int _add_action(struct nft_rule *r, struct ebtables_command_state *cs)
 static int nft_bridge_add(struct nft_rule *r, void *data)
 {
 	struct ebtables_command_state *cs = data;
-	struct xtables_rule_match *matchp;
+	struct match *iter;
 	struct ebt_entry *fw = &cs->fw;
 	uint32_t op;
 	char *addr;
@@ -189,9 +204,14 @@ static int nft_bridge_add(struct nft_rule *r, void *data)
 
 	add_compat(r, fw->ethproto, fw->invflags);
 
-	for (matchp = cs->matches; matchp; matchp = matchp->next) {
-		if (add_match(r, matchp->match->m) < 0)
-			break;
+	for (iter = cs->match_list; iter; iter = iter->next) {
+		if (iter->ismatch) {
+			if (add_match(r, iter->u.match->m))
+				break;
+		} else {
+			if (add_target(r, iter->u.watcher->t))
+				break;
+		}
 	}
 
 	if (add_counters(r, cs->counters.pcnt, cs->counters.bcnt) < 0)
@@ -296,10 +316,44 @@ static void nft_bridge_parse_immediate(const char *jumpto, bool nft_goto,
 	cs->jumpto = jumpto;
 }
 
+static void parse_watcher(void *object, struct match **match_list,
+			  bool ismatch)
+{
+	struct match *m;
+
+	m = calloc(1, sizeof(struct match));
+	if (m == NULL)
+		xtables_error(OTHER_PROBLEM, "Can't allocate memory");
+
+	if (ismatch)
+		m->u.match = object;
+	else
+		m->u.watcher = object;
+
+	m->ismatch = ismatch;
+	if (*match_list == NULL)
+		*match_list = m;
+	else
+		(*match_list)->next = m;
+}
+
+static void nft_bridge_parse_match(struct xtables_match *m, void *data)
+{
+	struct ebtables_command_state *cs = data;
+
+	parse_watcher(m, &cs->match_list, true);
+}
+
 static void nft_bridge_parse_target(struct xtables_target *t, void *data)
 {
 	struct ebtables_command_state *cs = data;
 
+	/* harcoded names :-( */
+	if (strcmp(t->name, "log") == 0) {
+		parse_watcher(t, &cs->match_list, false);
+		return;
+	}
+
 	cs->target = t;
 }
 
@@ -382,7 +436,9 @@ static void nft_bridge_print_header(unsigned int format, const char *chain,
 static void nft_bridge_print_firewall(struct nft_rule *r, unsigned int num,
 				      unsigned int format)
 {
-	struct xtables_rule_match *matchp;
+	struct xtables_match *matchp;
+	struct xtables_target *watcherp;
+	struct match *m;
 	struct ebtables_command_state cs = {};
 	char *addr;
 
@@ -456,10 +512,19 @@ static void nft_bridge_print_firewall(struct nft_rule *r, unsigned int num,
 		print_iface(cs.fw.out);
 	}
 
-	for (matchp = cs.matches; matchp; matchp = matchp->next) {
-		if (matchp->match->print != NULL) {
-			matchp->match->print(&cs.fw, matchp->match->m,
-					     format & FMT_NUMERIC);
+	for (m = cs.match_list; m; m = m->next) {
+		if (m->ismatch) {
+			matchp = m->u.match;
+			if (matchp->print != NULL) {
+				matchp->print(&cs.fw, matchp->m,
+					      format & FMT_NUMERIC);
+			}
+		} else {
+			watcherp = m->u.watcher;
+			if (watcherp->print != NULL) {
+				watcherp->print(&cs.fw, watcherp->t,
+						format & FMT_NUMERIC);
+			}
 		}
 	}
 
@@ -476,6 +541,8 @@ static void nft_bridge_print_firewall(struct nft_rule *r, unsigned int num,
 
 	if (!(format & FMT_NONEWLINE))
 		fputc('\n', stdout);
+
+	ebt_cs_clean(&cs);
 }
 
 static bool nft_bridge_is_same(const void *data_a, const void *data_b)
@@ -567,6 +634,7 @@ struct nft_family_ops nft_family_ops_bridge = {
 	.parse_meta		= nft_bridge_parse_meta,
 	.parse_payload		= nft_bridge_parse_payload,
 	.parse_immediate	= nft_bridge_parse_immediate,
+	.parse_match		= nft_bridge_parse_match,
 	.parse_target		= nft_bridge_parse_target,
 	.print_table_header	= nft_bridge_print_table_header,
 	.print_header		= nft_bridge_print_header,
diff --git a/iptables/nft-bridge.h b/iptables/nft-bridge.h
index cd63c11..8dc6c9a 100644
--- a/iptables/nft-bridge.h
+++ b/iptables/nft-bridge.h
@@ -93,10 +93,21 @@ struct ebt_entry {
 	unsigned char out_mask[IFNAMSIZ];
 };
 
+/* trick for ebtables-compat, since watchers are targets */
+struct match {
+	struct match				*next;
+	union {
+		struct xtables_match		*match;
+		struct xtables_target		*watcher;
+	} u;
+	bool					ismatch;
+};
+
 struct ebtables_command_state {
 	struct ebt_entry fw;
 	struct xtables_target *target;
 	struct xtables_rule_match *matches;
+	struct match *match_list;
 	const char *jumpto;
 	struct xt_counters counters;
 	int invert;
@@ -155,4 +166,6 @@ static inline const char *ebt_target_name(unsigned int verdict)
 	*flags |= mask;						\
 })								\
 
+void ebt_cs_clean(struct ebtables_command_state *cs);
+
 #endif
diff --git a/iptables/nft-shared.c b/iptables/nft-shared.c
index 76984e8..620da3e 100644
--- a/iptables/nft-shared.c
+++ b/iptables/nft-shared.c
@@ -328,6 +328,7 @@ void nft_parse_match(struct nft_xt_ctx *ctx, struct nft_rule_expr *e)
 	struct xtables_match *match;
 	struct xtables_rule_match **matches;
 	struct xt_entry_match *m;
+	struct nft_family_ops *ops;
 
 	switch (ctx->family) {
 	case NFPROTO_IPV4:
@@ -359,6 +360,10 @@ void nft_parse_match(struct nft_xt_ctx *ctx, struct nft_rule_expr *e)
 	strcpy(m->u.user.name, match->name);
 
 	match->m = m;
+
+	ops = nft_family_ops_lookup(ctx->family);
+	if (ops->parse_match != NULL)
+		ops->parse_match(match, nft_get_data(ctx));
 }
 
 void print_proto(uint16_t proto, int invert)
diff --git a/iptables/nft-shared.h b/iptables/nft-shared.h
index 33582aa..fbce5b5 100644
--- a/iptables/nft-shared.h
+++ b/iptables/nft-shared.h
@@ -97,6 +97,7 @@ struct nft_family_ops {
 			    struct xtables_args *args);
 	void (*post_parse)(int command, struct iptables_command_state *cs,
 			   struct xtables_args *args);
+	void (*parse_match)(struct xtables_match *m, void *data);
 	void (*parse_target)(struct xtables_target *t, void *data);
 	bool (*rule_find)(struct nft_family_ops *ops, struct nft_rule *r,
 			  void *data);
diff --git a/iptables/xtables-eb.c b/iptables/xtables-eb.c
index db1717c..7f3c1e6 100644
--- a/iptables/xtables-eb.c
+++ b/iptables/xtables-eb.c
@@ -610,19 +610,49 @@ static void ebt_load_match(const char *name)
 		xtables_error(OTHER_PROBLEM, "Can't alloc memory");
 }
 
-static void ebt_load_matches(void)
+static void ebt_load_watcher(const char *name)
+{
+	struct xtables_target *watcher;
+	size_t size;
+
+	watcher = xtables_find_target(name, XTF_LOAD_MUST_SUCCEED);
+	if (!watcher)
+		xtables_error(OTHER_PROBLEM,
+			      "Unable to load %s watcher", name);
+
+	size = XT_ALIGN(sizeof(struct xt_entry_target)) + watcher->size;
+
+	watcher->t = xtables_calloc(1, size);
+	watcher->t->u.target_size = size;
+	strncpy(watcher->t->u.user.name, name,
+		sizeof(watcher->t->u.user.name));
+	watcher->t->u.user.name[sizeof(watcher->t->u.user.name)-1] = '\0';
+	watcher->t->u.user.revision = watcher->revision;
+
+	xs_init_target(watcher);
+
+	opts = merge_options(opts, watcher->extra_opts,
+			     &watcher->option_offset);
+	if (opts == NULL)
+		xtables_error(OTHER_PROBLEM, "Can't alloc memory");
+}
+
+static void ebt_load_match_extensions(void)
 {
 	opts = ebt_original_options;
 	ebt_load_match("802_3");
 	ebt_load_match("ip");
 	ebt_load_match("mark_m");
+
+	ebt_load_watcher("log");
 }
 
 static void ebt_add_match(struct xtables_match *m,
-			  struct xtables_rule_match **rule_matches)
+			  struct ebtables_command_state *cs)
 {
-	struct xtables_rule_match *i;
+	struct xtables_rule_match *i, **rule_matches = &cs->matches;
 	struct xtables_match *newm;
+	struct match *newnode;
 
 	/* match already in rule_matches, skip inclusion */
 	for (i = *rule_matches; i; i = i->next) {
@@ -638,6 +668,45 @@ static void ebt_add_match(struct xtables_match *m,
 			      "Unable to add match %s", m->name);
 
 	newm->mflags = m->mflags;
+
+	/* glue code for watchers */
+	newnode = calloc(1, sizeof(struct match));
+	if (newnode == NULL)
+		xtables_error(OTHER_PROBLEM, "Unable to alloc memory");
+
+	newnode->ismatch = true;
+	newnode->u.match = newm;
+
+	if (cs->match_list == NULL)
+		cs->match_list = newnode;
+	else
+		cs->match_list->next = newnode;
+}
+
+static void ebt_add_watcher(struct xtables_target *watcher,
+			    struct ebtables_command_state *cs)
+{
+	struct match *i, *newnode;
+
+	for (i = cs->match_list; i; i = i->next) {
+		if (i->ismatch)
+			continue;
+		if (strcmp(i->u.watcher->name, watcher->name) == 0) {
+			i->u.watcher->tflags |= watcher->tflags;
+			return;
+		}
+	}
+
+	newnode = calloc(1, sizeof(struct match));
+	if (newnode == NULL)
+		xtables_error(OTHER_PROBLEM, "Unable to alloc memory");
+
+	newnode->u.watcher = watcher;
+
+	if (cs->match_list == NULL)
+		cs->match_list = newnode;
+	else
+		cs->match_list->next = newnode;
 }
 
 /* We use exec_style instead of #ifdef's because ebtables.so is a shared object. */
@@ -651,7 +720,7 @@ int do_commandeb(struct nft_handle *h, int argc, char *argv[], char **table)
 	int rule_nr_end = 0;
 	int ret = 0;
 	unsigned int flags = 0;
-	struct xtables_target *t;
+	struct xtables_target *t, *w;
 	struct xtables_match *m;
 	struct ebtables_command_state cs;
 	char command = 'h';
@@ -660,6 +729,7 @@ int do_commandeb(struct nft_handle *h, int argc, char *argv[], char **table)
 	int exec_style = EXEC_STYLE_PRG;
 	int selected_chain = -1;
 	struct xtables_rule_match *xtrm_i;
+	struct match *miter;
 
 	memset(&cs, 0, sizeof(cs));
 	cs.argv = argv;
@@ -676,7 +746,7 @@ int do_commandeb(struct nft_handle *h, int argc, char *argv[], char **table)
 	 * don't use '-m matchname' and the match can't loaded dinamically when
 	 * the user calls it.
 	 */
-	ebt_load_matches();
+	ebt_load_match_extensions();
 
 	/* clear mflags in case do_commandeb gets called a second time
 	 * (we clear the global list of all matches for security)*/
@@ -1164,16 +1234,21 @@ big_iface_length:
 			/* Is it a match_option? */
 			for (m = xtables_matches; m; m = m->next) {
 				if (m->parse(c - m->option_offset, argv, ebt_invert, &m->mflags, NULL, &m->m)) {
-					ebt_add_match(m, &cs.matches);
+					ebt_add_match(m, &cs);
 					goto check_extension;
 				}
 			}
 
 			/* Is it a watcher option? */
-			/*for (w = ebt_watchers; w; w = w->next)
-				if (w->parse(c - w->option_offset, argv, argc, new_entry, &w->flags, &w->w))
-					break;
-
+			for (w = xtables_targets; w; w = w->next) {
+				if (w->parse(c - w->option_offset, argv,
+					     ebt_invert, &w->tflags,
+					     NULL, &w->t)) {
+					ebt_add_watcher(w, &cs);
+					goto check_extension;
+				}
+			}
+			/*
 			if (w == NULL && c == '?')
 				ebt_print_error2("Unknown argument: '%s'", argv[optind - 1], (char)optopt, (char)c);
 			else if (w == NULL) {
@@ -1216,6 +1291,13 @@ check_extension:
 		for (xtrm_i = cs.matches; xtrm_i; xtrm_i = xtrm_i->next)
 			xtables_option_mfcall(xtrm_i->match);
 
+		for (miter = cs.match_list; miter; miter = miter->next) {
+			if (miter->ismatch)
+				continue;
+
+			xtables_option_tfcall(miter->u.watcher);
+		}
+
 		if (cs.target != NULL)
 			xtables_option_tfcall(cs.target);
 	}
@@ -1278,5 +1360,7 @@ check_extension:
 
 		if (replace->nentries)
 			ebt_deliver_counters(replace);*/
+
+	ebt_cs_clean(&cs);
 	return ret;
 }

