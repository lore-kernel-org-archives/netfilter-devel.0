Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94D86C433DB
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Mar 2021 21:02:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6F77865243
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Mar 2021 21:02:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231785AbhCIVCT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 9 Mar 2021 16:02:19 -0500
Received: from correo.us.es ([193.147.175.20]:60886 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231858AbhCIVBs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 9 Mar 2021 16:01:48 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id EA342E1230
        for <netfilter-devel@vger.kernel.org>; Tue,  9 Mar 2021 22:01:45 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D990EDA78F
        for <netfilter-devel@vger.kernel.org>; Tue,  9 Mar 2021 22:01:45 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id CEC14DA78C; Tue,  9 Mar 2021 22:01:45 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8C154DA73D;
        Tue,  9 Mar 2021 22:01:43 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 09 Mar 2021 22:01:43 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 5F93E42DF562;
        Tue,  9 Mar 2021 22:01:43 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     fw@strlen.de, fmyhr@fhmtech.com, stefanh@hafenthal.de
Subject: [PATCH nf-next 1/2] netfilter: nftables: rename NFT_CT_HELPER to NFT_CT_HELPER_TYPE
Date:   Tue,  9 Mar 2021 22:01:33 +0100
Message-Id: <20210309210134.13620-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210309210134.13620-1-pablo@netfilter.org>
References: <20210309210134.13620-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The existing NFT_CT_HELPER allows to match on the helper type, rename
this attribute to support for matching on the helper object name.

NFT_CT_HELPER is left in place for backward compatibility.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/uapi/linux/netfilter/nf_tables.h | 5 +++--
 net/netfilter/nft_ct.c                   | 4 ++--
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 79bab7a36b30..481e32c1b1b2 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -1047,7 +1047,7 @@ enum nft_socket_keys {
  * @NFT_CT_MARK: conntrack mark value
  * @NFT_CT_SECMARK: conntrack secmark value
  * @NFT_CT_EXPIRATION: relative conntrack expiration time in ms
- * @NFT_CT_HELPER: connection tracking helper assigned to conntrack
+ * @NFT_CT_HELPER_TYPE: connection tracking helper type assigned to conntrack
  * @NFT_CT_L3PROTOCOL: conntrack layer 3 protocol
  * @NFT_CT_SRC: conntrack layer 3 protocol source (IPv4/IPv6 address, deprecated)
  * @NFT_CT_DST: conntrack layer 3 protocol destination (IPv4/IPv6 address, deprecated)
@@ -1073,7 +1073,8 @@ enum nft_ct_keys {
 	NFT_CT_MARK,
 	NFT_CT_SECMARK,
 	NFT_CT_EXPIRATION,
-	NFT_CT_HELPER,
+	NFT_CT_HELPER_TYPE,
+#define NFT_CT_HELPER	NFT_CT_HELPER_TYPE
 	NFT_CT_L3PROTOCOL,
 	NFT_CT_SRC,
 	NFT_CT_DST,
diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index 882fe8648653..a9041dce9345 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -107,7 +107,7 @@ static void nft_ct_get_eval(const struct nft_expr *expr,
 	case NFT_CT_EXPIRATION:
 		*dest = jiffies_to_msecs(nf_ct_expires(ct));
 		return;
-	case NFT_CT_HELPER:
+	case NFT_CT_HELPER_TYPE:
 		if (ct->master == NULL)
 			goto err;
 		help = nfct_help(ct->master);
@@ -418,7 +418,7 @@ static int nft_ct_get_init(const struct nft_ctx *ctx,
 		len = NF_CT_LABELS_MAX_SIZE;
 		break;
 #endif
-	case NFT_CT_HELPER:
+	case NFT_CT_HELPER_TYPE:
 		if (tb[NFTA_CT_DIRECTION] != NULL)
 			return -EINVAL;
 		len = NF_CT_HELPER_NAME_LEN;
-- 
2.20.1

