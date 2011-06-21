From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 4/7] iptables: consolidate target/match init call
Date: Tue, 21 Jun 2011 17:53:31 +0200
Message-ID: <1308671615-17505-5-git-send-email-jengelh@medozas.de>
References: <1308671615-17505-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:40646 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756768Ab1FUPxl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 21 Jun 2011 11:53:41 -0400
In-Reply-To: <1308671615-17505-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is useful for the upcoming patch about per-instance auxiliary
data.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 iptables/ip6tables.c |    9 +++------
 iptables/iptables.c  |   10 ++++------
 iptables/xshared.c   |   15 +++++++++++++--
 iptables/xshared.h   |    2 ++
 4 files changed, 22 insertions(+), 14 deletions(-)

diff --git a/iptables/ip6tables.c b/iptables/ip6tables.c
index 4037acf..d13744c 100644
--- a/iptables/ip6tables.c
+++ b/iptables/ip6tables.c
@@ -1288,8 +1288,7 @@ static void command_jump(struct iptables_command_state *cs)
 	cs->target->t->u.target_size = size;
 	strcpy(cs->target->t->u.user.name, cs->jumpto);
 	cs->target->t->u.user.revision = cs->target->revision;
-	if (cs->target->init != NULL)
-		cs->target->init(cs->target->t);
+	xs_init_target(cs->target);
 	if (cs->target->x6_options != NULL)
 		opts = xtables_options_xfrm(ip6tables_globals.orig_opts, opts,
 					    cs->target->x6_options,
@@ -1317,8 +1316,7 @@ static void command_match(struct iptables_command_state *cs)
 	m->m->u.match_size = size;
 	strcpy(m->m->u.user.name, m->name);
 	m->m->u.user.revision = m->revision;
-	if (m->init != NULL)
-		m->init(m->m);
+	xs_init_match(m);
 	if (m == m->next)
 		return;
 	/* Merge options for non-cloned matches */
@@ -1839,8 +1837,7 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 			cs.target->t = xtables_calloc(1, size);
 			cs.target->t->u.target_size = size;
 			strcpy(cs.target->t->u.user.name, cs.jumpto);
-			if (cs.target->init != NULL)
-				cs.target->init(cs.target->t);
+			xs_init_target(cs.target);
 		}
 
 		if (!cs.target) {
diff --git a/iptables/iptables.c b/iptables/iptables.c
index 4ae7541..477e8f1 100644
--- a/iptables/iptables.c
+++ b/iptables/iptables.c
@@ -1315,8 +1315,8 @@ static void command_jump(struct iptables_command_state *cs)
 	cs->target->t->u.target_size = size;
 	strcpy(cs->target->t->u.user.name, cs->jumpto);
 	cs->target->t->u.user.revision = cs->target->revision;
-	if (cs->target->init != NULL)
-		cs->target->init(cs->target->t);
+	xs_init_target(cs->target);
+
 	if (cs->target->x6_options != NULL)
 		opts = xtables_options_xfrm(iptables_globals.orig_opts, opts,
 					    cs->target->x6_options,
@@ -1344,8 +1344,7 @@ static void command_match(struct iptables_command_state *cs)
 	m->m->u.match_size = size;
 	strcpy(m->m->u.user.name, m->name);
 	m->m->u.user.revision = m->revision;
-	if (m->init != NULL)
-		m->init(m->m);
+	xs_init_match(m);
 	if (m == m->next)
 		return;
 	/* Merge options for non-cloned matches */
@@ -1871,8 +1870,7 @@ int do_command4(int argc, char *argv[], char **table, struct iptc_handle **handl
 			strcpy(cs.target->t->u.user.name, cs.jumpto);
 			if (!iptc_is_chain(cs.jumpto, *handle))
 				cs.target->t->u.user.revision = cs.target->revision;
-			if (cs.target->init != NULL)
-				cs.target->init(cs.target->t);
+			xs_init_target(cs.target);
 		}
 
 		if (!cs.target) {
diff --git a/iptables/xshared.c b/iptables/xshared.c
index 0e3857b..55ce550 100644
--- a/iptables/xshared.c
+++ b/iptables/xshared.c
@@ -145,8 +145,7 @@ int command_default(struct iptables_command_state *cs,
 		m->m->u.match_size = size;
 		strcpy(m->m->u.user.name, m->name);
 		m->m->u.user.revision = m->revision;
-		if (m->init != NULL)
-			m->init(m->m);
+		xs_init_match(m);
 
 		if (m->x6_options != NULL)
 			gl->opts = xtables_options_xfrm(gl->orig_opts,
@@ -207,3 +206,15 @@ int subcmd_main(int argc, char **argv, const struct subcommand *cb)
 		fprintf(stderr, " * %s\n", cb->name);
 	exit(EXIT_FAILURE);
 }
+
+void xs_init_target(struct xtables_target *target)
+{
+	if (target->init != NULL)
+		target->init(target->t);
+}
+
+void xs_init_match(struct xtables_match *match)
+{
+	if (match->init != NULL)
+		match->init(match->m);
+}
diff --git a/iptables/xshared.h b/iptables/xshared.h
index b44a3a3..b804aaf 100644
--- a/iptables/xshared.h
+++ b/iptables/xshared.h
@@ -81,6 +81,8 @@ extern int command_default(struct iptables_command_state *,
 	struct xtables_globals *);
 extern struct xtables_match *load_proto(struct iptables_command_state *);
 extern int subcmd_main(int, char **, const struct subcommand *);
+extern void xs_init_target(struct xtables_target *);
+extern void xs_init_match(struct xtables_match *);
 
 extern const struct xtables_afinfo *afinfo;
 
-- 
1.7.3.4

