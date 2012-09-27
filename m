From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH 3/7] libxtables: consolidate preference logic
Date: Fri, 28 Sep 2012 00:48:25 +0200
Message-ID: <1348786109-20894-4-git-send-email-jengelh@inai.de>
References: <1348786109-20894-1-git-send-email-jengelh@inai.de>
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:56152 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755826Ab2I0Wsc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 27 Sep 2012 18:48:32 -0400
In-Reply-To: <1348786109-20894-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Alias support will require testing for more conditions, so move the
revision comparison code into a separate function where it can be
shared between matches and targets.

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 libxtables/xtables.c |   69 ++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 53 insertions(+), 16 deletions(-)

diff --git a/libxtables/xtables.c b/libxtables/xtables.c
index d818579..7f0d3cc 100644
--- a/libxtables/xtables.c
+++ b/libxtables/xtables.c
@@ -862,14 +862,58 @@ void xtables_register_match(struct xtables_match *me)
 	xtables_pending_matches = me;
 }
 
+/**
+ * Compare two actions for their preference
+ * @a:	one action
+ * @b: 	another
+ *
+ * Like strcmp, returns a negative number if @a is less preferred than @b,
+ * positive number if @a is more preferred than @b, or zero if equally
+ * preferred.
+ */
+static int
+xtables_mt_prefer(unsigned int a_rev, unsigned int a_fam,
+		  unsigned int b_rev, unsigned int b_fam)
+{
+	/* Higher revision ranks higher. */
+	if (a_rev < b_rev)
+		return -1;
+	if (a_rev > b_rev)
+		return 1;
+
+	/* NFPROTO_<specific> ranks higher than NFPROTO_UNSPEC. */
+	if (a_fam == NFPROTO_UNSPEC && b_fam != NFPROTO_UNSPEC)
+		return -1;
+	if (a_fam != NFPROTO_UNSPEC && b_fam == NFPROTO_UNSPEC)
+		return 1;
+
+	/* Must be the same thing. */
+	return 0;
+}
+
+static int xtables_match_prefer(const struct xtables_match *a,
+				const struct xtables_match *b)
+{
+	return xtables_mt_prefer(a->revision, a->family,
+				 b->revision, b->family);
+}
+
+static int xtables_target_prefer(const struct xtables_target *a,
+				 const struct xtables_target *b)
+{
+	return xtables_mt_prefer(a->revision, a->family,
+				 b->revision, b->family);
+}
+
 static void xtables_fully_register_pending_match(struct xtables_match *me)
 {
 	struct xtables_match **i, *old;
+	int compare;
 
 	old = xtables_find_match(me->name, XTF_DURING_LOAD, NULL);
 	if (old) {
-		if (old->revision == me->revision &&
-		    old->family == me->family) {
+		compare = xtables_match_prefer(old, me);
+		if (compare == 0) {
 			fprintf(stderr,
 				"%s: match `%s' already registered.\n",
 				xt_params->program_name, me->name);
@@ -877,18 +921,14 @@ static void xtables_fully_register_pending_match(struct xtables_match *me)
 		}
 
 		/* Now we have two (or more) options, check compatibility. */
-		if (compatible_match_revision(old->name, old->revision)
-		    && old->revision > me->revision)
+		if (compare > 0 &&
+		    compatible_match_revision(old->name, old->revision))
 			return;
 
 		/* See if new match can be used. */
 		if (!compatible_match_revision(me->name, me->revision))
 			return;
 
-		/* Prefer !AF_UNSPEC over AF_UNSPEC for same revision. */
-		if (old->revision == me->revision && me->family == AF_UNSPEC)
-			return;
-
 		/* Delete old one. */
 		for (i = &xtables_matches; *i!=old; i = &(*i)->next);
 		*i = old->next;
@@ -962,13 +1002,14 @@ void xtables_register_target(struct xtables_target *me)
 static void xtables_fully_register_pending_target(struct xtables_target *me)
 {
 	struct xtables_target *old;
+	int compare;
 
 	old = xtables_find_target(me->name, XTF_DURING_LOAD);
 	if (old) {
 		struct xtables_target **i;
 
-		if (old->revision == me->revision &&
-		    old->family == me->family) {
+		compare = xtables_target_prefer(old, me);
+		if (compare == 0) {
 			fprintf(stderr,
 				"%s: target `%s' already registered.\n",
 				xt_params->program_name, me->name);
@@ -976,18 +1017,14 @@ static void xtables_fully_register_pending_target(struct xtables_target *me)
 		}
 
 		/* Now we have two (or more) options, check compatibility. */
-		if (compatible_target_revision(old->name, old->revision)
-		    && old->revision > me->revision)
+		if (compare > 0 &&
+		    compatible_target_revision(old->name, old->revision))
 			return;
 
 		/* See if new target can be used. */
 		if (!compatible_target_revision(me->name, me->revision))
 			return;
 
-		/* Prefer !AF_UNSPEC over AF_UNSPEC for same revision. */
-		if (old->revision == me->revision && me->family == AF_UNSPEC)
-			return;
-
 		/* Delete old one. */
 		for (i = &xtables_targets; *i!=old; i = &(*i)->next);
 		*i = old->next;
-- 
1.7.10.4

