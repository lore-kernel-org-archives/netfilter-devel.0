From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH 06/31] netfilter: nf_tables: add xfrm expression
Date: Wed, 10 Oct 2018 14:53:37 +0200
Message-ID: <20181010125337.evhkbxhzvzz6yby4@breakpoint.cc>
References: <20181008230125.2330-1-pablo@netfilter.org>
 <20181008230125.2330-7-pablo@netfilter.org>
 <20181010143947.44a8f385@jimi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: fw@strlen.de, Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: Eyal Birger <eyal.birger@gmail.com>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181010143947.44a8f385@jimi>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Eyal Birger <eyal.birger@gmail.com> wrote:
> > +	state = sp->xvec[priv->spnum];
> > +	nft_xfrm_state_get_key(priv, regs, state, nft_pf(pkt));
> 
> I'm not familiar enough with nftables to be sure, but doesn't the use
> of nft_pf(pkt) in this context limit the matching of encapsulated
> packets to the same family?

Good point.  I'll test this fix:

diff --git a/net/netfilter/nft_xfrm.c b/net/netfilter/nft_xfrm.c
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
 
