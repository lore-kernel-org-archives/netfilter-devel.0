Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD2AEC433DB
	for <netfilter-devel@archiver.kernel.org>; Tue, 30 Mar 2021 14:16:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9D2F8619CE
	for <netfilter-devel@archiver.kernel.org>; Tue, 30 Mar 2021 14:16:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231532AbhC3OP6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 30 Mar 2021 10:15:58 -0400
Received: from relay.sw.ru ([185.231.240.75]:59362 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231652AbhC3OPe (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 30 Mar 2021 10:15:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=MIME-Version:Message-Id:Date:Subject:From:
        Content-Type; bh=rxCdYeGeWM+sIzm6uyzNrR4bf/763WV3Z3gkz5oO2Q4=; b=bb0DHUudK5eS
        EjGwRZDVz13mofXxHwhvjeGj6VZOHUhHvLJlMJ7prZwJHxeHMLsy+Z6wtLslPMzHtoEeB5td4IbS0
        k2Rp/b5Q9D61sIQhZfUZCuNLqAoQyvaL/fHa+bUylUdtb2iEnv6zYr3uCNev/UdGGlsk+ZO/baghL
        4M34Y=;
Received: from [10.93.0.33] (helo=dhcp-172-16-24-175.sw.ru)
        by relay.sw.ru with esmtp (Exim 4.94)
        (envelope-from <alexander.mikhalitsyn@virtuozzo.com>)
        id 1lRF9Y-000AvA-Hq; Tue, 30 Mar 2021 17:15:32 +0300
From:   Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
To:     netfilter-devel@vger.kernel.org
Cc:     pablo@netfilter.org, fw@strlen.de
Subject: [iptables PATCH v2 2/2] extensions: libxt_conntrack: print xlate status as set
Date:   Tue, 30 Mar 2021 17:15:24 +0300
Message-Id: <20210330141524.747259-2-alexander.mikhalitsyn@virtuozzo.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20210330141524.747259-1-alexander.mikhalitsyn@virtuozzo.com>
References: <20210330141524.747259-1-alexander.mikhalitsyn@virtuozzo.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

status_xlate_print function prints statusmask
without { ... } around. But if ctstatus condition is
negative, then we have to use { ... } after "!=" operator in nft

Reproducer:
$ iptables -A INPUT -d 127.0.0.1/32 -p tcp -m conntrack ! --ctstatus expected,assured -j DROP
$ nft list ruleset
...
meta l4proto tcp ip daddr 127.0.0.1 ct status != expected,assured counter packets 0 bytes 0 drop
...

it will fail if we try to load this rule:
$ nft -f nft_test
../nft_test:6:97-97: Error: syntax error, unexpected comma, expecting newline or semicolon

Signed-off-by: Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
---
 extensions/libxt_conntrack.c      | 15 +++++++++++++--
 extensions/libxt_conntrack.txlate |  3 +++
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/extensions/libxt_conntrack.c b/extensions/libxt_conntrack.c
index fe964aa..61a67b0 100644
--- a/extensions/libxt_conntrack.c
+++ b/extensions/libxt_conntrack.c
@@ -1198,9 +1198,16 @@ static int state_xlate(struct xt_xlate *xl,
 	return 1;
 }
 
-static void status_xlate_print(struct xt_xlate *xl, unsigned int statusmask)
+static void status_xlate_print(struct xt_xlate *xl, unsigned int statusmask, int afterinv)
 {
 	const char *sep = "";
+	int as_set;
+
+	/* print as set only after inversion and if more than one flag is set */
+	as_set = afterinv && (statusmask & (statusmask - 1));
+
+	if (as_set)
+		xt_xlate_add(xl, "{ ");
 
 	if (statusmask & IPS_EXPECTED) {
 		xt_xlate_add(xl, "%s%s", sep, "expected");
@@ -1218,6 +1225,9 @@ static void status_xlate_print(struct xt_xlate *xl, unsigned int statusmask)
 		xt_xlate_add(xl, "%s%s", sep, "confirmed");
 		sep = ",";
 	}
+
+	if (as_set)
+		xt_xlate_add(xl, " }");
 }
 
 static void addr_xlate_print(struct xt_xlate *xl,
@@ -1280,7 +1290,8 @@ static int _conntrack3_mt_xlate(struct xt_xlate *xl,
 		xt_xlate_add(xl, "%sct status %s", space,
 			     sinfo->invert_flags & XT_CONNTRACK_STATUS ?
 			     "!= " : "");
-		status_xlate_print(xl, sinfo->status_mask);
+		status_xlate_print(xl, sinfo->status_mask,
+				   sinfo->invert_flags & XT_CONNTRACK_STATUS);
 		space = " ";
 	}
 
diff --git a/extensions/libxt_conntrack.txlate b/extensions/libxt_conntrack.txlate
index 75b3daa..0cc7513 100644
--- a/extensions/libxt_conntrack.txlate
+++ b/extensions/libxt_conntrack.txlate
@@ -37,6 +37,9 @@ nft add rule ip filter INPUT ct status expected counter accept
 iptables-translate -t filter -A INPUT -m conntrack ! --ctstatus CONFIRMED -j ACCEPT
 nft add rule ip filter INPUT ct status != confirmed counter accept
 
+iptables-translate -t filter -A INPUT -m conntrack ! --ctstatus CONFIRMED,ASSURED -j ACCEPT
+nft add rule ip filter INPUT ct status != { assured,confirmed } counter accept
+
 iptables-translate -t filter -A INPUT -m conntrack --ctexpire 3 -j ACCEPT
 nft add rule ip filter INPUT ct expiration 3 counter accept
 
-- 
1.8.3.1

