From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH 6/7] iptables: support for match aliases
Date: Fri, 28 Sep 2012 00:48:28 +0200
Message-ID: <1348786109-20894-7-git-send-email-jengelh@inai.de>
References: <1348786109-20894-1-git-send-email-jengelh@inai.de>
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:56165 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755985Ab2I0Wsd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 27 Sep 2012 18:48:33 -0400
In-Reply-To: <1348786109-20894-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch allows for match names listed on the command line to be
rewritten to new names and revisions, like we did for targets before.

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 include/xtables.h    |    1 +
 iptables/ip6tables.c |    6 +++++-
 iptables/iptables.c  |    6 +++++-
 libxtables/xtables.c |   12 ++++++++----
 4 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/include/xtables.h b/include/xtables.h
index 7bdc331..2cc1a02 100644
--- a/include/xtables.h
+++ b/include/xtables.h
@@ -213,6 +213,7 @@ struct xtables_match
 	struct xtables_match *next;
 
 	const char *name;
+	const char *real_name;
 
 	/* Revision of match (0 by default). */
 	u_int8_t revision;
diff --git a/iptables/ip6tables.c b/iptables/ip6tables.c
index 752cf03..f93bfb3 100644
--- a/iptables/ip6tables.c
+++ b/iptables/ip6tables.c
@@ -1319,8 +1319,12 @@ static void command_match(struct iptables_command_state *cs)
 	size = XT_ALIGN(sizeof(struct xt_entry_match)) + m->size;
 	m->m = xtables_calloc(1, size);
 	m->m->u.match_size = size;
-	strcpy(m->m->u.user.name, m->name);
+	strcpy(m->m->u.user.name, m->real_name);
 	m->m->u.user.revision = m->revision;
+	if (m->real_name != m->name)
+		fprintf(stderr, "WARNING: The %s match is obsolete. "
+		        "Use %s instead.\n", m->name, m->real_name);
+
 	xs_init_match(m);
 	if (m == m->next)
 		return;
diff --git a/iptables/iptables.c b/iptables/iptables.c
index a237e93..5786bfd 100644
--- a/iptables/iptables.c
+++ b/iptables/iptables.c
@@ -1330,8 +1330,12 @@ static void command_match(struct iptables_command_state *cs)
 	size = XT_ALIGN(sizeof(struct xt_entry_match)) + m->size;
 	m->m = xtables_calloc(1, size);
 	m->m->u.match_size = size;
-	strcpy(m->m->u.user.name, m->name);
+	strcpy(m->m->u.user.name, m->real_name);
 	m->m->u.user.revision = m->revision;
+	if (m->real_name != m->name)
+		fprintf(stderr, "WARNING: The %s match is obsolete. "
+		        "Use %s instead.\n", m->name, m->real_name);
+
 	xs_init_match(m);
 	if (m == m->next)
 		return;
diff --git a/libxtables/xtables.c b/libxtables/xtables.c
index a2b24c5..82c3643 100644
--- a/libxtables/xtables.c
+++ b/libxtables/xtables.c
@@ -848,6 +848,8 @@ void xtables_register_match(struct xtables_match *me)
 		exit(1);
 	}
 
+	if (me->real_name == NULL)
+		me->real_name = me->name;
 	if (me->x6_options != NULL)
 		xtables_option_metavalidate(me->name, me->x6_options);
 	if (me->extra_opts != NULL)
@@ -903,8 +905,10 @@ xtables_mt_prefer(bool a_alias, unsigned int a_rev, unsigned int a_fam,
 static int xtables_match_prefer(const struct xtables_match *a,
 				const struct xtables_match *b)
 {
-	return xtables_mt_prefer(false, a->revision, a->family,
-				 false, b->revision, b->family);
+	return xtables_mt_prefer(a->name != a->real_name,
+				 a->revision, a->family,
+				 b->name != b->real_name,
+				 b->revision, b->family);
 }
 
 static int xtables_target_prefer(const struct xtables_target *a,
@@ -938,11 +942,11 @@ static void xtables_fully_register_pending_match(struct xtables_match *me)
 
 		/* Now we have two (or more) options, check compatibility. */
 		if (compare > 0 &&
-		    compatible_match_revision(old->name, old->revision))
+		    compatible_match_revision(old->real_name, old->revision))
 			return;
 
 		/* See if new match can be used. */
-		if (!compatible_match_revision(me->name, me->revision))
+		if (!compatible_match_revision(me->real_name, me->revision))
 			return;
 
 		/* Delete old one. */
-- 
1.7.10.4

