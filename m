From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nf-next] netfilter: nft_ct: make byte/packet expr more friendly
Date: Tue,  5 Jul 2016 23:23:00 +0800
Message-ID: <1467732180-3938-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org,
	Liping Zhang <liping.zhang@spreadtrum.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-11.163.com ([220.181.12.11]:58664 "EHLO m12-11.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754712AbcGEPYY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 5 Jul 2016 11:24:24 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <liping.zhang@spreadtrum.com>

If we want to use ct packets expr, and add a rule like follows:
  # nft add rule filter input ct packets gt 1 counter

We will find that no packets will hit it, because
nf_conntrack_acct is disabled by default. So It will
not work until we enable it manually via
"echo 1 > /proc/sys/net/netfilter/nf_conntrack_acct".

This is not friendly, so like xt_connbytes do, if the user
want to use ct byte/packet expr, enable nf_conntrack_acct
automatically.

Signed-off-by: Liping Zhang <liping.zhang@spreadtrum.com>
---
 net/netfilter/nft_ct.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index 137e308..7ce8fd7 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -355,6 +355,9 @@ static int nft_ct_get_init(const struct nft_ctx *ctx,
 	if (err < 0)
 		return err;
 
+	if (priv->key == NFT_CT_BYTES || priv->key == NFT_CT_PKTS)
+		nf_ct_set_acct(ctx->net, true);
+
 	return 0;
 }
 
-- 
2.5.5


