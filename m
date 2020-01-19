Return-Path: <SRS0=vOmJ=3I=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 924CAC33CB1
	for <netfilter-devel@archiver.kernel.org>; Sun, 19 Jan 2020 10:58:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3DF2C2053B
	for <netfilter-devel@archiver.kernel.org>; Sun, 19 Jan 2020 10:58:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="oIRATuUH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726775AbgASK6C (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 19 Jan 2020 05:58:02 -0500
Received: from kadath.azazel.net ([81.187.231.250]:57832 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726744AbgASK6C (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 19 Jan 2020 05:58:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject
        :To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=VefDYV3KeYmG7u5x9ItWBWm5qn/EjM1ui6E4iMFkoio=; b=oIRATuUHocOLkJaMudn1dg8Yy1
        mHTbt2lLCJ0Pfa8dsM/cc2myCvw1sUfh6f2Lu6bQH1jrmygmEUtI8i4fGXLGe7y5Dww1ZORgtaHa4
        PnyYKzAHqmdVd++Ejtr6uUZmqkXq2ab2Q6sQ5FUxah0m/smxI5GMPJ9RFYx+mY3Ry2roz/87G2Stb
        8wNX4UkCuYuvRgTu/Ky46RDTTQOSmPJMZ1mX94ohkxWCc3EmGvm30ew3+io2W3j3rFf15k7fO40xj
        TxJSvzjv/MDTGYokEP4uIEk5d/2YdIvEJnGG0jC8K9/o+/vDDlJnrK+GHb3RjCBqWFLxkl3lW26qW
        VQqsRcOQ==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1it8HJ-0004bc-Ce
        for netfilter-devel@vger.kernel.org; Sun, 19 Jan 2020 10:58:01 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nft] include: nf_tables: correct bitwise header comment.
Date:   Sun, 19 Jan 2020 10:58:01 +0000
Message-Id: <20200119105801.368018-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The comment documenting how bitwise expressions work includes a table
which summarizes the mask and xor arguments combined to express the
supported boolean operations.  However, the row for OR:

 mask    xor
 0       x

is incorrect.

  dreg = (sreg & 0) ^ x

is not equivalent to:

  dreg = sreg | x

What the code actually does is:

  dreg = (sreg & ~x) ^ x

Update the documentation to match.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 include/linux/netfilter/nf_tables.h | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index c556ccd3dbf7..42ed5ca39477 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -491,15 +491,16 @@ enum nft_immediate_attributes {
  * @NFTA_BITWISE_MASK: mask value (NLA_NESTED: nft_data_attributes)
  * @NFTA_BITWISE_XOR: xor value (NLA_NESTED: nft_data_attributes)
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
- * OR:		0	x
+ * OR:		~x	x
  * XOR:		1	x
  * AND:		x	0
  */
-- 
2.24.1

