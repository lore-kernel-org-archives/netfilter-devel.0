From: Laura Garcia Liebana <nevola@gmail.com>
Subject: [PATCH 5/5] netfilter: nf_tables: Check u32 load in u8 nft_nat
 attribute
Date: Wed, 10 Aug 2016 17:32:22 +0200
Message-ID: <2fb83448cb34c7ee8ede6b95ade5601cec392371.1470842571.git.nevola@gmail.com>
References: <cover.1470842571.git.nevola@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:34819 "EHLO
	mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932706AbcHJTL6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Aug 2016 15:11:58 -0400
Received: by mail-wm0-f68.google.com with SMTP id i5so11415929wmg.2
        for <netfilter-devel@vger.kernel.org>; Wed, 10 Aug 2016 12:11:58 -0700 (PDT)
Received: from sonyv ([91.126.73.162])
        by smtp.gmail.com with ESMTPSA id o4sm43562430wjd.15.2016.08.10.08.32.24
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Wed, 10 Aug 2016 08:32:25 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <cover.1470842571.git.nevola@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Fix the direct assignment from u32 data input into the family
attribute with a size of u8.

Signed-off-by: Laura Garcia Liebana <nevola@gmail.com>
---
 net/netfilter/nft_nat.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/nft_nat.c b/net/netfilter/nft_nat.c
index ee2d717..74f8293 100644
--- a/net/netfilter/nft_nat.c
+++ b/net/netfilter/nft_nat.c
@@ -148,6 +148,8 @@ static int nft_nat_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 	family = ntohl(nla_get_be32(tb[NFTA_NAT_FAMILY]));
 	if (family != ctx->afi->family)
 		return -EOPNOTSUPP;
+	if (family > U8_MAX)
+		return -EINVAL;
 
 	switch (family) {
 	case NFPROTO_IPV4:
-- 
2.8.1

