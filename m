From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 35/38] netfilter: nft_socket: Break evaluation if no socket found
Date: Fri, 20 Jul 2018 15:09:03 +0200
Message-ID: <20180720130906.27687-36-pablo@netfilter.org>
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

Actual implementation stores 0 in the destination register if no socket
is found by the lookup, but that is not intentional as it is not really
a value of any socket metadata.

This patch fixes this and breaks rule evaluation in this case.

Fixes: 554ced0a6e29 ("netfilter: nf_tables: add support for native socket matching")
Signed-off-by: Máté Eckl <ecklm94@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_socket.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nft_socket.c b/net/netfilter/nft_socket.c
index e43c1939d25f..622ac2012a40 100644
--- a/net/netfilter/nft_socket.c
+++ b/net/netfilter/nft_socket.c
@@ -43,7 +43,7 @@ static void nft_socket_eval(const struct nft_expr *expr,
 		}
 
 	if (!sk) {
-		nft_reg_store8(dest, 0);
+		regs->verdict.code = NFT_BREAK;
 		return;
 	}
 
-- 
2.11.0
