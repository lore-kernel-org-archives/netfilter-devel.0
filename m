From: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
Subject: [PATCH] nft_counter: remove wrong __percpu of nft_counter_resest()'s arg
Date: Sat, 19 Jan 2019 22:50:24 +0100
Message-ID: <20190119215024.90174-1-luc.vanoostenryck@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        linux-kernel@vger.kernel.org,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

nft_counter_rest() has its first argument declared as
	struct nft_counter_percpu_priv __percpu *priv
but this structure is not percpu (it only countains
a member 'counter' which is, correctly, a pointer to a
percpu struct nft_counter).

So, remove the '__percpu' from the argument's declaration.

Signed-off-by: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
---
 net/netfilter/nft_counter.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nft_counter.c b/net/netfilter/nft_counter.c
index a61d7edfc..1a6b06ce6 100644
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
2.20.0
