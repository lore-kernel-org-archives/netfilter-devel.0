Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3361AC433EF
	for <netfilter-devel@archiver.kernel.org>; Thu, 24 Feb 2022 16:45:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229553AbiBXQph (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 24 Feb 2022 11:45:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230085AbiBXQpg (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 24 Feb 2022 11:45:36 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B86C3159292
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Feb 2022 08:45:05 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1nNHEm-0005eX-38; Thu, 24 Feb 2022 17:45:04 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next v2 3/7] netfilter: ecache: move to separate structure
Date:   Thu, 24 Feb 2022 17:44:42 +0100
Message-Id: <20220224164446.23208-4-fw@strlen.de>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220224164446.23208-1-fw@strlen.de>
References: <20220224164446.23208-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This makes it easier for a followup patch to only expose ecache
related parts of nf_conntrack_net structure.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nf_conntrack.h |  8 ++++++--
 net/netfilter/nf_conntrack_ecache.c  | 19 ++++++++++---------
 2 files changed, 16 insertions(+), 11 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index 8731d5bcb47d..20fefe043850 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -43,6 +43,11 @@ union nf_conntrack_expect_proto {
 	/* insert expect proto private data here */
 };
 
+struct nf_conntrack_net_ecache {
+	struct delayed_work dwork;
+	struct netns_ct *ct_net;
+};
+
 struct nf_conntrack_net {
 	/* only used when new connection is allocated: */
 	atomic_t count;
@@ -58,8 +63,7 @@ struct nf_conntrack_net {
 	struct ctl_table_header	*sysctl_header;
 #endif
 #ifdef CONFIG_NF_CONNTRACK_EVENTS
-	struct delayed_work ecache_dwork;
-	struct netns_ct *ct_net;
+	struct nf_conntrack_net_ecache ecache;
 #endif
 };
 
diff --git a/net/netfilter/nf_conntrack_ecache.c b/net/netfilter/nf_conntrack_ecache.c
index 13ba6aa82ec1..d7a07873e605 100644
--- a/net/netfilter/nf_conntrack_ecache.c
+++ b/net/netfilter/nf_conntrack_ecache.c
@@ -96,8 +96,8 @@ static enum retry_state ecache_work_evict_list(struct ct_pcpu *pcpu)
 
 static void ecache_work(struct work_struct *work)
 {
-	struct nf_conntrack_net *cnet = container_of(work, struct nf_conntrack_net, ecache_dwork.work);
-	struct netns_ct *ctnet = cnet->ct_net;
+	struct nf_conntrack_net *cnet = container_of(work, struct nf_conntrack_net, ecache.dwork.work);
+	struct netns_ct *ctnet = cnet->ecache.ct_net;
 	int cpu, delay = -1;
 	struct ct_pcpu *pcpu;
 
@@ -127,7 +127,7 @@ static void ecache_work(struct work_struct *work)
 
 	ctnet->ecache_dwork_pending = delay > 0;
 	if (delay >= 0)
-		schedule_delayed_work(&cnet->ecache_dwork, delay);
+		schedule_delayed_work(&cnet->ecache.dwork, delay);
 }
 
 static int __nf_conntrack_eventmask_report(struct nf_conntrack_ecache *e,
@@ -281,12 +281,12 @@ void nf_conntrack_ecache_work(struct net *net, enum nf_ct_ecache_state state)
 	struct nf_conntrack_net *cnet = nf_ct_pernet(net);
 
 	if (state == NFCT_ECACHE_DESTROY_FAIL &&
-	    !delayed_work_pending(&cnet->ecache_dwork)) {
-		schedule_delayed_work(&cnet->ecache_dwork, HZ);
+	    !delayed_work_pending(&cnet->ecache.dwork)) {
+		schedule_delayed_work(&cnet->ecache.dwork, HZ);
 		net->ct.ecache_dwork_pending = true;
 	} else if (state == NFCT_ECACHE_DESTROY_SENT) {
 		net->ct.ecache_dwork_pending = false;
-		mod_delayed_work(system_wq, &cnet->ecache_dwork, 0);
+		mod_delayed_work(system_wq, &cnet->ecache.dwork, 0);
 	}
 }
 
@@ -298,8 +298,9 @@ void nf_conntrack_ecache_pernet_init(struct net *net)
 	struct nf_conntrack_net *cnet = nf_ct_pernet(net);
 
 	net->ct.sysctl_events = nf_ct_events;
-	cnet->ct_net = &net->ct;
-	INIT_DELAYED_WORK(&cnet->ecache_dwork, ecache_work);
+
+	cnet->ecache.ct_net = &net->ct;
+	INIT_DELAYED_WORK(&cnet->ecache.dwork, ecache_work);
 
 	BUILD_BUG_ON(__IPCT_MAX >= 16);	/* e->ctmask is u16 */
 }
@@ -308,5 +309,5 @@ void nf_conntrack_ecache_pernet_fini(struct net *net)
 {
 	struct nf_conntrack_net *cnet = nf_ct_pernet(net);
 
-	cancel_delayed_work_sync(&cnet->ecache_dwork);
+	cancel_delayed_work_sync(&cnet->ecache.dwork);
 }
-- 
2.34.1

