Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1E86C4709A
	for <netfilter-devel@archiver.kernel.org>; Thu,  3 Jun 2021 22:58:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 95F496140C
	for <netfilter-devel@archiver.kernel.org>; Thu,  3 Jun 2021 22:58:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbhFCW77 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 3 Jun 2021 18:59:59 -0400
Received: from mail.netfilter.org ([217.70.188.207]:45826 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229812AbhFCW77 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 3 Jun 2021 18:59:59 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 5B4506420B
        for <netfilter-devel@vger.kernel.org>; Fri,  4 Jun 2021 00:57:05 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH iptables,v2 5/5] extensions: libxt_conntrack: simplify translation using negation
Date:   Fri,  4 Jun 2021 00:58:06 +0200
Message-Id: <20210603225806.13625-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210603225806.13625-1-pablo@netfilter.org>
References: <20210603225806.13625-1-pablo@netfilter.org>
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
 extensions/libxt_conntrack.c      | 46 +++++++++----------------------
 extensions/libxt_conntrack.txlate |  8 +++---
 2 files changed, 17 insertions(+), 37 deletions(-)

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
diff --git a/extensions/libxt_conntrack.txlate b/extensions/libxt_conntrack.txlate
index 8cc7c504ab4b..45fba984ba96 100644
--- a/extensions/libxt_conntrack.txlate
+++ b/extensions/libxt_conntrack.txlate
@@ -2,10 +2,10 @@ iptables-translate -t filter -A INPUT -m conntrack --ctstate NEW,RELATED -j ACCE
 nft add rule ip filter INPUT ct state new,related counter accept
 
 ip6tables-translate -t filter -A INPUT -m conntrack ! --ctstate NEW,RELATED -j ACCEPT
-nft add rule ip6 filter INPUT ct state & (new|related) == 0 counter accept
+nft add rule ip6 filter INPUT ct state ! new,related counter accept
 
 ip6tables-translate -t filter -A INPUT -m conntrack ! --ctstate NEW -j ACCEPT
-nft add rule ip6 filter INPUT ct state & new == 0 counter accept
+nft add rule ip6 filter INPUT ct state ! new counter accept
 
 iptables-translate -t filter -A INPUT -m conntrack --ctproto UDP -j ACCEPT
 nft add rule ip filter INPUT ct original protocol 17 counter accept
@@ -35,10 +35,10 @@ iptables-translate -t filter -A INPUT -m conntrack --ctstatus EXPECTED -j ACCEPT
 nft add rule ip filter INPUT ct status expected counter accept
 
 iptables-translate -t filter -A INPUT -m conntrack ! --ctstatus CONFIRMED -j ACCEPT
-nft add rule ip filter INPUT ct status & confirmed == 0 counter accept
+nft add rule ip filter INPUT ct status ! confirmed counter accept
 
 iptables-translate -t filter -A INPUT -m conntrack ! --ctstatus CONFIRMED,ASSURED -j ACCEPT
-nft add rule ip filter INPUT ct status & (assured|confirmed) == 0 counter accept
+nft add rule ip filter INPUT ct status ! assured,confirmed counter accept
 
 iptables-translate -t filter -A INPUT -m conntrack --ctstatus CONFIRMED,ASSURED -j ACCEPT
 nft add rule ip filter INPUT ct status assured,confirmed counter accept
-- 
2.20.1

