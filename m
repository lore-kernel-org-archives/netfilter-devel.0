Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96471C43603
	for <netfilter-devel@archiver.kernel.org>; Thu,  1 Apr 2021 17:55:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 66933611EE
	for <netfilter-devel@archiver.kernel.org>; Thu,  1 Apr 2021 17:55:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236293AbhDARyL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 1 Apr 2021 13:54:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235674AbhDARs1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 1 Apr 2021 13:48:27 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43FDEC0085A5
        for <netfilter-devel@vger.kernel.org>; Thu,  1 Apr 2021 07:12:01 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1lRy3D-0001cb-Uv; Thu, 01 Apr 2021 16:12:00 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next v2 09/11] netfilter: conntrack: move sysctl pointer to net_generic infra
Date:   Thu,  1 Apr 2021 16:11:12 +0200
Message-Id: <20210401141114.24712-10-fw@strlen.de>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20210401141114.24712-1-fw@strlen.de>
References: <20210401141114.24712-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

No need to keep this in struct net, place it in the net_generic data.
The sysctl pointer is removed from struct net in a followup patch.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nf_conntrack.h    |  3 +++
 net/netfilter/nf_conntrack_standalone.c | 10 ++++++----
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index 439379ca9ffa..ef405a134307 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -47,6 +47,9 @@ struct nf_conntrack_net {
 	unsigned int users4;
 	unsigned int users6;
 	unsigned int users_bridge;
+#ifdef CONFIG_SYSCTL
+	struct ctl_table_header	*sysctl_header;
+#endif
 };
 
 #include <linux/types.h>
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 0ee702d374b0..3f2cc7b04b20 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -1027,6 +1027,7 @@ static void nf_conntrack_standalone_init_gre_sysctl(struct net *net,
 
 static int nf_conntrack_standalone_init_sysctl(struct net *net)
 {
+	struct nf_conntrack_net *cnet = net_generic(net, nf_conntrack_net_id);
 	struct nf_udp_net *un = nf_udp_pernet(net);
 	struct ctl_table *table;
 
@@ -1072,8 +1073,8 @@ static int nf_conntrack_standalone_init_sysctl(struct net *net)
 		table[NF_SYSCTL_CT_BUCKETS].mode = 0444;
 	}
 
-	net->ct.sysctl_header = register_net_sysctl(net, "net/netfilter", table);
-	if (!net->ct.sysctl_header)
+	cnet->sysctl_header = register_net_sysctl(net, "net/netfilter", table);
+	if (!cnet->sysctl_header)
 		goto out_unregister_netfilter;
 
 	return 0;
@@ -1085,10 +1086,11 @@ static int nf_conntrack_standalone_init_sysctl(struct net *net)
 
 static void nf_conntrack_standalone_fini_sysctl(struct net *net)
 {
+	struct nf_conntrack_net *cnet = net_generic(net, nf_conntrack_net_id);
 	struct ctl_table *table;
 
-	table = net->ct.sysctl_header->ctl_table_arg;
-	unregister_net_sysctl_table(net->ct.sysctl_header);
+	table = cnet->sysctl_header->ctl_table_arg;
+	unregister_net_sysctl_table(cnet->sysctl_header);
 	kfree(table);
 }
 #else
-- 
2.26.3

