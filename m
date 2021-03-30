Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCF7BC433E0
	for <netfilter-devel@archiver.kernel.org>; Tue, 30 Mar 2021 12:47:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 980F6619BA
	for <netfilter-devel@archiver.kernel.org>; Tue, 30 Mar 2021 12:47:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232051AbhC3Mq3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 30 Mar 2021 08:46:29 -0400
Received: from relay.sw.ru ([185.231.240.75]:39350 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232054AbhC3MqJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 30 Mar 2021 08:46:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=MIME-Version:Message-Id:Date:Subject:From:
        Content-Type; bh=3+IIpFewwoy8HVW52VE19N4BnJpPt/kiKdbzxS9js8o=; b=w7k2qiQF6EkJ
        eVJnIrGFL7A4oE06hGXYQI+kP3WFLN0wijODDwTEH9P74INlQYfN916fod59LRcrCr2O83iCXe4Ol
        0dm4/WS5ML1tRsVMXnM2Y177dpsQgnV6UQTxvoYjtyTgK1oS8zDEeIT67AEketXdRfokGMed9x33G
        mGw+w=;
Received: from [10.93.0.33] (helo=dhcp-172-16-24-175.sw.ru)
        by relay.sw.ru with esmtp (Exim 4.94)
        (envelope-from <alexander.mikhalitsyn@virtuozzo.com>)
        id 1lRDl0-000AnC-GV; Tue, 30 Mar 2021 15:46:06 +0300
From:   Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
To:     netfilter-devel@vger.kernel.org
Cc:     pablo@netfilter.org, fw@strlen.de
Subject: [iptables PATCH 1/2] extensions: libxt_conntrack: print xlate state as set
Date:   Tue, 30 Mar 2021 15:45:47 +0300
Message-Id: <20210330124548.739796-1-alexander.mikhalitsyn@virtuozzo.com>
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

Signed-off-by: Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>

---
 extensions/libxt_conntrack.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/extensions/libxt_conntrack.c b/extensions/libxt_conntrack.c
index 7734509..b3a2b2d 100644
--- a/extensions/libxt_conntrack.c
+++ b/extensions/libxt_conntrack.c
@@ -1152,6 +1152,8 @@ static void state_xlate_print(struct xt_xlate *xl, unsigned int statemask)
 {
 	const char *sep = "";
 
+	xt_xlate_add(xl, "{ ");
+
 	if (statemask & XT_CONNTRACK_STATE_INVALID) {
 		xt_xlate_add(xl, "%s%s", sep, "invalid");
 		sep = ",";
@@ -1172,6 +1174,8 @@ static void state_xlate_print(struct xt_xlate *xl, unsigned int statemask)
 		xt_xlate_add(xl, "%s%s", sep, "untracked");
 		sep = ",";
 	}
+
+	xt_xlate_add(xl, " }");
 }
 
 static int state_xlate(struct xt_xlate *xl,
-- 
1.8.3.1

