From: Laura Garcia Liebana <nevola@gmail.com>
Subject: [PATCH 4/5] netfilter: nf_tables: Check u32 load in u8 nft_immediate
 attribute
Date: Wed, 10 Aug 2016 17:31:52 +0200
Message-ID: <13f03298fe8c42993a4a56c3a2fe70cc67bd6bd5.1470842571.git.nevola@gmail.com>
References: <cover.1470842571.git.nevola@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:34861 "EHLO
	mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933631AbcHJTZp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Aug 2016 15:25:45 -0400
Received: by mail-wm0-f67.google.com with SMTP id i5so11485698wmg.2
        for <netfilter-devel@vger.kernel.org>; Wed, 10 Aug 2016 12:25:44 -0700 (PDT)
Received: from sonyv (cli-5b7e49a2.wholesale.adamo.es. [91.126.73.162])
        by smtp.gmail.com with ESMTPSA id 190sm8906895wmk.13.2016.08.10.08.31.53
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Wed, 10 Aug 2016 08:31:54 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <cover.1470842571.git.nevola@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Fix the direct assignment from u32 data input into the dlen attribute
with a size of u8.

Signed-off-by: Laura Garcia Liebana <nevola@gmail.com>
---
 net/netfilter/nft_immediate.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/nft_immediate.c b/net/netfilter/nft_immediate.c
index db3b746..6de590c 100644
--- a/net/netfilter/nft_immediate.c
+++ b/net/netfilter/nft_immediate.c
@@ -53,6 +53,9 @@ static int nft_immediate_init(const struct nft_ctx *ctx,
 			    tb[NFTA_IMMEDIATE_DATA]);
 	if (err < 0)
 		return err;
+
+	if (desc.len > U8_MAX)
+		return -EINVAL;
 	priv->dlen = desc.len;
 
 	priv->dreg = nft_parse_register(tb[NFTA_IMMEDIATE_DREG]);
-- 
2.8.1

