From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 46/53] netfilter: nft_ct: report error if mark and dir specified simultaneously
Date: Mon, 26 Sep 2016 01:06:56 +0200
Message-ID: <1474844823-2026-47-git-send-email-pablo@netfilter.org>
References: <1474844823-2026-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54768 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1034871AbcIYXIG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 25 Sep 2016 19:08:06 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A5847DA887
        for <netfilter-devel@vger.kernel.org>; Mon, 26 Sep 2016 01:08:05 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 913BCDA819
        for <netfilter-devel@vger.kernel.org>; Mon, 26 Sep 2016 01:08:05 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7C188DA81B
        for <netfilter-devel@vger.kernel.org>; Mon, 26 Sep 2016 01:08:03 +0200 (CEST)
In-Reply-To: <1474844823-2026-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <liping.zhang@spreadtrum.com>

NFT_CT_MARK is unrelated to direction, so if NFTA_CT_DIRECTION attr is
specified, report EINVAL to the userspace. This validation check was
already done at nft_ct_get_init, but we missed it in nft_ct_set_init.

Signed-off-by: Liping Zhang <liping.zhang@spreadtrum.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_ct.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index 825fbbc62f48..d7b0d171172a 100644
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
2.1.4

