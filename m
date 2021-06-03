Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38C0BC4708F
	for <netfilter-devel@archiver.kernel.org>; Thu,  3 Jun 2021 00:07:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1001C6101B
	for <netfilter-devel@archiver.kernel.org>; Thu,  3 Jun 2021 00:07:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229790AbhFCAIo (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 2 Jun 2021 20:08:44 -0400
Received: from mail.netfilter.org ([217.70.188.207]:43240 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbhFCAIo (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 2 Jun 2021 20:08:44 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 1523364156
        for <netfilter-devel@vger.kernel.org>; Thu,  3 Jun 2021 02:05:52 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH iptables] extensions: libxt_conntrack: simplify translation using negation
Date:   Thu,  3 Jun 2021 02:06:56 +0200
Message-Id: <20210603000656.4348-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Available since nftables 0.9.9. For example:

 # iptables-translate -I INPUT -m state ! --state NEW,INVALID
 nft insert rule ip filter INPUT ct state ! invalid,new  counter

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 extensions/libxt_conntrack.c | 46 ++++++++++--------------------------
 1 file changed, 13 insertions(+), 33 deletions(-)

diff --git a/extensions/libxt_conntrack.c b/extensions/libxt_conntrack.c
index 7f7b45ee1f82..64018ce152b7 100644
--- a/extensions/libxt_conntrack.c
+++ b/extensions/libxt_conntrack.c
@@ -1151,40 +1151,30 @@ static void state_save(const void *ip, const struct xt_entry_match *match)
 static void state_xlate_print(struct xt_xlate *xl, unsigned int statemask, int inverted)
 {
 	const char *sep = "";
-	int one_flag_set;
 
-	one_flag_set = !(statemask & (statemask - 1));
-
-	if (inverted && !one_flag_set)
-		xt_xlate_add(xl, "& (");
-	else if (inverted)
-		xt_xlate_add(xl, "& ");
+	if (inverted)
+		xt_xlate_add(xl, "! ");
 
 	if (statemask & XT_CONNTRACK_STATE_INVALID) {
 		xt_xlate_add(xl, "%s%s", sep, "invalid");
-		sep = inverted && !one_flag_set ? "|" : ",";
+		sep = ",";
 	}
 	if (statemask & XT_CONNTRACK_STATE_BIT(IP_CT_NEW)) {
 		xt_xlate_add(xl, "%s%s", sep, "new");
-		sep = inverted && !one_flag_set ? "|" : ",";
+		sep = ",";
 	}
 	if (statemask & XT_CONNTRACK_STATE_BIT(IP_CT_RELATED)) {
 		xt_xlate_add(xl, "%s%s", sep, "related");
-		sep = inverted && !one_flag_set ? "|" : ",";
+		sep = ",";
 	}
 	if (statemask & XT_CONNTRACK_STATE_BIT(IP_CT_ESTABLISHED)) {
 		xt_xlate_add(xl, "%s%s", sep, "established");
-		sep = inverted && !one_flag_set ? "|" : ",";
+		sep = ",";
 	}
 	if (statemask & XT_CONNTRACK_STATE_UNTRACKED) {
 		xt_xlate_add(xl, "%s%s", sep, "untracked");
-		sep = inverted && !one_flag_set ? "|" : ",";
+		sep = ",";
 	}
-
-	if (inverted && !one_flag_set)
-		xt_xlate_add(xl, ") == 0");
-	else if (inverted)
-		xt_xlate_add(xl, " == 0");
 }
 
 static int state_xlate(struct xt_xlate *xl,
@@ -1203,36 +1193,26 @@ static int state_xlate(struct xt_xlate *xl,
 static void status_xlate_print(struct xt_xlate *xl, unsigned int statusmask, int inverted)
 {
 	const char *sep = "";
-	int one_flag_set;
 
-	one_flag_set = !(statusmask & (statusmask - 1));
-
-	if (inverted && !one_flag_set)
-		xt_xlate_add(xl, "& (");
-	else if (inverted)
-		xt_xlate_add(xl, "& ");
+	if (inverted)
+		xt_xlate_add(xl, "! ");
 
 	if (statusmask & IPS_EXPECTED) {
 		xt_xlate_add(xl, "%s%s", sep, "expected");
-		sep = inverted && !one_flag_set ? "|" : ",";
+		sep = ",";
 	}
 	if (statusmask & IPS_SEEN_REPLY) {
 		xt_xlate_add(xl, "%s%s", sep, "seen-reply");
-		sep = inverted && !one_flag_set ? "|" : ",";
+		sep = ",";
 	}
 	if (statusmask & IPS_ASSURED) {
 		xt_xlate_add(xl, "%s%s", sep, "assured");
-		sep = inverted && !one_flag_set ? "|" : ",";
+		sep = ",";
 	}
 	if (statusmask & IPS_CONFIRMED) {
 		xt_xlate_add(xl, "%s%s", sep, "confirmed");
-		sep = inverted && !one_flag_set ? "|" : ",";
+		sep = ",";
 	}
-
-	if (inverted && !one_flag_set)
-		xt_xlate_add(xl, ") == 0");
-	else if (inverted)
-		xt_xlate_add(xl, " == 0");
 }
 
 static void addr_xlate_print(struct xt_xlate *xl,
-- 
2.20.1

