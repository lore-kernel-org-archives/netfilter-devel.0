Return-Path: <SRS0=4S6R=YT=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACBC8CA9EB9
	for <netfilter-devel@archiver.kernel.org>; Sat, 26 Oct 2019 11:48:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8C474206DD
	for <netfilter-devel@archiver.kernel.org>; Sat, 26 Oct 2019 11:48:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726449AbfJZLrs (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 26 Oct 2019 07:47:48 -0400
Received: from correo.us.es ([193.147.175.20]:46422 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726386AbfJZLrr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 26 Oct 2019 07:47:47 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 6C27A8C3C69
        for <netfilter-devel@vger.kernel.org>; Sat, 26 Oct 2019 13:47:43 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 60193DA4CA
        for <netfilter-devel@vger.kernel.org>; Sat, 26 Oct 2019 13:47:43 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 55411DA801; Sat, 26 Oct 2019 13:47:43 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6CF8DB8001;
        Sat, 26 Oct 2019 13:47:41 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 26 Oct 2019 13:47:41 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 3518542EE395;
        Sat, 26 Oct 2019 13:47:41 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 08/31] ipvs: no need to update skb route entry for local destination packets.
Date:   Sat, 26 Oct 2019 13:47:10 +0200
Message-Id: <20191026114733.28111-9-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191026114733.28111-1-pablo@netfilter.org>
References: <20191026114733.28111-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: zhang kai <zhangkaiheb@126.com>

In the end of function __ip_vs_get_out_rt/__ip_vs_get_out_rt_v6,the
'local' variable is always zero.

Signed-off-by: zhang kai <zhangkaiheb@126.com>
Acked-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Simon Horman <horms@verge.net.au>
---
 net/netfilter/ipvs/ip_vs_xmit.c | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_xmit.c b/net/netfilter/ipvs/ip_vs_xmit.c
index 888d3068a492..b1e300f8881b 100644
--- a/net/netfilter/ipvs/ip_vs_xmit.c
+++ b/net/netfilter/ipvs/ip_vs_xmit.c
@@ -407,12 +407,9 @@ __ip_vs_get_out_rt(struct netns_ipvs *ipvs, int skb_af, struct sk_buff *skb,
 		goto err_put;
 
 	skb_dst_drop(skb);
-	if (noref) {
-		if (!local)
-			skb_dst_set_noref(skb, &rt->dst);
-		else
-			skb_dst_set(skb, dst_clone(&rt->dst));
-	} else
+	if (noref)
+		skb_dst_set_noref(skb, &rt->dst);
+	else
 		skb_dst_set(skb, &rt->dst);
 
 	return local;
@@ -574,12 +571,9 @@ __ip_vs_get_out_rt_v6(struct netns_ipvs *ipvs, int skb_af, struct sk_buff *skb,
 		goto err_put;
 
 	skb_dst_drop(skb);
-	if (noref) {
-		if (!local)
-			skb_dst_set_noref(skb, &rt->dst);
-		else
-			skb_dst_set(skb, dst_clone(&rt->dst));
-	} else
+	if (noref)
+		skb_dst_set_noref(skb, &rt->dst);
+	else
 		skb_dst_set(skb, &rt->dst);
 
 	return local;
-- 
2.11.0

