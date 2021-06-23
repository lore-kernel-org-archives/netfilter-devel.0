Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4814C4743C
	for <netfilter-devel@archiver.kernel.org>; Wed, 23 Jun 2021 12:46:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 90FA061076
	for <netfilter-devel@archiver.kernel.org>; Wed, 23 Jun 2021 12:46:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230163AbhFWMsd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 23 Jun 2021 08:48:33 -0400
Received: from mail.netfilter.org ([217.70.188.207]:60646 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230019AbhFWMsd (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 23 Jun 2021 08:48:33 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 13D706423C
        for <netfilter-devel@vger.kernel.org>; Wed, 23 Jun 2021 14:44:50 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] rule: obj_free() releases timeout state string
Date:   Wed, 23 Jun 2021 14:46:11 +0200
Message-Id: <20210623124611.2663-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Missing free() on the timeout state string on object release.

Fixes: 7a0e26723496 ("rule: memleak of list of timeout policies"
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/rule.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/src/rule.c b/src/rule.c
index 10569aa7875a..877eae3cd85d 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -1714,6 +1714,7 @@ void obj_free(struct obj *obj)
 
 		list_for_each_entry_safe(ts, next, &obj->ct_timeout.timeout_list, head) {
 			list_del(&ts->head);
+			xfree(ts->timeout_str);
 			xfree(ts);
 		}
 	}
-- 
2.20.1

