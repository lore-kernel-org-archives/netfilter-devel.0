From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 09/25] netfilter: nft_ct: make byte/packet expr more friendly
Date: Sat, 23 Jul 2016 13:08:23 +0200
Message-ID: <1469272119-29942-10-git-send-email-pablo@netfilter.org>
References: <1469272119-29942-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1469272119-29942-1-git-send-email-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

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
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
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
2.1.4
