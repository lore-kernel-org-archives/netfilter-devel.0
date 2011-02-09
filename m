From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 08/11] src: unclutter command_default function
Date: Wed,  9 Feb 2011 02:48:53 +0100
Message-ID: <1297216137-18505-9-git-send-email-jengelh@medozas.de>
References: <1297216137-18505-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:38736 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756146Ab1BIBtK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Feb 2011 20:49:10 -0500
In-Reply-To: <1297216137-18505-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

(Essentially, 5 levels of indentation have been stripped compared to the
original layout, and this is surely a result that looks a lot better
than it did before.)

Things to note:

1. If the m->parse call succeeded, we can return from the function and
do not need to go through the other code. As such, "m" is guaranteed to
be useless at the end of the match loop, and so, conditions can be
removed.

2. Since the per-extension parse function only ever get their own option
codes (since v1.4.10-26-gd09b6d5), their return value no longer has a
meaning and can be ignored.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 ip6tables.c |  100 +++++++++++++++++++++---------------------------
 iptables.c  |  121 ++++++++++++++++++++++++++---------------------------------
 2 files changed, 97 insertions(+), 124 deletions(-)

diff --git a/ip6tables.c b/ip6tables.c
index 3330420..c475bf2 100644
--- a/ip6tables.c
+++ b/ip6tables.c
@@ -1247,71 +1247,59 @@ static void command_default(struct iptables_command_state *cs)
 
 	if (cs->target == NULL || cs->target->parse == NULL ||
 	    cs->c < cs->target->option_offset ||
-	    cs->c >= cs->target->option_offset + XT_OPTION_OFFSET_SCALE ||
-	    !cs->target->parse(cs->c - cs->target->option_offset,
-			       cs->argv, cs->invert,
-			       &cs->target->tflags,
-			       &cs->fw6, &cs->target->t)) {
-		for (matchp = cs->matches; matchp; matchp = matchp->next) {
-			if (matchp->completed ||
-			    matchp->match->parse == NULL)
-				continue;
-			if (cs->c < matchp->match->option_offset ||
-			    cs->c >= matchp->match->option_offset + XT_OPTION_OFFSET_SCALE)
-				continue;
-			if (matchp->match->parse(cs->c - matchp->match->option_offset,
-				     cs->argv, cs->invert,
-				     &matchp->match->mflags,
-				     &cs->fw6,
-				     &matchp->match->m))
-				break;
-		}
-		m = matchp ? matchp->match : NULL;
+	    cs->c >= cs->target->option_offset + XT_OPTION_OFFSET_SCALE) {
+		cs->target->parse(cs->c - cs->target->option_offset, cs->argv,
+				  cs->invert, &cs->target->tflags, &cs->fw6,
+				  &cs->target->t);
+		return;
+	}
 
-		if (m == NULL && (m = load_proto(cs)) != NULL) {
-			/* Try loading protocol */
-			size_t size;
+	for (matchp = cs->matches; matchp; matchp = matchp->next) {
+		m = matchp->match;
 
-			cs->proto_used = 1;
+		if (matchp->completed || m->parse == NULL)
+			continue;
+		if (cs->c < matchp->match->option_offset ||
+		    cs->c >= matchp->match->option_offset + XT_OPTION_OFFSET_SCALE)
+			continue;
+		m->parse(cs->c - m->option_offset, cs->argv, cs->invert,
+			 &m->mflags, &cs->fw6, &m->m);
+		return;
+	}
 
-			size = IP6T_ALIGN(sizeof(struct ip6t_entry_match))
-					 + m->size;
+	/* Try loading protocol */
+	m = load_proto(cs);
+	if (m != NULL) {
+		size_t size;
 
-			m->m = xtables_calloc(1, size);
-			m->m->u.match_size = size;
-			strcpy(m->m->u.user.name, m->name);
-			m->m->u.user.revision = m->revision;
-			if (m->init != NULL)
-				m->init(m->m);
+		cs->proto_used = 1;
 
-			opts = xtables_merge_options(ip6tables_globals.orig_opts, opts,
-			    m->extra_opts, &m->option_offset);
+		size = IP6T_ALIGN(sizeof(struct ip6t_entry_match)) + m->size;
 
-			optind--;
-			return;
-		}
+		m->m = xtables_calloc(1, size);
+		m->m->u.match_size = size;
+		strcpy(m->m->u.user.name, m->name);
+		m->m->u.user.revision = m->revision;
+		if (m->init != NULL)
+			m->init(m->m);
 
-		if (!m) {
-			if (cs->c == '?') {
-				if (optopt) {
-					xtables_error(
-					   PARAMETER_PROBLEM,
-					   "option `%s' "
-					   "requires an "
-					   "argument",
-					   cs->argv[optind-1]);
-				} else {
-					xtables_error(
-					   PARAMETER_PROBLEM,
-					   "unknown option "
-					   "`%s'",
-					   cs->argv[optind-1]);
-				}
-			}
+		opts = xtables_merge_options(ip6tables_globals.orig_opts, opts,
+					     m->extra_opts, &m->option_offset);
+
+		optind--;
+		return;
+	}
+
+	if (cs->c == '?') {
+		if (optopt)
 			xtables_error(PARAMETER_PROBLEM,
-				   "Unknown arg `%s'", optarg);
-		}
+				"option \"%s\" requires an argument",
+				cs->argv[optind-1]);
+		else
+			xtables_error(PARAMETER_PROBLEM,
+				"unknown option \"%s\"", cs->argv[optind-1]);
 	}
+	xtables_error(PARAMETER_PROBLEM, "Unknown arg \"%s\"", optarg);
 }
 
 int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **handle)
diff --git a/iptables.c b/iptables.c
index bae14af..96732b4 100644
--- a/iptables.c
+++ b/iptables.c
@@ -1271,76 +1271,61 @@ static void command_default(struct iptables_command_state *cs)
 
 	if (cs->target == NULL || cs->target->parse == NULL ||
 	    cs->c < cs->target->option_offset ||
-	    cs->c >= cs->target->option_offset + XT_OPTION_OFFSET_SCALE ||
-	    !cs->target->parse(cs->c - cs->target->option_offset,
-			       cs->argv, cs->invert,
-			       &cs->target->tflags,
-			       &cs->fw, &cs->target->t)) {
-		for (matchp = cs->matches; matchp; matchp = matchp->next) {
-			if (matchp->completed ||
-			    matchp->match->parse == NULL)
-				continue;
-			if (cs->c < matchp->match->option_offset ||
-			    cs->c >= matchp->match->option_offset + XT_OPTION_OFFSET_SCALE)
-				continue;
-			if (matchp->match->parse(cs->c - matchp->match->option_offset,
-				     cs->argv, cs->invert,
-				     &matchp->match->mflags,
-				     &cs->fw,
-				     &matchp->match->m))
-				break;
-		}
-		m = matchp ? matchp->match : NULL;
+	    cs->c >= cs->target->option_offset + XT_OPTION_OFFSET_SCALE) {
+		cs->target->parse(cs->c - cs->target->option_offset, cs->argv,
+				  cs->invert, &cs->target->tflags, &cs->fw,
+				  &cs->target->t);
+		return;
+	}
 
-		if (m == NULL && (m = load_proto(cs)) != NULL) {
-			/* Try loading protocol */
-			size_t size;
+	for (matchp = cs->matches; matchp; matchp = matchp->next) {
+		m = matchp->match;
 
-			cs->proto_used = 1;
+		if (matchp->completed || m->parse == NULL)
+			continue;
+		if (cs->c < m->option_offset ||
+		    cs->c >= m->option_offset + XT_OPTION_OFFSET_SCALE)
+			continue;
+		m->parse(cs->c - m->option_offset, cs->argv, cs->invert,
+			 &m->mflags, &cs->fw, &m->m);
+		return;
+	}
 
-			size = IPT_ALIGN(sizeof(struct ipt_entry_match))
-					 + m->size;
+	/* Try loading protocol */
+	m = load_proto(cs);
+	if (m != NULL) {
+		size_t size;
 
-			m->m = xtables_calloc(1, size);
-			m->m->u.match_size = size;
-			strcpy(m->m->u.user.name, m->name);
-			m->m->u.user.revision = m->revision;
-			if (m->init != NULL)
-				m->init(m->m);
+		cs->proto_used = 1;
 
-			opts = xtables_merge_options(
-					     iptables_globals.orig_opts,
-					     opts,
-					     m->extra_opts,
-					     &m->option_offset);
-			if (opts == NULL)
-				xtables_error(OTHER_PROBLEM,
-					"can't alloc memory!");
+		size = IPT_ALIGN(sizeof(struct ipt_entry_match)) + m->size;
 
-			optind--;
-			return;
-		}
-		if (!m) {
-			if (cs->c == '?') {
-				if (optopt) {
-					xtables_error(
-					   PARAMETER_PROBLEM,
-					   "option `%s' "
-					   "requires an "
-					   "argument",
-					   cs->argv[optind-1]);
-				} else {
-					xtables_error(
-					   PARAMETER_PROBLEM,
-					   "unknown option "
-					   "`%s'",
-					   cs->argv[optind-1]);
-				}
-			}
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
+
+		optind--;
+		return;
+	}
+
+	if (cs->c == '?') {
+		if (optopt)
 			xtables_error(PARAMETER_PROBLEM,
-				   "Unknown arg `%s'", optarg);
-		}
+				"option \"%s\" requires an argument",
+				cs->argv[optind-1]);
+		else
+			xtables_error(PARAMETER_PROBLEM,
+				"unknown option \"%s\"", cs->argv[optind-1]);
 	}
+	xtables_error(PARAMETER_PROBLEM, "Unknown arg \"%s\"", optarg);
 }
 
 int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle)
-- 
1.7.1

