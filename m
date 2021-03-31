Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A0B1C43600
	for <netfilter-devel@archiver.kernel.org>; Wed, 31 Mar 2021 20:11:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E96686109E
	for <netfilter-devel@archiver.kernel.org>; Wed, 31 Mar 2021 20:11:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236469AbhCaUK4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 31 Mar 2021 16:10:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236429AbhCaUKq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 31 Mar 2021 16:10:46 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52EA8C061574
        for <netfilter-devel@vger.kernel.org>; Wed, 31 Mar 2021 13:10:46 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1lRhAq-0005AP-VB; Wed, 31 Mar 2021 22:10:45 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 05/11] netfilter: nf_defrag_ipv4: use net_generic infra
Date:   Wed, 31 Mar 2021 22:10:08 +0200
Message-Id: <20210331201014.23293-6-fw@strlen.de>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20210331201014.23293-1-fw@strlen.de>
References: <20210331201014.23293-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This allows followup patch to remove the defrag_ipv4 member from struct
net.  It also allows to auto-remove the hooks later on by adding a
_disable() function.  This will be done later in a follow patch series.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/ipv4/netfilter/nf_defrag_ipv4.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/net/ipv4/netfilter/nf_defrag_ipv4.c b/net/ipv4/netfilter/nf_defrag_ipv4.c
index 8115611aa47d..ffdcc2b9360f 100644
--- a/net/ipv4/netfilter/nf_defrag_ipv4.c
+++ b/net/ipv4/netfilter/nf_defrag_ipv4.c
@@ -20,8 +20,13 @@
 #endif
 #include <net/netfilter/nf_conntrack_zones.h>
 
+static unsigned int defrag4_pernet_id __read_mostly;
 static DEFINE_MUTEX(defrag4_mutex);
 
+struct defrag4_pernet {
+	unsigned int users;
+};
+
 static int nf_ct_ipv4_gather_frags(struct net *net, struct sk_buff *skb,
 				   u_int32_t user)
 {
@@ -106,15 +111,19 @@ static const struct nf_hook_ops ipv4_defrag_ops[] = {
 
 static void __net_exit defrag4_net_exit(struct net *net)
 {
-	if (net->nf.defrag_ipv4) {
+	struct defrag4_pernet *nf_defrag = net_generic(net, defrag4_pernet_id);
+
+	if (nf_defrag->users) {
 		nf_unregister_net_hooks(net, ipv4_defrag_ops,
 					ARRAY_SIZE(ipv4_defrag_ops));
-		net->nf.defrag_ipv4 = false;
+		nf_defrag->users = 0;
 	}
 }
 
 static struct pernet_operations defrag4_net_ops = {
 	.exit = defrag4_net_exit,
+	.id   = &defrag4_pernet_id,
+	.size = sizeof(struct defrag4_pernet),
 };
 
 static int __init nf_defrag_init(void)
@@ -129,21 +138,22 @@ static void __exit nf_defrag_fini(void)
 
 int nf_defrag_ipv4_enable(struct net *net)
 {
+	struct defrag4_pernet *nf_defrag = net_generic(net, defrag4_pernet_id);
 	int err = 0;
 
 	might_sleep();
 
-	if (net->nf.defrag_ipv4)
+	if (nf_defrag->users)
 		return 0;
 
 	mutex_lock(&defrag4_mutex);
-	if (net->nf.defrag_ipv4)
+	if (nf_defrag->users)
 		goto out_unlock;
 
 	err = nf_register_net_hooks(net, ipv4_defrag_ops,
 				    ARRAY_SIZE(ipv4_defrag_ops));
 	if (err == 0)
-		net->nf.defrag_ipv4 = true;
+		nf_defrag->users = 1;
 
  out_unlock:
 	mutex_unlock(&defrag4_mutex);
-- 
2.26.3

