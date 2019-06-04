Return-Path: <SRS0=ghWo=UD=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6316C282CE
	for <netfilter-devel@archiver.kernel.org>; Tue,  4 Jun 2019 17:32:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C8EC82067C
	for <netfilter-devel@archiver.kernel.org>; Tue,  4 Jun 2019 17:32:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726521AbfFDRc1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 4 Jun 2019 13:32:27 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:56472 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726312AbfFDRc1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 4 Jun 2019 13:32:27 -0400
Received: from localhost ([::1]:41328 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1hYDIQ-0000mM-BU; Tue, 04 Jun 2019 19:32:26 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Eric Garver <e@erig.me>
Subject: [nft PATCH v5 07/10] rule: Introduce rule_lookup_by_index()
Date:   Tue,  4 Jun 2019 19:31:55 +0200
Message-Id: <20190604173158.1184-8-phil@nwl.cc>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190604173158.1184-1-phil@nwl.cc>
References: <20190604173158.1184-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

In contrast to rule_lookup(), this function returns a chain's rule at a
given index instead of by handle.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/rule.h |  2 ++
 src/rule.c     | 11 +++++++++++
 2 files changed, 13 insertions(+)

diff --git a/include/rule.h b/include/rule.h
index 61aa040a2e891..a7dd042d60e3f 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -260,6 +260,8 @@ extern struct rule *rule_get(struct rule *rule);
 extern void rule_free(struct rule *rule);
 extern void rule_print(const struct rule *rule, struct output_ctx *octx);
 extern struct rule *rule_lookup(const struct chain *chain, uint64_t handle);
+extern struct rule *rule_lookup_by_index(const struct chain *chain,
+					 uint64_t index);
 
 /**
  * struct set - nftables set
diff --git a/src/rule.c b/src/rule.c
index a734ec6097b16..4270fc7a9cd92 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -719,6 +719,17 @@ struct rule *rule_lookup(const struct chain *chain, uint64_t handle)
 	return NULL;
 }
 
+struct rule *rule_lookup_by_index(const struct chain *chain, uint64_t index)
+{
+	struct rule *rule;
+
+	list_for_each_entry(rule, &chain->rules, list) {
+		if (!--index)
+			return rule;
+	}
+	return NULL;
+}
+
 struct scope *scope_init(struct scope *scope, const struct scope *parent)
 {
 	scope->parent = parent;
-- 
2.21.0

