From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 02/12] src: combine default_command functions
Date: Fri, 13 May 2011 02:47:26 +0200
Message-ID: <1305247657-29158-3-git-send-email-jengelh@medozas.de>
References: <1305247657-29158-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:35626 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752272Ab1EMAtQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 May 2011 20:49:16 -0400
In-Reply-To: <1305247657-29158-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

---
 ip6tables.c |   69 +---------------------------------------------------------
 iptables.c  |   70 +----------------------------------------------------------
 xshared.c   |   70 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 xshared.h   |    3 ++
 4 files changed, 75 insertions(+), 137 deletions(-)

diff --git a/ip6tables.c b/ip6tables.c
index 58c7e2d..a74238c 100644
--- a/ip6tables.c
+++ b/ip6tables.c
@@ -1272,73 +1272,6 @@ static void clear_rule_matches(struct xtables_rule_match **matches)
 	*matches = NULL;
 }
 
-static void command_default(struct iptables_command_state *cs)
-{
-	struct xtables_rule_match *matchp;
-	struct xtables_match *m;
-
-	if (cs->target != NULL &&
-	    (cs->target->parse != NULL || cs->target->x6_parse != NULL) &&
-	    cs->c >= cs->target->option_offset &&
-	    cs->c < cs->target->option_offset + XT_OPTION_OFFSET_SCALE) {
-		xtables_option_tpcall(cs->c, cs->argv, cs->invert,
-				      cs->target, &cs->fw);
-		return;
-	}
-
-	for (matchp = cs->matches; matchp; matchp = matchp->next) {
-		m = matchp->match;
-
-		if (matchp->completed ||
-		    (m->x6_parse == NULL && m->parse == NULL))
-			continue;
-		if (cs->c < matchp->match->option_offset ||
-		    cs->c >= matchp->match->option_offset + XT_OPTION_OFFSET_SCALE)
-			continue;
-		xtables_option_mpcall(cs->c, cs->argv, cs->invert, m, &cs->fw);
-		return;
-	}
-
-	/* Try loading protocol */
-	m = load_proto(cs);
-	if (m != NULL) {
-		size_t size;
-
-		cs->proto_used = 1;
-
-		size = XT_ALIGN(sizeof(struct ip6t_entry_match)) + m->size;
-
-		m->m = xtables_calloc(1, size);
-		m->m->u.match_size = size;
-		strcpy(m->m->u.user.name, m->name);
-		m->m->u.user.revision = m->revision;
-		if (m->init != NULL)
-			m->init(m->m);
-
-		if (m->x6_options != NULL)
-			opts = xtables_options_xfrm(ip6tables_globals.orig_opts,
-						    opts, m->x6_options,
-						    &m->option_offset);
-		else
-			opts = xtables_merge_options(ip6tables_globals.orig_opts,
-						     opts,
-						     m->extra_opts,
-						     &m->option_offset);
-		if (opts == NULL)
-			xtables_error(OTHER_PROBLEM, "can't alloc memory!");
-		optind--;
-		return;
-	}
-
-	if (cs->c == ':')
-		xtables_error(PARAMETER_PROBLEM, "option \"%s\" "
-		              "requires an argument", cs->argv[optind-1]);
-	if (cs->c == '?')
-		xtables_error(PARAMETER_PROBLEM, "unknown option "
-			      "\"%s\"", cs->argv[optind-1]);
-	xtables_error(PARAMETER_PROBLEM, "Unknown arg \"%s\"", optarg);
-}
-
 static void command_jump(struct iptables_command_state *cs)
 {
 	size_t size;
@@ -1785,7 +1718,7 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 			exit_tryhelp(2);
 
 		default:
-			command_default(&cs);
+			command_default(&cs, &ip6tables_globals);
 			break;
 		}
 		cs.invert = FALSE;
diff --git a/iptables.c b/iptables.c
index d01e828..d9c6436 100644
--- a/iptables.c
+++ b/iptables.c
@@ -1296,74 +1296,6 @@ get_kernel_version(void) {
 	kernel_version = LINUX_VERSION(x, y, z);
 }
 
-static void command_default(struct iptables_command_state *cs)
-{
-	struct xtables_rule_match *matchp;
-	struct xtables_match *m;
-
-	if (cs->target != NULL &&
-	    (cs->target->parse != NULL || cs->target->x6_parse != NULL) &&
-	    cs->c >= cs->target->option_offset &&
-	    cs->c < cs->target->option_offset + XT_OPTION_OFFSET_SCALE) {
-		xtables_option_tpcall(cs->c, cs->argv, cs->invert,
-				      cs->target, &cs->fw);
-		return;
-	}
-
-	for (matchp = cs->matches; matchp; matchp = matchp->next) {
-		m = matchp->match;
-
-		if (matchp->completed ||
-		    (m->x6_parse == NULL && m->parse == NULL))
-			continue;
-		if (cs->c < m->option_offset ||
-		    cs->c >= m->option_offset + XT_OPTION_OFFSET_SCALE)
-			continue;
-		xtables_option_mpcall(cs->c, cs->argv, cs->invert, m, &cs->fw);
-		return;
-	}
-
-	/* Try loading protocol */
-	m = load_proto(cs);
-	if (m != NULL) {
-		size_t size;
-
-		cs->proto_used = 1;
-
-		size = XT_ALIGN(sizeof(struct ipt_entry_match)) + m->size;
-
-		m->m = xtables_calloc(1, size);
-		m->m->u.match_size = size;
-		strcpy(m->m->u.user.name, m->name);
-		m->m->u.user.revision = m->revision;
-		if (m->init != NULL)
-			m->init(m->m);
-
-		if (m->x6_options != NULL)
-			opts = xtables_options_xfrm(iptables_globals.orig_opts,
-						    opts, m->x6_options,
-						    &m->option_offset);
-		else
-			opts = xtables_merge_options(iptables_globals.orig_opts,
-						     opts,
-						     m->extra_opts,
-						     &m->option_offset);
-		if (opts == NULL)
-			xtables_error(OTHER_PROBLEM, "can't alloc memory!");
-
-		optind--;
-		return;
-	}
-
-	if (cs->c == ':')
-		xtables_error(PARAMETER_PROBLEM, "option \"%s\" "
-		              "requires an argument", cs->argv[optind-1]);
-	if (cs->c == '?')
-		xtables_error(PARAMETER_PROBLEM, "unknown option "
-			      "\"%s\"", cs->argv[optind-1]);
-	xtables_error(PARAMETER_PROBLEM, "Unknown arg \"%s\"", optarg);
-}
-
 static void command_jump(struct iptables_command_state *cs)
 {
 	size_t size;
@@ -1811,7 +1743,7 @@ int do_command4(int argc, char *argv[], char **table, struct iptc_handle **handl
 			exit_tryhelp(2);
 
 		default:
-			command_default(&cs);
+			command_default(&cs, &iptables_globals);
 			break;
 		}
 		cs.invert = FALSE;
diff --git a/xshared.c b/xshared.c
index 87402b4..4651888 100644
--- a/xshared.c
+++ b/xshared.c
@@ -1,3 +1,4 @@
+#include <getopt.h>
 #include <libgen.h>
 #include <netdb.h>
 #include <stdbool.h>
@@ -103,6 +104,75 @@ struct xtables_match *load_proto(struct iptables_command_state *cs)
 			  cs->options & OPT_NUMERIC, &cs->matches);
 }
 
+void command_default(struct iptables_command_state *cs,
+		     struct xtables_globals *gl)
+{
+	struct xtables_rule_match *matchp;
+	struct xtables_match *m;
+
+	if (cs->target != NULL &&
+	    (cs->target->parse != NULL || cs->target->x6_parse != NULL) &&
+	    cs->c >= cs->target->option_offset &&
+	    cs->c < cs->target->option_offset + XT_OPTION_OFFSET_SCALE) {
+		xtables_option_tpcall(cs->c, cs->argv, cs->invert,
+				      cs->target, &cs->fw);
+		return;
+	}
+
+	for (matchp = cs->matches; matchp; matchp = matchp->next) {
+		m = matchp->match;
+
+		if (matchp->completed ||
+		    (m->x6_parse == NULL && m->parse == NULL))
+			continue;
+		if (cs->c < matchp->match->option_offset ||
+		    cs->c >= matchp->match->option_offset + XT_OPTION_OFFSET_SCALE)
+			continue;
+		xtables_option_mpcall(cs->c, cs->argv, cs->invert, m, &cs->fw);
+		return;
+	}
+
+	/* Try loading protocol */
+	m = load_proto(cs);
+	if (m != NULL) {
+		size_t size;
+
+		cs->proto_used = 1;
+
+		size = XT_ALIGN(sizeof(struct ip6t_entry_match)) + m->size;
+
+		m->m = xtables_calloc(1, size);
+		m->m->u.match_size = size;
+		strcpy(m->m->u.user.name, m->name);
+		m->m->u.user.revision = m->revision;
+		if (m->init != NULL)
+			m->init(m->m);
+
+		if (m->x6_options != NULL)
+			gl->opts = xtables_options_xfrm(gl->orig_opts,
+							gl->opts,
+							m->x6_options,
+							&m->option_offset);
+		else
+			gl->opts = xtables_merge_options(gl->orig_opts,
+							 gl->opts,
+							 m->extra_opts,
+							 &m->option_offset);
+		if (gl->opts == NULL)
+			xtables_error(OTHER_PROBLEM, "can't alloc memory!");
+		optind--;
+		return;
+	}
+
+	if (cs->c == ':')
+		xtables_error(PARAMETER_PROBLEM, "option \"%s\" "
+		              "requires an argument", cs->argv[optind-1]);
+	if (cs->c == '?')
+		xtables_error(PARAMETER_PROBLEM, "unknown option "
+			      "\"%s\"", cs->argv[optind-1]);
+	xtables_error(PARAMETER_PROBLEM, "Unknown arg \"%s\"", optarg);
+}
+
 static mainfunc_t subcmd_get(const char *cmd, const struct subcommand *cb)
 {
 	for (; cb->name != NULL; ++cb)
diff --git a/xshared.h b/xshared.h
index 34f3265..d868c06 100644
--- a/xshared.h
+++ b/xshared.h
@@ -23,6 +23,7 @@ enum {
 	OPT_COUNTERS    = 1 << 10,
 };
 
+struct xtables_globals;
 struct xtables_rule_match;
 struct xtables_target;
 
@@ -76,6 +77,8 @@ enum {
 extern void print_extension_helps(const struct xtables_target *,
 	const struct xtables_rule_match *);
 extern const char *proto_to_name(uint8_t, int);
+extern void command_default(struct iptables_command_state *,
+	struct xtables_globals *);
 extern struct xtables_match *load_proto(struct iptables_command_state *);
 extern int subcmd_main(int, char **, const struct subcommand *);
 
-- 
1.7.1

