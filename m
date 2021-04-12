Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73B05C433ED
	for <netfilter-devel@archiver.kernel.org>; Mon, 12 Apr 2021 19:56:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 521EF610FC
	for <netfilter-devel@archiver.kernel.org>; Mon, 12 Apr 2021 19:56:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242657AbhDLT4T (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 12 Apr 2021 15:56:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242025AbhDLT4T (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 12 Apr 2021 15:56:19 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B6C2C061574
        for <netfilter-devel@vger.kernel.org>; Mon, 12 Apr 2021 12:56:01 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1lW2f9-0000s4-O6; Mon, 12 Apr 2021 21:55:59 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next v2 2/5] netfilter: conntrack: move autoassign_helper sysctl to net_generic data
Date:   Mon, 12 Apr 2021 21:55:41 +0200
Message-Id: <20210412195544.417-3-fw@strlen.de>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20210412195544.417-1-fw@strlen.de>
References: <20210412195544.417-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

While at it, make it an u8, no need to use an integer for a boolean.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nf_conntrack.h    | 1 +
 net/netfilter/nf_conntrack_helper.c     | 6 ++++--
 net/netfilter/nf_conntrack_standalone.c | 7 +++----
 3 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index c532b629db7b..db8f047eb75f 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -45,6 +45,7 @@ union nf_conntrack_expect_proto {
 
 struct nf_conntrack_net {
 	/* only used when new connection is allocated: */
+	u8 sysctl_auto_assign_helper;
 	bool auto_assign_helper_warned;
 
 	/* only used from work queues, configuration plane, and so on: */
diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index ad91964eaa92..ac396cc8bfae 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -216,7 +216,7 @@ nf_ct_lookup_helper(struct nf_conn *ct, struct net *net)
 {
 	struct nf_conntrack_net *cnet = net_generic(net, nf_conntrack_net_id);
 
-	if (!net->ct.sysctl_auto_assign_helper) {
+	if (!cnet->sysctl_auto_assign_helper) {
 		if (cnet->auto_assign_helper_warned)
 			return NULL;
 		if (!__nf_ct_helper_find(&ct->tuplehash[IP_CT_DIR_REPLY].tuple))
@@ -560,7 +560,9 @@ static const struct nf_ct_ext_type helper_extend = {
 
 void nf_conntrack_helper_pernet_init(struct net *net)
 {
-	net->ct.sysctl_auto_assign_helper = nf_ct_auto_assign_helper;
+	struct nf_conntrack_net *cnet = net_generic(net, nf_conntrack_net_id);
+
+	cnet->sysctl_auto_assign_helper = nf_ct_auto_assign_helper;
 }
 
 int nf_conntrack_helper_init(void)
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 3f2cc7b04b20..da85bb6ddbb4 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -662,10 +662,9 @@ static struct ctl_table nf_ct_sysctl_table[] = {
 	},
 	[NF_SYSCTL_CT_HELPER] = {
 		.procname	= "nf_conntrack_helper",
-		.data		= &init_net.ct.sysctl_auto_assign_helper,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
+		.proc_handler	= proc_dou8vec_minmax,
 		.extra1 	= SYSCTL_ZERO,
 		.extra2 	= SYSCTL_ONE,
 	},
@@ -1042,7 +1041,7 @@ static int nf_conntrack_standalone_init_sysctl(struct net *net)
 	table[NF_SYSCTL_CT_CHECKSUM].data = &net->ct.sysctl_checksum;
 	table[NF_SYSCTL_CT_LOG_INVALID].data = &net->ct.sysctl_log_invalid;
 	table[NF_SYSCTL_CT_ACCT].data = &net->ct.sysctl_acct;
-	table[NF_SYSCTL_CT_HELPER].data = &net->ct.sysctl_auto_assign_helper;
+	table[NF_SYSCTL_CT_HELPER].data = &cnet->sysctl_auto_assign_helper;
 #ifdef CONFIG_NF_CONNTRACK_EVENTS
 	table[NF_SYSCTL_CT_EVENTS].data = &net->ct.sysctl_events;
 #endif
-- 
2.26.3

