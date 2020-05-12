Return-Path: <SRS0=em6Q=62=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40C53CA90AF
	for <netfilter-devel@archiver.kernel.org>; Tue, 12 May 2020 17:10:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 26F6B206B8
	for <netfilter-devel@archiver.kernel.org>; Tue, 12 May 2020 17:10:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727099AbgELRKp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 12 May 2020 13:10:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725938AbgELRKo (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 12 May 2020 13:10:44 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF6CAC061A0C
        for <netfilter-devel@vger.kernel.org>; Tue, 12 May 2020 10:10:44 -0700 (PDT)
Received: from localhost ([::1]:45492 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1jYYQV-000273-I6; Tue, 12 May 2020 19:10:43 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 2/3] libxtables: Introduce 'matchmask' target callback
Date:   Tue, 12 May 2020 19:10:17 +0200
Message-Id: <20200512171018.16871-3-phil@nwl.cc>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200512171018.16871-1-phil@nwl.cc>
References: <20200512171018.16871-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

In order to support customized target data comparison, introduce a
callback which sets the matchmask used by libiptc's target_same()
function for the per-target part.

If defined, use this function in both legacy and nft variants.

Since this changes struct xtables_target, bump libxtables current and
reset age to zero.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 configure.ac          |  4 ++--
 include/xtables.h     |  3 +++
 iptables/nft-shared.c | 15 ++++++++++++++-
 iptables/xshared.c    | 10 +++++++---
 4 files changed, 26 insertions(+), 6 deletions(-)

diff --git a/configure.ac b/configure.ac
index 02f6481ca52ed..5e330f3388de2 100644
--- a/configure.ac
+++ b/configure.ac
@@ -2,8 +2,8 @@
 AC_INIT([iptables], [1.8.4])
 
 # See libtool.info "Libtool's versioning system"
-libxtables_vcurrent=15
-libxtables_vage=3
+libxtables_vcurrent=16
+libxtables_vage=0
 
 AC_CONFIG_AUX_DIR([build-aux])
 AC_CONFIG_HEADERS([config.h])
diff --git a/include/xtables.h b/include/xtables.h
index 5044dd08e86d3..9483486bf7bae 100644
--- a/include/xtables.h
+++ b/include/xtables.h
@@ -356,6 +356,9 @@ struct xtables_target {
 	/* Print target name or alias */
 	const char *(*alias)(const struct xt_entry_target *target);
 
+	/* fill matchmask of size userspacesize */
+	void (*matchmask)(void *mask);
+
 	/* Pointer to list of extra command-line options */
 	const struct option *extra_opts;
 
diff --git a/iptables/nft-shared.c b/iptables/nft-shared.c
index c5a8f3fcc051d..d2c252a3081b0 100644
--- a/iptables/nft-shared.c
+++ b/iptables/nft-shared.c
@@ -968,8 +968,21 @@ bool compare_targets(struct xtables_target *tg1, struct xtables_target *tg2)
 	if (strcmp(tg1->t->u.user.name, tg2->t->u.user.name) != 0)
 		return false;
 
-	if (memcmp(tg1->t->data, tg2->t->data, tg1->userspacesize) != 0)
+	if (tg1->matchmask) {
+		char *mask = xtables_malloc(tg1->userspacesize);
+		int i;
+
+		tg1->matchmask(mask);
+		for (i = 0; i < tg1->userspacesize; i++) {
+			if ((tg1->t->data[i] ^ tg2->t->data[i]) & mask[i]) {
+				free(mask);
+				return false;
+			}
+		}
+		free(mask);
+	} else if (memcmp(tg1->t->data, tg2->t->data, tg1->userspacesize)) {
 		return false;
+	}
 
 	return true;
 }
diff --git a/iptables/xshared.c b/iptables/xshared.c
index 2438c4eeb5ff7..d938fc5d1f9e2 100644
--- a/iptables/xshared.c
+++ b/iptables/xshared.c
@@ -802,9 +802,13 @@ make_delete_mask(const struct xtables_rule_match *matches,
 		mptr += XT_ALIGN(sizeof(struct xt_entry_match)) + matchp->match->size;
 	}
 
-	memset(mptr, 0xFF,
-	       XT_ALIGN(sizeof(struct xt_entry_target))
-	       + target->userspacesize);
+	memset(mptr, 0xFF, XT_ALIGN(sizeof(struct xt_entry_target)));
+	mptr += XT_ALIGN(sizeof(struct xt_entry_target));
+
+	if (target->matchmask)
+		target->matchmask(mptr);
+	else
+		memset(mptr, 0xFF, target->userspacesize);
 
 	return mask;
 }
-- 
2.25.1

