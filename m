From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 2/9] netfilter: nft_socket: fix module autoload
Date: Wed, 13 Jun 2018 12:56:53 +0200
Message-ID: <20180613105700.12894-3-pablo@netfilter.org>
References: <20180613105700.12894-1-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=y
Content-Transfer-Encoding: 8bit
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180613105700.12894-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Add alias definition for module autoload when adding socket rules.

Fixes: 554ced0a6e29 ("netfilter: nf_tables: add support for native socket matching")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_socket.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/nft_socket.c b/net/netfilter/nft_socket.c
index f28a0b944087..74e1b3bd6954 100644
--- a/net/netfilter/nft_socket.c
+++ b/net/netfilter/nft_socket.c
@@ -142,3 +142,4 @@ module_exit(nft_socket_module_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Máté Eckl");
 MODULE_DESCRIPTION("nf_tables socket match module");
+MODULE_ALIAS_NFT_EXPR("socket");
-- 
2.11.0
