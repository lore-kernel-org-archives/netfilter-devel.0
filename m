Return-Path: <SRS0=CFkq=5P=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33430C2D0E9
	for <netfilter-devel@archiver.kernel.org>; Mon, 30 Mar 2020 00:37:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 13F98206DB
	for <netfilter-devel@archiver.kernel.org>; Mon, 30 Mar 2020 00:37:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728129AbgC3Ahc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 29 Mar 2020 20:37:32 -0400
Received: from correo.us.es ([193.147.175.20]:57158 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728057AbgC3Ah2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 29 Mar 2020 20:37:28 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C2097EF431
        for <netfilter-devel@vger.kernel.org>; Mon, 30 Mar 2020 02:37:25 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B2106100A53
        for <netfilter-devel@vger.kernel.org>; Mon, 30 Mar 2020 02:37:25 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id A7382100A50; Mon, 30 Mar 2020 02:37:25 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C295F100A47;
        Mon, 30 Mar 2020 02:37:23 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 30 Mar 2020 02:37:23 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 9D1E442EF42A;
        Mon, 30 Mar 2020 02:37:23 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 24/26] netfilter: nf_tables: skip set types that do not support for expressions
Date:   Mon, 30 Mar 2020 02:37:06 +0200
Message-Id: <20200330003708.54017-25-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200330003708.54017-1-pablo@netfilter.org>
References: <20200330003708.54017-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The bitmap set does not support for expressions, skip it from the
estimation step.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h | 2 ++
 net/netfilter/nf_tables_api.c     | 3 +++
 net/netfilter/nft_set_bitmap.c    | 2 ++
 3 files changed, 7 insertions(+)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 642bc3ef81aa..6eb627b3c99b 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -266,6 +266,7 @@ struct nft_set_iter {
  *	@size: number of set elements
  *	@field_len: length of each field in concatenation, bytes
  *	@field_count: number of concatenated fields in element
+ *	@expr: set must support for expressions
  */
 struct nft_set_desc {
 	unsigned int		klen;
@@ -273,6 +274,7 @@ struct nft_set_desc {
 	unsigned int		size;
 	u8			field_len[NFT_REG32_COUNT];
 	u8			field_count;
+	bool			expr;
 };
 
 /**
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index c1e04ac21392..8a73adfab7ff 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4032,6 +4032,9 @@ static int nf_tables_newset(struct net *net, struct sock *nlsk,
 			return err;
 	}
 
+	if (nla[NFTA_SET_EXPR])
+		desc.expr = true;
+
 	table = nft_table_lookup(net, nla[NFTA_SET_TABLE], family, genmask);
 	if (IS_ERR(table)) {
 		NL_SET_BAD_ATTR(extack, nla[NFTA_SET_TABLE]);
diff --git a/net/netfilter/nft_set_bitmap.c b/net/netfilter/nft_set_bitmap.c
index 6829a497b4cc..32f0fc8be3a4 100644
--- a/net/netfilter/nft_set_bitmap.c
+++ b/net/netfilter/nft_set_bitmap.c
@@ -286,6 +286,8 @@ static bool nft_bitmap_estimate(const struct nft_set_desc *desc, u32 features,
 	/* Make sure bitmaps we don't get bitmaps larger than 16 Kbytes. */
 	if (desc->klen > 2)
 		return false;
+	else if (desc->expr)
+		return false;
 
 	est->size   = nft_bitmap_total_size(desc->klen);
 	est->lookup = NFT_SET_CLASS_O_1;
-- 
2.11.0

