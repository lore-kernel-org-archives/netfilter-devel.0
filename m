Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D8E1C433E6
	for <netfilter-devel@archiver.kernel.org>; Mon, 25 Jan 2021 22:25:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 055D420756
	for <netfilter-devel@archiver.kernel.org>; Mon, 25 Jan 2021 22:25:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732230AbhAYWZ1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 25 Jan 2021 17:25:27 -0500
Received: from correo.us.es ([193.147.175.20]:41826 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732259AbhAYWZP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 25 Jan 2021 17:25:15 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 90345396267
        for <netfilter-devel@vger.kernel.org>; Mon, 25 Jan 2021 23:23:31 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 82AF9DA73F
        for <netfilter-devel@vger.kernel.org>; Mon, 25 Jan 2021 23:23:31 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 7835DDA789; Mon, 25 Jan 2021 23:23:31 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 43CAEDA73F
        for <netfilter-devel@vger.kernel.org>; Mon, 25 Jan 2021 23:23:29 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 25 Jan 2021 23:23:29 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 2D844426CC86
        for <netfilter-devel@vger.kernel.org>; Mon, 25 Jan 2021 23:23:29 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next 3/2] netfilter: nftables: statify nft_parse_register()
Date:   Mon, 25 Jan 2021 23:24:21 +0100
Message-Id: <20210125222421.19701-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This function is not used anymore by any extension, statify it.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
Statify this function after conversion to nft_parse_register_{load,store}().

 include/net/netfilter/nf_tables.h | 1 -
 net/netfilter/nf_tables_api.c     | 3 +--
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 78d174517749..99d4571fef46 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -200,7 +200,6 @@ static inline enum nft_registers nft_type_to_reg(enum nft_data_types type)
 }
 
 int nft_parse_u32_check(const struct nlattr *attr, int max, u32 *dest);
-unsigned int nft_parse_register(const struct nlattr *attr);
 int nft_dump_register(struct sk_buff *skb, unsigned int attr, unsigned int reg);
 
 int nft_parse_register_load(const struct nlattr *attr, u8 *sreg, u32 len);
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index c23163ffb5a1..1d76d07592bf 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -8595,7 +8595,7 @@ EXPORT_SYMBOL_GPL(nft_parse_u32_check);
  *	Registers used to be 128 bit wide, these register numbers will be
  *	mapped to the corresponding 32 bit register numbers.
  */
-unsigned int nft_parse_register(const struct nlattr *attr)
+static unsigned int nft_parse_register(const struct nlattr *attr)
 {
 	unsigned int reg;
 
@@ -8607,7 +8607,6 @@ unsigned int nft_parse_register(const struct nlattr *attr)
 		return reg + NFT_REG_SIZE / NFT_REG32_SIZE - NFT_REG32_00;
 	}
 }
-EXPORT_SYMBOL_GPL(nft_parse_register);
 
 /**
  *	nft_dump_register - dump a register value to a netlink attribute
-- 
2.20.1

