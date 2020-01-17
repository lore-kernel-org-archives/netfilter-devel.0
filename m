Return-Path: <SRS0=kPFe=3G=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5F20C33CB6
	for <netfilter-devel@archiver.kernel.org>; Fri, 17 Jan 2020 20:58:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7D98C2072B
	for <netfilter-devel@archiver.kernel.org>; Fri, 17 Jan 2020 20:58:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="EI81paAI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729828AbgAQU6L (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 17 Jan 2020 15:58:11 -0500
Received: from kadath.azazel.net ([81.187.231.250]:55992 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729783AbgAQU6L (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 17 Jan 2020 15:58:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=QGbfIR6EtP3cVrVM6RupTSp/HkiZVtQZ+ZPtw6yi9Gs=; b=EI81paAIJBylkTVJKAGxGfPoZJ
        5b07IJLpDznpkctcDrlxd3M8XPOpW/0k/UpebgqThHhqtVkGtt4nyuYEEYYTAbLgz38abu64up1wt
        rMMlD/nd/tizo6aZ2YlMYWLyqxte7pxu2ZgndQd5wIw6a3UHbZ1QSI933yKOJArR+iW0XnA+ax/rc
        8+ZNbrWPTv6XwFpcH1NRoFbpF5oPmQPatAsDgVm+Rs/XARtSibagyd2lcTDmk+zFqBcYAK8OW0KBm
        /ZWcgB6Lgi9uNW2cnQNoKG8v4oJMaNNRhHFx2BZyf79l4GJURpS0+MxKL44rd9a8ogTQwKMPXs/eD
        KBSE5aUw==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1isYgz-0004I2-Rx
        for netfilter-devel@vger.kernel.org; Fri, 17 Jan 2020 20:58:10 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH libnftnl v2 4/6] include: update nf_tables.h.
Date:   Fri, 17 Jan 2020 20:58:06 +0000
Message-Id: <20200117205808.172194-5-jeremy@azazel.net>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200117205808.172194-1-jeremy@azazel.net>
References: <20200117205808.172194-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The kernel UAPI header includes a couple of new bitwise netlink
attributes and an enum.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 include/libnftnl/expr.h             |  2 ++
 include/linux/netfilter/nf_tables.h | 24 ++++++++++++++++++++++--
 2 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/include/libnftnl/expr.h b/include/libnftnl/expr.h
index 3e0f5b078c7a..cfe456dbc7a5 100644
--- a/include/libnftnl/expr.h
+++ b/include/libnftnl/expr.h
@@ -116,6 +116,8 @@ enum {
 	NFTNL_EXPR_BITWISE_LEN,
 	NFTNL_EXPR_BITWISE_MASK,
 	NFTNL_EXPR_BITWISE_XOR,
+	NFTNL_EXPR_BITWISE_OP,
+	NFTNL_EXPR_BITWISE_DATA,
 };
 
 enum {
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index e237ecbdcd8a..59455e7fec93 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -484,6 +484,20 @@ enum nft_immediate_attributes {
 };
 #define NFTA_IMMEDIATE_MAX	(__NFTA_IMMEDIATE_MAX - 1)
 
+/**
+ * enum nft_bitwise_ops - nf_tables bitwise operations
+ *
+ * @NFT_BITWISE_BOOL: mask-and-xor operation used to implement NOT, AND, OR and
+ *                    XOR boolean operations
+ * @NFT_BITWISE_LSHIFT: left-shift operation
+ * @NFT_BITWISE_RSHIFT: right-shift operation
+ */
+enum nft_bitwise_ops {
+	NFT_BITWISE_BOOL,
+	NFT_BITWISE_LSHIFT,
+	NFT_BITWISE_RSHIFT,
+};
+
 /**
  * enum nft_bitwise_attributes - nf_tables bitwise expression netlink attributes
  *
@@ -492,12 +506,16 @@ enum nft_immediate_attributes {
  * @NFTA_BITWISE_LEN: length of operands (NLA_U32)
  * @NFTA_BITWISE_MASK: mask value (NLA_NESTED: nft_data_attributes)
  * @NFTA_BITWISE_XOR: xor value (NLA_NESTED: nft_data_attributes)
+ * @NFTA_BITWISE_OP: type of operation (NLA_U32: nft_bitwise_ops)
+ * @NFTA_BITWISE_DATA: argument for non-boolean operations
+ *                     (NLA_NESTED: nft_data_attributes)
  *
- * The bitwise expression performs the following operation:
+ * The bitwise expression supports boolean and shift operations.  It implements
+ * the boolean operations by performing the following operation:
  *
  * dreg = (sreg & mask) ^ xor
  *
- * which allow to express all bitwise operations:
+ * with these mask and xor values:
  *
  * 		mask	xor
  * NOT:		1	1
@@ -512,6 +530,8 @@ enum nft_bitwise_attributes {
 	NFTA_BITWISE_LEN,
 	NFTA_BITWISE_MASK,
 	NFTA_BITWISE_XOR,
+	NFTA_BITWISE_OP,
+	NFTA_BITWISE_DATA,
 	__NFTA_BITWISE_MAX
 };
 #define NFTA_BITWISE_MAX	(__NFTA_BITWISE_MAX - 1)
-- 
2.24.1

