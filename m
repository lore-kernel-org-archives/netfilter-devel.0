Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84FC5C433FE
	for <netfilter-devel@archiver.kernel.org>; Mon, 11 Apr 2022 11:02:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345870AbiDKLEW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 11 Apr 2022 07:04:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345842AbiDKLEP (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 11 Apr 2022 07:04:15 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F4A8443E3
        for <netfilter-devel@vger.kernel.org>; Mon, 11 Apr 2022 04:02:00 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1ndrny-0000KT-HM; Mon, 11 Apr 2022 13:01:58 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next v4 07/10] netfilter: cttimeout: decouple unlink and free on netns destruction
Date:   Mon, 11 Apr 2022 13:01:22 +0200
Message-Id: <20220411110125.4854-8-fw@strlen.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220411110125.4854-1-fw@strlen.de>
References: <20220411110125.4854-1-fw@strlen.de>
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
2.35.1

