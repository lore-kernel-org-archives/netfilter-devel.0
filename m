Return-Path: <SRS0=20ch=WJ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4294C433FF
	for <netfilter-devel@archiver.kernel.org>; Tue, 13 Aug 2019 18:39:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A3F9B2064A
	for <netfilter-devel@archiver.kernel.org>; Tue, 13 Aug 2019 18:39:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726566AbfHMSjz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 13 Aug 2019 14:39:55 -0400
Received: from vxsys-smtpclusterma-02.srv.cat ([46.16.61.68]:35433 "EHLO
        vxsys-smtpclusterma-02.srv.cat" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726365AbfHMSjz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 13 Aug 2019 14:39:55 -0400
Received: from localhost.localdomain (static-79-171-230-77.ipcom.comunitel.net [77.230.171.79])
        by vxsys-smtpclusterma-02.srv.cat (Postfix) with ESMTPA id 2F435245F7
        for <netfilter-devel@vger.kernel.org>; Tue, 13 Aug 2019 20:39:50 +0200 (CEST)
From:   Ander Juaristi <a@juaristi.eus>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH v4 1/2] netfilter: Introduce new 64-bit helper functions
Date:   Tue, 13 Aug 2019 20:38:19 +0200
Message-Id: <20190813183820.6659-1-a@juaristi.eus>
X-Mailer: git-send-email 2.17.1
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Introduce new helper functions to load/store 64-bit values
onto/from registers:

 - nft_reg_store64
 - nft_reg_load64

Signed-off-by: Ander Juaristi <a@juaristi.eus>
---
 include/net/netfilter/nf_tables.h | 11 +++++++++++
 net/netfilter/nft_byteorder.c     |  8 ++++----
 2 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 9b624566b82d..aa33ada8728a 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -2,6 +2,7 @@
 #ifndef _NET_NF_TABLES_H
 #define _NET_NF_TABLES_H
 
+#include <asm/unaligned.h>
 #include <linux/list.h>
 #include <linux/netfilter.h>
 #include <linux/netfilter/nfnetlink.h>
@@ -119,6 +120,16 @@ static inline void nft_reg_store8(u32 *dreg, u8 val)
 	*(u8 *)dreg = val;
 }
 
+static inline void nft_reg_store64(u32 *dreg, u64 val)
+{
+	put_unaligned(val, (u64 *)dreg);
+}
+
+static inline u64 nft_reg_load64(u32 *sreg)
+{
+	return get_unaligned((u64 *)sreg);
+}
+
 static inline u16 nft_reg_load16(u32 *sreg)
 {
 	return *(u16 *)sreg;
diff --git a/net/netfilter/nft_byteorder.c b/net/netfilter/nft_byteorder.c
index e06318428ea0..a25a222d94c8 100644
--- a/net/netfilter/nft_byteorder.c
+++ b/net/netfilter/nft_byteorder.c
@@ -43,14 +43,14 @@ void nft_byteorder_eval(const struct nft_expr *expr,
 		switch (priv->op) {
 		case NFT_BYTEORDER_NTOH:
 			for (i = 0; i < priv->len / 8; i++) {
-				src64 = get_unaligned((u64 *)&src[i]);
-				put_unaligned_be64(src64, &dst[i]);
+				src64 = nft_reg_load64(&src[i]);
+				nft_reg_store64(&dst[i], cpu_to_be64(src64));
 			}
 			break;
 		case NFT_BYTEORDER_HTON:
 			for (i = 0; i < priv->len / 8; i++) {
-				src64 = get_unaligned_be64(&src[i]);
-				put_unaligned(src64, (u64 *)&dst[i]);
+				src64 = be64_to_cpu(nft_reg_load64(&src[i]));
+				nft_reg_store64(&dst[i], src64);
 			}
 			break;
 		}
-- 
2.17.1

