From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 05/12] netfilter: nft_meta: permit pkttype mangling in ip/ip6 prerouting
Date: Tue,  1 Nov 2016 22:26:26 +0100
Message-ID: <1478035593-1362-6-git-send-email-pablo@netfilter.org>
References: <1478035593-1362-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1478035593-1362-1-git-send-email-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Liping Zhang <liping.zhang@spreadtrum.com>

After supporting this, we can combine it with hash expression to emulate
the 'cluster match'.

Suggested-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Liping Zhang <liping.zhang@spreadtrum.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_meta.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index 6c1e0246706e..64994023bf81 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -310,6 +310,11 @@ int nft_meta_set_validate(const struct nft_ctx *ctx,
 	case NFPROTO_NETDEV:
 		hooks = 1 << NF_NETDEV_INGRESS;
 		break;
+	case NFPROTO_IPV4:
+	case NFPROTO_IPV6:
+	case NFPROTO_INET:
+		hooks = 1 << NF_INET_PRE_ROUTING;
+		break;
 	default:
 		return -EOPNOTSUPP;
 	}
-- 
2.1.4
