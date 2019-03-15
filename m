Return-Path: <SRS0=WWTr=RS=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C675C10F00
	for <netfilter-devel@archiver.kernel.org>; Fri, 15 Mar 2019 18:35:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 24E7E218A1
	for <netfilter-devel@archiver.kernel.org>; Fri, 15 Mar 2019 18:35:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727230AbfCOSfU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 15 Mar 2019 14:35:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51912 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726684AbfCOSfT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 15 Mar 2019 14:35:19 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 708A65D60E;
        Fri, 15 Mar 2019 18:35:13 +0000 (UTC)
Received: from madcap2.tricolour.ca (ovpn-112-22.phx2.redhat.com [10.3.112.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 59BF25C205;
        Fri, 15 Mar 2019 18:35:08 +0000 (UTC)
From:   Richard Guy Briggs <rgb@redhat.com>
To:     containers@lists.linux-foundation.org, linux-api@vger.kernel.org,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Cc:     Paul Moore <paul@paul-moore.com>, sgrubb@redhat.com,
        omosnace@redhat.com, dhowells@redhat.com, simo@redhat.com,
        eparis@parisplace.org, serge@hallyn.com, ebiederm@xmission.com,
        nhorman@tuxdriver.com, Richard Guy Briggs <rgb@redhat.com>
Subject: [PATCH ghak90 V5 10/10] audit: NETFILTER_PKT: record each container ID associated with a netNS
Date:   Fri, 15 Mar 2019 14:29:58 -0400
Message-Id: <56127b2a5b82f15cb0d0f040502c2e3bb6945f30.1552665316.git.rgb@redhat.com>
In-Reply-To: <cover.1552665316.git.rgb@redhat.com>
References: <cover.1552665316.git.rgb@redhat.com>
In-Reply-To: <cover.1552665316.git.rgb@redhat.com>
References: <cover.1552665316.git.rgb@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.39]); Fri, 15 Mar 2019 18:35:18 +0000 (UTC)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add audit container identifier auxiliary record(s) to NETFILTER_PKT
event standalone records.  Iterate through all potential audit container
identifiers associated with a network namespace.

Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
 include/linux/audit.h    |  5 +++++
 kernel/audit.c           | 41 +++++++++++++++++++++++++++++++++++++++++
 net/netfilter/nft_log.c  | 11 +++++++++--
 net/netfilter/xt_AUDIT.c | 11 +++++++++--
 4 files changed, 64 insertions(+), 4 deletions(-)

diff --git a/include/linux/audit.h b/include/linux/audit.h
index 70255c2dfb9f..723e2d020228 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -214,6 +214,8 @@ static inline u64 audit_get_contid(struct task_struct *tsk)
 extern void audit_netns_contid_del(struct net *net, u64 contid);
 extern void audit_switch_task_namespaces(struct nsproxy *ns,
 					 struct task_struct *p);
+extern void audit_log_netns_contid_list(struct net *net,
+					struct audit_context *context);
 
 extern u32 audit_enabled;
 #else /* CONFIG_AUDIT */
@@ -290,6 +292,9 @@ static inline void audit_netns_contid_del(struct net *net, u64 contid)
 static inline void audit_switch_task_namespaces(struct nsproxy *ns,
 						struct task_struct *p)
 { }
+static inline void audit_log_netns_contid_list(struct net *net,
+					       struct audit_context *context)
+{ }
 
 #define audit_enabled AUDIT_OFF
 #endif /* CONFIG_AUDIT */
diff --git a/kernel/audit.c b/kernel/audit.c
index 7fa3194f5342..80ed323feeb5 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -451,6 +451,47 @@ void audit_switch_task_namespaces(struct nsproxy *ns, struct task_struct *p)
 		audit_netns_contid_add(new->net_ns, contid);
 }
 
+/**
+ * audit_log_netns_contid_list - List contids for the given network namespace
+ * @net: the network namespace of interest
+ * @context: the audit context to use
+ *
+ * Description:
+ * Issues a CONTAINER_ID record with a CSV list of contids associated
+ * with a network namespace to accompany a NETFILTER_PKT record.
+ */
+void audit_log_netns_contid_list(struct net *net, struct audit_context *context)
+{
+	struct audit_buffer *ab = NULL;
+	struct audit_contid *cont;
+	bool first = true;
+	struct audit_net *aunet;
+
+	/* Generate AUDIT_CONTAINER_ID record with container ID CSV list */
+	rcu_read_lock();
+	aunet = net_generic(net, audit_net_id);
+	if (!aunet)
+		goto out;
+	list_for_each_entry_rcu(cont, &aunet->contid_list, list) {
+		if (first) {
+			ab = audit_log_start(context, GFP_ATOMIC,
+					     AUDIT_CONTAINER_ID);
+			if (!ab) {
+				audit_log_lost("out of memory in audit_log_netns_contid_list");
+				goto out;
+			}
+			audit_log_format(ab, "contid=");
+		} else 
+			audit_log_format(ab, ",");
+		audit_log_format(ab, "%llu", cont->id);
+		first = false;
+	}
+	audit_log_end(ab);
+out:
+	rcu_read_unlock();
+}
+EXPORT_SYMBOL(audit_log_netns_contid_list);
+
 void audit_panic(const char *message)
 {
 	switch (audit_failure) {
diff --git a/net/netfilter/nft_log.c b/net/netfilter/nft_log.c
index 655187bed5d8..bdb1ec2368a7 100644
--- a/net/netfilter/nft_log.c
+++ b/net/netfilter/nft_log.c
@@ -69,13 +69,16 @@ static void nft_log_eval_audit(const struct nft_pktinfo *pkt)
 	struct sk_buff *skb = pkt->skb;
 	struct audit_buffer *ab;
 	int fam = -1;
+	struct audit_context *context;
+	struct net *net;
 
 	if (!audit_enabled)
 		return;
 
-	ab = audit_log_start(NULL, GFP_ATOMIC, AUDIT_NETFILTER_PKT);
+	context = audit_alloc_local(GFP_ATOMIC);
+	ab = audit_log_start(context, GFP_ATOMIC, AUDIT_NETFILTER_PKT);
 	if (!ab)
-		return;
+		goto errout;
 
 	audit_log_format(ab, "mark=%#x", skb->mark);
 
@@ -102,6 +105,10 @@ static void nft_log_eval_audit(const struct nft_pktinfo *pkt)
 		audit_log_format(ab, " saddr=? daddr=? proto=-1");
 
 	audit_log_end(ab);
+	net = xt_net(&pkt->xt);
+	audit_log_netns_contid_list(net, context);
+errout:
+	audit_free_context(context);
 }
 
 static void nft_log_eval(const struct nft_expr *expr,
diff --git a/net/netfilter/xt_AUDIT.c b/net/netfilter/xt_AUDIT.c
index af883f1b64f9..a3e547435f13 100644
--- a/net/netfilter/xt_AUDIT.c
+++ b/net/netfilter/xt_AUDIT.c
@@ -71,10 +71,13 @@ static bool audit_ip6(struct audit_buffer *ab, struct sk_buff *skb)
 {
 	struct audit_buffer *ab;
 	int fam = -1;
+	struct audit_context *context;
+	struct net *net;
 
 	if (audit_enabled == AUDIT_OFF)
-		goto errout;
-	ab = audit_log_start(NULL, GFP_ATOMIC, AUDIT_NETFILTER_PKT);
+		goto out;
+	context = audit_alloc_local(GFP_ATOMIC);
+	ab = audit_log_start(context, GFP_ATOMIC, AUDIT_NETFILTER_PKT);
 	if (ab == NULL)
 		goto errout;
 
@@ -104,7 +107,11 @@ static bool audit_ip6(struct audit_buffer *ab, struct sk_buff *skb)
 
 	audit_log_end(ab);
 
+	net = xt_net(par);
+	audit_log_netns_contid_list(net, context);
 errout:
+	audit_free_context(context);
+out:
 	return XT_CONTINUE;
 }
 
-- 
1.8.3.1

