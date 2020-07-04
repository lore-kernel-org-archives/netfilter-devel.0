Return-Path: <SRS0=AjNT=AP=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22707C433E0
	for <netfilter-devel@archiver.kernel.org>; Sat,  4 Jul 2020 00:55:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 010A0206DF
	for <netfilter-devel@archiver.kernel.org>; Sat,  4 Jul 2020 00:55:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726501AbgGDAzH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 3 Jul 2020 20:55:07 -0400
Received: from correo.us.es ([193.147.175.20]:59884 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726455AbgGDAzH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 3 Jul 2020 20:55:07 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 09484ED5BE
        for <netfilter-devel@vger.kernel.org>; Sat,  4 Jul 2020 02:55:06 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EF5B4DA722
        for <netfilter-devel@vger.kernel.org>; Sat,  4 Jul 2020 02:55:05 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id E4942DA73D; Sat,  4 Jul 2020 02:55:05 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9FC2DDA722
        for <netfilter-devel@vger.kernel.org>; Sat,  4 Jul 2020 02:55:03 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 04 Jul 2020 02:55:03 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 853B34265A2F
        for <netfilter-devel@vger.kernel.org>; Sat,  4 Jul 2020 02:55:03 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next] netfilter: nf_tables: reject unsupported chain flags
Date:   Sat,  4 Jul 2020 02:55:00 +0200
Message-Id: <20200704005500.4632-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Bail out if userspace sends unsupported chain flags.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/uapi/linux/netfilter/nf_tables.h | 3 +++
 net/netfilter/nf_tables_api.c            | 3 +++
 2 files changed, 6 insertions(+)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index e00b4ae6174e..42f351c1f5c5 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -189,6 +189,9 @@ enum nft_chain_flags {
 	NFT_CHAIN_HW_OFFLOAD	= (1 << 1),
 	NFT_CHAIN_BINDING	= (1 << 2),
 };
+#define NFT_CHAIN_FLAGS		(NFT_CHAIN_BASE		| \
+				 NFT_CHAIN_HW_OFFLOAD	| \
+				 NFT_CHAIN_BINDING)
 
 /**
  * enum nft_chain_attributes - nf_tables chain netlink attributes
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index b8a970dad213..f96785586f64 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2285,6 +2285,9 @@ static int nf_tables_newchain(struct net *net, struct sock *nlsk,
 	else if (chain)
 		flags = chain->flags;
 
+	if (flags & ~NFT_CHAIN_FLAGS)
+		return -EOPNOTSUPP;
+
 	nft_ctx_init(&ctx, net, skb, nlh, family, table, chain, nla);
 
 	if (chain != NULL) {
-- 
2.20.1

