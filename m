Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C1F5C433E0
	for <netfilter-devel@archiver.kernel.org>; Wed, 31 Mar 2021 10:30:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B6BA61990
	for <netfilter-devel@archiver.kernel.org>; Wed, 31 Mar 2021 10:30:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234956AbhCaKaJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 31 Mar 2021 06:30:09 -0400
Received: from relay.sw.ru ([185.231.240.75]:49890 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234855AbhCaK3x (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 31 Mar 2021 06:29:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=MIME-Version:Message-Id:Date:Subject:From:
        Content-Type; bh=TV2YQyVZAUq8Kt3dD6VeMG/SVDZRtjirvvPwbzVjEqM=; b=QW5mrwvuicuw
        pj1K3SnYJcbrhD9cAwXrMai1eCLsh1Fv9pWkMvX+bCk45O5vRVhoip0TMiK87RKD5ll5rzah5u9eo
        ow02CyZI7U+LOr9L7fXFu1lPERjDei8Fa7StwT6bQ6I68fXfwmYsr4NF6lmFihQq86/bmyL2yktCn
        agDsc=;
Received: from [10.93.0.33] (helo=dhcp-172-16-24-175.sw.ru)
        by relay.sw.ru with esmtp (Exim 4.94)
        (envelope-from <alexander.mikhalitsyn@virtuozzo.com>)
        id 1lRY6h-000CRd-Oc; Wed, 31 Mar 2021 13:29:51 +0300
From:   Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
To:     netfilter-devel@vger.kernel.org
Cc:     pablo@netfilter.org, fw@strlen.de
Subject: [iptables PATCH v3 1/2] extensions: libxt_conntrack: print xlate state as set
Date:   Wed, 31 Mar 2021 13:29:33 +0300
Message-Id: <20210331102934.848126-1-alexander.mikhalitsyn@virtuozzo.com>
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
 extensions/libxt_conntrack.c      | 18 +++++++++++++++---
 extensions/libxt_conntrack.txlate |  5 ++++-
 2 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/extensions/libxt_conntrack.c b/extensions/libxt_conntrack.c
index 7734509..fe964aa 100644
--- a/extensions/libxt_conntrack.c
+++ b/extensions/libxt_conntrack.c
@@ -1148,9 +1148,16 @@ static void state_save(const void *ip, const struct xt_entry_match *match)
 	state_print_state(sinfo->statemask);
 }
 
-static void state_xlate_print(struct xt_xlate *xl, unsigned int statemask)
+static void state_xlate_print(struct xt_xlate *xl, unsigned int statemask, int afterinv)
 {
 	const char *sep = "";
+	int as_set;
+
+	/* print as set only after inversion and if more than one flag is set */
+	as_set = afterinv && (statemask & (statemask - 1));
+
+	if (as_set)
+		xt_xlate_add(xl, "{ ");
 
 	if (statemask & XT_CONNTRACK_STATE_INVALID) {
 		xt_xlate_add(xl, "%s%s", sep, "invalid");
@@ -1172,6 +1179,9 @@ static void state_xlate_print(struct xt_xlate *xl, unsigned int statemask)
 		xt_xlate_add(xl, "%s%s", sep, "untracked");
 		sep = ",";
 	}
+
+	if (as_set)
+		xt_xlate_add(xl, " }");
 }
 
 static int state_xlate(struct xt_xlate *xl,
@@ -1182,7 +1192,8 @@ static int state_xlate(struct xt_xlate *xl,
 
 	xt_xlate_add(xl, "ct state %s", sinfo->invert_flags & XT_CONNTRACK_STATE ?
 					"!= " : "");
-	state_xlate_print(xl, sinfo->state_mask);
+	state_xlate_print(xl, sinfo->state_mask,
+			  sinfo->invert_flags & XT_CONNTRACK_STATE);
 	xt_xlate_add(xl, " ");
 	return 1;
 }
@@ -1259,7 +1270,8 @@ static int _conntrack3_mt_xlate(struct xt_xlate *xl,
 			xt_xlate_add(xl, "%sct state %s", space,
 				     sinfo->invert_flags & XT_CONNTRACK_STATE ?
 				     "!= " : "");
-			state_xlate_print(xl, sinfo->state_mask);
+			state_xlate_print(xl, sinfo->state_mask,
+					  sinfo->invert_flags & XT_CONNTRACK_STATE);
 			space = " ";
 		}
 	}
diff --git a/extensions/libxt_conntrack.txlate b/extensions/libxt_conntrack.txlate
index d374f8a..75b3daa 100644
--- a/extensions/libxt_conntrack.txlate
+++ b/extensions/libxt_conntrack.txlate
@@ -2,7 +2,10 @@ iptables-translate -t filter -A INPUT -m conntrack --ctstate NEW,RELATED -j ACCE
 nft add rule ip filter INPUT ct state new,related counter accept
 
 ip6tables-translate -t filter -A INPUT -m conntrack ! --ctstate NEW,RELATED -j ACCEPT
-nft add rule ip6 filter INPUT ct state != new,related counter accept
+nft add rule ip6 filter INPUT ct state != { new,related } counter accept
+
+ip6tables-translate -t filter -A INPUT -m conntrack ! --ctstate NEW -j ACCEPT
+nft add rule ip6 filter INPUT ct state != new counter accept
 
 iptables-translate -t filter -A INPUT -m conntrack --ctproto UDP -j ACCEPT
 nft add rule ip filter INPUT ct original protocol 17 counter accept
-- 
1.8.3.1

