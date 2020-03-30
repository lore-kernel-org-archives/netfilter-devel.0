Return-Path: <SRS0=CFkq=5P=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85976C2D0E9
	for <netfilter-devel@archiver.kernel.org>; Mon, 30 Mar 2020 00:38:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 62D42206DB
	for <netfilter-devel@archiver.kernel.org>; Mon, 30 Mar 2020 00:38:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728311AbgC3AiF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 29 Mar 2020 20:38:05 -0400
Received: from correo.us.es ([193.147.175.20]:57146 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727937AbgC3AhX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 29 Mar 2020 20:37:23 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id AE3B0EF428
        for <netfilter-devel@vger.kernel.org>; Mon, 30 Mar 2020 02:37:21 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9F2CD100A5C
        for <netfilter-devel@vger.kernel.org>; Mon, 30 Mar 2020 02:37:21 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 942D3100A55; Mon, 30 Mar 2020 02:37:21 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AB516100A47;
        Mon, 30 Mar 2020 02:37:19 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 30 Mar 2020 02:37:19 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 80CBD42EF42A;
        Mon, 30 Mar 2020 02:37:19 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 11/26] netfilter: nf_tables: add enum nft_flowtable_flags to uapi
Date:   Mon, 30 Mar 2020 02:36:53 +0200
Message-Id: <20200330003708.54017-12-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200330003708.54017-1-pablo@netfilter.org>
References: <20200330003708.54017-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Expose the NFT_FLOWTABLE_HW_OFFLOAD flag through uapi.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_flow_table.h    |  2 +-
 include/uapi/linux/netfilter/nf_tables.h | 10 ++++++++++
 net/netfilter/nf_tables_api.c            |  2 +-
 3 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index f523ea87b6ae..4beb7f13bc50 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -62,7 +62,7 @@ struct nf_flowtable_type {
 };
 
 enum nf_flowtable_flags {
-	NF_FLOWTABLE_HW_OFFLOAD		= 0x1,
+	NF_FLOWTABLE_HW_OFFLOAD		= 0x1,	/* NFT_FLOWTABLE_HW_OFFLOAD */
 };
 
 struct nf_flowtable {
diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 4e3a5971d4ee..717ee3aa05d7 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -1554,6 +1554,16 @@ enum nft_object_attributes {
 #define NFTA_OBJ_MAX		(__NFTA_OBJ_MAX - 1)
 
 /**
+ * enum nft_flowtable_flags - nf_tables flowtable flags
+ *
+ * @NFT_FLOWTABLE_HW_OFFLOAD: flowtable hardware offload is enabled
+ */
+enum nft_flowtable_flags {
+	NFT_FLOWTABLE_HW_OFFLOAD	= 0x1,
+	NFT_FLOWTABLE_MASK		= NFT_FLOWTABLE_HW_OFFLOAD
+};
+
+/**
  * enum nft_flowtable_attributes - nf_tables flow table netlink attributes
  *
  * @NFTA_FLOWTABLE_TABLE: name of the table containing the expression (NLA_STRING)
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index c5332a313283..ace325218edb 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6375,7 +6375,7 @@ static int nf_tables_newflowtable(struct net *net, struct sock *nlsk,
 	if (nla[NFTA_FLOWTABLE_FLAGS]) {
 		flowtable->data.flags =
 			ntohl(nla_get_be32(nla[NFTA_FLOWTABLE_FLAGS]));
-		if (flowtable->data.flags & ~NF_FLOWTABLE_HW_OFFLOAD)
+		if (flowtable->data.flags & ~NFT_FLOWTABLE_MASK)
 			goto err3;
 	}
 
-- 
2.11.0

