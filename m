Return-Path: <SRS0=MXnI=C7=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10E59C4727E
	for <netfilter-devel@archiver.kernel.org>; Tue, 22 Sep 2020 22:42:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D5311221EB
	for <netfilter-devel@archiver.kernel.org>; Tue, 22 Sep 2020 22:42:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726637AbgIVWmW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 22 Sep 2020 18:42:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726448AbgIVWmW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 22 Sep 2020 18:42:22 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3884CC061755
        for <netfilter-devel@vger.kernel.org>; Tue, 22 Sep 2020 15:42:22 -0700 (PDT)
Received: from localhost ([::1]:52092 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.94)
        (envelope-from <phil@nwl.cc>)
        id 1kKqzM-0007Vu-JH; Wed, 23 Sep 2020 00:42:20 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org,
        Serhey Popovych <serhe.popovych@gmail.com>
Subject: [iptables PATCH 2/3] libxtables: Simplify pending extension registration
Date:   Wed, 23 Sep 2020 00:53:40 +0200
Message-Id: <20200922225341.8976-3-phil@nwl.cc>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200922225341.8976-1-phil@nwl.cc>
References: <20200922225341.8976-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Assuming that pending extensions are sorted by first name and family,
then descending revision, the decision where to insert a newly
registered extension may be simplified by memorizing the previous
registration (which obviously is of same name and family and higher
revision).

As a side-effect, fix for unsupported old extension revisions lingering
in pending extension list forever and being retried with every use of
the given extension. Any revision being rejected by the kernel may
safely be dropped iff a previous (read: higher) revision was accepted
already.

Yet another side-effect of this change is the removal of an unwanted
recursion by xtables_fully_register_pending_*() into itself via
xtables_find_*().

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 libxtables/xtables.c | 128 +++++++++++--------------------------------
 1 file changed, 33 insertions(+), 95 deletions(-)

diff --git a/libxtables/xtables.c b/libxtables/xtables.c
index 63d0ea5def2d5..de74d361a53af 100644
--- a/libxtables/xtables.c
+++ b/libxtables/xtables.c
@@ -203,8 +203,10 @@ struct xtables_match *xtables_matches;
 struct xtables_target *xtables_targets;
 
 /* Fully register a match/target which was previously partially registered. */
-static bool xtables_fully_register_pending_match(struct xtables_match *me);
-static bool xtables_fully_register_pending_target(struct xtables_target *me);
+static bool xtables_fully_register_pending_match(struct xtables_match *me,
+						 struct xtables_match *prev);
+static bool xtables_fully_register_pending_target(struct xtables_target *me,
+						  struct xtables_target *prev);
 
 #ifndef NO_SHARED_LIBS
 /* registry for loaded shared objects to close later */
@@ -662,6 +664,7 @@ struct xtables_match *
 xtables_find_match(const char *name, enum xtables_tryload tryload,
 		   struct xtables_rule_match **matches)
 {
+	struct xtables_match *prev = NULL;
 	struct xtables_match **dptr;
 	struct xtables_match *ptr;
 	const char *icmp6 = "icmp6";
@@ -683,8 +686,12 @@ xtables_find_match(const char *name, enum xtables_tryload tryload,
 		if (extension_cmp(name, (*dptr)->name, (*dptr)->family)) {
 			ptr = *dptr;
 			*dptr = (*dptr)->next;
-			if (xtables_fully_register_pending_match(ptr))
+			if (xtables_fully_register_pending_match(ptr, prev)) {
+				prev = ptr;
 				continue;
+			} else if (prev) {
+				continue;
+			}
 			*dptr = ptr;
 		}
 		dptr = &((*dptr)->next);
@@ -778,6 +785,7 @@ xtables_find_match_revision(const char *name, enum xtables_tryload tryload,
 struct xtables_target *
 xtables_find_target(const char *name, enum xtables_tryload tryload)
 {
+	struct xtables_target *prev = NULL;
 	struct xtables_target **dptr;
 	struct xtables_target *ptr;
 
@@ -794,8 +802,12 @@ xtables_find_target(const char *name, enum xtables_tryload tryload)
 		if (extension_cmp(name, (*dptr)->name, (*dptr)->family)) {
 			ptr = *dptr;
 			*dptr = (*dptr)->next;
-			if (xtables_fully_register_pending_target(ptr))
+			if (xtables_fully_register_pending_target(ptr, prev)) {
+				prev = ptr;
 				continue;
+			} else if (prev) {
+				continue;
+			}
 			*dptr = ptr;
 		}
 		dptr = &((*dptr)->next);
@@ -1096,64 +1108,27 @@ static int xtables_target_prefer(const struct xtables_target *a,
 				 b->revision, b->family);
 }
 
-static bool xtables_fully_register_pending_match(struct xtables_match *me)
+static bool xtables_fully_register_pending_match(struct xtables_match *me,
+						 struct xtables_match *prev)
 {
-	struct xtables_match **i, *old, *pos = NULL;
+	struct xtables_match **i;
 	const char *rn;
-	int compare;
 
 	/* See if new match can be used. */
 	rn = (me->real_name != NULL) ? me->real_name : me->name;
 	if (!compatible_match_revision(rn, me->revision))
 		return false;
 
-	old = xtables_find_match(me->name, XTF_DURING_LOAD, NULL);
-	while (old) {
-		compare = xtables_match_prefer(old, me);
-		if (compare == 0) {
-			fprintf(stderr,
-				"%s: match `%s' already registered.\n",
-				xt_params->program_name, me->name);
-			exit(1);
-		}
-
-		/* Now we have two (or more) options, check compatibility. */
-		rn = (old->real_name != NULL) ? old->real_name : old->name;
-		if (compare > 0) {
-			/* Kernel tells old isn't compatible anymore??? */
-			if (!compatible_match_revision(rn, old->revision)) {
-				/* Delete old one. */
-				for (i = &xtables_matches; *i != old;)
-				     i = &(*i)->next;
-				*i = old->next;
-			}
-			pos = old;
-			old = old->next;
-			if (!old)
-				break;
-			if (!extension_cmp(me->name, old->name, old->family))
-				break;
-			continue;
-		}
-
-		/* Found right old */
-		pos = old;
-		break;
-	}
-
-	if (!pos) {
+	if (!prev) {
 		/* Append to list. */
 		for (i = &xtables_matches; *i; i = &(*i)->next);
-	} else if (compare < 0) {
-		/* Prepend it */
-		for (i = &xtables_matches; *i != pos; i = &(*i)->next);
-	} else if (compare > 0) {
+	} else {
 		/* Append it */
-		i = &pos->next;
-		pos = pos->next;
+		i = &prev->next;
+		prev = prev->next;
 	}
 
-	me->next = pos;
+	me->next = prev;
 	*i = me;
 
 	me->m = NULL;
@@ -1255,11 +1230,11 @@ void xtables_register_target(struct xtables_target *me)
 #endif
 }
 
-static bool xtables_fully_register_pending_target(struct xtables_target *me)
+static bool xtables_fully_register_pending_target(struct xtables_target *me,
+						  struct xtables_target *prev)
 {
-	struct xtables_target **i, *old, *pos = NULL;
+	struct xtables_target **i;
 	const char *rn;
-	int compare;
 
 	if (strcmp(me->name, "standard") != 0) {
 		/* See if new target can be used. */
@@ -1268,54 +1243,17 @@ static bool xtables_fully_register_pending_target(struct xtables_target *me)
 			return false;
 	}
 
-	old = xtables_find_target(me->name, XTF_DURING_LOAD);
-	while (old) {
-		compare = xtables_target_prefer(old, me);
-		if (compare == 0) {
-			fprintf(stderr,
-				"%s: target `%s' already registered.\n",
-				xt_params->program_name, me->name);
-			exit(1);
-		}
-
-		/* Now we have two (or more) options, check compatibility. */
-		rn = (old->real_name != NULL) ? old->real_name : old->name;
-		if (compare > 0) {
-			/* Kernel tells old isn't compatible anymore??? */
-			if (!compatible_target_revision(rn, old->revision)) {
-				/* Delete old one. */
-				for (i = &xtables_targets; *i != old;)
-				     i = &(*i)->next;
-				*i = old->next;
-			}
-			pos = old;
-			old = old->next;
-			if (!old)
-				break;
-			if (!extension_cmp(me->name, old->name, old->family))
-				break;
-			continue;
-		}
-
-		/* Found right old */
-		pos = old;
-		break;
-	}
-
-	if (!pos) {
+	if (!prev) {
 		/* Prepend to list. */
 		i = &xtables_targets;
-		pos = xtables_targets;
-	} else if (compare < 0) {
-		/* Prepend it */
-		for (i = &xtables_targets; *i != pos; i = &(*i)->next);
-	} else if (compare > 0) {
+		prev = xtables_targets;
+	} else {
 		/* Append it */
-		i = &pos->next;
-		pos = pos->next;
+		i = &prev->next;
+		prev = prev->next;
 	}
 
-	me->next = pos;
+	me->next = prev;
 	*i = me;
 
 	me->t = NULL;
-- 
2.28.0

