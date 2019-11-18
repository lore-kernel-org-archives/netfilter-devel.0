Return-Path: <SRS0=asLr=ZK=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 920CCC43215
	for <netfilter-devel@archiver.kernel.org>; Mon, 18 Nov 2019 21:49:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7013F222DC
	for <netfilter-devel@archiver.kernel.org>; Mon, 18 Nov 2019 21:49:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727146AbfKRVte (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 18 Nov 2019 16:49:34 -0500
Received: from correo.us.es ([193.147.175.20]:45706 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727135AbfKRVtd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 18 Nov 2019 16:49:33 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E0BBEEB48A
        for <netfilter-devel@vger.kernel.org>; Mon, 18 Nov 2019 22:49:29 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D324CB8014
        for <netfilter-devel@vger.kernel.org>; Mon, 18 Nov 2019 22:49:29 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id C873CB8007; Mon, 18 Nov 2019 22:49:29 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 16428D2B1F;
        Mon, 18 Nov 2019 22:49:25 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 18 Nov 2019 22:49:25 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id DD8B342EE38F;
        Mon, 18 Nov 2019 22:49:24 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 06/18] netfilter: nft_payload: add C-VLAN support
Date:   Mon, 18 Nov 2019 22:49:02 +0100
Message-Id: <20191118214914.142794-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191118214914.142794-1-pablo@netfilter.org>
References: <20191118214914.142794-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

If the encapsulated ethertype announces another inner VLAN header and
the offset falls within the boundaries of the inner VLAN header, then
adjust arithmetics to include the extra VLAN header length and fetch the
bytes from the vlan header in the skbuff data area that represents this
inner VLAN header.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_payload.c | 23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index 3db9c802ea62..0877d46b8605 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -43,27 +43,36 @@ nft_payload_copy_vlan(u32 *d, const struct sk_buff *skb, u8 offset, u8 len)
 	int mac_off = skb_mac_header(skb) - skb->data;
 	u8 *vlanh, *dst_u8 = (u8 *) d;
 	struct vlan_ethhdr veth;
+	u8 vlan_hlen = 0;
+
+	if ((skb->protocol == htons(ETH_P_8021AD) ||
+	     skb->protocol == htons(ETH_P_8021Q)) &&
+	    offset >= VLAN_ETH_HLEN && offset < VLAN_ETH_HLEN + VLAN_HLEN)
+		vlan_hlen += VLAN_HLEN;
 
 	vlanh = (u8 *) &veth;
-	if (offset < VLAN_ETH_HLEN) {
+	if (offset < VLAN_ETH_HLEN + vlan_hlen) {
 		u8 ethlen = len;
 
-		if (!nft_payload_rebuild_vlan_hdr(skb, mac_off, &veth))
+		if (vlan_hlen &&
+		    skb_copy_bits(skb, mac_off, &veth, VLAN_ETH_HLEN) < 0)
+			return false;
+		else if (!nft_payload_rebuild_vlan_hdr(skb, mac_off, &veth))
 			return false;
 
-		if (offset + len > VLAN_ETH_HLEN)
-			ethlen -= offset + len - VLAN_ETH_HLEN;
+		if (offset + len > VLAN_ETH_HLEN + vlan_hlen)
+			ethlen -= offset + len - VLAN_ETH_HLEN + vlan_hlen;
 
-		memcpy(dst_u8, vlanh + offset, ethlen);
+		memcpy(dst_u8, vlanh + offset - vlan_hlen, ethlen);
 
 		len -= ethlen;
 		if (len == 0)
 			return true;
 
 		dst_u8 += ethlen;
-		offset = ETH_HLEN;
+		offset = ETH_HLEN + vlan_hlen;
 	} else {
-		offset -= VLAN_HLEN;
+		offset -= VLAN_HLEN + vlan_hlen;
 	}
 
 	return skb_copy_bits(skb, offset + mac_off, dst_u8, len) == 0;
-- 
2.11.0

