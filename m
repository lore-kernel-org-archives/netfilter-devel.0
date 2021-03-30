Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9984BC433C1
	for <netfilter-devel@archiver.kernel.org>; Tue, 30 Mar 2021 12:47:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6F166619B9
	for <netfilter-devel@archiver.kernel.org>; Tue, 30 Mar 2021 12:47:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232019AbhC3Mq2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 30 Mar 2021 08:46:28 -0400
Received: from relay.sw.ru ([185.231.240.75]:39352 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232057AbhC3MqJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 30 Mar 2021 08:46:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=MIME-Version:Message-Id:Date:Subject:From:
        Content-Type; bh=B01gtK4hc27EAxDiCu5ErZVoq48yA2WC8mqECLCTgLQ=; b=AJR8U8xy68IM
        CZNIuK7ralZXlGuT5FJFYxR2gLhY3NSL8wqCL7ghDa2R7TynBbUcgHj+PaW/C28H0eDVuY6plB4V4
        MPgkhTe2objznT/xITdCZ8XqkMJmxtapAEjHwzr2ZJFm/QJuiHbeZbJQZD76YUvr9NpWYI5xyEFqP
        UsCXU=;
Received: from [10.93.0.33] (helo=dhcp-172-16-24-175.sw.ru)
        by relay.sw.ru with esmtp (Exim 4.94)
        (envelope-from <alexander.mikhalitsyn@virtuozzo.com>)
        id 1lRDl0-000AnC-Iv; Tue, 30 Mar 2021 15:46:06 +0300
From:   Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
To:     netfilter-devel@vger.kernel.org
Cc:     pablo@netfilter.org, fw@strlen.de
Subject: [iptables PATCH 2/2] extensions: libxt_conntrack: print xlate status as set
Date:   Tue, 30 Mar 2021 15:45:48 +0300
Message-Id: <20210330124548.739796-2-alexander.mikhalitsyn@virtuozzo.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20210330124548.739796-1-alexander.mikhalitsyn@virtuozzo.com>
References: <20210330124548.739796-1-alexander.mikhalitsyn@virtuozzo.com>
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
 extensions/libxt_conntrack.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/extensions/libxt_conntrack.c b/extensions/libxt_conntrack.c
index b3a2b2d..132d512 100644
--- a/extensions/libxt_conntrack.c
+++ b/extensions/libxt_conntrack.c
@@ -1195,6 +1195,8 @@ static void status_xlate_print(struct xt_xlate *xl, unsigned int statusmask)
 {
 	const char *sep = "";
 
+	xt_xlate_add(xl, "{ ");
+
 	if (statusmask & IPS_EXPECTED) {
 		xt_xlate_add(xl, "%s%s", sep, "expected");
 		sep = ",";
@@ -1211,6 +1213,8 @@ static void status_xlate_print(struct xt_xlate *xl, unsigned int statusmask)
 		xt_xlate_add(xl, "%s%s", sep, "confirmed");
 		sep = ",";
 	}
+
+	xt_xlate_add(xl, " }");
 }
 
 static void addr_xlate_print(struct xt_xlate *xl,
-- 
1.8.3.1

