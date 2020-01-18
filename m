Return-Path: <SRS0=S009=3H=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D876C33CB6
	for <netfilter-devel@archiver.kernel.org>; Sat, 18 Jan 2020 21:23:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 24578246A2
	for <netfilter-devel@archiver.kernel.org>; Sat, 18 Jan 2020 21:23:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="dGPJ4LWI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727121AbgARVXW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 18 Jan 2020 16:23:22 -0500
Received: from kadath.azazel.net ([81.187.231.250]:55194 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726910AbgARVXV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 18 Jan 2020 16:23:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Zyca8iXKwuqKJetY8JC4K3lYqszMwDpsCbzHM2alX0Y=; b=dGPJ4LWIMGmyt3nngPm21NQ01F
        F/xMyMZcNB7IsNQmNwjxvTb3fT5lXq6l+PWjownXxSSjiI7RLrYwg8i3rBF07pDbkfPvTC5O7muob
        c5tscrEJVt3zZM3B46Rzk2WMi+/Sx5pvcHaFTm/nKXSrtzeqC7kWhnwuU0hL7FCdWAsLtst62q5D9
        7IzrI9L6NMwFz6aNgZvBzct2ACFNr53fm0mDk360TbQvJqivvYPhokjKIilCVPGRJ/DeqixH96z5H
        BJBuRGYkqDJktOlEmCXvoIfGngdzb+tkyNUExVgc0XTXrFzoCF1BAC11MYMXzCQFMy27cR0Waj3LP
        /oOLMTpw==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1isvYu-0006Ji-3B
        for netfilter-devel@vger.kernel.org; Sat, 18 Jan 2020 21:23:20 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nft v2 7/9] include: update nf_tables.h.
Date:   Sat, 18 Jan 2020 21:23:17 +0000
Message-Id: <20200118212319.253112-8-jeremy@azazel.net>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200118212319.253112-1-jeremy@azazel.net>
References: <20200118212319.253112-1-jeremy@azazel.net>
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
 include/linux/netfilter/nf_tables.h | 28 ++++++++++++++++++++++++++--
 1 file changed, 26 insertions(+), 2 deletions(-)

diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index c556ccd3dbf7..59455e7fec93 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -144,12 +144,14 @@ enum nft_list_attributes {
  * @NFTA_HOOK_HOOKNUM: netfilter hook number (NLA_U32)
  * @NFTA_HOOK_PRIORITY: netfilter hook priority (NLA_U32)
  * @NFTA_HOOK_DEV: netdevice name (NLA_STRING)
+ * @NFTA_HOOK_DEVS: list of netdevices (NLA_NESTED)
  */
 enum nft_hook_attributes {
 	NFTA_HOOK_UNSPEC,
 	NFTA_HOOK_HOOKNUM,
 	NFTA_HOOK_PRIORITY,
 	NFTA_HOOK_DEV,
+	NFTA_HOOK_DEVS,
 	__NFTA_HOOK_MAX
 };
 #define NFTA_HOOK_MAX		(__NFTA_HOOK_MAX - 1)
@@ -482,6 +484,20 @@ enum nft_immediate_attributes {
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
@@ -490,12 +506,16 @@ enum nft_immediate_attributes {
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
@@ -510,6 +530,8 @@ enum nft_bitwise_attributes {
 	NFTA_BITWISE_LEN,
 	NFTA_BITWISE_MASK,
 	NFTA_BITWISE_XOR,
+	NFTA_BITWISE_OP,
+	NFTA_BITWISE_DATA,
 	__NFTA_BITWISE_MAX
 };
 #define NFTA_BITWISE_MAX	(__NFTA_BITWISE_MAX - 1)
@@ -1520,6 +1542,7 @@ enum nft_object_attributes {
  * @NFTA_FLOWTABLE_HOOK: netfilter hook configuration(NLA_U32)
  * @NFTA_FLOWTABLE_USE: number of references to this flow table (NLA_U32)
  * @NFTA_FLOWTABLE_HANDLE: object handle (NLA_U64)
+ * @NFTA_FLOWTABLE_FLAGS: flags (NLA_U32)
  */
 enum nft_flowtable_attributes {
 	NFTA_FLOWTABLE_UNSPEC,
@@ -1529,6 +1552,7 @@ enum nft_flowtable_attributes {
 	NFTA_FLOWTABLE_USE,
 	NFTA_FLOWTABLE_HANDLE,
 	NFTA_FLOWTABLE_PAD,
+	NFTA_FLOWTABLE_FLAGS,
 	__NFTA_FLOWTABLE_MAX
 };
 #define NFTA_FLOWTABLE_MAX	(__NFTA_FLOWTABLE_MAX - 1)
-- 
2.24.1

