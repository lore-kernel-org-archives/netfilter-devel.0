From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 4/8] iptables: reduce indentation of parse loop (3/3)
Date: Fri,  4 Feb 2011 14:08:50 +0100
Message-ID: <1296824935-4606-5-git-send-email-jengelh@medozas.de>
References: <1296824935-4606-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:36773 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752350Ab1BDNJB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 4 Feb 2011 08:09:01 -0500
In-Reply-To: <1296824935-4606-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Put the default case into its own function. Essentially, 5 levels of
indentation have been stripped, and this is surely a result that looks
a lot better than it did before.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 ip6tables.c |  190 ++++++++++++++++++++++++++-------------------------------
 iptables.c  |  196 ++++++++++++++++++++++++++--------------------------------
 2 files changed, 176 insertions(+), 210 deletions(-)

diff --git a/ip6tables.c b/ip6tables.c
index caee730..fb3b320 100644
--- a/ip6tables.c
+++ b/ip6tables.c
@@ -1288,6 +1288,88 @@ static void clear_rule_matches(struct xtables_rule_match **matches)
 	*matches = NULL;
 }
 
+static void
+command_default(int c, char **argv, bool invert, struct ip6t_entry *fw,
+		const char *protocol, bool *proto_used, unsigned int options,
+		struct xtables_target *target,
+		struct xtables_rule_match **matches)
+{
+	struct xtables_rule_match *matchp;
+	struct xtables_match *m;
+
+	if (target != NULL && target->parse != NULL &&
+	    c >= target->option_offset &&
+	    c < target->option_offset + XT_OPTION_OFFSET_SCALE)
+		if (target->parse(c - target->option_offset, argv, invert,
+		    &target->tflags, fw, &target->t))
+			return;
+
+	for (matchp = *matches; matchp != NULL; matchp = matchp->next) {
+		m = matchp->match;
+
+		if (matchp->completed || m->parse == NULL)
+			continue;
+		if (c < m->option_offset ||
+		    c >= m->option_offset + XT_OPTION_OFFSET_SCALE)
+			continue;
+		if (m->parse(c - matchp->match->option_offset,
+		    argv, invert, &matchp->match->mflags, fw,
+		    &matchp->match->m))
+			return;
+	}
+
+	/*
+	 * If you listen carefully, you can actually hear this code suck.
+	 *
+	 * Some explanations (after four different bugs in 3 different
+	 * releases): If we encounter a parameter, that has not been parsed
+	 * yet, it's not an option of an explicitly loaded match or a target.
+	 * However, we support implicit loading of the protocol match
+	 * extension. '-p tcp' means 'l4 proto 6' and at the same time 'load
+	 * tcp protocol match on demand if we specify --dport'.
+	 *
+	 * To make this work, we need to make sure:
+	 * - the parameter has not been parsed by a match (m above)
+	 * - a protocol has been specified
+	 * - the protocol extension has not been loaded yet, or is loaded and
+	 *   unused [think of iptables-restore!]
+	 * - the protocol extension can be successively loaded
+	 */
+	if (m == NULL && protocol != NULL &&
+	    (!find_proto(protocol, XTF_DONT_LOAD, options & OPT_NUMERIC, NULL) ||
+	     (find_proto(protocol, XTF_DONT_LOAD, options & OPT_NUMERIC, NULL) && !*proto_used)) &&
+	    (m = find_proto(protocol, XTF_TRY_LOAD, options & OPT_NUMERIC, matches))) {
+		/* Try loading protocol */
+		size_t size;
+
+		*proto_used = true;
+		size = IP6T_ALIGN(sizeof(struct ip6t_entry_match)) + m->size;
+
+		m->m = xtables_calloc(1, size);
+		m->m->u.match_size = size;
+		strcpy(m->m->u.user.name, m->name);
+		m->m->u.user.revision = m->revision;
+		if (m->init != NULL)
+			m->init(m->m);
+
+		opts = xtables_merge_options(ip6tables_globals.orig_opts, opts,
+					     m->extra_opts, &m->option_offset);
+		if (opts == NULL)
+			xtables_error(OTHER_PROBLEM, "can't alloc memory!");
+		optind--;
+		return;
+	}
+	if (c == '?') {
+		if (optopt)
+			xtables_error(PARAMETER_PROBLEM, "option \"%s\" "
+			              "requires an argument", argv[optind-1]);
+		else
+			xtables_error(PARAMETER_PROBLEM, "unknown option "
+				      "\"%s\"", optarg);
+	}
+	xtables_error(PARAMETER_PROBLEM, "Unknown arg \"%s\"", argv[optind-1]);
+}
+
 int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **handle)
 {
 	struct ip6t_entry fw, *e = NULL;
@@ -1310,7 +1392,7 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 	struct xtables_target *t;
 	const char *jumpto = "";
 	char *protocol = NULL;
-	int proto_used = 0;
+	bool proto_used = false;
 	unsigned long long cnt;
 
 	memset(&fw, 0, sizeof(fw));
@@ -1702,107 +1784,11 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 			fprintf(stderr, "Bad argument `%s'\n", optarg);
 			exit_tryhelp(2);
 
-		default: {
-			bool stop = false;
-
-			if (target != NULL && target->parse != NULL &&
-			    c >= target->option_offset &&
-			    c < target->option_offset + XT_OPTION_OFFSET_SCALE &&
-			    target->parse(c - target->option_offset,
-					       argv, invert,
-					       &target->tflags,
-					       &fw, &target->t))
-				break;
-			for (matchp = matches; matchp; matchp = matchp->next) {
-				m = matchp->match;
-
-				if (matchp->completed || m->parse == NULL)
-					continue;
-				if (c < m->option_offset ||
-				    c >= m->option_offset + XT_OPTION_OFFSET_SCALE)
-					continue;
-				if (m->parse(c - matchp->match->option_offset,
-					     argv, invert, &m->mflags, &fw,
-					     &m->m)) {
-					stop = true;
-					break;
-				}
-			}
-			if (stop)
-				break;
-
-			/* If you listen carefully, you can
-			   actually hear this code suck. */
-
-			/* some explanations (after four different bugs
-			 * in 3 different releases): If we encounter a
-			 * parameter, that has not been parsed yet,
-			 * it's not an option of an explicitly loaded
-			 * match or a target.  However, we support
-			 * implicit loading of the protocol match
-			 * extension.  '-p tcp' means 'l4 proto 6' and
-			 * at the same time 'load tcp protocol match on
-			 * demand if we specify --dport'.
-			 *
-			 * To make this work, we need to make sure:
-			 * - the parameter has not been parsed by
-			 *   a match (m above)
-			 * - a protocol has been specified
-			 * - the protocol extension has not been
-			 *   loaded yet, or is loaded and unused
-			 *   [think of ip6tables-restore!]
-			 * - the protocol extension can be successively
-			 *   loaded
-			 */
-			if (protocol != NULL
-			    && (!find_proto(protocol, XTF_DONT_LOAD,
-					   options&OPT_NUMERIC, NULL)
-				|| (find_proto(protocol, XTF_DONT_LOAD,
-						options&OPT_NUMERIC, NULL)
-				    && (proto_used == 0))
-			       )
-			    && (m = find_proto(protocol, XTF_TRY_LOAD,
-					       options&OPT_NUMERIC, &matches))) {
-				/* Try loading protocol */
-				size_t size;
-
-				proto_used = 1;
-
-				size = IP6T_ALIGN(sizeof(struct ip6t_entry_match))
-						 + m->size;
-
-				m->m = xtables_calloc(1, size);
-				m->m->u.match_size = size;
-				strcpy(m->m->u.user.name, m->name);
-				m->m->u.user.revision = m->revision;
-				if (m->init != NULL)
-					m->init(m->m);
-
-				opts = xtables_merge_options(ip6tables_globals.orig_opts, opts,
-				    m->extra_opts, &m->option_offset);
-
-				optind--;
-				continue;
-			}
-			if (c == '?') {
-				if (optopt) {
-					xtables_error(
-					   PARAMETER_PROBLEM,
-					   "option `%s' "
-					   "requires an "
-					   "argument",
-					   argv[optind-1]);
-				} else {
-					xtables_error(
-					   PARAMETER_PROBLEM,
-					   "unknown option "
-					   "`%s'",
-					   argv[optind-1]);
-				}
-			}
-			xtables_error(PARAMETER_PROBLEM,
-				   "Unknown arg `%s'", optarg);
-		} /* default */
+		default:
+			command_default(c, argv, invert, &fw, protocol,
+					&proto_used, options,
+					target, &matches);
+			break;
 		}
 		invert = FALSE;
 	}
diff --git a/iptables.c b/iptables.c
index db8e136..9977634 100644
--- a/iptables.c
+++ b/iptables.c
@@ -1311,6 +1311,88 @@ get_kernel_version(void) {
 	kernel_version = LINUX_VERSION(x, y, z);
 }
 
+static void
+command_default(int c, char **argv, bool invert, struct ipt_entry *fw,
+		const char *protocol, bool *proto_used, unsigned int options,
+		struct xtables_target *target,
+		struct xtables_rule_match **matches)
+{
+	struct xtables_rule_match *matchp;
+	struct xtables_match *m;
+
+	if (target != NULL && target->parse != NULL &&
+	    c >= target->option_offset &&
+	    c < target->option_offset + XT_OPTION_OFFSET_SCALE)
+		if (target->parse(c - target->option_offset, argv, invert,
+		    &target->tflags, fw, &target->t))
+			return;
+
+	for (matchp = *matches; matchp != NULL; matchp = matchp->next) {
+		m = matchp->match;
+
+		if (matchp->completed || m->parse == NULL)
+			continue;
+		if (c < m->option_offset ||
+		    c >= m->option_offset + XT_OPTION_OFFSET_SCALE)
+			continue;
+		if (m->parse(c - matchp->match->option_offset,
+		    argv, invert, &matchp->match->mflags, fw,
+		    &matchp->match->m))
+			return;
+	}
+
+	/*
+	 * If you listen carefully, you can actually hear this code suck.
+	 *
+	 * Some explanations (after four different bugs in 3 different
+	 * releases): If we encounter a parameter, that has not been parsed
+	 * yet, it's not an option of an explicitly loaded match or a target.
+	 * However, we support implicit loading of the protocol match
+	 * extension. '-p tcp' means 'l4 proto 6' and at the same time 'load
+	 * tcp protocol match on demand if we specify --dport'.
+	 *
+	 * To make this work, we need to make sure:
+	 * - the parameter has not been parsed by a match (m above)
+	 * - a protocol has been specified
+	 * - the protocol extension has not been loaded yet, or is loaded and
+	 *   unused [think of iptables-restore!]
+	 * - the protocol extension can be successively loaded
+	 */
+	if (m == NULL && protocol != NULL &&
+	    (!find_proto(protocol, XTF_DONT_LOAD, options & OPT_NUMERIC, NULL) ||
+	     (find_proto(protocol, XTF_DONT_LOAD, options & OPT_NUMERIC, NULL) && !*proto_used)) &&
+	    (m = find_proto(protocol, XTF_TRY_LOAD, options & OPT_NUMERIC, matches))) {
+		/* Try loading protocol */
+		size_t size;
+
+		*proto_used = true;
+		size = IPT_ALIGN(sizeof(struct ipt_entry_match)) + m->size;
+
+		m->m = xtables_calloc(1, size);
+		m->m->u.match_size = size;
+		strcpy(m->m->u.user.name, m->name);
+		m->m->u.user.revision = m->revision;
+		if (m->init != NULL)
+			m->init(m->m);
+
+		opts = xtables_merge_options(iptables_globals.orig_opts, opts,
+					     m->extra_opts, &m->option_offset);
+		if (opts == NULL)
+			xtables_error(OTHER_PROBLEM, "can't alloc memory!");
+		optind--;
+		return;
+	}
+	if (c == '?') {
+		if (optopt)
+			xtables_error(PARAMETER_PROBLEM, "option \"%s\" "
+			              "requires an argument", argv[optind-1]);
+		else
+			xtables_error(PARAMETER_PROBLEM, "unknown option "
+				      "\"%s\"", argv[optind-1]);
+	}
+	xtables_error(PARAMETER_PROBLEM, "Unknown arg \"%s\"", optarg);
+}
+
 int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle)
 {
 	struct ipt_entry fw, *e = NULL;
@@ -1333,7 +1415,7 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 	struct xtables_target *t;
 	const char *jumpto = "";
 	char *protocol = NULL;
-	int proto_used = 0;
+	bool proto_used = false;
 	unsigned long long cnt;
 
 	memset(&fw, 0, sizeof(fw));
@@ -1734,113 +1816,11 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 			fprintf(stderr, "Bad argument `%s'\n", optarg);
 			exit_tryhelp(2);
 
-		default: {
-			bool stop = false;
-
-			if (target != NULL && target->parse != NULL &&
-			    c >= target->option_offset &&
-			    c < target->option_offset + XT_OPTION_OFFSET_SCALE &&
-			    target->parse(c - target->option_offset,
-					       argv, invert,
-					       &target->tflags,
-					       &fw, &target->t))
-				break;
-			for (matchp = matches; matchp; matchp = matchp->next) {
-				m = matchp->match;
-
-				if (matchp->completed || m->parse == NULL)
-					continue;
-				if (c < m->option_offset ||
-				    c >= m->option_offset + XT_OPTION_OFFSET_SCALE)
-					continue;
-				if (m->parse(c - matchp->match->option_offset,
-					     argv, invert, &m->mflags, &fw,
-					     &m->m)) {
-					stop = true;
-					break;
-				}
-			}
-			if (stop)
-				break;
-
-			/* If you listen carefully, you can
-			   actually hear this code suck. */
-
-			/* some explanations (after four different bugs
-			 * in 3 different releases): If we encounter a
-			 * parameter, that has not been parsed yet,
-			 * it's not an option of an explicitly loaded
-			 * match or a target.  However, we support
-			 * implicit loading of the protocol match
-			 * extension.  '-p tcp' means 'l4 proto 6' and
-			 * at the same time 'load tcp protocol match on
-			 * demand if we specify --dport'.
-			 *
-			 * To make this work, we need to make sure:
-			 * - the parameter has not been parsed by
-			 *   a match (m above)
-			 * - a protocol has been specified
-			 * - the protocol extension has not been
-			 *   loaded yet, or is loaded and unused
-			 *   [think of iptables-restore!]
-			 * - the protocol extension can be successively
-			 *   loaded
-			 */
-			if (protocol != NULL
-			    && (!find_proto(protocol, XTF_DONT_LOAD,
-					   options&OPT_NUMERIC, NULL)
-				|| (find_proto(protocol, XTF_DONT_LOAD,
-						options&OPT_NUMERIC, NULL)
-				    && (proto_used == 0))
-			       )
-			    && (m = find_proto(protocol, XTF_TRY_LOAD,
-					       options&OPT_NUMERIC, &matches))) {
-				/* Try loading protocol */
-				size_t size;
-
-				proto_used = 1;
-
-				size = IPT_ALIGN(sizeof(struct ipt_entry_match))
-						 + m->size;
-
-				m->m = xtables_calloc(1, size);
-				m->m->u.match_size = size;
-				strcpy(m->m->u.user.name, m->name);
-				m->m->u.user.revision = m->revision;
-				if (m->init != NULL)
-					m->init(m->m);
-
-				opts = xtables_merge_options(
-						     iptables_globals.orig_opts,
-						     opts,
-						     m->extra_opts,
-						     &m->option_offset);
-				if (opts == NULL)
-					xtables_error(OTHER_PROBLEM,
-						"can't alloc memory!");
-
-				optind--;
-				continue;
-			}
-			if (c == '?') {
-				if (optopt) {
-					xtables_error(
-					   PARAMETER_PROBLEM,
-					   "option `%s' "
-					   "requires an "
-					   "argument",
-					   argv[optind-1]);
-				} else {
-					xtables_error(
-					   PARAMETER_PROBLEM,
-					   "unknown option "
-					   "`%s'",
-					   argv[optind-1]);
-				}
-			}
-			xtables_error(PARAMETER_PROBLEM,
-				   "Unknown arg `%s'", optarg);
-		} /* default */
+		default:
+			command_default(c, argv, invert, &fw, protocol,
+					&proto_used, options,
+					target, &matches);
+			break;
 		}
 		invert = FALSE;
 	}
-- 
1.7.1

