Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FECDC433EF
	for <netfilter-devel@archiver.kernel.org>; Wed, 17 Nov 2021 11:36:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E503C61BB6
	for <netfilter-devel@archiver.kernel.org>; Wed, 17 Nov 2021 11:36:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236825AbhKQLjJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 17 Nov 2021 06:39:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236822AbhKQLjJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 17 Nov 2021 06:39:09 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC7ADC061570
        for <netfilter-devel@vger.kernel.org>; Wed, 17 Nov 2021 03:36:10 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1mnJEX-0000Nd-5u; Wed, 17 Nov 2021 12:36:09 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 1/2] netfilter: conntrack: split nf_conntrack_cleanup_net_list
Date:   Wed, 17 Nov 2021 12:23:44 +0100
Message-Id: <20211117112345.6741-2-fw@strlen.de>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211117112345.6741-1-fw@strlen.de>
References: <20211117112345.6741-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Preparation patch to keep size of next change down.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_conntrack_core.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 770a63103c7a..c560bce9ebcb 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -2476,6 +2476,18 @@ void nf_conntrack_cleanup_end(void)
 	kmem_cache_destroy(nf_conntrack_cachep);
 }
 
+static void __nf_conntrack_cleanup_net_list(struct list_head *net_exit_list)
+{
+	struct net *net;
+
+	list_for_each_entry(net, net_exit_list, exit_list) {
+		nf_conntrack_ecache_pernet_fini(net);
+		nf_conntrack_expect_pernet_fini(net);
+		free_percpu(net->ct.stat);
+		free_percpu(net->ct.pcpu_lists);
+	}
+}
+
 /*
  * Mishearing the voices in his head, our hero wonders how he's
  * supposed to kill the mall.
@@ -2513,12 +2525,7 @@ void nf_conntrack_cleanup_net_list(struct list_head *net_exit_list)
 		goto i_see_dead_people;
 	}
 
-	list_for_each_entry(net, net_exit_list, exit_list) {
-		nf_conntrack_ecache_pernet_fini(net);
-		nf_conntrack_expect_pernet_fini(net);
-		free_percpu(net->ct.stat);
-		free_percpu(net->ct.pcpu_lists);
-	}
+	__nf_conntrack_cleanup_net_list(net_exit_list);
 }
 
 void *nf_ct_alloc_hashtable(unsigned int *sizep, int nulls)
-- 
2.32.0

