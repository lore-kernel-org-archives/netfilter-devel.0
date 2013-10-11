From: Anand Raj Manickam <anandrm@gmail.com>
Subject: [PATCH] iptables-nftables nft: Removes NFT_META_IIF ,NFT_META_OIF
Date: Fri, 11 Oct 2013 12:08:38 +0530
Message-ID: <CAEyr1FSxBQC3u3wePjscZPmtiqA5m54qc-8j8Sbz-8+JRcu2Mw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qa0-f47.google.com ([209.85.216.47]:49277 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752338Ab3JKGii (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 11 Oct 2013 02:38:38 -0400
Received: by mail-qa0-f47.google.com with SMTP id k15so186269qaq.6
        for <netfilter-devel@vger.kernel.org>; Thu, 10 Oct 2013 23:38:38 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Removes the  NFT_META_IIF ,NFT_META_OIF

diff --git a/iptables/nft-shared.c b/iptables/nft-shared.c
index 25cb177..a115d7d 100644
--- a/iptables/nft-shared.c
+++ b/iptables/nft-shared.c
@@ -227,39 +218,20 @@ void parse_meta(struct nft_rule_expr *e, uint8_t
key, char *iniface,
        uint32_t len;

        switch(key) {
-       case NFT_META_IIF:
-               value = nft_rule_expr_get_u32(e, NFT_EXPR_CMP_DATA);
-               if (nft_rule_expr_get_u8(e, NFT_EXPR_CMP_OP) == NFT_CMP_NEQ)
-                       *invflags |= IPT_INV_VIA_IN;
-
-               if_indextoname(value, iniface);
-
-               memset(iniface_mask, 0xff, strlen(iniface)+1);
-               break;
-       case NFT_META_OIF:
-               value = nft_rule_expr_get_u32(e, NFT_EXPR_CMP_DATA);
-               if (nft_rule_expr_get_u8(e, NFT_EXPR_CMP_OP) == NFT_CMP_NEQ)
-                       *invflags |= IPT_INV_VIA_OUT;
-
-               if_indextoname(value, outiface);
-
-               memset(outiface_mask, 0xff, strlen(outiface)+1);
-               break;
        case NFT_META_IIFNAME:
