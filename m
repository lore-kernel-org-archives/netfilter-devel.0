Return-Path: <SRS0=LXG+=DT=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B369CC43467
	for <netfilter-devel@archiver.kernel.org>; Mon, 12 Oct 2020 01:38:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 84CCF20782
	for <netfilter-devel@archiver.kernel.org>; Mon, 12 Oct 2020 01:38:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727626AbgJLBif (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 11 Oct 2020 21:38:35 -0400
Received: from correo.us.es ([193.147.175.20]:41710 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727436AbgJLBic (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 11 Oct 2020 21:38:32 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 9D6C0E7818
        for <netfilter-devel@vger.kernel.org>; Mon, 12 Oct 2020 03:38:29 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8EFC2DA730
        for <netfilter-devel@vger.kernel.org>; Mon, 12 Oct 2020 03:38:29 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 84CD2DA78B; Mon, 12 Oct 2020 03:38:29 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8D3ECDA704;
        Mon, 12 Oct 2020 03:38:27 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 12 Oct 2020 03:38:27 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 62D9441FF201;
        Mon, 12 Oct 2020 03:38:27 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH 2/6] netfilter: add nf_static_key_{inc,dec}
Date:   Mon, 12 Oct 2020 03:38:15 +0200
Message-Id: <20201012013819.23128-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201012013819.23128-1-pablo@netfilter.org>
References: <20201012013819.23128-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add helper functions increment and decrement the hook static keys.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/core.c | 23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index 3ac7c8c1548d..b9ec8ecf7e30 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -311,6 +311,20 @@ nf_hook_entry_head(struct net *net, int pf, unsigned int hooknum,
 	return NULL;
 }
 
+static void nf_static_key_inc(const struct nf_hook_ops *reg, int pf)
+{
+#ifdef CONFIG_JUMP_LABEL
+       static_key_slow_inc(&nf_hooks_needed[pf][reg->hooknum]);
+#endif
+}
+
+static void nf_static_key_dec(const struct nf_hook_ops *reg, int pf)
+{
+#ifdef CONFIG_JUMP_LABEL
+       static_key_slow_dec(&nf_hooks_needed[pf][reg->hooknum]);
+#endif
+}
+
 static int __nf_register_net_hook(struct net *net, int pf,
 				  const struct nf_hook_ops *reg)
 {
@@ -348,9 +362,8 @@ static int __nf_register_net_hook(struct net *net, int pf,
 	if (pf == NFPROTO_NETDEV && reg->hooknum == NF_NETDEV_INGRESS)
 		net_inc_ingress_queue();
 #endif
-#ifdef CONFIG_JUMP_LABEL
-	static_key_slow_inc(&nf_hooks_needed[pf][reg->hooknum]);
-#endif
+	nf_static_key_inc(reg, pf);
+
 	BUG_ON(p == new_hooks);
 	nf_hook_entries_free(p);
 	return 0;
@@ -406,9 +419,7 @@ static void __nf_unregister_net_hook(struct net *net, int pf,
 		if (pf == NFPROTO_NETDEV && reg->hooknum == NF_NETDEV_INGRESS)
 			net_dec_ingress_queue();
 #endif
-#ifdef CONFIG_JUMP_LABEL
-		static_key_slow_dec(&nf_hooks_needed[pf][reg->hooknum]);
-#endif
+		nf_static_key_dec(reg, pf);
 	} else {
 		WARN_ONCE(1, "hook not found, pf %d num %d", pf, reg->hooknum);
 	}
-- 
2.20.1

