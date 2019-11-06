Return-Path: <SRS0=uVIa=Y6=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 986DEC5DF63
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 Nov 2019 11:12:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 702E4217D7
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 Nov 2019 11:12:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731310AbfKFLMu (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 6 Nov 2019 06:12:50 -0500
Received: from correo.us.es ([193.147.175.20]:44102 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731099AbfKFLMu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 6 Nov 2019 06:12:50 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 0F1F03066B9
        for <netfilter-devel@vger.kernel.org>; Wed,  6 Nov 2019 12:12:46 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 00165DA7B6
        for <netfilter-devel@vger.kernel.org>; Wed,  6 Nov 2019 12:12:46 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id E9D74B7FFE; Wed,  6 Nov 2019 12:12:45 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E7B62DA3A9;
        Wed,  6 Nov 2019 12:12:43 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 06 Nov 2019 12:12:43 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id B5EA641E4802;
        Wed,  6 Nov 2019 12:12:43 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 7/9] bridge: ebtables: don't crash when using dnat target in output chains
Date:   Wed,  6 Nov 2019 12:12:35 +0100
Message-Id: <20191106111237.3183-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191106111237.3183-1-pablo@netfilter.org>
References: <20191106111237.3183-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

xt_in() returns NULL in the output hook, skip the pkt_type change for
that case, redirection only makes sense in broute/prerouting hooks.

Reported-by: Tom Yan <tom.ty89@gmail.com>
Cc: Linus Lüssing <linus.luessing@c0d3.blue>
Fixes: cf3cb246e277d ("bridge: ebtables: fix reception of frames DNAT-ed to bridge device/port")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/bridge/netfilter/ebt_dnat.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/net/bridge/netfilter/ebt_dnat.c b/net/bridge/netfilter/ebt_dnat.c
index ed91ea31978a..12a4f4d93681 100644
--- a/net/bridge/netfilter/ebt_dnat.c
+++ b/net/bridge/netfilter/ebt_dnat.c
@@ -20,7 +20,6 @@ static unsigned int
 ebt_dnat_tg(struct sk_buff *skb, const struct xt_action_param *par)
 {
 	const struct ebt_nat_info *info = par->targinfo;
-	struct net_device *dev;
 
 	if (skb_ensure_writable(skb, ETH_ALEN))
 		return EBT_DROP;
@@ -33,10 +32,22 @@ ebt_dnat_tg(struct sk_buff *skb, const struct xt_action_param *par)
 		else
 			skb->pkt_type = PACKET_MULTICAST;
 	} else {
-		if (xt_hooknum(par) != NF_BR_BROUTING)
-			dev = br_port_get_rcu(xt_in(par))->br->dev;
-		else
+		const struct net_device *dev;
+
+		switch (xt_hooknum(par)) {
+		case NF_BR_BROUTING:
 			dev = xt_in(par);
+			break;
+		case NF_BR_PRE_ROUTING:
+			dev = br_port_get_rcu(xt_in(par))->br->dev;
+			break;
+		default:
+			dev = NULL;
+			break;
+		}
+
+		if (!dev) /* NF_BR_LOCAL_OUT */
+			return info->target;
 
 		if (ether_addr_equal(info->mac, dev->dev_addr))
 			skb->pkt_type = PACKET_HOST;
-- 
2.11.0

