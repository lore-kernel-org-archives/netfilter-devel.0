Return-Path: <SRS0=iWGL=XA=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38D20C43140
	for <netfilter-devel@archiver.kernel.org>; Thu,  5 Sep 2019 16:04:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D8B862082E
	for <netfilter-devel@archiver.kernel.org>; Thu,  5 Sep 2019 16:04:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390794AbfIEQEJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 5 Sep 2019 12:04:09 -0400
Received: from correo.us.es ([193.147.175.20]:53028 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389620AbfIEQEI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 5 Sep 2019 12:04:08 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 31EBB1228CB
        for <netfilter-devel@vger.kernel.org>; Thu,  5 Sep 2019 18:04:05 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2575FB7FFE
        for <netfilter-devel@vger.kernel.org>; Thu,  5 Sep 2019 18:04:05 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 1B19CB8011; Thu,  5 Sep 2019 18:04:05 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E6C99D2B1F;
        Thu,  5 Sep 2019 18:04:02 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 05 Sep 2019 18:04:02 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id B639242EE38E;
        Thu,  5 Sep 2019 18:04:02 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 1/8] netfilter: nf_tables: Introduce new 64-bit helper register functions
Date:   Thu,  5 Sep 2019 18:03:53 +0200
Message-Id: <20190905160400.25399-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190905160400.25399-1-pablo@netfilter.org>
References: <20190905160400.25399-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Ander Juaristi <a@juaristi.eus>

Introduce new helper functions to load/store 64-bit values onto/from
registers:

 - nft_reg_store64
 - nft_reg_load64

This commit also re-orders all these helpers from smallest to largest
target bit size.

Signed-off-by: Ander Juaristi <a@juaristi.eus>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h | 25 ++++++++++++++++++-------
 net/netfilter/nft_byteorder.c     |  9 +++++----
 2 files changed, 23 insertions(+), 11 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index e73d16f8b870..64765140657b 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -2,6 +2,7 @@
 #ifndef _NET_NF_TABLES_H
 #define _NET_NF_TABLES_H
 
+#include <asm/unaligned.h>
 #include <linux/list.h>
 #include <linux/netfilter.h>
 #include <linux/netfilter/nfnetlink.h>
@@ -102,23 +103,28 @@ struct nft_regs {
 	};
 };
 
-/* Store/load an u16 or u8 integer to/from the u32 data register.
+/* Store/load an u8, u16 or u64 integer to/from the u32 data register.
  *
  * Note, when using concatenations, register allocation happens at 32-bit
  * level. So for store instruction, pad the rest part with zero to avoid
  * garbage values.
  */
 
-static inline void nft_reg_store16(u32 *dreg, u16 val)
+static inline void nft_reg_store8(u32 *dreg, u8 val)
 {
 	*dreg = 0;
-	*(u16 *)dreg = val;
+	*(u8 *)dreg = val;
 }
 
-static inline void nft_reg_store8(u32 *dreg, u8 val)
+static inline u8 nft_reg_load8(u32 *sreg)
+{
+	return *(u8 *)sreg;
+}
+
+static inline void nft_reg_store16(u32 *dreg, u16 val)
 {
 	*dreg = 0;
-	*(u8 *)dreg = val;
+	*(u16 *)dreg = val;
 }
 
 static inline u16 nft_reg_load16(u32 *sreg)
@@ -126,9 +132,14 @@ static inline u16 nft_reg_load16(u32 *sreg)
 	return *(u16 *)sreg;
 }
 
-static inline u8 nft_reg_load8(u32 *sreg)
+static inline void nft_reg_store64(u32 *dreg, u64 val)
 {
-	return *(u8 *)sreg;
+	put_unaligned(val, (u64 *)dreg);
+}
+
+static inline u64 nft_reg_load64(u32 *sreg)
+{
+	return get_unaligned((u64 *)sreg);
 }
 
 static inline void nft_data_copy(u32 *dst, const struct nft_data *src,
diff --git a/net/netfilter/nft_byteorder.c b/net/netfilter/nft_byteorder.c
index e06318428ea0..12bed3f7bbc6 100644
--- a/net/netfilter/nft_byteorder.c
+++ b/net/netfilter/nft_byteorder.c
@@ -43,14 +43,15 @@ void nft_byteorder_eval(const struct nft_expr *expr,
 		switch (priv->op) {
 		case NFT_BYTEORDER_NTOH:
 			for (i = 0; i < priv->len / 8; i++) {
-				src64 = get_unaligned((u64 *)&src[i]);
-				put_unaligned_be64(src64, &dst[i]);
+				src64 = nft_reg_load64(&src[i]);
+				nft_reg_store64(&dst[i], be64_to_cpu(src64));
 			}
 			break;
 		case NFT_BYTEORDER_HTON:
 			for (i = 0; i < priv->len / 8; i++) {
-				src64 = get_unaligned_be64(&src[i]);
-				put_unaligned(src64, (u64 *)&dst[i]);
+				src64 = (__force __u64)
+					cpu_to_be64(nft_reg_load64(&src[i]));
+				nft_reg_store64(&dst[i], src64);
 			}
 			break;
 		}
-- 
2.11.0

