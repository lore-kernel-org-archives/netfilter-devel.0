From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 10/11] netfilter: remove useless prototype
Date: Wed,  7 Feb 2018 18:42:28 +0100
Message-ID: <20180207174229.4098-11-pablo@netfilter.org>
References: <20180207174229.4098-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180207174229.4098-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

prototype nf_ct_nat_offset is not used anymore.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 include/net/netfilter/nf_conntrack.h | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index f5223bf2c420..062dc19b5840 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -213,11 +213,6 @@ static inline bool nf_ct_kill(struct nf_conn *ct)
 	return nf_ct_delete(ct, 0, 0);
 }
 
-/* These are for NAT.  Icky. */
-extern s32 (*nf_ct_nat_offset)(const struct nf_conn *ct,
-			       enum ip_conntrack_dir dir,
-			       u32 seq);
-
 /* Set all unconfirmed conntrack as dying */
 void nf_ct_unconfirmed_destroy(struct net *);
 
-- 
2.11.0
