Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 104CCC433F5
	for <netfilter-devel@archiver.kernel.org>; Wed, 17 Nov 2021 11:36:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E73A261BF4
	for <netfilter-devel@archiver.kernel.org>; Wed, 17 Nov 2021 11:36:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236830AbhKQLjN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 17 Nov 2021 06:39:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236822AbhKQLjN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 17 Nov 2021 06:39:13 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D591CC061570
        for <netfilter-devel@vger.kernel.org>; Wed, 17 Nov 2021 03:36:14 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1mnJEb-0000Nn-Bv; Wed, 17 Nov 2021 12:36:13 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 2/2] netfilter: conntrack: speed up netns cleanup
Date:   Wed, 17 Nov 2021 12:23:45 +0100
Message-Id: <20211117112345.6741-3-fw@strlen.de>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211117112345.6741-1-fw@strlen.de>
References: <20211117112345.6741-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Only do a single table iteration. Detect the "dead" namespaces by checking
the reference count.

This reaps all conntrack entries of dead namespaces in a single
cycle rather than having one full scan per netns.

This is similar to what tcp metrics table is doing.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_conntrack_core.c | 21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index c560bce9ebcb..38f97c1d9b3f 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -2448,6 +2448,9 @@ EXPORT_SYMBOL_GPL(nf_ct_iterate_destroy);
 
 static int kill_all(struct nf_conn *i, void *data)
 {
+	if (!data)
+		return !check_net(nf_ct_net(i));
+
 	return net_eq(nf_ct_net(i), data);
 }
 
@@ -2494,10 +2497,18 @@ static void __nf_conntrack_cleanup_net_list(struct list_head *net_exit_list)
  */
 void nf_conntrack_cleanup_net(struct net *net)
 {
+	struct nf_conntrack_net *cnet = nf_ct_pernet(net);
 	LIST_HEAD(single);
 
+	synchronize_net();
+
+	while (atomic_read(&cnet->count) != 0) {
+		nf_ct_iterate_cleanup(kill_all, net, 0, 0);
+		schedule();
+	}
+
 	list_add(&net->exit_list, &single);
-	nf_conntrack_cleanup_net_list(&single);
+	__nf_conntrack_cleanup_net_list(&single);
 }
 
 void nf_conntrack_cleanup_net_list(struct list_head *net_exit_list)
@@ -2516,9 +2527,11 @@ void nf_conntrack_cleanup_net_list(struct list_head *net_exit_list)
 	list_for_each_entry(net, net_exit_list, exit_list) {
 		struct nf_conntrack_net *cnet = nf_ct_pernet(net);
 
-		nf_ct_iterate_cleanup(kill_all, net, 0, 0);
-		if (atomic_read(&cnet->count) != 0)
-			busy = 1;
+		if (atomic_read(&cnet->count) != 0) {
+			nf_ct_iterate_cleanup(kill_all, NULL, 0, 0);
+			if (atomic_read(&cnet->count) != 0)
+				busy = 1;
+		}
 	}
 	if (busy) {
 		schedule();
-- 
2.32.0

