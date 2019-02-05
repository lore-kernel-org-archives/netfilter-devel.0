From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 3/6] netfilter: nf_nat: skip nat clash resolution for same-origin entries
Date: Tue,  5 Feb 2019 20:04:12 +0100
Message-ID: <20190205190415.25041-4-pablo@netfilter.org>
References: <20190205190415.25041-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190205190415.25041-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Martynas Pumputis <martynas@weave.works>

It is possible that two concurrent packets originating from the same
socket of a connection-less protocol (e.g. UDP) can end up having
different IP_CT_DIR_REPLY tuples which results in one of the packets
being dropped.

To illustrate this, consider the following simplified scenario:

1. Packet A and B are sent at the same time from two different threads
   by same UDP socket.  No matching conntrack entry exists yet.
   Both packets cause allocation of a new conntrack entry.
2. get_unique_tuple gets called for A.  No clashing entry found.
   conntrack entry for A is added to main conntrack table.
3. get_unique_tuple is called for B and will find that the reply
   tuple of B is already taken by A.
   It will allocate a new UDP source port for B to resolve the clash.
4. conntrack entry for B cannot be added to main conntrack table
   because its ORIGINAL direction is clashing with A and the REPLY
   directions of A and B are not the same anymore due to UDP source
   port reallocation done in step 3.

This patch modifies nf_conntrack_tuple_taken so it doesn't consider
colliding reply tuples if the IP_CT_DIR_ORIGINAL tuples are equal.

[ Florian: simplify patch to not use .allow_clash setting
  and always ignore identical flows ]

Signed-off-by: Martynas Pumputis <martynas@weave.works>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_core.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 741b533148ba..db4d46332e86 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1007,6 +1007,22 @@ nf_conntrack_tuple_taken(const struct nf_conntrack_tuple *tuple,
 		}
 
 		if (nf_ct_key_equal(h, tuple, zone, net)) {
+			/* Tuple is taken already, so caller will need to find
+			 * a new source port to use.
+			 *
+			 * Only exception:
+			 * If the *original tuples* are identical, then both
+			 * conntracks refer to the same flow.
+			 * This is a rare situation, it can occur e.g. when
+			 * more than one UDP packet is sent from same socket
+			 * in different threads.
+			 *
+			 * Let nf_ct_resolve_clash() deal with this later.
+			 */
+			if (nf_ct_tuple_equal(&ignored_conntrack->tuplehash[IP_CT_DIR_ORIGINAL].tuple,
+					      &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple))
+				continue;
+
 			NF_CT_STAT_INC_ATOMIC(net, found);
 			rcu_read_unlock();
 			return 1;
-- 
2.11.0
