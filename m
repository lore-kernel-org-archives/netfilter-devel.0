From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nf-next 2/2] netfilter: nft_ct: report error if mark and dir specified simultaneously
Date: Thu, 22 Sep 2016 22:28:52 +0800
Message-ID: <1474554532-50664-2-git-send-email-zlpnobody@163.com>
References: <1474554532-50664-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org,
        Liping Zhang <liping.zhang@spreadtrum.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-13.163.com ([220.181.12.13]:41221 "EHLO m12-13.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934041AbcIVO3k (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 22 Sep 2016 10:29:40 -0400
In-Reply-To: <1474554532-50664-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <liping.zhang@spreadtrum.com>

NFT_CT_MARK is unrelated to direction, so if NFTA_CT_DIRECTION attr is
specified, report EINVAL to the userspace. This validation check was
already done at nft_ct_get_init, but we missed it in nft_ct_set_init.

Signed-off-by: Liping Zhang <liping.zhang@spreadtrum.com>
---
 net/netfilter/nft_ct.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index 825fbbc..d7b0d171 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -364,6 +364,8 @@ static int nft_ct_set_init(const struct nft_ctx *ctx,
 	switch (priv->key) {
 #ifdef CONFIG_NF_CONNTRACK_MARK
 	case NFT_CT_MARK:
+		if (tb[NFTA_CT_DIRECTION])
+			return -EINVAL;
 		len = FIELD_SIZEOF(struct nf_conn, mark);
 		break;
 #endif
-- 
2.5.5


