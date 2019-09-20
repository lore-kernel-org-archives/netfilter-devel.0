Return-Path: <SRS0=NOIG=XP=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35540C4CECD
	for <netfilter-devel@archiver.kernel.org>; Fri, 20 Sep 2019 09:30:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 162D42070C
	for <netfilter-devel@archiver.kernel.org>; Fri, 20 Sep 2019 09:30:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390037AbfITJaa (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 20 Sep 2019 05:30:30 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:60466 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405517AbfITJaa (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 20 Sep 2019 05:30:30 -0400
Received: from localhost ([::1]:45324 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1iBFFE-0007pR-NM; Fri, 20 Sep 2019 11:30:29 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH] nft: Fix add_bitwise_u16() on Big Endian
Date:   Fri, 20 Sep 2019 11:30:20 +0200
Message-Id: <20190920093020.458-1-phil@nwl.cc>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Type used for 'mask' and 'xor' parameters was wrong, 'int' is four bytes
on 32 or 64 bit architectures. After casting a uint16_t to int, on Big
Endian the first two bytes of data are (the leading) zero which libnftnl
then copies instead of the actual value.

This problem was noticed when using '--fragment' option:

| # iptables-nft -A FORWARD --fragment -j ACCEPT
| # nft list ruleset | grep frag-off
| ip frag-off & 0 != 0 counter packets 0 bytes 0 accept

With this fix in place, the resulting nft rule is correct:

| ip frag-off & 8191 != 0 counter packets 0 bytes 0 accept

Fixes: 2f1fbab671576 ("iptables: nft: add -f support")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft-shared.c | 2 +-
 iptables/nft-shared.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/iptables/nft-shared.c b/iptables/nft-shared.c
index 1c09277d85fb5..62072520db2aa 100644
--- a/iptables/nft-shared.c
+++ b/iptables/nft-shared.c
@@ -69,7 +69,7 @@ void add_payload(struct nftnl_rule *r, int offset, int len, uint32_t base)
 }
 
 /* bitwise operation is = sreg & mask ^ xor */
-void add_bitwise_u16(struct nftnl_rule *r, int mask, int xor)
+void add_bitwise_u16(struct nftnl_rule *r, uint16_t mask, uint16_t xor)
 {
 	struct nftnl_expr *expr;
 
diff --git a/iptables/nft-shared.h b/iptables/nft-shared.h
index f3eab6bd53a30..bb88a34679688 100644
--- a/iptables/nft-shared.h
+++ b/iptables/nft-shared.h
@@ -111,7 +111,7 @@ struct nft_family_ops {
 void add_meta(struct nftnl_rule *r, uint32_t key);
 void add_payload(struct nftnl_rule *r, int offset, int len, uint32_t base);
 void add_bitwise(struct nftnl_rule *r, uint8_t *mask, size_t len);
-void add_bitwise_u16(struct nftnl_rule *r, int mask, int xor);
+void add_bitwise_u16(struct nftnl_rule *r, uint16_t mask, uint16_t xor);
 void add_cmp_ptr(struct nftnl_rule *r, uint32_t op, void *data, size_t len);
 void add_cmp_u8(struct nftnl_rule *r, uint8_t val, uint32_t op);
 void add_cmp_u16(struct nftnl_rule *r, uint16_t val, uint32_t op);
-- 
2.23.0

