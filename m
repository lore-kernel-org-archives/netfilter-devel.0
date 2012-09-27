From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH 4/7] iptables: support for target aliases
Date: Fri, 28 Sep 2012 00:48:26 +0200
Message-ID: <1348786109-20894-5-git-send-email-jengelh@inai.de>
References: <1348786109-20894-1-git-send-email-jengelh@inai.de>
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:56157 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755235Ab2I0Wsc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 27 Sep 2012 18:48:32 -0400
In-Reply-To: <1348786109-20894-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch allows for target names listed on the command line to be
rewritten to new names and revisions.

As before, we will pick a revision that is supported by the kernel - now
including real_name in the search. This gives us the possibility to test
for many action names.

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 configure.ac         |    4 ++--
 include/xtables.h    |    3 +++
 iptables/ip6tables.c |    7 ++++++-
 iptables/iptables.c  |    8 +++++++-
 libxtables/xtables.c |   32 +++++++++++++++++++++++++-------
 5 files changed, 43 insertions(+), 11 deletions(-)

diff --git a/configure.ac b/configure.ac
index 4060f90..adda50e 100644
--- a/configure.ac
+++ b/configure.ac
@@ -2,8 +2,8 @@
 AC_INIT([iptables], [1.4.15])
 
 # See libtool.info "Libtool's versioning system"
-libxtables_vcurrent=8
-libxtables_vage=1
+libxtables_vcurrent=9
+libxtables_vage=0
 
 AC_CONFIG_AUX_DIR([build-aux])
 AC_CONFIG_HEADERS([config.h])
diff --git a/include/xtables.h b/include/xtables.h
index 3b15e67..7bdc331 100644
--- a/include/xtables.h
+++ b/include/xtables.h
@@ -282,6 +282,9 @@ struct xtables_target
 
 	const char *name;
 
+	/* Real target behind this, if any. */
+	const char *real_name;
+
 	/* Revision of target (0 by default). */
 	u_int8_t revision;
 
diff --git a/iptables/ip6tables.c b/iptables/ip6tables.c
index b191d5d..752cf03 100644
--- a/iptables/ip6tables.c
+++ b/iptables/ip6tables.c
@@ -1286,8 +1286,13 @@ static void command_jump(struct iptables_command_state *cs)
 
 	cs->target->t = xtables_calloc(1, size);
 	cs->target->t->u.target_size = size;
-	strcpy(cs->target->t->u.user.name, cs->jumpto);
+	strcpy(cs->target->t->u.user.name, cs->target->real_name);
 	cs->target->t->u.user.revision = cs->target->revision;
+	if (cs->target->real_name != cs->target->name)
+		fprintf(stderr, "WARNING: The %s target is obsolete. "
+		        "Use %s instead.\n",
+		        cs->jumpto, cs->target->real_name);
+
 	xs_init_target(cs->target);
 	if (cs->target->x6_options != NULL)
 		opts = xtables_options_xfrm(ip6tables_globals.orig_opts, opts,
diff --git a/iptables/iptables.c b/iptables/iptables.c
index 03ac63b..a237e93 100644
--- a/iptables/iptables.c
+++ b/iptables/iptables.c
@@ -1295,8 +1295,14 @@ static void command_jump(struct iptables_command_state *cs)
 
 	cs->target->t = xtables_calloc(1, size);
 	cs->target->t->u.target_size = size;
-	strcpy(cs->target->t->u.user.name, cs->jumpto);
+	strcpy(cs->target->t->u.user.name, cs->target->real_name);
 	cs->target->t->u.user.revision = cs->target->revision;
+	if (cs->target->real_name != cs->target->name)
+		/* Alias support for userspace side */
+		fprintf(stderr, "WARNING: The %s target is obsolete. "
+		        "Use %s instead.\n",
+		        cs->jumpto, cs->target->real_name);
+
 	xs_init_target(cs->target);
 
 	if (cs->target->x6_options != NULL)
diff --git a/libxtables/xtables.c b/libxtables/xtables.c
index 7f0d3cc..a2b24c5 100644
--- a/libxtables/xtables.c
+++ b/libxtables/xtables.c
@@ -872,9 +872,18 @@ void xtables_register_match(struct xtables_match *me)
  * preferred.
  */
 static int
-xtables_mt_prefer(unsigned int a_rev, unsigned int a_fam,
-		  unsigned int b_rev, unsigned int b_fam)
+xtables_mt_prefer(bool a_alias, unsigned int a_rev, unsigned int a_fam,
+		  bool b_alias, unsigned int b_rev, unsigned int b_fam)
 {
+	/*
+	 * Alias ranks higher than no alias.
+	 * (We want the new action to be used whenever possible.)
+	 */
+	if (!a_alias && b_alias)
+		return -1;
+	if (a_alias && !b_alias)
+		return 1;
+
 	/* Higher revision ranks higher. */
 	if (a_rev < b_rev)
 		return -1;
@@ -894,14 +903,21 @@ xtables_mt_prefer(unsigned int a_rev, unsigned int a_fam,
 static int xtables_match_prefer(const struct xtables_match *a,
 				const struct xtables_match *b)
 {
-	return xtables_mt_prefer(a->revision, a->family,
-				 b->revision, b->family);
+	return xtables_mt_prefer(false, a->revision, a->family,
+				 false, b->revision, b->family);
 }
 
 static int xtables_target_prefer(const struct xtables_target *a,
 				 const struct xtables_target *b)
 {
-	return xtables_mt_prefer(a->revision, a->family,
+	/*
+	 * Note that if x->real_name==NULL, it will be set to x->name in
+	 * xtables_register_*; the direct pointer comparison here is therefore
+	 * legitimate to detect an alias.
+	 */
+	return xtables_mt_prefer(a->name != a->real_name,
+				 a->revision, a->family,
+				 b->name != b->real_name,
 				 b->revision, b->family);
 }
 
@@ -985,6 +1001,8 @@ void xtables_register_target(struct xtables_target *me)
 		exit(1);
 	}
 
+	if (me->real_name == NULL)
+		me->real_name = me->name;
 	if (me->x6_options != NULL)
 		xtables_option_metavalidate(me->name, me->x6_options);
 	if (me->extra_opts != NULL)
@@ -1018,11 +1036,11 @@ static void xtables_fully_register_pending_target(struct xtables_target *me)
 
 		/* Now we have two (or more) options, check compatibility. */
 		if (compare > 0 &&
-		    compatible_target_revision(old->name, old->revision))
+		    compatible_target_revision(old->real_name, old->revision))
 			return;
 
 		/* See if new target can be used. */
-		if (!compatible_target_revision(me->name, me->revision))
+		if (!compatible_target_revision(me->real_name, me->revision))
 			return;
 
 		/* Delete old one. */
-- 
1.7.10.4

