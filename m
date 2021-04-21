Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12B12C433ED
	for <netfilter-devel@archiver.kernel.org>; Wed, 21 Apr 2021 07:51:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CCCAA6113C
	for <netfilter-devel@archiver.kernel.org>; Wed, 21 Apr 2021 07:51:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237372AbhDUHv4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 21 Apr 2021 03:51:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237376AbhDUHv4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 21 Apr 2021 03:51:56 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7978FC06174A
        for <netfilter-devel@vger.kernel.org>; Wed, 21 Apr 2021 00:51:23 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1lZ7dq-0004rx-58; Wed, 21 Apr 2021 09:51:22 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next v2 03/12] netfilter: add xt_find_table
Date:   Wed, 21 Apr 2021 09:51:01 +0200
Message-Id: <20210421075110.19334-4-fw@strlen.de>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20210421075110.19334-1-fw@strlen.de>
References: <20210421075110.19334-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This will be used to obtain the xt_table struct given address family and
table name.

Followup patches will reduce the number of direct accesses to the xt_table
structures via net->ipv{4,6}.ip(6)table_{nat,mangle,...} pointers, then
remove them.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/linux/netfilter/x_tables.h |  1 +
 net/netfilter/x_tables.c           | 17 +++++++++++++++++
 2 files changed, 18 insertions(+)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index 8ec48466410a..b2eec7de5280 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -322,6 +322,7 @@ struct xt_target *xt_request_find_target(u8 af, const char *name, u8 revision);
 int xt_find_revision(u8 af, const char *name, u8 revision, int target,
 		     int *err);
 
+struct xt_table *xt_find_table(struct net *net, u8 af, const char *name);
 struct xt_table *xt_find_table_lock(struct net *net, u_int8_t af,
 				    const char *name);
 struct xt_table *xt_request_find_table_lock(struct net *net, u_int8_t af,
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index b7f8d2ed3cc2..1caba9507228 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -1199,6 +1199,23 @@ void xt_free_table_info(struct xt_table_info *info)
 }
 EXPORT_SYMBOL(xt_free_table_info);
 
+struct xt_table *xt_find_table(struct net *net, u8 af, const char *name)
+{
+	struct xt_pernet *xt_net = net_generic(net, xt_pernet_id);
+	struct xt_table *t;
+
+	mutex_lock(&xt[af].mutex);
+	list_for_each_entry(t, &xt_net->tables[af], list) {
+		if (strcmp(t->name, name) == 0) {
+			mutex_unlock(&xt[af].mutex);
+			return t;
+		}
+	}
+	mutex_unlock(&xt[af].mutex);
+	return NULL;
+}
+EXPORT_SYMBOL(xt_find_table);
+
 /* Find table by name, grabs mutex & ref.  Returns ERR_PTR on error. */
 struct xt_table *xt_find_table_lock(struct net *net, u_int8_t af,
 				    const char *name)
-- 
2.26.3

