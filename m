From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 1/8] iptables: reduce indentation of parse loop (1/3)
Date: Fri,  4 Feb 2011 14:08:47 +0100
Message-ID: <1296824935-4606-2-git-send-email-jengelh@medozas.de>
References: <1296824935-4606-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:36763 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752223Ab1BDNI6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 4 Feb 2011 08:08:58 -0500
In-Reply-To: <1296824935-4606-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Trying to make this code suck less by using early
exclusion/break/return.

References: http://iq0.com/notes/deep.nesting.html
Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 ip6tables.c |  184 ++++++++++++++++++++++++++++----------------------------
 iptables.c  |  196 +++++++++++++++++++++++++++++-----------------------------
 2 files changed, 190 insertions(+), 190 deletions(-)

diff --git a/ip6tables.c b/ip6tables.c
index 8c1b504..d453868 100644
--- a/ip6tables.c
+++ b/ip6tables.c
@@ -1703,104 +1703,104 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 			exit_tryhelp(2);
 
 		default:
-			if (target == NULL || target->parse == NULL ||
-			    c < target->option_offset ||
-			    c >= target->option_offset + XT_OPTION_OFFSET_SCALE ||
-			    !target->parse(c - target->option_offset,
+			if (target != NULL && target->parse != NULL &&
+			    c >= target->option_offset &&
+			    c < target->option_offset + XT_OPTION_OFFSET_SCALE &&
+			    target->parse(c - target->option_offset,
 					       argv, invert,
 					       &target->tflags,
-					       &fw, &target->t)) {
-				for (matchp = matches; matchp; matchp = matchp->next) {
-					if (matchp->completed ||
-					    matchp->match->parse == NULL)
-						continue;
-					if (c < matchp->match->option_offset ||
-					    c >= matchp->match->option_offset + XT_OPTION_OFFSET_SCALE)
-						continue;
-					if (matchp->match->parse(c - matchp->match->option_offset,
-						     argv, invert,
-						     &matchp->match->mflags,
-						     &fw,
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
-				    && protocol
-				    && (!find_proto(protocol, XTF_DONT_LOAD,
-						   options&OPT_NUMERIC, NULL)
-					|| (find_proto(protocol, XTF_DONT_LOAD,
-							options&OPT_NUMERIC, NULL)
-					    && (proto_used == 0))
-				       )
-				    && (m = find_proto(protocol, XTF_TRY_LOAD,
-						       options&OPT_NUMERIC, &matches))) {
-					/* Try loading protocol */
-					size_t size;
-
-					proto_used = 1;
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
+					       &fw, &target->t))
+				break;
+			for (matchp = matches; matchp; matchp = matchp->next) {
+				if (matchp->completed ||
+				    matchp->match->parse == NULL)
 					continue;
-				}
+				if (c < matchp->match->option_offset ||
+				    c >= matchp->match->option_offset + XT_OPTION_OFFSET_SCALE)
+					continue;
+				if (matchp->match->parse(c - matchp->match->option_offset,
+					     argv, invert,
+					     &matchp->match->mflags,
+					     &fw,
+					     &matchp->match->m))
+					break;
+			}
+			m = matchp ? matchp->match : NULL;
+
+			/* If you listen carefully, you can
+			   actually hear this code suck. */
+
+			/* some explanations (after four different bugs
+			 * in 3 different releases): If we encounter a
+			 * parameter, that has not been parsed yet,
+			 * it's not an option of an explicitly loaded
+			 * match or a target.  However, we support
+			 * implicit loading of the protocol match
+			 * extension.  '-p tcp' means 'l4 proto 6' and
+			 * at the same time 'load tcp protocol match on
+			 * demand if we specify --dport'.
+			 *
+			 * To make this work, we need to make sure:
+			 * - the parameter has not been parsed by
+			 *   a match (m above)
+			 * - a protocol has been specified
+			 * - the protocol extension has not been
+			 *   loaded yet, or is loaded and unused
+			 *   [think of ip6tables-restore!]
+			 * - the protocol extension can be successively
+			 *   loaded
+			 */
+			if (m == NULL
+			    && protocol
+			    && (!find_proto(protocol, XTF_DONT_LOAD,
+					   options&OPT_NUMERIC, NULL)
+				|| (find_proto(protocol, XTF_DONT_LOAD,
+						options&OPT_NUMERIC, NULL)
+				    && (proto_used == 0))
+			       )
+			    && (m = find_proto(protocol, XTF_TRY_LOAD,
+					       options&OPT_NUMERIC, &matches))) {
+				/* Try loading protocol */
+				size_t size;
+
+				proto_used = 1;
+
+				size = IP6T_ALIGN(sizeof(struct ip6t_entry_match))
+						 + m->size;
 
-				if (!m) {
-					if (c == '?') {
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
+				m->m = xtables_calloc(1, size);
+				m->m->u.match_size = size;
+				strcpy(m->m->u.user.name, m->name);
+				m->m->u.user.revision = m->revision;
+				if (m->init != NULL)
+					m->init(m->m);
+
+				opts = xtables_merge_options(ip6tables_globals.orig_opts, opts,
+				    m->extra_opts, &m->option_offset);
+
+				optind--;
+				continue;
+			}
+
+			if (!m) {
+				if (c == '?') {
+					if (optopt) {
+						xtables_error(
+						   PARAMETER_PROBLEM,
+						   "option `%s' "
+						   "requires an "
+						   "argument",
+						   argv[optind-1]);
+					} else {
+						xtables_error(
+						   PARAMETER_PROBLEM,
+						   "unknown option "
+						   "`%s'",
+						   argv[optind-1]);
 					}
-					xtables_error(PARAMETER_PROBLEM,
-						   "Unknown arg `%s'", optarg);
 				}
+				xtables_error(PARAMETER_PROBLEM,
+					   "Unknown arg `%s'", optarg);
 			}
 		}
 		invert = FALSE;
diff --git a/iptables.c b/iptables.c
index 2459b64..eb7ac8e 100644
--- a/iptables.c
+++ b/iptables.c
@@ -1735,109 +1735,109 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 			exit_tryhelp(2);
 
 		default:
-			if (target == NULL || target->parse == NULL ||
-			    c < target->option_offset ||
-			    c >= target->option_offset + XT_OPTION_OFFSET_SCALE ||
-			    !target->parse(c - target->option_offset,
+			if (target != NULL && target->parse != NULL &&
+			    c >= target->option_offset &&
+			    c < target->option_offset + XT_OPTION_OFFSET_SCALE &&
+			    target->parse(c - target->option_offset,
 					       argv, invert,
 					       &target->tflags,
-					       &fw, &target->t)) {
-				for (matchp = matches; matchp; matchp = matchp->next) {
-					if (matchp->completed ||
-					    matchp->match->parse == NULL)
-						continue;
-					if (c < matchp->match->option_offset ||
-					    c >= matchp->match->option_offset + XT_OPTION_OFFSET_SCALE)
-						continue;
-					if (matchp->match->parse(c - matchp->match->option_offset,
-						     argv, invert,
-						     &matchp->match->mflags,
-						     &fw,
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
-				    && protocol
-				    && (!find_proto(protocol, XTF_DONT_LOAD,
-						   options&OPT_NUMERIC, NULL)
-					|| (find_proto(protocol, XTF_DONT_LOAD,
-							options&OPT_NUMERIC, NULL)
-					    && (proto_used == 0))
-				       )
-				    && (m = find_proto(protocol, XTF_TRY_LOAD,
-						       options&OPT_NUMERIC, &matches))) {
-					/* Try loading protocol */
-					size_t size;
-
-					proto_used = 1;
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
+					       &fw, &target->t))
+				break;
+			for (matchp = matches; matchp; matchp = matchp->next) {
+				if (matchp->completed ||
+				    matchp->match->parse == NULL)
 					continue;
-				}
-				if (!m) {
-					if (c == '?') {
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
+				if (c < matchp->match->option_offset ||
+				    c >= matchp->match->option_offset + XT_OPTION_OFFSET_SCALE)
+					continue;
+				if (matchp->match->parse(c - matchp->match->option_offset,
+					     argv, invert,
+					     &matchp->match->mflags,
+					     &fw,
+					     &matchp->match->m))
+					break;
+			}
+			m = matchp ? matchp->match : NULL;
+
+			/* If you listen carefully, you can
+			   actually hear this code suck. */
+
+			/* some explanations (after four different bugs
+			 * in 3 different releases): If we encounter a
+			 * parameter, that has not been parsed yet,
+			 * it's not an option of an explicitly loaded
+			 * match or a target.  However, we support
+			 * implicit loading of the protocol match
+			 * extension.  '-p tcp' means 'l4 proto 6' and
+			 * at the same time 'load tcp protocol match on
+			 * demand if we specify --dport'.
+			 *
+			 * To make this work, we need to make sure:
+			 * - the parameter has not been parsed by
+			 *   a match (m above)
+			 * - a protocol has been specified
+			 * - the protocol extension has not been
+			 *   loaded yet, or is loaded and unused
+			 *   [think of iptables-restore!]
+			 * - the protocol extension can be successively
+			 *   loaded
+			 */
+			if (m == NULL
+			    && protocol
+			    && (!find_proto(protocol, XTF_DONT_LOAD,
+					   options&OPT_NUMERIC, NULL)
+				|| (find_proto(protocol, XTF_DONT_LOAD,
+						options&OPT_NUMERIC, NULL)
+				    && (proto_used == 0))
+			       )
+			    && (m = find_proto(protocol, XTF_TRY_LOAD,
+					       options&OPT_NUMERIC, &matches))) {
+				/* Try loading protocol */
+				size_t size;
+
+				proto_used = 1;
+
+				size = IPT_ALIGN(sizeof(struct ipt_entry_match))
+						 + m->size;
+
+				m->m = xtables_calloc(1, size);
+				m->m->u.match_size = size;
+				strcpy(m->m->u.user.name, m->name);
+				m->m->u.user.revision = m->revision;
+				if (m->init != NULL)
+					m->init(m->m);
+
+				opts = xtables_merge_options(
+						     iptables_globals.orig_opts,
+						     opts,
+						     m->extra_opts,
+						     &m->option_offset);
+				if (opts == NULL)
+					xtables_error(OTHER_PROBLEM,
+						"can't alloc memory!");
+
+				optind--;
+				continue;
+			}
+			if (!m) {
+				if (c == '?') {
+					if (optopt) {
+						xtables_error(
+						   PARAMETER_PROBLEM,
+						   "option `%s' "
+						   "requires an "
+						   "argument",
+						   argv[optind-1]);
+					} else {
+						xtables_error(
+						   PARAMETER_PROBLEM,
+						   "unknown option "
+						   "`%s'",
+						   argv[optind-1]);
 					}
-					xtables_error(PARAMETER_PROBLEM,
-						   "Unknown arg `%s'", optarg);
 				}
+				xtables_error(PARAMETER_PROBLEM,
+					   "Unknown arg `%s'", optarg);
 			}
 		}
 		invert = FALSE;
-- 
1.7.1

