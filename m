Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D400C433F5
	for <netfilter-devel@archiver.kernel.org>; Wed, 17 Nov 2021 10:06:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 41D3460EBD
	for <netfilter-devel@archiver.kernel.org>; Wed, 17 Nov 2021 10:06:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236056AbhKQKJZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 17 Nov 2021 05:09:25 -0500
Received: from mail.netfilter.org ([217.70.188.207]:39650 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236033AbhKQKJZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 17 Nov 2021 05:09:25 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id CDFBE6083C
        for <netfilter-devel@vger.kernel.org>; Wed, 17 Nov 2021 11:04:19 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnftnl] expr: payload: print inner header base offset
Date:   Wed, 17 Nov 2021 11:06:22 +0100
Message-Id: <20211117100622.730615-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Update string array to print the "inner" header string, instead of
printing "unknown".

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter/nf_tables.h | 2 ++
 src/expr/payload.c                  | 5 +++--
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index e94d1fa554cb..0ae912054cf1 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -753,11 +753,13 @@ enum nft_dynset_attributes {
  * @NFT_PAYLOAD_LL_HEADER: link layer header
  * @NFT_PAYLOAD_NETWORK_HEADER: network header
  * @NFT_PAYLOAD_TRANSPORT_HEADER: transport header
+ * @NFT_PAYLOAD_INNER_HEADER: inner header
  */
 enum nft_payload_bases {
 	NFT_PAYLOAD_LL_HEADER,
 	NFT_PAYLOAD_NETWORK_HEADER,
 	NFT_PAYLOAD_TRANSPORT_HEADER,
+	NFT_PAYLOAD_INNER_HEADER,
 };
 
 /**
diff --git a/src/expr/payload.c b/src/expr/payload.c
index 9ccb78e6b535..82747ec8994f 100644
--- a/src/expr/payload.c
+++ b/src/expr/payload.c
@@ -203,15 +203,16 @@ nftnl_expr_payload_parse(struct nftnl_expr *e, struct nlattr *attr)
 	return 0;
 }
 
-static const char *base2str_array[NFT_PAYLOAD_TRANSPORT_HEADER+1] = {
+static const char *base2str_array[NFT_PAYLOAD_INNER_HEADER + 1] = {
 	[NFT_PAYLOAD_LL_HEADER]		= "link",
 	[NFT_PAYLOAD_NETWORK_HEADER] 	= "network",
 	[NFT_PAYLOAD_TRANSPORT_HEADER]	= "transport",
+	[NFT_PAYLOAD_INNER_HEADER]	= "inner",
 };
 
 static const char *base2str(enum nft_payload_bases base)
 {
-	if (base > NFT_PAYLOAD_TRANSPORT_HEADER)
+	if (base > NFT_PAYLOAD_INNER_HEADER)
 		return "unknown";
 
 	return base2str_array[base];
-- 
2.30.2

