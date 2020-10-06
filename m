Return-Path: <SRS0=CgNT=DN=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0557C4363D
	for <netfilter-devel@archiver.kernel.org>; Tue,  6 Oct 2020 11:46:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A80420789
	for <netfilter-devel@archiver.kernel.org>; Tue,  6 Oct 2020 11:46:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726248AbgJFLqi (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 6 Oct 2020 07:46:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726147AbgJFLqh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 6 Oct 2020 07:46:37 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7878EC061755
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Oct 2020 04:46:37 -0700 (PDT)
Received: from localhost ([::1]:60856 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.94)
        (envelope-from <phil@nwl.cc>)
        id 1kPlQR-0000Bi-Hh; Tue, 06 Oct 2020 13:46:35 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH v2] libxtables: Make sure extensions register in revision order
Date:   Tue,  6 Oct 2020 14:07:48 +0200
Message-Id: <20201006120748.22006-1-phil@nwl.cc>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200922225341.8976-2-phil@nwl.cc>
References: <20200922225341.8976-2-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Insert extensions into pending lists in ordered fashion: Group by
extension name (and, for matches, family) and order groups by descending
revision number.

This allows to simplify the later full registration considerably. Since
that involves kernel compatibility checks, the extra cycles here pay off
eventually.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
Changes since v1:
- Fix wrong insertion order for arrays with ascending revision: If
  pending extension list was empty, new lowest revision items were
  always inserted first.
- Add some comments explaining the algorithm.
---
 libxtables/xtables.c | 71 +++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 64 insertions(+), 7 deletions(-)

diff --git a/libxtables/xtables.c b/libxtables/xtables.c
index 8907ba2069be7..de52e3e2bbc15 100644
--- a/libxtables/xtables.c
+++ b/libxtables/xtables.c
@@ -948,8 +948,14 @@ static void xtables_check_options(const char *name, const struct option *opt)
 		}
 }
 
+static int xtables_match_prefer(const struct xtables_match *a,
+				const struct xtables_match *b);
+
 void xtables_register_match(struct xtables_match *me)
 {
+	struct xtables_match **pos;
+	bool seen_myself = false;
+
 	if (me->next) {
 		fprintf(stderr, "%s: match \"%s\" already registered\n",
 			xt_params->program_name, me->name);
@@ -1001,10 +1007,34 @@ void xtables_register_match(struct xtables_match *me)
 	if (me->extra_opts != NULL)
 		xtables_check_options(me->name, me->extra_opts);
 
-
-	/* place on linked list of matches pending full registration */
-	me->next = xtables_pending_matches;
-	xtables_pending_matches = me;
+	/* order into linked list of matches pending full registration */
+	for (pos = &xtables_pending_matches; *pos; pos = &(*pos)->next) {
+		/* group by name and family */
+		if (strcmp(me->name, (*pos)->name) ||
+		    me->family != (*pos)->family) {
+			if (seen_myself)
+				break; /* end of own group, append to it */
+			continue;
+		}
+		/* found own group */
+		seen_myself = true;
+		if (xtables_match_prefer(me, *pos) >= 0)
+			break; /* put preferred items first in group */
+	}
+	/* if own group was not found, prepend item */
+	if (!*pos && !seen_myself)
+		pos = &xtables_pending_matches;
+
+	me->next = *pos;
+	*pos = me;
+#ifdef DEBUG
+	printf("%s: inserted match %s (family %d, revision %d):\n",
+			__func__, me->name, me->family, me->revision);
+	for (pos = &xtables_pending_matches; *pos; pos = &(*pos)->next) {
+		printf("%s:\tmatch %s (family %d, revision %d)\n", __func__,
+		       (*pos)->name, (*pos)->family, (*pos)->revision);
+	}
+#endif
 }
 
 /**
@@ -1143,6 +1173,9 @@ void xtables_register_matches(struct xtables_match *match, unsigned int n)
 
 void xtables_register_target(struct xtables_target *me)
 {
+	struct xtables_target **pos;
+	bool seen_myself = false;
+
 	if (me->next) {
 		fprintf(stderr, "%s: target \"%s\" already registered\n",
 			xt_params->program_name, me->name);
@@ -1198,9 +1231,33 @@ void xtables_register_target(struct xtables_target *me)
 	if (me->family != afinfo->family && me->family != AF_UNSPEC)
 		return;
 
-	/* place on linked list of targets pending full registration */
-	me->next = xtables_pending_targets;
-	xtables_pending_targets = me;
+	/* order into linked list of targets pending full registration */
+	for (pos = &xtables_pending_targets; *pos; pos = &(*pos)->next) {
+		/* group by name */
+		if (!extension_cmp(me->name, (*pos)->name, (*pos)->family)) {
+			if (seen_myself)
+				break; /* end of own group, append to it */
+			continue;
+		}
+		/* found own group */
+		seen_myself = true;
+		if (xtables_target_prefer(me, *pos) >= 0)
+			break; /* put preferred items first in group */
+	}
+	/* if own group was not found, prepend item */
+	if (!*pos && !seen_myself)
+		pos = &xtables_pending_targets;
+
+	me->next = *pos;
+	*pos = me;
+#ifdef DEBUG
+	printf("%s: inserted target %s (family %d, revision %d):\n",
+			__func__, me->name, me->family, me->revision);
+	for (pos = &xtables_pending_targets; *pos; pos = &(*pos)->next) {
+		printf("%s:\ttarget %s (family %d, revision %d)\n", __func__,
+		       (*pos)->name, (*pos)->family, (*pos)->revision);
+	}
+#endif
 }
 
 static bool xtables_fully_register_pending_target(struct xtables_target *me)
-- 
2.28.0

