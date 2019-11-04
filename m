Return-Path: <SRS0=62bg=Y4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAD97CA9EB5
	for <netfilter-devel@archiver.kernel.org>; Mon,  4 Nov 2019 13:41:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9524D20B7C
	for <netfilter-devel@archiver.kernel.org>; Mon,  4 Nov 2019 13:41:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727998AbfKDNln (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 4 Nov 2019 08:41:43 -0500
Received: from correo.us.es ([193.147.175.20]:49880 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727332AbfKDNln (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 4 Nov 2019 08:41:43 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 21D10E8E96
        for <netfilter-devel@vger.kernel.org>; Mon,  4 Nov 2019 14:41:38 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 12367DA801
        for <netfilter-devel@vger.kernel.org>; Mon,  4 Nov 2019 14:41:38 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 07DCBDA7B6; Mon,  4 Nov 2019 14:41:38 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 042AFDA840
        for <netfilter-devel@vger.kernel.org>; Mon,  4 Nov 2019 14:41:36 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 04 Nov 2019 14:41:36 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id DF81B4251480
        for <netfilter-devel@vger.kernel.org>; Mon,  4 Nov 2019 14:41:35 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next] netfilter: nft_payload: add C-VLAN support
Date:   Mon,  4 Nov 2019 14:41:34 +0100
Message-Id: <20191104134134.29088-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
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
I made a quick update on nft to test this patch that generates the
following netlink bytecode:

  [ meta load iiftype => reg 1 ]
  [ cmp eq reg 1 0x00000001 ]
  [ payload load 2b @ link header + 12 => reg 1 ]
  [ cmp eq reg 1 0x00000081 ]
  [ payload load 2b @ link header + 16 => reg 1 ]
  [ cmp eq reg 1 0x00000081 ]
  [ payload load 2b @ link header + 18 => reg 1 ]
  [ bitwise reg 1 = (reg=1 & 0x0000ff0f ) ^ 0x00000000 ]
  [ cmp eq reg 1 0x00006400 ]
  [ counter pkts 0 bytes 0 ]

Userspace patch needs a bit of work.

 net/netfilter/nft_payload.c | 23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index 5676e22b36bc..66d94e34886b 100644
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

