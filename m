From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 1/3] Introduce match/target aliases
Date: Mon, 28 Jan 2013 21:32:53 +0100
Message-ID: <1359405175-4394-2-git-send-email-kadlec@blackhole.kfki.hu>
References: <1359405175-4394-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp0.kfki.hu ([148.6.0.25]:49364 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752049Ab3A1Ujl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 Jan 2013 15:39:41 -0500
In-Reply-To: <1359405175-4394-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The match/target alias allows us to support the syntax of matches, targets
targets merged into other matches/targets.

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 include/xtables.h    |   16 ++++++++++++++++
 iptables/ip6tables.c |   34 ++++++++++++++++++----------------
 iptables/iptables.c  |   34 ++++++++++++++++++----------------
 3 files changed, 52 insertions(+), 32 deletions(-)

diff --git a/include/xtables.h b/include/xtables.h
index 75de958..c35a6e6 100644
--- a/include/xtables.h
+++ b/include/xtables.h
@@ -201,6 +201,10 @@ struct xtables_lmap {
 	struct xtables_lmap *next;
 };
 
+enum xtables_ext_flags {
+	XTABLES_EXT_ALIAS = 1 << 0,
+};
+
 /* Include file for additions: new matches and targets. */
 struct xtables_match
 {
@@ -218,6 +222,9 @@ struct xtables_match
 	/* Revision of match (0 by default). */
 	u_int8_t revision;
 
+	/* Extension flags */
+	u_int8_t ext_flags;
+
 	u_int16_t family;
 
 	/* Size of match data. */
@@ -251,6 +258,9 @@ struct xtables_match
 	/* ip is struct ipt_ip * for example */
 	void (*save)(const void *ip, const struct xt_entry_match *match);
 
+	/* Print match name or alias */
+	const char *(*alias)(const struct xt_entry_match *match);
+
 	/* Pointer to list of extra command-line options */
 	const struct option *extra_opts;
 
@@ -289,6 +299,9 @@ struct xtables_target
 	/* Revision of target (0 by default). */
 	u_int8_t revision;
 
+	/* Extension flags */
+	u_int8_t ext_flags;
+
 	u_int16_t family;
 
 
@@ -322,6 +335,9 @@ struct xtables_target
 	void (*save)(const void *ip,
 		     const struct xt_entry_target *target);
 
+	/* Print target name or alias */
+	const char *(*alias)(const struct xt_entry_target *target);
+
 	/* Pointer to list of extra command-line options */
 	const struct option *extra_opts;
 
diff --git a/iptables/ip6tables.c b/iptables/ip6tables.c
index 556647f..4cfbea3 100644
--- a/iptables/ip6tables.c
+++ b/iptables/ip6tables.c
@@ -1000,7 +1000,8 @@ static int print_match_save(const struct xt_entry_match *e,
 		xtables_find_match(e->u.user.name, XTF_TRY_LOAD, NULL);
 
 	if (match) {
-		printf(" -m %s", e->u.user.name);
+		printf(" -m %s",
+			match->alias ? match->alias(e) : e->u.user.name);
 
 		/* some matches don't provide a save function */
 		if (match->save)
@@ -1089,16 +1090,8 @@ void print_rule6(const struct ip6t_entry *e,
 	if (counters < 0)
 		printf(" -c %llu %llu", (unsigned long long)e->counters.pcnt, (unsigned long long)e->counters.bcnt);
 
-	/* Print target name */
+	/* Print target name and targinfo part */
 	target_name = ip6tc_get_target(e, h);
-	if (target_name && (*target_name != '\0'))
-#ifdef IP6T_F_GOTO
-		printf(" -%c %s", e->ipv6.flags & IP6T_F_GOTO ? 'g' : 'j', target_name);
-#else
-		printf(" -j %s", target_name);
-#endif
-
-	/* Print targinfo part */
 	t = ip6t_get_target((struct ip6t_entry *)e);
 	if (t->u.user.name[0]) {
 		struct xtables_target *target =
@@ -1110,6 +1103,7 @@ void print_rule6(const struct ip6t_entry *e,
 			exit(1);
 		}
 
+		printf(" -j %s", target->alias ? target->alias(t) : target_name);
 		if (target->save)
 			target->save(&e->ipv6, t);
 		else {
@@ -1124,7 +1118,13 @@ void print_rule6(const struct ip6t_entry *e,
 				exit(1);
 			}
 		}
-	}
+	} else if (target_name && (*target_name != '\0'))
+#ifdef IP6T_F_GOTO
+		printf(" -%c %s", e->ipv6.flags & IP6T_F_GOTO ? 'g' : 'j', target_name);
+#else
+		printf(" -j %s", target_name);
+#endif
+
 	printf("\n");
 }
 
@@ -1229,9 +1229,10 @@ static void command_jump(struct iptables_command_state *cs)
 		strcpy(cs->target->t->u.user.name, cs->jumpto);
 	} else {
 		strcpy(cs->target->t->u.user.name, cs->target->real_name);
-		fprintf(stderr, "WARNING: The %s target is obsolete. "
-		        "Use %s instead.\n",
-		        cs->jumpto, cs->target->real_name);
+		if (!(cs->target->ext_flags & XTABLES_EXT_ALIAS))
+			fprintf(stderr, "Notice: The %s target is converted into %s target "
+			        "in rule listing and saving.\n",
+			        cs->jumpto, cs->target->real_name);
 	}
 	cs->target->t->u.user.revision = cs->target->revision;
 
@@ -1265,8 +1266,9 @@ static void command_match(struct iptables_command_state *cs)
 		strcpy(m->m->u.user.name, m->name);
 	} else {
 		strcpy(m->m->u.user.name, m->real_name);
-		fprintf(stderr, "WARNING: The %s match is obsolete. "
-		        "Use %s instead.\n", m->name, m->real_name);
+		if (!(m->ext_flags & XTABLES_EXT_ALIAS))
+			fprintf(stderr, "Notice: The %s match is converted into %s match "
+			        "in rule listing and saving.\n", m->name, m->real_name);
 	}
 	m->m->u.user.revision = m->revision;
 
diff --git a/iptables/iptables.c b/iptables/iptables.c
index 00e3f01..085eea1 100644
--- a/iptables/iptables.c
+++ b/iptables/iptables.c
@@ -991,7 +991,8 @@ static int print_match_save(const struct xt_entry_match *e,
 		xtables_find_match(e->u.user.name, XTF_TRY_LOAD, NULL);
 
 	if (match) {
-		printf(" -m %s", e->u.user.name);
+		printf(" -m %s",
+			match->alias ? match->alias(e) : e->u.user.name);
 
 		/* some matches don't provide a save function */
 		if (match->save)
@@ -1080,16 +1081,8 @@ void print_rule4(const struct ipt_entry *e,
 	if (counters < 0)
 		printf(" -c %llu %llu", (unsigned long long)e->counters.pcnt, (unsigned long long)e->counters.bcnt);
 
-	/* Print target name */
+	/* Print target name and targinfo part */
 	target_name = iptc_get_target(e, h);
-	if (target_name && (*target_name != '\0'))
-#ifdef IPT_F_GOTO
-		printf(" -%c %s", e->ip.flags & IPT_F_GOTO ? 'g' : 'j', target_name);
-#else
-		printf(" -j %s", target_name);
-#endif
-
-	/* Print targinfo part */
 	t = ipt_get_target((struct ipt_entry *)e);
 	if (t->u.user.name[0]) {
 		const struct xtables_target *target =
@@ -1101,6 +1094,7 @@ void print_rule4(const struct ipt_entry *e,
 			exit(1);
 		}
 
+		printf(" -j %s", target->alias ? target->alias(t) : target_name);
 		if (target->save)
 			target->save(&e->ip, t);
 		else {
@@ -1115,7 +1109,13 @@ void print_rule4(const struct ipt_entry *e,
 				exit(1);
 			}
 		}
-	}
+	} else if (target_name && (*target_name != '\0'))
+#ifdef IPT_F_GOTO
+		printf(" -%c %s", e->ip.flags & IPT_F_GOTO ? 'g' : 'j', target_name);
+#else
+		printf(" -j %s", target_name);
+#endif
+
 	printf("\n");
 }
 
@@ -1222,9 +1222,10 @@ static void command_jump(struct iptables_command_state *cs)
 	} else {
 		/* Alias support for userspace side */
 		strcpy(cs->target->t->u.user.name, cs->target->real_name);
-		fprintf(stderr, "WARNING: The %s target is obsolete. "
-		        "Use %s instead.\n",
-		        cs->jumpto, cs->target->real_name);
+		if (!(cs->target->ext_flags & XTABLES_EXT_ALIAS))
+			fprintf(stderr, "Notice: The %s target is converted into %s target "
+			        "in rule listing and saving.\n",
+			        cs->jumpto, cs->target->real_name);
 	}
 	cs->target->t->u.user.revision = cs->target->revision;
 
@@ -1259,8 +1260,9 @@ static void command_match(struct iptables_command_state *cs)
 		strcpy(m->m->u.user.name, m->name);
 	} else {
 		strcpy(m->m->u.user.name, m->real_name);
-		fprintf(stderr, "WARNING: The %s match is obsolete. "
-		        "Use %s instead.\n", m->name, m->real_name);
+		if (!(m->ext_flags & XTABLES_EXT_ALIAS))
+			fprintf(stderr, "Notice: the %s match is converted into %s match "
+			        "in rule listing and saving.\n", m->name, m->real_name);
 	}
 	m->m->u.user.revision = m->revision;
 
-- 
1.7.0.4

