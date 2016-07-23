From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 10/25] netfilter: constify arg to is_dying/confirmed
Date: Sat, 23 Jul 2016 13:08:24 +0200
Message-ID: <1469272119-29942-11-git-send-email-pablo@netfilter.org>
References: <1469272119-29942-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1469272119-29942-1-git-send-email-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_conntrack.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index a08825b..1e04911 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -270,12 +270,12 @@ static inline int nf_ct_is_template(const struct nf_conn *ct)
 }
 
 /* It's confirmed if it is, or has been in the hash table. */
-static inline int nf_ct_is_confirmed(struct nf_conn *ct)
+static inline int nf_ct_is_confirmed(const struct nf_conn *ct)
 {
 	return test_bit(IPS_CONFIRMED_BIT, &ct->status);
 }
 
-static inline int nf_ct_is_dying(struct nf_conn *ct)
+static inline int nf_ct_is_dying(const struct nf_conn *ct)
 {
 	return test_bit(IPS_DYING_BIT, &ct->status);
 }
-- 
2.1.4
