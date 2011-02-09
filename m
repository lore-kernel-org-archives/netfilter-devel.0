From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 02/11] src: move large default: block from do_command6 into its own function
Date: Wed,  9 Feb 2011 02:48:47 +0100
Message-ID: <1297216137-18505-3-git-send-email-jengelh@medozas.de>
References: <1297216137-18505-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:38712 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755205Ab1BIBtE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Feb 2011 20:49:04 -0500
In-Reply-To: <1297216137-18505-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 ip6tables.c |  209 ++++++++++++++++++++++++++++++---------------------------
 iptables.c  |  219 +++++++++++++++++++++++++++++++----------------------------
 2 files changed, 225 insertions(+), 203 deletions(-)

diff --git a/ip6tables.c b/ip6tables.c
index cb9e1f5..947f3c9 100644
--- a/ip6tables.c
+++ b/ip6tables.c
@@ -1297,8 +1297,115 @@ struct iptables_command_state {
 	struct xtables_target *target;
 	char *protocol;
 	int proto_used;
+	char **argv;
 };
 
+static void command_default(struct iptables_command_state *cs)
+{
+	struct xtables_rule_match *matchp;
+	struct xtables_match *m;
+
+	if (cs->target == NULL || cs->target->parse == NULL ||
+	    cs->c < cs->target->option_offset ||
+	    cs->c >= cs->target->option_offset + XT_OPTION_OFFSET_SCALE ||
+	    !cs->target->parse(cs->c - cs->target->option_offset,
+			       cs->argv, cs->invert,
+			       &cs->target->tflags,
+			       &cs->fw, &cs->target->t)) {
+		for (matchp = cs->matches; matchp; matchp = matchp->next) {
+			if (matchp->completed ||
+			    matchp->match->parse == NULL)
+				continue;
+			if (cs->c < matchp->match->option_offset ||
+			    cs->c >= matchp->match->option_offset + XT_OPTION_OFFSET_SCALE)
+				continue;
+			if (matchp->match->parse(cs->c - matchp->match->option_offset,
+				     cs->argv, cs->invert,
+				     &matchp->match->mflags,
+				     &cs->fw,
+				     &matchp->match->m))
+				break;
+		}
+		m = matchp ? matchp->match : NULL;
+
+		/* If you listen carefully, you can
+		   actually hear this code suck. */
+
+		/* some explanations (after four different bugs
+		 * in 3 different releases): If we encounter a
+		 * parameter, that has not been parsed yet,
+		 * it's not an option of an explicitly loaded
+		 * match or a target.  However, we support
+		 * implicit loading of the protocol match
+		 * extension.  '-p tcp' means 'l4 proto 6' and
+		 * at the same time 'load tcp protocol match on
+		 * demand if we specify --dport'.
+		 *
+		 * To make this work, we need to make sure:
+		 * - the parameter has not been parsed by
+		 *   a match (m above)
+		 * - a protocol has been specified
+		 * - the protocol extension has not been
+		 *   loaded yet, or is loaded and unused
+		 *   [think of ip6tables-restore!]
+		 * - the protocol extension can be successively
+		 *   loaded
+		 */
+		if (m == NULL
+		    && cs->protocol
+		    && (!find_proto(cs->protocol, XTF_DONT_LOAD,
+				   cs->options&OPT_NUMERIC, NULL)
+			|| (find_proto(cs->protocol, XTF_DONT_LOAD,
+					cs->options&OPT_NUMERIC, NULL)
+			    && (cs->proto_used == 0))
+		       )
+		    && (m = find_proto(cs->protocol, XTF_TRY_LOAD,
+				       cs->options&OPT_NUMERIC, &cs->matches))) {
+			/* Try loading protocol */
+			size_t size;
+
+			cs->proto_used = 1;
+
+			size = IP6T_ALIGN(sizeof(struct ip6t_entry_match))
+					 + m->size;
+
+			m->m = xtables_calloc(1, size);
+			m->m->u.match_size = size;
+			strcpy(m->m->u.user.name, m->name);
+			m->m->u.user.revision = m->revision;
+			if (m->init != NULL)
+				m->init(m->m);
+
+			opts = xtables_merge_options(ip6tables_globals.orig_opts, opts,
+			    m->extra_opts, &m->option_offset);
+
+			optind--;
+			return;
+		}
+
+		if (!m) {
+			if (cs->c == '?') {
+				if (optopt) {
+					xtables_error(
+					   PARAMETER_PROBLEM,
+					   "option `%s' "
+					   "requires an "
+					   "argument",
+					   cs->argv[optind-1]);
+				} else {
+					xtables_error(
+					   PARAMETER_PROBLEM,
+					   "unknown option "
+					   "`%s'",
+					   cs->argv[optind-1]);
+				}
+			}
+			xtables_error(PARAMETER_PROBLEM,
+				   "Unknown arg `%s'", optarg);
+		}
+	}
+}
+
 int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **handle)
 {
 	struct iptables_command_state cs;
@@ -1321,6 +1428,7 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 	unsigned long long cnt;
 
 	memset(&cs, 0, sizeof(cs));
+	cs.argv = argv;
 
 	/* re-set optind to 0 in case do_command gets called
 	 * a second time */
@@ -1710,105 +1818,8 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 			exit_tryhelp(2);
 
 		default:
-			if (cs.target == NULL || cs.target->parse == NULL ||
-			    cs.c < cs.target->option_offset ||
-			    cs.c >= cs.target->option_offset + XT_OPTION_OFFSET_SCALE ||
-			    !cs.target->parse(cs.c - cs.target->option_offset,
-					       argv, cs.invert,
-					       &cs.target->tflags,
-					       &cs.fw, &cs.target->t)) {
-				for (matchp = cs.matches; matchp; matchp = matchp->next) {
-					if (matchp->completed ||
-					    matchp->match->parse == NULL)
-						continue;
-					if (cs.c < matchp->match->option_offset ||
-					    cs.c >= matchp->match->option_offset + XT_OPTION_OFFSET_SCALE)
-						continue;
-					if (matchp->match->parse(cs.c - matchp->match->option_offset,
-						     argv, cs.invert,
-						     &matchp->match->mflags,
-						     &cs.fw,
-						     &matchp->match->m))
-						break;
-				}
-				m = matchp ? matchp->match : NULL;
-
-				/* If you listen carefully, you can
-				   actually hear this code suck. */
-
-				/* some explanations (after four different bugs
-				 * in 3 different releases): If we encounter a
-				 * parameter, that has not been parsed yet,
-				 * it's not an option of an explicitly loaded
-				 * match or a target.  However, we support
-				 * implicit loading of the protocol match
-				 * extension.  '-p tcp' means 'l4 proto 6' and
-				 * at the same time 'load tcp protocol match on
-				 * demand if we specify --dport'.
-				 *
-				 * To make this work, we need to make sure:
-				 * - the parameter has not been parsed by
-				 *   a match (m above)
-				 * - a protocol has been specified
-				 * - the protocol extension has not been
-				 *   loaded yet, or is loaded and unused
-				 *   [think of ip6tables-restore!]
-				 * - the protocol extension can be successively
-				 *   loaded
-				 */
-				if (m == NULL
-				    && cs.protocol
-				    && (!find_proto(cs.protocol, XTF_DONT_LOAD,
-						   cs.options&OPT_NUMERIC, NULL)
-					|| (find_proto(cs.protocol, XTF_DONT_LOAD,
-							cs.options&OPT_NUMERIC, NULL)
-					    && (cs.proto_used == 0))
-				       )
-				    && (m = find_proto(cs.protocol, XTF_TRY_LOAD,
-						       cs.options&OPT_NUMERIC, &cs.matches))) {
-					/* Try loading protocol */
-					size_t size;
-
-					cs.proto_used = 1;
-
-					size = IP6T_ALIGN(sizeof(struct ip6t_entry_match))
-							 + m->size;
-
-					m->m = xtables_calloc(1, size);
-					m->m->u.match_size = size;
-					strcpy(m->m->u.user.name, m->name);
-					m->m->u.user.revision = m->revision;
-					if (m->init != NULL)
-						m->init(m->m);
-
-					opts = xtables_merge_options(ip6tables_globals.orig_opts, opts,
-					    m->extra_opts, &m->option_offset);
-
-					optind--;
-					continue;
-				}
-
-				if (!m) {
-					if (cs.c == '?') {
-						if (optopt) {
-							xtables_error(
-							   PARAMETER_PROBLEM,
-							   "option `%s' "
-							   "requires an "
-							   "argument",
-							   argv[optind-1]);
-						} else {
-							xtables_error(
-							   PARAMETER_PROBLEM,
-							   "unknown option "
-							   "`%s'",
-							   argv[optind-1]);
-						}
-					}
-					xtables_error(PARAMETER_PROBLEM,
-						   "Unknown arg `%s'", optarg);
-				}
-			}
+			command_default(&cs);
+			break;
 		}
 		cs.invert = FALSE;
 	}
diff --git a/iptables.c b/iptables.c
index 5f62ae5..4303cdf 100644
--- a/iptables.c
+++ b/iptables.c
@@ -1320,8 +1320,120 @@ struct iptables_command_state {
 	struct xtables_target *target;
 	char *protocol;
 	int proto_used;
+	char **argv;
 };
 
+static void command_default(struct iptables_command_state *cs)
+{
+	struct xtables_rule_match *matchp;
+	struct xtables_match *m;
+
+	if (cs->target == NULL || cs->target->parse == NULL ||
+	    cs->c < cs->target->option_offset ||
+	    cs->c >= cs->target->option_offset + XT_OPTION_OFFSET_SCALE ||
+	    !cs->target->parse(cs->c - cs->target->option_offset,
+			       cs->argv, cs->invert,
+			       &cs->target->tflags,
+			       &cs->fw, &cs->target->t)) {
+		for (matchp = cs->matches; matchp; matchp = matchp->next) {
+			if (matchp->completed ||
+			    matchp->match->parse == NULL)
+				continue;
+			if (cs->c < matchp->match->option_offset ||
+			    cs->c >= matchp->match->option_offset + XT_OPTION_OFFSET_SCALE)
+				continue;
+			if (matchp->match->parse(cs->c - matchp->match->option_offset,
+				     cs->argv, cs->invert,
+				     &matchp->match->mflags,
+				     &cs->fw,
+				     &matchp->match->m))
+				break;
+		}
+		m = matchp ? matchp->match : NULL;
+
+		/* If you listen carefully, you can
+		   actually hear this code suck. */
+
+		/* some explanations (after four different bugs
+		 * in 3 different releases): If we encounter a
+		 * parameter, that has not been parsed yet,
+		 * it's not an option of an explicitly loaded
+		 * match or a target.  However, we support
+		 * implicit loading of the protocol match
+		 * extension.  '-p tcp' means 'l4 proto 6' and
+		 * at the same time 'load tcp protocol match on
+		 * demand if we specify --dport'.
+		 *
+		 * To make this work, we need to make sure:
+		 * - the parameter has not been parsed by
+		 *   a match (m above)
+		 * - a protocol has been specified
+		 * - the protocol extension has not been
+		 *   loaded yet, or is loaded and unused
+		 *   [think of iptables-restore!]
+		 * - the protocol extension can be successively
+		 *   loaded
+		 */
+		if (m == NULL
+		    && cs->protocol
+		    && (!find_proto(cs->protocol, XTF_DONT_LOAD,
+				   cs->options&OPT_NUMERIC, NULL)
+			|| (find_proto(cs->protocol, XTF_DONT_LOAD,
+					cs->options&OPT_NUMERIC, NULL)
+			    && (cs->proto_used == 0))
+		       )
+		    && (m = find_proto(cs->protocol, XTF_TRY_LOAD,
+				       cs->options&OPT_NUMERIC, &cs->matches))) {
+			/* Try loading protocol */
+			size_t size;
+
+			cs->proto_used = 1;
+
+			size = IPT_ALIGN(sizeof(struct ipt_entry_match))
+					 + m->size;
+
+			m->m = xtables_calloc(1, size);
+			m->m->u.match_size = size;
+			strcpy(m->m->u.user.name, m->name);
+			m->m->u.user.revision = m->revision;
+			if (m->init != NULL)
+				m->init(m->m);
+
+			opts = xtables_merge_options(
+					     iptables_globals.orig_opts,
+					     opts,
+					     m->extra_opts,
+					     &m->option_offset);
+			if (opts == NULL)
+				xtables_error(OTHER_PROBLEM,
+					"can't alloc memory!");
+
+			optind--;
+			return;
+		}
+		if (!m) {
+			if (cs->c == '?') {
+				if (optopt) {
+					xtables_error(
+					   PARAMETER_PROBLEM,
+					   "option `%s' "
+					   "requires an "
+					   "argument",
+					   cs->argv[optind-1]);
+				} else {
+					xtables_error(
+					   PARAMETER_PROBLEM,
+					   "unknown option "
+					   "`%s'",
+					   cs->argv[optind-1]);
+				}
+			}
+			xtables_error(PARAMETER_PROBLEM,
+				   "Unknown arg `%s'", optarg);
+		}
+	}
+}
+
 int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle)
 {
 	struct iptables_command_state cs;
@@ -1344,6 +1456,7 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 	unsigned long long cnt;
 
 	memset(&cs, 0, sizeof(cs));
+	cs.argv = argv;
 
 	/* re-set optind to 0 in case do_command gets called
 	 * a second time */
@@ -1742,110 +1855,8 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 			exit_tryhelp(2);
 
 		default:
-			if (cs.target == NULL || cs.target->parse == NULL ||
-			    cs.c < cs.target->option_offset ||
-			    cs.c >= cs.target->option_offset + XT_OPTION_OFFSET_SCALE ||
-			    !cs.target->parse(cs.c - cs.target->option_offset,
-					       argv, cs.invert,
-					       &cs.target->tflags,
-					       &cs.fw, &cs.target->t)) {
-				for (matchp = cs.matches; matchp; matchp = matchp->next) {
-					if (matchp->completed ||
-					    matchp->match->parse == NULL)
-						continue;
-					if (cs.c < matchp->match->option_offset ||
-					    cs.c >= matchp->match->option_offset + XT_OPTION_OFFSET_SCALE)
-						continue;
-					if (matchp->match->parse(cs.c - matchp->match->option_offset,
-						     argv, cs.invert,
-						     &matchp->match->mflags,
-						     &cs.fw,
-						     &matchp->match->m))
-						break;
-				}
-				m = matchp ? matchp->match : NULL;
-
-				/* If you listen carefully, you can
-				   actually hear this code suck. */
-
-				/* some explanations (after four different bugs
-				 * in 3 different releases): If we encounter a
-				 * parameter, that has not been parsed yet,
-				 * it's not an option of an explicitly loaded
-				 * match or a target.  However, we support
-				 * implicit loading of the protocol match
-				 * extension.  '-p tcp' means 'l4 proto 6' and
-				 * at the same time 'load tcp protocol match on
-				 * demand if we specify --dport'.
-				 *
-				 * To make this work, we need to make sure:
-				 * - the parameter has not been parsed by
-				 *   a match (m above)
-				 * - a protocol has been specified
-				 * - the protocol extension has not been
-				 *   loaded yet, or is loaded and unused
-				 *   [think of iptables-restore!]
-				 * - the protocol extension can be successively
-				 *   loaded
-				 */
-				if (m == NULL
-				    && cs.protocol
-				    && (!find_proto(cs.protocol, XTF_DONT_LOAD,
-						   cs.options&OPT_NUMERIC, NULL)
-					|| (find_proto(cs.protocol, XTF_DONT_LOAD,
-							cs.options&OPT_NUMERIC, NULL)
-					    && (cs.proto_used == 0))
-				       )
-				    && (m = find_proto(cs.protocol, XTF_TRY_LOAD,
-						       cs.options&OPT_NUMERIC, &cs.matches))) {
-					/* Try loading protocol */
-					size_t size;
-
-					cs.proto_used = 1;
-
-					size = IPT_ALIGN(sizeof(struct ipt_entry_match))
-							 + m->size;
-
-					m->m = xtables_calloc(1, size);
-					m->m->u.match_size = size;
-					strcpy(m->m->u.user.name, m->name);
-					m->m->u.user.revision = m->revision;
-					if (m->init != NULL)
-						m->init(m->m);
-
-					opts = xtables_merge_options(
-							     iptables_globals.orig_opts,
-							     opts,
-							     m->extra_opts,
-							     &m->option_offset);
-					if (opts == NULL)
-						xtables_error(OTHER_PROBLEM,
-							"can't alloc memory!");
-
-					optind--;
-					continue;
-				}
-				if (!m) {
-					if (cs.c == '?') {
-						if (optopt) {
-							xtables_error(
-							   PARAMETER_PROBLEM,
-							   "option `%s' "
-							   "requires an "
-							   "argument",
-							   argv[optind-1]);
-						} else {
-							xtables_error(
-							   PARAMETER_PROBLEM,
-							   "unknown option "
-							   "`%s'",
-							   argv[optind-1]);
-						}
-					}
-					xtables_error(PARAMETER_PROBLEM,
-						   "Unknown arg `%s'", optarg);
-				}
-			}
+			command_default(&cs);
+			break;
 		}
 		cs.invert = FALSE;
 	}
-- 
1.7.1

