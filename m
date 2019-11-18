Return-Path: <SRS0=asLr=ZK=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 070C9C432C0
	for <netfilter-devel@archiver.kernel.org>; Mon, 18 Nov 2019 21:50:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DCE52222DC
	for <netfilter-devel@archiver.kernel.org>; Mon, 18 Nov 2019 21:50:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727139AbfKRVtd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 18 Nov 2019 16:49:33 -0500
Received: from correo.us.es ([193.147.175.20]:45720 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726705AbfKRVtc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 18 Nov 2019 16:49:32 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C5391EB497
        for <netfilter-devel@vger.kernel.org>; Mon, 18 Nov 2019 22:49:28 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B73984C3BF
        for <netfilter-devel@vger.kernel.org>; Mon, 18 Nov 2019 22:49:28 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id ACF3DCE15C; Mon, 18 Nov 2019 22:49:28 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DEC16DA801;
        Mon, 18 Nov 2019 22:49:23 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 18 Nov 2019 22:49:23 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id B0BDF42EE38F;
        Mon, 18 Nov 2019 22:49:23 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 04/18] netfilter: nf_tables: add nft_payload_rebuild_vlan_hdr()
Date:   Mon, 18 Nov 2019 22:49:00 +0100
Message-Id: <20191118214914.142794-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191118214914.142794-1-pablo@netfilter.org>
References: <20191118214914.142794-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Wrap the code to rebuild the ethernet + vlan header into a function.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Acked-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nft_payload.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index 247799801165..3db9c802ea62 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -23,6 +23,19 @@
 #include <linux/ip.h>
 #include <linux/ipv6.h>
 
+static bool nft_payload_rebuild_vlan_hdr(const struct sk_buff *skb, int mac_off,
+					 struct vlan_ethhdr *veth)
+{
+	if (skb_copy_bits(skb, mac_off, veth, ETH_HLEN))
+		return false;
+
+	veth->h_vlan_proto = skb->vlan_proto;
+	veth->h_vlan_TCI = htons(skb_vlan_tag_get(skb));
+	veth->h_vlan_encapsulated_proto = skb->protocol;
+
+	return true;
+}
+
 /* add vlan header into the user buffer for if tag was removed by offloads */
 static bool
 nft_payload_copy_vlan(u32 *d, const struct sk_buff *skb, u8 offset, u8 len)
@@ -35,13 +48,9 @@ nft_payload_copy_vlan(u32 *d, const struct sk_buff *skb, u8 offset, u8 len)
 	if (offset < VLAN_ETH_HLEN) {
 		u8 ethlen = len;
 
-		if (skb_copy_bits(skb, mac_off, &veth, ETH_HLEN))
+		if (!nft_payload_rebuild_vlan_hdr(skb, mac_off, &veth))
 			return false;
 
-		veth.h_vlan_proto = skb->vlan_proto;
-		veth.h_vlan_TCI = htons(skb_vlan_tag_get(skb));
-		veth.h_vlan_encapsulated_proto = skb->protocol;
-
 		if (offset + len > VLAN_ETH_HLEN)
 			ethlen -= offset + len - VLAN_ETH_HLEN;
 
-- 
2.11.0

