From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 31/33] netfilter: nft_counter: remove wrong __percpu of nft_counter_resest()'s arg
Date: Tue, 29 Jan 2019 00:57:48 +0100
Message-ID: <20190128235750.18412-32-pablo@netfilter.org>
References: <20190128235750.18412-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190128235750.18412-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>

nft_counter_rest() has its first argument declared as
	struct nft_counter_percpu_priv __percpu *priv
but this structure is not percpu (it only countains
a member 'counter' which is, correctly, a pointer to a
percpu struct nft_counter).

So, remove the '__percpu' from the argument's declaration.

Signed-off-by: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_counter.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nft_counter.c b/net/netfilter/nft_counter.c
index a61d7edfc290..1a6b06ce6b5b 100644
--- a/net/netfilter/nft_counter.c
+++ b/net/netfilter/nft_counter.c
@@ -104,7 +104,7 @@ static void nft_counter_obj_destroy(const struct nft_ctx *ctx,
 	nft_counter_do_destroy(priv);
 }
 
-static void nft_counter_reset(struct nft_counter_percpu_priv __percpu *priv,
+static void nft_counter_reset(struct nft_counter_percpu_priv *priv,
 			      struct nft_counter *total)
 {
 	struct nft_counter *this_cpu;
-- 
2.11.0
