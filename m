Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DF39C6FA99
	for <netfilter-devel@archiver.kernel.org>; Sun, 12 Mar 2023 20:27:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229946AbjCLU1c (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 12 Mar 2023 16:27:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231279AbjCLU13 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 12 Mar 2023 16:27:29 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D39833448
        for <netfilter-devel@vger.kernel.org>; Sun, 12 Mar 2023 13:27:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=sTetd3eajDv8qKZwRUPHI86syTYlr1jnFvvWSqdZdF4=; b=V8EGl6uO27ZP67hxPe8ubaM9ta
        al6LqB38pnpnaUbA6FAEpyDWTkJBMeEWn7lk/PcqX6nv1+jhw2tVZMnQSTb2VrmIBh5Luq+HSfNBp
        z182qnfHnJmHb2A10oLYOgp2TJSDKc+gVshEazvLZQdYqf4FhaQcGGaXX0GlKxhw614S/ILPmJa0u
        39rFiSHpMJrPTGxKZlMsPOrtG+YzgwkUWgaBODeMirzd40t2/3CV2bSprGvZy7XJe94lKL/LCEimj
        NmrvI1l9+V2h04pFeJTH7GbP0C76AghJehiCn0cXEmHBc4XLj5jyqVil/1jpQVgoaJoXHZAAjODHV
        rGPaGmDg==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1pbSHm-005ll2-ON
        for netfilter-devel@vger.kernel.org; Sun, 12 Mar 2023 20:27:18 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nftables] src: fix a couple of typo's in comments
Date:   Sun, 12 Mar 2023 20:27:10 +0000
Message-Id: <20230312202710.173344-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 include/datatype.h | 2 +-
 src/parser_bison.y | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/datatype.h b/include/datatype.h
index 73f38f66c4ce..391d6ac8b4bd 100644
--- a/include/datatype.h
+++ b/include/datatype.h
@@ -23,7 +23,7 @@
  * @TYPE_INET_SERVICE:	internet service (integer subtype)
  * @TYPE_ICMP_TYPE:	ICMP type codes (integer subtype)
  * @TYPE_TCP_FLAG:	TCP flag (bitmask subtype)
- * @TCPE_DCCP_PKTTYPE:	DCCP packet type (integer subtype)
+ * @TYPE_DCCP_PKTTYPE:	DCCP packet type (integer subtype)
  * @TYPE_MH_TYPE:	Mobility Header type (integer subtype)
  * @TYPE_TIME:		relative time
  * @TYPE_MARK:		packet mark (integer subtype)
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 3c06ff48c95c..ccedfafe1bfa 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -6180,7 +6180,7 @@ exthdr_exists_expr	:	EXTHDR	exthdr_key
 				desc = exthdr_find_proto($2);
 
 				/* Assume that NEXTHDR template is always
-				 * the fist one in list of templates.
+				 * the first one in list of templates.
 				 */
 				$$ = exthdr_expr_alloc(&@$, desc, 1);
 				$$->exthdr.flags = NFT_EXTHDR_F_PRESENT;
-- 
2.39.2

