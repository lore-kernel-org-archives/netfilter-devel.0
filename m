Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DC88EB64DC
	for <netfilter-devel@archiver.kernel.org>; Mon, 26 Jun 2023 11:05:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229753AbjFZLFS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 26 Jun 2023 07:05:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbjFZLFR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 26 Jun 2023 07:05:17 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8FA0C9D;
        Mon, 26 Jun 2023 04:05:14 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     stable@vger.kernel.org, carnil@debian.org
Subject: [PATCH -stable,5.10 1/3] netfilter: nftables: statify nft_parse_register()
Date:   Mon, 26 Jun 2023 13:05:04 +0200
Message-Id: <20230626110506.76630-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230626110506.76630-1-pablo@netfilter.org>
References: <20230626110506.76630-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

[ 08a01c11a5bb3de9b0a9c9b2685867e50eda9910 ]

This function is not used anymore by any extension, statify it.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h | 1 -
 net/netfilter/nf_tables_api.c     | 3 +--
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 564fbe0c865f..030237f3d82a 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -205,7 +205,6 @@ static inline enum nft_registers nft_type_to_reg(enum nft_data_types type)
 }
 
 int nft_parse_u32_check(const struct nlattr *attr, int max, u32 *dest);
-unsigned int nft_parse_register(const struct nlattr *attr);
 int nft_dump_register(struct sk_buff *skb, unsigned int attr, unsigned int reg);
 
 int nft_parse_register_load(const struct nlattr *attr, u8 *sreg, u32 len);
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index fe51cedd9cc3..e1e1cde42075 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -8489,7 +8489,7 @@ EXPORT_SYMBOL_GPL(nft_parse_u32_check);
  *	Registers used to be 128 bit wide, these register numbers will be
  *	mapped to the corresponding 32 bit register numbers.
  */
-unsigned int nft_parse_register(const struct nlattr *attr)
+static unsigned int nft_parse_register(const struct nlattr *attr)
 {
 	unsigned int reg;
 
@@ -8501,7 +8501,6 @@ unsigned int nft_parse_register(const struct nlattr *attr)
 		return reg + NFT_REG_SIZE / NFT_REG32_SIZE - NFT_REG32_00;
 	}
 }
-EXPORT_SYMBOL_GPL(nft_parse_register);
 
 /**
  *	nft_dump_register - dump a register value to a netlink attribute
-- 
2.30.2

