Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E9FDC4161D
	for <netfilter-devel@archiver.kernel.org>; Thu,  1 Apr 2021 18:31:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D7A860C3E
	for <netfilter-devel@archiver.kernel.org>; Thu,  1 Apr 2021 18:31:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234608AbhDASbp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 1 Apr 2021 14:31:45 -0400
Received: from relay.sw.ru ([185.231.240.75]:40410 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234620AbhDASRj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 1 Apr 2021 14:17:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=MIME-Version:Message-Id:Date:Subject:From:
        Content-Type; bh=ZICGHgbe0yvapa1EaB1+YEHGNpN5YILQgHqtq1MlvN0=; b=P1xWkhKRZLuu
        fVdp5UvUKFjt+xhpeCAVitwxmN0+m84FuEgeE4iTsp8OSmNcQl7aoiiNiB1u2APrpl4xqN6HF/acg
        RfzTEUxVkTtI4JT9eZXgnbuojb/rmsYlCxhzZgTLNdJ8iQyzGhLA0pb9daBjwbxRbau2Ze1sMhEm0
        ACaoY=;
Received: from [10.94.6.52] (helo=dhcp-172-16-24-175.sw.ru)
        by relay.sw.ru with esmtp (Exim 4.94)
        (envelope-from <alexander.mikhalitsyn@virtuozzo.com>)
        id 1lRxfQ-000EFa-8n; Thu, 01 Apr 2021 16:47:24 +0300
From:   Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
To:     netfilter-devel@vger.kernel.org
Cc:     pablo@netfilter.org, fw@strlen.de
Subject: [iptables PATCH v5 2/2] extensions: libxt_conntrack: print xlate status as set
Date:   Thu,  1 Apr 2021 16:47:08 +0300
Message-Id: <20210401134708.34288-2-alexander.mikhalitsyn@virtuozzo.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20210401134708.34288-1-alexander.mikhalitsyn@virtuozzo.com>
References: <20210401134708.34288-1-alexander.mikhalitsyn@virtuozzo.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

At the moment, status_xlate_print function prints statusmask as comma-separated
sequence of enabled statusmask flags. But if we have inverted conntrack ctstatus
condition then we have to use more complex expression (if more than one flag enabled)
because nft not supports syntax like "ct status != expected,assured".

Examples:
! --ctstatus CONFIRMED,ASSURED
should be translated as
ct status & (assured|confirmed) == 0

! --ctstatus CONFIRMED
can be translated as
ct status & confirmed == 0

See also netfilter/xt_conntrack.c (conntrack_mt() function as a reference).

Reproducer:
$ iptables -A INPUT -d 127.0.0.1/32 -p tcp -m conntrack ! --ctstatus expected,assured -j DROP
$ nft list ruleset
...
meta l4proto tcp ip daddr 127.0.0.1 ct status != expected,assured counter packets 0 bytes 0 drop
...

it will fail if we try to load this rule:
$ nft -f nft_test
../nft_test:6:97-97: Error: syntax error, unexpected comma, expecting newline or semicolon

Cc: Florian Westphal <fw@strlen.de>
Signed-off-by: Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
---
 extensions/libxt_conntrack.c      | 30 +++++++++++++++++++++---------
 extensions/libxt_conntrack.txlate |  8 +++++++-
 2 files changed, 28 insertions(+), 10 deletions(-)

diff --git a/extensions/libxt_conntrack.c b/extensions/libxt_conntrack.c
index 91f9e4a..7f7b45e 100644
--- a/extensions/libxt_conntrack.c
+++ b/extensions/libxt_conntrack.c
@@ -1200,26 +1200,39 @@ static int state_xlate(struct xt_xlate *xl,
 	return 1;
 }
 
-static void status_xlate_print(struct xt_xlate *xl, unsigned int statusmask)
+static void status_xlate_print(struct xt_xlate *xl, unsigned int statusmask, int inverted)
 {
 	const char *sep = "";
+	int one_flag_set;
+
+	one_flag_set = !(statusmask & (statusmask - 1));
+
+	if (inverted && !one_flag_set)
+		xt_xlate_add(xl, "& (");
+	else if (inverted)
+		xt_xlate_add(xl, "& ");
 
 	if (statusmask & IPS_EXPECTED) {
 		xt_xlate_add(xl, "%s%s", sep, "expected");
-		sep = ",";
+		sep = inverted && !one_flag_set ? "|" : ",";
 	}
 	if (statusmask & IPS_SEEN_REPLY) {
 		xt_xlate_add(xl, "%s%s", sep, "seen-reply");
-		sep = ",";
+		sep = inverted && !one_flag_set ? "|" : ",";
 	}
 	if (statusmask & IPS_ASSURED) {
 		xt_xlate_add(xl, "%s%s", sep, "assured");
-		sep = ",";
+		sep = inverted && !one_flag_set ? "|" : ",";
 	}
 	if (statusmask & IPS_CONFIRMED) {
 		xt_xlate_add(xl, "%s%s", sep, "confirmed");
-		sep = ",";
+		sep = inverted && !one_flag_set ? "|" : ",";
 	}
+
+	if (inverted && !one_flag_set)
+		xt_xlate_add(xl, ") == 0");
+	else if (inverted)
+		xt_xlate_add(xl, " == 0");
 }
 
 static void addr_xlate_print(struct xt_xlate *xl,
@@ -1277,10 +1290,9 @@ static int _conntrack3_mt_xlate(struct xt_xlate *xl,
 	}
 
 	if (sinfo->match_flags & XT_CONNTRACK_STATUS) {
-		xt_xlate_add(xl, "%sct status %s", space,
-			     sinfo->invert_flags & XT_CONNTRACK_STATUS ?
-			     "!= " : "");
-		status_xlate_print(xl, sinfo->status_mask);
+		xt_xlate_add(xl, "%sct status ", space);
+		status_xlate_print(xl, sinfo->status_mask,
+				   sinfo->invert_flags & XT_CONNTRACK_STATUS);
 		space = " ";
 	}
 
diff --git a/extensions/libxt_conntrack.txlate b/extensions/libxt_conntrack.txlate
index 5ab85b1..8cc7c50 100644
--- a/extensions/libxt_conntrack.txlate
+++ b/extensions/libxt_conntrack.txlate
@@ -35,7 +35,13 @@ iptables-translate -t filter -A INPUT -m conntrack --ctstatus EXPECTED -j ACCEPT
 nft add rule ip filter INPUT ct status expected counter accept
 
 iptables-translate -t filter -A INPUT -m conntrack ! --ctstatus CONFIRMED -j ACCEPT
-nft add rule ip filter INPUT ct status != confirmed counter accept
+nft add rule ip filter INPUT ct status & confirmed == 0 counter accept
+
+iptables-translate -t filter -A INPUT -m conntrack ! --ctstatus CONFIRMED,ASSURED -j ACCEPT
+nft add rule ip filter INPUT ct status & (assured|confirmed) == 0 counter accept
+
+iptables-translate -t filter -A INPUT -m conntrack --ctstatus CONFIRMED,ASSURED -j ACCEPT
+nft add rule ip filter INPUT ct status assured,confirmed counter accept
 
 iptables-translate -t filter -A INPUT -m conntrack --ctexpire 3 -j ACCEPT
 nft add rule ip filter INPUT ct expiration 3 counter accept
-- 
1.8.3.1

