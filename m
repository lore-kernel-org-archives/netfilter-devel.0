From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 09/11] src: move jump option handling from do_command6 into its own function
Date: Wed,  9 Feb 2011 02:48:54 +0100
Message-ID: <1297216137-18505-10-git-send-email-jengelh@medozas.de>
References: <1297216137-18505-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:38744 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756140Ab1BIBtL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Feb 2011 20:49:11 -0500
In-Reply-To: <1297216137-18505-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 ip6tables.c |   72 ++++++++++++++++++++++++++++-------------------------
 iptables.c  |   79 ++++++++++++++++++++++++++++++----------------------------
 xshared.h   |    1 +
 3 files changed, 80 insertions(+), 72 deletions(-)

diff --git a/ip6tables.c b/ip6tables.c
index c475bf2..eb28dc0 100644
--- a/ip6tables.c
+++ b/ip6tables.c
@@ -1302,6 +1302,33 @@ static void command_default(struct iptables_command_state *cs)
 	xtables_error(PARAMETER_PROBLEM, "Unknown arg \"%s\"", optarg);
 }
 
+static void command_jump(struct iptables_command_state *cs)
+{
+	size_t size;
+
+	set_option(&cs->options, OPT_JUMP, &cs->fw6.ipv6.invflags, cs->invert);
+	cs->jumpto = parse_target(optarg);
+	/* TRY_LOAD (may be chain name) */
+	cs->target = xtables_find_target(cs->jumpto, XTF_TRY_LOAD);
+
+	if (cs->target == NULL)
+		return;
+
+	size = IP6T_ALIGN(sizeof(struct ip6t_entry_target)) + cs->target->size;
+
+	cs->target->t = xtables_calloc(1, size);
+	cs->target->t->u.target_size = size;
+	strcpy(cs->target->t->u.user.name, cs->jumpto);
+	cs->target->t->u.user.revision = cs->target->revision;
+	if (cs->target->init != NULL)
+		cs->target->init(cs->target->t);
+	opts = xtables_merge_options(ip6tables_globals.orig_opts, opts,
+				     cs->target->extra_opts,
+				     &cs->target->option_offset);
+	if (opts == NULL)
+		xtables_error(OTHER_PROBLEM, "can't alloc memory!");
+}
+
 int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **handle)
 {
 	struct iptables_command_state cs;
@@ -1320,10 +1347,10 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 	struct xtables_match *m;
 	struct xtables_rule_match *matchp;
 	struct xtables_target *t;
-	const char *jumpto = "";
 	unsigned long long cnt;
 
 	memset(&cs, 0, sizeof(cs));
+	cs.jumpto = "";
 	cs.argv = argv;
 
 	/* re-set optind to 0 in case do_command gets called
@@ -1548,36 +1575,12 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 			set_option(&cs.options, OPT_JUMP, &cs.fw6.ipv6.invflags,
 					cs.invert);
 			cs.fw6.ipv6.flags |= IP6T_F_GOTO;
-			jumpto = parse_target(optarg);
+			cs.jumpto = parse_target(optarg);
 			break;
 #endif
 
 		case 'j':
-			set_option(&cs.options, OPT_JUMP, &cs.fw6.ipv6.invflags,
-				   cs.invert);
-			jumpto = parse_target(optarg);
-			/* TRY_LOAD (may be chain name) */
-			cs.target = xtables_find_target(jumpto, XTF_TRY_LOAD);
-
-			if (cs.target) {
-				size_t size;
-
-				size = IP6T_ALIGN(sizeof(struct ip6t_entry_target))
-					+ cs.target->size;
-
-				cs.target->t = xtables_calloc(1, size);
-				cs.target->t->u.target_size = size;
-				strcpy(cs.target->t->u.user.name, jumpto);
-				cs.target->t->u.user.revision = cs.target->revision;
-				if (cs.target->init != NULL)
-					cs.target->init(cs.target->t);
-				opts = xtables_merge_options(ip6tables_globals.orig_opts, opts,
-						     cs.target->extra_opts,
-						     &cs.target->option_offset);
-				if (opts == NULL)
-					xtables_error(OTHER_PROBLEM,
-						   "can't alloc memory!");
-			}
+			command_jump(&cs);
 			break;
 
 
@@ -1806,10 +1809,10 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 					   chain);
 		}
 
-		if (cs.target && ip6tc_is_chain(jumpto, *handle)) {
+		if (cs.target && ip6tc_is_chain(cs.jumpto, *handle)) {
 			fprintf(stderr,
 				"Warning: using chain %s, not extension\n",
-				jumpto);
+				cs.jumpto);
 
 			if (cs.target->t)
 				free(cs.target->t);
@@ -1820,8 +1823,8 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 		/* If they didn't specify a target, or it's a chain
 		   name, use standard. */
 		if (!cs.target
-		    && (strlen(jumpto) == 0
-			|| ip6tc_is_chain(jumpto, *handle))) {
+		    && (strlen(cs.jumpto) == 0
+			|| ip6tc_is_chain(cs.jumpto, *handle))) {
 			size_t size;
 
 			cs.target = xtables_find_target(IP6T_STANDARD_TARGET,
@@ -1831,7 +1834,7 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 				+ cs.target->size;
 			cs.target->t = xtables_calloc(1, size);
 			cs.target->t->u.target_size = size;
-			strcpy(cs.target->t->u.user.name, jumpto);
+			strcpy(cs.target->t->u.user.name, cs.jumpto);
 			if (cs.target->init != NULL)
 				cs.target->init(cs.target->t);
 		}
@@ -1844,9 +1847,10 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 #ifdef IP6T_F_GOTO
 			if (cs.fw6.ipv6.flags & IP6T_F_GOTO)
 				xtables_error(PARAMETER_PROBLEM,
-						"goto '%s' is not a chain\n", jumpto);
+						"goto '%s' is not a chain\n",
+						cs.jumpto);
 #endif
-			xtables_find_target(jumpto, XTF_LOAD_MUST_SUCCEED);
+			xtables_find_target(cs.jumpto, XTF_LOAD_MUST_SUCCEED);
 		} else {
 			e = generate_entry(&cs.fw6, cs.matches, cs.target->t);
 			free(cs.target->t);
diff --git a/iptables.c b/iptables.c
index 96732b4..354bc9c 100644
--- a/iptables.c
+++ b/iptables.c
@@ -1328,6 +1328,34 @@ static void command_default(struct iptables_command_state *cs)
 	xtables_error(PARAMETER_PROBLEM, "Unknown arg \"%s\"", optarg);
 }
 
+static void command_jump(struct iptables_command_state *cs)
+{
+	size_t size;
+
+	set_option(&cs->options, OPT_JUMP, &cs->fw.ip.invflags, cs->invert);
+	cs->jumpto = parse_target(optarg);
+	/* TRY_LOAD (may be chain name) */
+	cs->target = xtables_find_target(cs->jumpto, XTF_TRY_LOAD);
+
+	if (cs->target == NULL)
+		return;
+
+	size = IPT_ALIGN(sizeof(struct ipt_entry_target))
+		+ cs->target->size;
+
+	cs->target->t = xtables_calloc(1, size);
+	cs->target->t->u.target_size = size;
+	strcpy(cs->target->t->u.user.name, cs->jumpto);
+	cs->target->t->u.user.revision = cs->target->revision;
+	if (cs->target->init != NULL)
+		cs->target->init(cs->target->t);
+	opts = xtables_merge_options(iptables_globals.orig_opts, opts,
+				     cs->target->extra_opts,
+				     &cs->target->option_offset);
+	if (opts == NULL)
+		xtables_error(OTHER_PROBLEM, "can't alloc memory!");
+}
+
 int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle)
 {
 	struct iptables_command_state cs;
@@ -1346,10 +1374,10 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 	struct xtables_match *m;
 	struct xtables_rule_match *matchp;
 	struct xtables_target *t;
-	const char *jumpto = "";
 	unsigned long long cnt;
 
 	memset(&cs, 0, sizeof(cs));
+	cs.jumpto = "";
 	cs.argv = argv;
 
 	/* re-set optind to 0 in case do_command gets called
@@ -1566,38 +1594,12 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 			set_option(&cs.options, OPT_JUMP, &cs.fw.ip.invflags,
 				   cs.invert);
 			cs.fw.ip.flags |= IPT_F_GOTO;
-			jumpto = parse_target(optarg);
+			cs.jumpto = parse_target(optarg);
 			break;
 #endif
 
 		case 'j':
-			set_option(&cs.options, OPT_JUMP, &cs.fw.ip.invflags,
-				   cs.invert);
-			jumpto = parse_target(optarg);
-			/* TRY_LOAD (may be chain name) */
-			cs.target = xtables_find_target(jumpto, XTF_TRY_LOAD);
-
-			if (cs.target) {
-				size_t size;
-
-				size = IPT_ALIGN(sizeof(struct ipt_entry_target))
-					+ cs.target->size;
-
-				cs.target->t = xtables_calloc(1, size);
-				cs.target->t->u.target_size = size;
-				strcpy(cs.target->t->u.user.name, jumpto);
-				cs.target->t->u.user.revision = cs.target->revision;
-				if (cs.target->init != NULL)
-					cs.target->init(cs.target->t);
-				opts = xtables_merge_options(
-						     iptables_globals.orig_opts,
-						     opts,
-						     cs.target->extra_opts,
-						     &cs.target->option_offset);
-				if (opts == NULL)
-					xtables_error(OTHER_PROBLEM,
-						   "can't alloc memory!");
-			}
+			command_jump(&cs);
 			break;
 
 
@@ -1757,7 +1759,7 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 
 	if (strcmp(*table, "nat") == 0 &&
 	    ((policy != NULL && strcmp(policy, "DROP") == 0) ||
-	    (jumpto != NULL && strcmp(jumpto, "DROP") == 0)))
+	    (cs.jumpto != NULL && strcmp(cs.jumpto, "DROP") == 0)))
 		xtables_error(PARAMETER_PROBLEM,
 			"\nThe \"nat\" table is not intended for filtering, "
 		        "the use of DROP is therefore inhibited.\n\n");
@@ -1848,10 +1850,10 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 					   chain);
 		}
 
-		if (cs.target && iptc_is_chain(jumpto, *handle)) {
+		if (cs.target && iptc_is_chain(cs.jumpto, *handle)) {
 			fprintf(stderr,
 				"Warning: using chain %s, not extension\n",
-				jumpto);
+				cs.jumpto);
 
 			if (cs.target->t)
 				free(cs.target->t);
@@ -1862,8 +1864,8 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 		/* If they didn't specify a target, or it's a chain
 		   name, use standard. */
 		if (!cs.target
-		    && (strlen(jumpto) == 0
-			|| iptc_is_chain(jumpto, *handle))) {
+		    && (strlen(cs.jumpto) == 0
+			|| iptc_is_chain(cs.jumpto, *handle))) {
 			size_t size;
 
 			cs.target = xtables_find_target(IPT_STANDARD_TARGET,
@@ -1873,8 +1875,8 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 				+ cs.target->size;
 			cs.target->t = xtables_calloc(1, size);
 			cs.target->t->u.target_size = size;
-			strcpy(cs.target->t->u.user.name, jumpto);
-			if (!iptc_is_chain(jumpto, *handle))
+			strcpy(cs.target->t->u.user.name, cs.jumpto);
+			if (!iptc_is_chain(cs.jumpto, *handle))
 				cs.target->t->u.user.revision = cs.target->revision;
 			if (cs.target->init != NULL)
 				cs.target->init(cs.target->t);
@@ -1888,9 +1890,10 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 #ifdef IPT_F_GOTO
 			if (cs.fw.ip.flags & IPT_F_GOTO)
 				xtables_error(PARAMETER_PROBLEM,
-					   "goto '%s' is not a chain\n", jumpto);
+					   "goto '%s' is not a chain\n",
+					   cs.jumpto);
 #endif
-			xtables_find_target(jumpto, XTF_LOAD_MUST_SUCCEED);
+			xtables_find_target(cs.jumpto, XTF_LOAD_MUST_SUCCEED);
 		} else {
 			e = generate_entry(&cs.fw, cs.matches, cs.target->t);
 			free(cs.target->t);
diff --git a/xshared.h b/xshared.h
index d0cb516..a08e6d9 100644
--- a/xshared.h
+++ b/xshared.h
@@ -35,6 +35,7 @@ struct iptables_command_state {
 	struct xtables_target *target;
 	char *protocol;
 	int proto_used;
+	const char *jumpto;
 	char **argv;
 };
 
-- 
1.7.1

