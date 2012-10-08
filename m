From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH] iptables: restore NOTRACK functionality, target aliasing
Date: Mon,  8 Oct 2012 02:32:36 +0200
Message-ID: <1349656356-10180-1-git-send-email-jengelh@inai.de>
References: <alpine.LNX.2.01.1210080141140.2933@nerf07.vanv.qr>
Cc: netfilter-devel@vger.kernel.org, jengelh@inai.de
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:46321 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750858Ab2JHAcj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 7 Oct 2012 20:32:39 -0400
In-Reply-To: <alpine.LNX.2.01.1210080141140.2933@nerf07.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Commit v1.4.16-1-g2aaa7ec is testing for real_name (not) being NULL
which was always false (true). real_name was never NULL, so cs->jumpto
would always be used, which rendered -j NOTRACK unusable, since the
chosen real name.revision is for example NOTRACK.1, which does not exist
at the kernel side.

	# ./iptables/xtables-multi main4 -t raw -A foo -j NOTRACK
	dbg: Using NOTRACK.1
	WARNING: The NOTRACK target is obsolete. Use CT instead.
	iptables: Protocol wrong type for socket.

To reasonably support the extra-special verdict names, make it so that
real_name remains NULL when an extension defined no alias, which we can
then use to determine whether the user entered an alias name (which
needs to be followed) or not.

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---

(This is a try at a resend since I have not gotten back this very email
from majordomo as a list subscriber...)

Patch downloadable via
	git://git.inai.de/iptables master
as well

 iptables/ip6tables.c |   21 ++++++++++++++-------
 iptables/iptables.c  |   23 +++++++++++++++--------
 libxtables/xtables.c |   26 ++++++++++++++------------
 3 files changed, 43 insertions(+), 27 deletions(-)

diff --git a/iptables/ip6tables.c b/iptables/ip6tables.c
index faddb71..0f32b32 100644
--- a/iptables/ip6tables.c
+++ b/iptables/ip6tables.c
@@ -1286,15 +1286,19 @@ static void command_jump(struct iptables_command_state *cs)
 
 	cs->target->t = xtables_calloc(1, size);
 	cs->target->t->u.target_size = size;
-	if (cs->target->real_name != NULL)
+	if (cs->target->real_name == NULL) {
+		/*
+		 * Spooky action at a distance: Verdicts like ACCEPT, DROP,
+		 * etc. are translated to the real name in libiptc instead.
+		 */
 		strcpy(cs->target->t->u.user.name, cs->jumpto);
-	else
+	} else {
 		strcpy(cs->target->t->u.user.name, cs->target->real_name);
-	cs->target->t->u.user.revision = cs->target->revision;
-	if (cs->target->real_name != cs->target->name)
 		fprintf(stderr, "WARNING: The %s target is obsolete. "
 		        "Use %s instead.\n",
 		        cs->jumpto, cs->target->real_name);
+	}
+	cs->target->t->u.user.revision = cs->target->revision;
 
 	xs_init_target(cs->target);
 	if (cs->target->x6_options != NULL)
@@ -1322,11 +1326,14 @@ static void command_match(struct iptables_command_state *cs)
 	size = XT_ALIGN(sizeof(struct xt_entry_match)) + m->size;
 	m->m = xtables_calloc(1, size);
 	m->m->u.match_size = size;
-	strcpy(m->m->u.user.name, m->real_name);
-	m->m->u.user.revision = m->revision;
-	if (m->real_name != m->name)
+	if (m->real_name == NULL) {
+		strcpy(m->m->u.user.name, m->name);
+	} else {
+		strcpy(m->m->u.user.name, m->real_name);
 		fprintf(stderr, "WARNING: The %s match is obsolete. "
 		        "Use %s instead.\n", m->name, m->real_name);
+	}
+	m->m->u.user.revision = m->revision;
 
 	xs_init_match(m);
 	if (m == m->next)
diff --git a/iptables/iptables.c b/iptables/iptables.c
index 96cea64..cd34401 100644
--- a/iptables/iptables.c
+++ b/iptables/iptables.c
@@ -1295,16 +1295,20 @@ static void command_jump(struct iptables_command_state *cs)
 
 	cs->target->t = xtables_calloc(1, size);
 	cs->target->t->u.target_size = size;
-	if (cs->target->real_name != NULL)
+	if (cs->target->real_name == NULL) {
+		/*
+		 * Spooky action at a distance: Verdicts like ACCEPT, DROP,
+		 * etc. are translated to the real name in libiptc instead.
+		 */
 		strcpy(cs->target->t->u.user.name, cs->jumpto);
-	else
-		strcpy(cs->target->t->u.user.name, cs->target->real_name);
-	cs->target->t->u.user.revision = cs->target->revision;
-	if (cs->target->real_name != cs->target->name)
+	} else {
 		/* Alias support for userspace side */
+		strcpy(cs->target->t->u.user.name, cs->target->real_name);
 		fprintf(stderr, "WARNING: The %s target is obsolete. "
 		        "Use %s instead.\n",
 		        cs->jumpto, cs->target->real_name);
+	}
+	cs->target->t->u.user.revision = cs->target->revision;
 
 	xs_init_target(cs->target);
 
@@ -1333,11 +1337,14 @@ static void command_match(struct iptables_command_state *cs)
 	size = XT_ALIGN(sizeof(struct xt_entry_match)) + m->size;
 	m->m = xtables_calloc(1, size);
 	m->m->u.match_size = size;
-	strcpy(m->m->u.user.name, m->real_name);
-	m->m->u.user.revision = m->revision;
-	if (m->real_name != m->name)
+	if (m->real_name == NULL) {
+		strcpy(m->m->u.user.name, m->name);
+	} else {
+		strcpy(m->m->u.user.name, m->real_name);
 		fprintf(stderr, "WARNING: The %s match is obsolete. "
 		        "Use %s instead.\n", m->name, m->real_name);
+	}
+	m->m->u.user.revision = m->revision;
 
 	xs_init_match(m);
 	if (m == m->next)
diff --git a/libxtables/xtables.c b/libxtables/xtables.c
index 82c3643..4c91286 100644
--- a/libxtables/xtables.c
+++ b/libxtables/xtables.c
@@ -848,8 +848,6 @@ void xtables_register_match(struct xtables_match *me)
 		exit(1);
 	}
 
-	if (me->real_name == NULL)
-		me->real_name = me->name;
 	if (me->x6_options != NULL)
 		xtables_option_metavalidate(me->name, me->x6_options);
 	if (me->extra_opts != NULL)
@@ -905,9 +903,9 @@ xtables_mt_prefer(bool a_alias, unsigned int a_rev, unsigned int a_fam,
 static int xtables_match_prefer(const struct xtables_match *a,
 				const struct xtables_match *b)
 {
-	return xtables_mt_prefer(a->name != a->real_name,
+	return xtables_mt_prefer(a->real_name != NULL,
 				 a->revision, a->family,
-				 b->name != b->real_name,
+				 b->real_name != NULL,
 				 b->revision, b->family);
 }
 
@@ -919,15 +917,16 @@ static int xtables_target_prefer(const struct xtables_target *a,
 	 * xtables_register_*; the direct pointer comparison here is therefore
 	 * legitimate to detect an alias.
 	 */
-	return xtables_mt_prefer(a->name != a->real_name,
+	return xtables_mt_prefer(a->real_name != NULL,
 				 a->revision, a->family,
-				 b->name != b->real_name,
+				 b->real_name != NULL,
 				 b->revision, b->family);
 }
 
 static void xtables_fully_register_pending_match(struct xtables_match *me)
 {
 	struct xtables_match **i, *old;
+	const char *rn;
 	int compare;
 
 	old = xtables_find_match(me->name, XTF_DURING_LOAD, NULL);
@@ -941,12 +940,14 @@ static void xtables_fully_register_pending_match(struct xtables_match *me)
 		}
 
 		/* Now we have two (or more) options, check compatibility. */
+		rn = (old->real_name != NULL) ? old->real_name : old->name;
 		if (compare > 0 &&
-		    compatible_match_revision(old->real_name, old->revision))
+		    compatible_match_revision(rn, old->revision))
 			return;
 
 		/* See if new match can be used. */
-		if (!compatible_match_revision(me->real_name, me->revision))
+		rn = (me->real_name != NULL) ? me->real_name : me->name;
+		if (!compatible_match_revision(rn, me->revision))
 			return;
 
 		/* Delete old one. */
@@ -1005,8 +1006,6 @@ void xtables_register_target(struct xtables_target *me)
 		exit(1);
 	}
 
-	if (me->real_name == NULL)
-		me->real_name = me->name;
 	if (me->x6_options != NULL)
 		xtables_option_metavalidate(me->name, me->x6_options);
 	if (me->extra_opts != NULL)
@@ -1024,6 +1023,7 @@ void xtables_register_target(struct xtables_target *me)
 static void xtables_fully_register_pending_target(struct xtables_target *me)
 {
 	struct xtables_target *old;
+	const char *rn;
 	int compare;
 
 	old = xtables_find_target(me->name, XTF_DURING_LOAD);
@@ -1039,12 +1039,14 @@ static void xtables_fully_register_pending_target(struct xtables_target *me)
 		}
 
 		/* Now we have two (or more) options, check compatibility. */
+		rn = (old->real_name != NULL) ? old->real_name : old->name;
 		if (compare > 0 &&
-		    compatible_target_revision(old->real_name, old->revision))
+		    compatible_target_revision(rn, old->revision))
 			return;
 
 		/* See if new target can be used. */
-		if (!compatible_target_revision(me->real_name, me->revision))
+		rn = (me->real_name != NULL) ? me->real_name : me->name;
+		if (!compatible_target_revision(rn, me->revision))
 			return;
 
 		/* Delete old one. */
-- 
1.7.10.4

