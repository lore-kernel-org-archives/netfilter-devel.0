Return-Path: <SRS0=iRt+=ZL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0E21C43215
	for <netfilter-devel@archiver.kernel.org>; Tue, 19 Nov 2019 22:06:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8181022440
	for <netfilter-devel@archiver.kernel.org>; Tue, 19 Nov 2019 22:06:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727438AbfKSWGG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 19 Nov 2019 17:06:06 -0500
Received: from correo.us.es ([193.147.175.20]:35146 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727202AbfKSWGG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 19 Nov 2019 17:06:06 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 30CAD8C3C72
        for <netfilter-devel@vger.kernel.org>; Tue, 19 Nov 2019 23:06:02 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 238A0A8E5
        for <netfilter-devel@vger.kernel.org>; Tue, 19 Nov 2019 23:06:02 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 19053D1911; Tue, 19 Nov 2019 23:06:02 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 34A49B7FFB;
        Tue, 19 Nov 2019 23:06:00 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 19 Nov 2019 23:06:00 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id F244042EE38E;
        Tue, 19 Nov 2019 23:05:59 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH net-next 1/4] netfilter: nf_tables: constify nft_reg_load{8,16,64}()
Date:   Tue, 19 Nov 2019 23:05:52 +0100
Message-Id: <20191119220555.17391-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191119220555.17391-1-pablo@netfilter.org>
References: <20191119220555.17391-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch constifies the pointer to source register data that is passed
as an input parameter.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index cae47481e5d6..7dd03b1f0156 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -114,7 +114,7 @@ static inline void nft_reg_store8(u32 *dreg, u8 val)
 	*(u8 *)dreg = val;
 }
 
-static inline u8 nft_reg_load8(u32 *sreg)
+static inline u8 nft_reg_load8(const u32 *sreg)
 {
 	return *(u8 *)sreg;
 }
@@ -125,7 +125,7 @@ static inline void nft_reg_store16(u32 *dreg, u16 val)
 	*(u16 *)dreg = val;
 }
 
-static inline u16 nft_reg_load16(u32 *sreg)
+static inline u16 nft_reg_load16(const u32 *sreg)
 {
 	return *(u16 *)sreg;
 }
@@ -135,7 +135,7 @@ static inline void nft_reg_store64(u32 *dreg, u64 val)
 	put_unaligned(val, (u64 *)dreg);
 }
 
-static inline u64 nft_reg_load64(u32 *sreg)
+static inline u64 nft_reg_load64(const u32 *sreg)
 {
 	return get_unaligned((u64 *)sreg);
 }
-- 
2.11.0

