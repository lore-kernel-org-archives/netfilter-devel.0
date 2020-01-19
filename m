Return-Path: <SRS0=vOmJ=3I=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE9A2C33CB7
	for <netfilter-devel@archiver.kernel.org>; Sun, 19 Jan 2020 22:57:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9501D20678
	for <netfilter-devel@archiver.kernel.org>; Sun, 19 Jan 2020 22:57:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="hThn4rYd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729014AbgASW5P (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 19 Jan 2020 17:57:15 -0500
Received: from kadath.azazel.net ([81.187.231.250]:56588 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728831AbgASW5M (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 19 Jan 2020 17:57:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=I/9aln6VPeclFMdmeUBxtsAm2j9Sa/fJ2eCKpoqy/wA=; b=hThn4rYdh9MfslZb7z7HFjs4kw
        TuV+pKlneYcygb6QOUiI/BeyU2hyixQOpUcFGOzw8t/l0P3gku5sGkbDVM8tmnts09Yw9IN3CXvlF
        wdReVHcCyKGPLAL5Fqb/LWDQGsMBh/wH5UlzZvMdD2UOdn6zrhGa50bW0GGQH3sm50N8/tePhDgXS
        aHLIT7DzFYXatkP8+5Y/fUaQ01OdvRI0NRLZJi9anvgpS6KtfGyRivx9lYxtCxi3d12nW0QO2hOR1
        tKdsrq7ey5GeJO6jL3kchW+gOc0dIQG3YeF+HXulldf/0rOCG/9YEMe4CO8n690JQh7QyAAriy/sX
        lnvxCjrw==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1itJVH-0006wh-CX
        for netfilter-devel@vger.kernel.org; Sun, 19 Jan 2020 22:57:11 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nft v3 7/9] include: update nf_tables.h.
Date:   Sun, 19 Jan 2020 22:57:08 +0000
Message-Id: <20200119225710.222976-8-jeremy@azazel.net>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200119225710.222976-1-jeremy@azazel.net>
References: <20200119225710.222976-1-jeremy@azazel.net>
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
 include/linux/netfilter/nf_tables.h | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 42ed5ca39477..261864736b26 100644
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
@@ -490,6 +506,9 @@ enum nft_immediate_attributes {
  * @NFTA_BITWISE_LEN: length of operands (NLA_U32)
  * @NFTA_BITWISE_MASK: mask value (NLA_NESTED: nft_data_attributes)
  * @NFTA_BITWISE_XOR: xor value (NLA_NESTED: nft_data_attributes)
+ * @NFTA_BITWISE_OP: type of operation (NLA_U32: nft_bitwise_ops)
+ * @NFTA_BITWISE_DATA: argument for non-boolean operations
+ *                     (NLA_NESTED: nft_data_attributes)
  *
  * The bitwise expression supports boolean and shift operations.  It implements
  * the boolean operations by performing the following operation:
@@ -511,6 +530,8 @@ enum nft_bitwise_attributes {
 	NFTA_BITWISE_LEN,
 	NFTA_BITWISE_MASK,
 	NFTA_BITWISE_XOR,
+	NFTA_BITWISE_OP,
+	NFTA_BITWISE_DATA,
 	__NFTA_BITWISE_MAX
 };
 #define NFTA_BITWISE_MAX	(__NFTA_BITWISE_MAX - 1)
@@ -1521,6 +1542,7 @@ enum nft_object_attributes {
  * @NFTA_FLOWTABLE_HOOK: netfilter hook configuration(NLA_U32)
  * @NFTA_FLOWTABLE_USE: number of references to this flow table (NLA_U32)
  * @NFTA_FLOWTABLE_HANDLE: object handle (NLA_U64)
+ * @NFTA_FLOWTABLE_FLAGS: flags (NLA_U32)
  */
 enum nft_flowtable_attributes {
 	NFTA_FLOWTABLE_UNSPEC,
@@ -1530,6 +1552,7 @@ enum nft_flowtable_attributes {
 	NFTA_FLOWTABLE_USE,
 	NFTA_FLOWTABLE_HANDLE,
 	NFTA_FLOWTABLE_PAD,
+	NFTA_FLOWTABLE_FLAGS,
 	__NFTA_FLOWTABLE_MAX
 };
 #define NFTA_FLOWTABLE_MAX	(__NFTA_FLOWTABLE_MAX - 1)
-- 
2.24.1

