Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2804C433EF
	for <netfilter-devel@archiver.kernel.org>; Tue, 10 May 2022 12:22:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241778AbiEJM0Z (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 10 May 2022 08:26:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241676AbiEJMZ5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 10 May 2022 08:25:57 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5AA109D4FD;
        Tue, 10 May 2022 05:22:00 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 07/17] netfilter: cttimeout: decouple unlink and free on netns destruction
Date:   Tue, 10 May 2022 14:21:40 +0200
Message-Id: <20220510122150.92533-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220510122150.92533-1-pablo@netfilter.org>
References: <20220510122150.92533-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Increment the extid on module removal; this makes sure that even
in extreme cases any old uncofirmed entry that happened to be kept
e.g. on nfnetlink_queue list will not trip over a stale timeout
reference.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nfnetlink_cttimeout.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/net/netfilter/nfnetlink_cttimeout.c b/net/netfilter/nfnetlink_cttimeout.c
index f366b8187915..9bc4ebe65faa 100644
--- a/net/netfilter/nfnetlink_cttimeout.c
+++ b/net/netfilter/nfnetlink_cttimeout.c
@@ -656,12 +656,24 @@ static int __init cttimeout_init(void)
 	return ret;
 }
 
+static int untimeout(struct nf_conn *ct, void *timeout)
+{
+	struct nf_conn_timeout *timeout_ext = nf_ct_timeout_find(ct);
+
+	if (timeout_ext)
+		RCU_INIT_POINTER(timeout_ext->timeout, NULL);
+
+	return 0;
+}
+
 static void __exit cttimeout_exit(void)
 {
 	nfnetlink_subsys_unregister(&cttimeout_subsys);
 
 	unregister_pernet_subsys(&cttimeout_ops);
 	RCU_INIT_POINTER(nf_ct_timeout_hook, NULL);
+
+	nf_ct_iterate_destroy(untimeout, NULL);
 	synchronize_rcu();
 }
 
-- 
2.30.2

