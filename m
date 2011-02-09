From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 10/11] src: move match option handling from do_command6 into its own functions
Date: Wed,  9 Feb 2011 02:48:55 +0100
Message-ID: <1297216137-18505-11-git-send-email-jengelh@medozas.de>
References: <1297216137-18505-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:38736 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756158Ab1BIBtL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Feb 2011 20:49:11 -0500
In-Reply-To: <1297216137-18505-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 ip6tables.c |   48 ++++++++++++++++++++++++++----------------------
 iptables.c  |   59 +++++++++++++++++++++++++++++------------------------------
 2 files changed, 55 insertions(+), 52 deletions(-)

diff --git a/ip6tables.c b/ip6tables.c
index eb28dc0..5a550bf 100644
--- a/ip6tables.c
+++ b/ip6tables.c
@@ -1329,6 +1329,29 @@ static void command_jump(struct iptables_command_state *cs)
 		xtables_error(OTHER_PROBLEM, "can't alloc memory!");
 }
 
+static void command_match(struct iptables_command_state *cs)
+{
+	struct xtables_match *m;
+	size_t size;
+
+	if (cs->invert)
+		xtables_error(PARAMETER_PROBLEM,
+			   "unexpected ! flag before --match");
+
+	m = xtables_find_match(optarg, XTF_LOAD_MUST_SUCCEED, &cs->matches);
+	size = IP6T_ALIGN(sizeof(struct ip6t_entry_match)) + m->size;
+	m->m = xtables_calloc(1, size);
+	m->m->u.match_size = size;
+	strcpy(m->m->u.user.name, m->name);
+	m->m->u.user.revision = m->revision;
+	if (m->init != NULL)
+		m->init(m->m);
+	if (m != m->next)
+		/* Merge options for non-cloned matches */
+		opts = xtables_merge_options(ip6tables_globals.orig_opts, opts,
+					     m->extra_opts, &m->option_offset);
+}
+
 int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **handle)
 {
 	struct iptables_command_state cs;
@@ -1617,28 +1640,9 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 			verbose++;
 			break;
 
-		case 'm': {
-			size_t size;
-
-			if (cs.invert)
-				xtables_error(PARAMETER_PROBLEM,
-					   "unexpected ! flag before --match");
-
-			m = xtables_find_match(optarg, XTF_LOAD_MUST_SUCCEED,
-			    &cs.matches);
-			size = IP6T_ALIGN(sizeof(struct ip6t_entry_match))
-					 + m->size;
-			m->m = xtables_calloc(1, size);
-			m->m->u.match_size = size;
-			strcpy(m->m->u.user.name, m->name);
-			m->m->u.user.revision = m->revision;
-			if (m->init != NULL)
-				m->init(m->m);
-			if (m != m->next)
-				/* Merge options for non-cloned matches */
-				opts = xtables_merge_options(ip6tables_globals.orig_opts, opts, m->extra_opts, &m->option_offset);
-		}
-		break;
+		case 'm':
+			command_match(&cs);
+			break;
 
 		case 'n':
 			set_option(&cs.options, OPT_NUMERIC, &cs.fw6.ipv6.invflags,
diff --git a/iptables.c b/iptables.c
index 354bc9c..6f5616b 100644
--- a/iptables.c
+++ b/iptables.c
@@ -1356,6 +1356,32 @@ static void command_jump(struct iptables_command_state *cs)
 		xtables_error(OTHER_PROBLEM, "can't alloc memory!");
 }
 
+static void command_match(struct iptables_command_state *cs)
+{
+	struct xtables_match *m;
+	size_t size;
+
+	if (cs->invert)
+		xtables_error(PARAMETER_PROBLEM,
+			   "unexpected ! flag before --match");
+
+	m = xtables_find_match(optarg, XTF_LOAD_MUST_SUCCEED, &cs->matches);
+	size = IPT_ALIGN(sizeof(struct ipt_entry_match)) + m->size;
+	m->m = xtables_calloc(1, size);
+	m->m->u.match_size = size;
+	strcpy(m->m->u.user.name, m->name);
+	m->m->u.user.revision = m->revision;
+	if (m->init != NULL)
+		m->init(m->m);
+	if (m != m->next) {
+		/* Merge options for non-cloned matches */
+		opts = xtables_merge_options(iptables_globals.orig_opts, opts,
+					     m->extra_opts, &m->option_offset);
+		if (opts == NULL)
+			xtables_error(OTHER_PROBLEM, "can't alloc memory!");
+	}
+}
+
 int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle)
 {
 	struct iptables_command_state cs;
@@ -1642,36 +1668,9 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 			verbose++;
 			break;
 
-		case 'm': {
-			size_t size;
-
-			if (cs.invert)
-				xtables_error(PARAMETER_PROBLEM,
-					   "unexpected ! flag before --match");
-
-			m = xtables_find_match(optarg, XTF_LOAD_MUST_SUCCEED,
-			    &cs.matches);
-			size = IPT_ALIGN(sizeof(struct ipt_entry_match))
-					 + m->size;
-			m->m = xtables_calloc(1, size);
-			m->m->u.match_size = size;
-			strcpy(m->m->u.user.name, m->name);
-			m->m->u.user.revision = m->revision;
-			if (m->init != NULL)
-				m->init(m->m);
-			if (m != m->next) {
-				/* Merge options for non-cloned matches */
-				opts = xtables_merge_options(
-						     iptables_globals.orig_opts,
-						     opts,
-						     m->extra_opts,
-						     &m->option_offset);
-				if (opts == NULL)
-					xtables_error(OTHER_PROBLEM,
-						   "can't alloc memory!");
-			}
-		}
-		break;
+		case 'm':
+			command_match(&cs);
+			break;
 
 		case 'n':
 			set_option(&cs.options, OPT_NUMERIC, &cs.fw.ip.invflags,
-- 
1.7.1

