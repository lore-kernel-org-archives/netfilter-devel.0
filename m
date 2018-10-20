From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 04/10] netfilter: nft_xfrm: use state family, not hook one
Date: Sat, 20 Oct 2018 11:43:11 +0200
Message-ID: <20181020094317.16011-5-pablo@netfilter.org>
References: <20181020094317.16011-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181020094317.16011-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Eyal says:
  doesn't the use of nft_pf(pkt) in this context limit the matching of
  encapsulated packets to the same family?

  IIUC when an e.g. IPv6-in-IPv4 packet is matched, the nft_pf(pkt) will
  be the decapsulated packet family - IPv6 - whereas the state may be
  IPv4. So this check would not allow matching the 'underlay' address in
  such cases.

  I know this was a limitation in xt_policy. but is this intentional in
  this matcher? or is it possible to use state->props.family when
  validating the match instead of nft_pf(pkt)?

Userspace already tells us which address family it expects to match, so
we can just use the real state family rather than the hook family.
so change it as suggested above.

Reported-by: Eyal Birger <eyal.birger@gmail.com>
Suggested-by: Eyal Birger <eyal.birger@gmail.com>
Fixes: 6c47260250fc6 ("netfilter: nf_tables: add xfrm expression")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_xfrm.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nft_xfrm.c b/net/netfilter/nft_xfrm.c
index 3cf71a2e375b..5322609f7662 100644
--- a/net/netfilter/nft_xfrm.c
+++ b/net/netfilter/nft_xfrm.c
@@ -118,12 +118,13 @@ static bool xfrm_state_addr_ok(enum nft_xfrm_keys k, u8 family, u8 mode)
 
 static void nft_xfrm_state_get_key(const struct nft_xfrm *priv,
 				   struct nft_regs *regs,
-				   const struct xfrm_state *state,
-				   u8 family)
+				   const struct xfrm_state *state)
 {
 	u32 *dest = &regs->data[priv->dreg];
 
-	if (!xfrm_state_addr_ok(priv->key, family, state->props.mode)) {
+	if (!xfrm_state_addr_ok(priv->key,
+				state->props.family,
+				state->props.mode)) {
 		regs->verdict.code = NFT_BREAK;
 		return;
 	}
@@ -169,7 +170,7 @@ static void nft_xfrm_get_eval_in(const struct nft_xfrm *priv,
 	}
 
 	state = sp->xvec[priv->spnum];
-	nft_xfrm_state_get_key(priv, regs, state, nft_pf(pkt));
+	nft_xfrm_state_get_key(priv, regs, state);
 }
 
 static void nft_xfrm_get_eval_out(const struct nft_xfrm *priv,
@@ -184,7 +185,7 @@ static void nft_xfrm_get_eval_out(const struct nft_xfrm *priv,
 		if (i < priv->spnum)
 			continue;
 
-		nft_xfrm_state_get_key(priv, regs, dst->xfrm, nft_pf(pkt));
+		nft_xfrm_state_get_key(priv, regs, dst->xfrm);
 		return;
 	}
 
-- 
2.11.0
