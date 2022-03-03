Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A8C0C433EF
	for <netfilter-devel@archiver.kernel.org>; Thu,  3 Mar 2022 13:55:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233134AbiCCN4I (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 3 Mar 2022 08:56:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232356AbiCCN4H (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 3 Mar 2022 08:56:07 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD9A718BA45
        for <netfilter-devel@vger.kernel.org>; Thu,  3 Mar 2022 05:55:22 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1nPlvN-0001Y1-BM; Thu, 03 Mar 2022 14:55:21 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [RFC v3 nf-next 13/15] netfilter: cttimeout: decouple unlink and free on netns destruction
Date:   Thu,  3 Mar 2022 14:54:17 +0100
Message-Id: <20220303135419.10837-14-fw@strlen.de>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220303135419.10837-1-fw@strlen.de>
References: <20220303135419.10837-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Increment the extid on module removal; this makes sure that even
in extreme cases any old uncofirmed entry that happened to be kept
e.g. on nfnetlink_queue list will not trip over a stale timeout
reference.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nfnetlink_cttimeout.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/net/netfilter/nfnetlink_cttimeout.c b/net/netfilter/nfnetlink_cttimeout.c
index a98cf956f7c7..fecebc991e6f 100644
--- a/net/netfilter/nfnetlink_cttimeout.c
+++ b/net/netfilter/nfnetlink_cttimeout.c
@@ -657,12 +657,24 @@ static int __init cttimeout_init(void)
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
2.34.1

