Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC564C433B4
	for <netfilter-devel@archiver.kernel.org>; Wed, 31 Mar 2021 13:03:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9B8936198F
	for <netfilter-devel@archiver.kernel.org>; Wed, 31 Mar 2021 13:03:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235140AbhCaNCt (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 31 Mar 2021 09:02:49 -0400
Received: from relay.sw.ru ([185.231.240.75]:46794 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235600AbhCaNCo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 31 Mar 2021 09:02:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=MIME-Version:Message-Id:Date:Subject:From:
        Content-Type; bh=y7DeDNYo2cBriH3kWILuQXmE8aBZ/bhackr7cF+9mvc=; b=PRp7ucNZU7th
        BXcRYDQd5s0J8YvxqYQgAjAAU1Ynf69fSCEEsWYBP/Gqlfp2clowC6AJnDt/vt067Ksk+XKI3Vjad
        NMxqo0KTOv7K/lWuTtUO+iBFKgAGr9QBAOSmTrlWFD5ghXVtFg/4DhcUIeXM3in1xXN7H7FShmyMY
        Apk60=;
Received: from [10.93.0.33] (helo=dhcp-172-16-24-175.sw.ru)
        by relay.sw.ru with esmtp (Exim 4.94)
        (envelope-from <alexander.mikhalitsyn@virtuozzo.com>)
        id 1lRaUb-000CdM-Eq; Wed, 31 Mar 2021 16:02:41 +0300
From:   Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
To:     netfilter-devel@vger.kernel.org
Cc:     pablo@netfilter.org, fw@strlen.de
Subject: [iptables PATCH v4 PATCH 1/2] extensions: libxt_conntrack: print xlate state as set
Date:   Wed, 31 Mar 2021 16:02:36 +0300
Message-Id: <20210331130237.860728-1-alexander.mikhalitsyn@virtuozzo.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Currently, state_xlate_print function prints statemask
without { ... } around. But if ctstate condition is
negative, then we have to use { ... } after "!=" operator

Reproducer:
$ iptables -A INPUT -d 127.0.0.1/32 -p tcp -m conntrack ! --ctstate RELATED,ESTABLISHED -j DROP
$ nft list ruleset
...
meta l4proto tcp ip daddr 127.0.0.1 ct state != related,established counter packets 0 bytes 0 drop
...

it will fail if we try to load this rule:
$ nft -f nft_test
../nft_test:6:97-97: Error: syntax error, unexpected comma, expecting newline or semicolon

Cc: Florian Westphal <fw@strlen.de>
Signed-off-by: Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
---
 extensions/libxt_conntrack.c      | 38 +++++++++++++++++++++++++-------------
 extensions/libxt_conntrack.txlate |  5 ++++-
 2 files changed, 29 insertions(+), 14 deletions(-)

diff --git a/extensions/libxt_conntrack.c b/extensions/libxt_conntrack.c
index 7734509..91f9e4a 100644
--- a/extensions/libxt_conntrack.c
+++ b/extensions/libxt_conntrack.c
@@ -1148,30 +1148,43 @@ static void state_save(const void *ip, const struct xt_entry_match *match)
 	state_print_state(sinfo->statemask);
 }
 
-static void state_xlate_print(struct xt_xlate *xl, unsigned int statemask)
+static void state_xlate_print(struct xt_xlate *xl, unsigned int statemask, int inverted)
 {
 	const char *sep = "";
+	int one_flag_set;
+
+	one_flag_set = !(statemask & (statemask - 1));
+
+	if (inverted && !one_flag_set)
+		xt_xlate_add(xl, "& (");
+	else if (inverted)
+		xt_xlate_add(xl, "& ");
 
 	if (statemask & XT_CONNTRACK_STATE_INVALID) {
 		xt_xlate_add(xl, "%s%s", sep, "invalid");
-		sep = ",";
+		sep = inverted && !one_flag_set ? "|" : ",";
 	}
 	if (statemask & XT_CONNTRACK_STATE_BIT(IP_CT_NEW)) {
 		xt_xlate_add(xl, "%s%s", sep, "new");
-		sep = ",";
+		sep = inverted && !one_flag_set ? "|" : ",";
 	}
 	if (statemask & XT_CONNTRACK_STATE_BIT(IP_CT_RELATED)) {
 		xt_xlate_add(xl, "%s%s", sep, "related");
-		sep = ",";
+		sep = inverted && !one_flag_set ? "|" : ",";
 	}
 	if (statemask & XT_CONNTRACK_STATE_BIT(IP_CT_ESTABLISHED)) {
 		xt_xlate_add(xl, "%s%s", sep, "established");
-		sep = ",";
+		sep = inverted && !one_flag_set ? "|" : ",";
 	}
 	if (statemask & XT_CONNTRACK_STATE_UNTRACKED) {
 		xt_xlate_add(xl, "%s%s", sep, "untracked");
-		sep = ",";
+		sep = inverted && !one_flag_set ? "|" : ",";
 	}
+
+	if (inverted && !one_flag_set)
+		xt_xlate_add(xl, ") == 0");
+	else if (inverted)
+		xt_xlate_add(xl, " == 0");
 }
 
 static int state_xlate(struct xt_xlate *xl,
@@ -1180,9 +1193,9 @@ static int state_xlate(struct xt_xlate *xl,
 	const struct xt_conntrack_mtinfo3 *sinfo =
 		(const void *)params->match->data;
 
-	xt_xlate_add(xl, "ct state %s", sinfo->invert_flags & XT_CONNTRACK_STATE ?
-					"!= " : "");
-	state_xlate_print(xl, sinfo->state_mask);
+	xt_xlate_add(xl, "ct state ");
+	state_xlate_print(xl, sinfo->state_mask,
+			  sinfo->invert_flags & XT_CONNTRACK_STATE);
 	xt_xlate_add(xl, " ");
 	return 1;
 }
@@ -1256,10 +1269,9 @@ static int _conntrack3_mt_xlate(struct xt_xlate *xl,
 				     sinfo->state_mask & XT_CONNTRACK_STATE_SNAT ? "snat" : "dnat");
 			space = " ";
 		} else {
-			xt_xlate_add(xl, "%sct state %s", space,
-				     sinfo->invert_flags & XT_CONNTRACK_STATE ?
-				     "!= " : "");
-			state_xlate_print(xl, sinfo->state_mask);
+			xt_xlate_add(xl, "%sct state ", space);
+			state_xlate_print(xl, sinfo->state_mask,
+					  sinfo->invert_flags & XT_CONNTRACK_STATE);
 			space = " ";
 		}
 	}
diff --git a/extensions/libxt_conntrack.txlate b/extensions/libxt_conntrack.txlate
index d374f8a..5ab85b1 100644
--- a/extensions/libxt_conntrack.txlate
+++ b/extensions/libxt_conntrack.txlate
@@ -2,7 +2,10 @@ iptables-translate -t filter -A INPUT -m conntrack --ctstate NEW,RELATED -j ACCE
 nft add rule ip filter INPUT ct state new,related counter accept
 
 ip6tables-translate -t filter -A INPUT -m conntrack ! --ctstate NEW,RELATED -j ACCEPT
-nft add rule ip6 filter INPUT ct state != new,related counter accept
+nft add rule ip6 filter INPUT ct state & (new|related) == 0 counter accept
+
+ip6tables-translate -t filter -A INPUT -m conntrack ! --ctstate NEW -j ACCEPT
+nft add rule ip6 filter INPUT ct state & new == 0 counter accept
 
 iptables-translate -t filter -A INPUT -m conntrack --ctproto UDP -j ACCEPT
 nft add rule ip filter INPUT ct original protocol 17 counter accept
-- 
1.8.3.1

