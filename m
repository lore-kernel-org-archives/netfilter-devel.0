Return-Path: <SRS0=r9U9=2U=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A9F5C2D0C2
	for <netfilter-devel@archiver.kernel.org>; Mon, 30 Dec 2019 11:21:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 31A77206E4
	for <netfilter-devel@archiver.kernel.org>; Mon, 30 Dec 2019 11:21:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727401AbfL3LVy (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 30 Dec 2019 06:21:54 -0500
Received: from correo.us.es ([193.147.175.20]:59208 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727359AbfL3LVx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 30 Dec 2019 06:21:53 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 372354DE722
        for <netfilter-devel@vger.kernel.org>; Mon, 30 Dec 2019 12:21:51 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 27EB2DA716
        for <netfilter-devel@vger.kernel.org>; Mon, 30 Dec 2019 12:21:51 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 1C6DCDA714; Mon, 30 Dec 2019 12:21:51 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1C511DA709;
        Mon, 30 Dec 2019 12:21:49 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 30 Dec 2019 12:21:49 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [185.124.28.61])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 829C941E4800;
        Mon, 30 Dec 2019 12:21:48 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 01/17] netfilter: Clean up unnecessary #ifdef
Date:   Mon, 30 Dec 2019 12:21:27 +0100
Message-Id: <20191230112143.121708-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191230112143.121708-1-pablo@netfilter.org>
References: <20191230112143.121708-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Lukas Wunner <lukas@wunner.de>

If CONFIG_NETFILTER_INGRESS is not enabled, nf_ingress() becomes a no-op
because it solely contains an if-clause calling nf_hook_ingress_active(),
for which an empty inline stub exists in <linux/netfilter_ingress.h>.

All the symbols used in the if-clause's body are still available even if
CONFIG_NETFILTER_INGRESS is not enabled.

The additional "#ifdef CONFIG_NETFILTER_INGRESS" in nf_ingress() is thus
unnecessary, so drop it.

Signed-off-by: Lukas Wunner <lukas@wunner.de>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/core/dev.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 2c277b8aba38..1ccead4b19bf 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4932,7 +4932,6 @@ static bool skb_pfmemalloc_protocol(struct sk_buff *skb)
 static inline int nf_ingress(struct sk_buff *skb, struct packet_type **pt_prev,
 			     int *ret, struct net_device *orig_dev)
 {
-#ifdef CONFIG_NETFILTER_INGRESS
 	if (nf_hook_ingress_active(skb)) {
 		int ingress_retval;
 
@@ -4946,7 +4945,6 @@ static inline int nf_ingress(struct sk_buff *skb, struct packet_type **pt_prev,
 		rcu_read_unlock();
 		return ingress_retval;
 	}
-#endif /* CONFIG_NETFILTER_INGRESS */
 	return 0;
 }
 
-- 
2.11.0

