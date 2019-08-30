Return-Path: <SRS0=JGmF=W2=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10246C3A5A3
	for <netfilter-devel@archiver.kernel.org>; Fri, 30 Aug 2019 04:17:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DB34021897
	for <netfilter-devel@archiver.kernel.org>; Fri, 30 Aug 2019 04:17:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726492AbfH3ER2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 30 Aug 2019 00:17:28 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:42669 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725819AbfH3ER2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 30 Aug 2019 00:17:28 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id C25FD4166E;
        Fri, 30 Aug 2019 12:17:22 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org, fw@strlen.de
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next v7 2/8] netfilter:nf_flow_table_core: Separate inet operation to single function
Date:   Fri, 30 Aug 2019 12:17:16 +0800
Message-Id: <1567138642-11446-3-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1567138642-11446-1-git-send-email-wenxu@ucloud.cn>
References: <1567138642-11446-1-git-send-email-wenxu@ucloud.cn>
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVklVSk9IS0tLSklOQ0NOS0pZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6OhQ6Kio4PTg5HzIRMiwZLzYO
        Ik4aCx5VSlVKTk1MSkhDTU9JQkxIVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQU9OSE03Bg++
X-HM-Tid: 0a6ce0bdfb772086kuqyc25fd4166e
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

This patch separate the inet family operation in nf_flow_table_core to
single function. Prepare for support the bridge family.

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
v7: rebase with upstream fix

 net/netfilter/nf_flow_table_core.c | 52 ++++++++++++++++++++++++++++----------
 1 file changed, 38 insertions(+), 14 deletions(-)

diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index e9bc756..9492c97 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -22,6 +22,20 @@ struct flow_offload_entry {
 static DEFINE_MUTEX(flowtable_lock);
 static LIST_HEAD(flowtables);
 
+static struct dst_entry *
+flow_offload_fill_inet_dst(struct flow_offload_tuple *ft,
+			   struct nf_flow_route *route,
+			   enum flow_offload_tuple_dir dir)
+{
+	struct dst_entry *other_dst = route->tuple[!dir].dst;
+	struct dst_entry *dst = route->tuple[dir].dst;
+
+	ft->iifidx = other_dst->dev->ifindex;
+	ft->dst.dst_cache = dst;
+
+	return dst;
+}
+
 static void
 flow_offload_fill_dir(struct flow_offload *flow, struct nf_conn *ct,
 		      struct nf_flow_dst *flow_dst,
@@ -29,9 +43,9 @@ struct flow_offload_entry {
 {
 	struct flow_offload_tuple *ft = &flow->tuplehash[dir].tuple;
 	struct nf_conntrack_tuple *ctt = &ct->tuplehash[dir].tuple;
-	struct dst_entry *other_dst = flow_dst->route.tuple[!dir].dst;
-	struct dst_entry *dst = flow_dst->route.tuple[dir].dst;
+	struct dst_entry *dst;
 
+	dst = flow_offload_fill_inet_dst(ft, &flow_dst->route, dir);
 	ft->dir = dir;
 
 	switch (ctt->src.l3num) {
@@ -51,9 +65,19 @@ struct flow_offload_entry {
 	ft->l4proto = ctt->dst.protonum;
 	ft->src_port = ctt->src.u.tcp.port;
 	ft->dst_port = ctt->dst.u.tcp.port;
+}
 
-	ft->iifidx = other_dst->dev->ifindex;
-	ft->dst.dst_cache = dst;
+static int flow_offload_dst_hold(struct nf_flow_dst *flow_dst)
+{
+	if (!dst_hold_safe(flow_dst->route.tuple[FLOW_OFFLOAD_DIR_ORIGINAL].dst))
+		return -1;
+
+	if (!dst_hold_safe(flow_dst->route.tuple[FLOW_OFFLOAD_DIR_REPLY].dst)) {
+		dst_release(flow_dst->route.tuple[FLOW_OFFLOAD_DIR_ORIGINAL].dst);
+		return -1;
+	}
+
+	return 0;
 }
 
 struct flow_offload *
@@ -72,11 +96,8 @@ struct flow_offload *
 
 	flow = &entry->flow;
 
-	if (!dst_hold_safe(flow_dst->route.tuple[FLOW_OFFLOAD_DIR_ORIGINAL].dst))
-		goto err_dst_cache_original;
-
-	if (!dst_hold_safe(flow_dst->route.tuple[FLOW_OFFLOAD_DIR_REPLY].dst))
-		goto err_dst_cache_reply;
+	if (flow_offload_dst_hold(flow_dst))
+		goto err_dst_cache;
 
 	entry->ct = ct;
 
@@ -90,9 +111,7 @@ struct flow_offload *
 
 	return flow;
 
-err_dst_cache_reply:
-	dst_release(flow_dst->route.tuple[FLOW_OFFLOAD_DIR_ORIGINAL].dst);
-err_dst_cache_original:
+err_dst_cache:
 	kfree(entry);
 err_ct_refcnt:
 	nf_ct_put(ct);
@@ -149,12 +168,17 @@ static void flow_offload_fixup_ct(struct nf_conn *ct)
 	flow_offload_fixup_ct_timeout(ct);
 }
 
+static void flow_offload_dst_release(struct flow_offload *flow)
+{
+	dst_release(flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tuple.dst.dst_cache);
+	dst_release(flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].tuple.dst.dst_cache);
+}
+
 void flow_offload_free(struct flow_offload *flow)
 {
 	struct flow_offload_entry *e;
 
-	dst_release(flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tuple.dst.dst_cache);
-	dst_release(flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].tuple.dst.dst_cache);
+	flow_offload_dst_release(flow);
 	e = container_of(flow, struct flow_offload_entry, flow);
 	if (flow->flags & FLOW_OFFLOAD_DYING)
 		nf_ct_delete(e->ct, 0, 0);
-- 
1.8.3.1

