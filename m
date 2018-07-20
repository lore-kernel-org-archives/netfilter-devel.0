From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 36/38] netfilter: nft_socket: Expose socket mark
Date: Fri, 20 Jul 2018 15:09:04 +0200
Message-ID: <20180720130906.27687-37-pablo@netfilter.org>
References: <20180720130906.27687-1-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180720130906.27687-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Máté Eckl <ecklm94@gmail.com>

Signed-off-by: Máté Eckl <ecklm94@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/uapi/linux/netfilter/nf_tables.h |  4 +++-
 net/netfilter/nft_socket.c               | 11 +++++++++++
 2 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 89438e68dc03..f466860bcf75 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -921,10 +921,12 @@ enum nft_socket_attributes {
 /*
  * enum nft_socket_keys - nf_tables socket expression keys
  *
- * @NFT_SOCKET_TRANSPARENT: Value of the IP(V6)_TRANSPARENT socket option_
+ * @NFT_SOCKET_TRANSPARENT: Value of the IP(V6)_TRANSPARENT socket option
+ * @NFT_SOCKET_MARK: Value of the socket mark
  */
 enum nft_socket_keys {
 	NFT_SOCKET_TRANSPARENT,
+	NFT_SOCKET_MARK,
 	__NFT_SOCKET_MAX
 };
 #define NFT_SOCKET_MAX	(__NFT_SOCKET_MAX - 1)
diff --git a/net/netfilter/nft_socket.c b/net/netfilter/nft_socket.c
index 622ac2012a40..d7f3776dfd71 100644
--- a/net/netfilter/nft_socket.c
+++ b/net/netfilter/nft_socket.c
@@ -54,6 +54,14 @@ static void nft_socket_eval(const struct nft_expr *expr,
 	case NFT_SOCKET_TRANSPARENT:
 		nft_reg_store8(dest, inet_sk_transparent(sk));
 		break;
+	case NFT_SOCKET_MARK:
+		if (sk_fullsock(sk)) {
+			*dest = sk->sk_mark;
+		} else {
+			regs->verdict.code = NFT_BREAK;
+			return;
+		}
+		break;
 	default:
 		WARN_ON(1);
 		regs->verdict.code = NFT_BREAK;
@@ -91,6 +99,9 @@ static int nft_socket_init(const struct nft_ctx *ctx,
 	case NFT_SOCKET_TRANSPARENT:
 		len = sizeof(u8);
 		break;
+	case NFT_SOCKET_MARK:
+		len = sizeof(u32);
+		break;
 	default:
 		return -EOPNOTSUPP;
 	}
-- 
2.11.0
