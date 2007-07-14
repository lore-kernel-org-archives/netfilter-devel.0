From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 04/08]: nf_conntrack: Don't track locally generated
	special ICMP error
Date: Sat, 14 Jul 2007 17:12:39 +0200 (MEST)
Message-ID: <20070714151155.9829.50994.sendpatchset@localhost.localdomain>
References: <20070714151150.9829.47674.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070714151150.9829.47674.sendpatchset@localhost.localdomain>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

[NETFILTER]: nf_conntrack: Don't track locally generated special ICMP error

The conntrack assigned to locally generated ICMP error is usually the one
assigned to the original packet which has caused the error. But if
the original packet is handled as invalid by nf_conntrack, no conntrack
is assigned to the original packet. Then nf_ct_attach() cannot assign
any conntrack to the ICMP error packet. In that case the current
nf_conntrack_icmp assigns appropriate conntrack to it. But the current
code mistakes the direction of the packet. As a result, NAT code mistakes
the address to be mangled.

To fix the bug, this changes nf_conntrack_icmp not to assign conntrack
to such ICMP error. Actually no address is necessary to be mangled
in this case.

Spotted by Jordan Russell.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 28b86df4d02014ae5ce0be0e82c074f15ea0dabf
tree 4f1d74fa6059740eb380260300f87e39c4e911ac
parent dabf3efb72da4003b4e22a8159e9ad3007502683
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Sat, 14 Jul 2007 17:02:19 +0200
committer Patrick McHardy <kaber@trash.net> Sat, 14 Jul 2007 17:02:19 +0200

 net/ipv4/netfilter/nf_conntrack_proto_icmp.c |   22 +++++-----------------
 1 files changed, 5 insertions(+), 17 deletions(-)

diff --git a/net/ipv4/netfilter/nf_conntrack_proto_icmp.c b/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
index b8b7999..f965733 100644
--- a/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
+++ b/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
@@ -165,25 +165,13 @@ icmp_error_message(struct sk_buff *skb,
 
 	h = nf_conntrack_find_get(&innertuple);
 	if (!h) {
-		/* Locally generated ICMPs will match inverted if they
-		   haven't been SNAT'ed yet */
-		/* FIXME: NAT code has to handle half-done double NAT --RR */
-		if (hooknum == NF_IP_LOCAL_OUT)
-			h = nf_conntrack_find_get(&origtuple);
-
-		if (!h) {
-			pr_debug("icmp_error_message: no match\n");
-			return -NF_ACCEPT;
-		}
-
-		/* Reverse direction from that found */
-		if (NF_CT_DIRECTION(h) == IP_CT_DIR_REPLY)
-			*ctinfo += IP_CT_IS_REPLY;
-	} else {
-		if (NF_CT_DIRECTION(h) == IP_CT_DIR_REPLY)
-			*ctinfo += IP_CT_IS_REPLY;
+		pr_debug("icmp_error_message: no match\n");
+		return -NF_ACCEPT;
 	}
 
+	if (NF_CT_DIRECTION(h) == IP_CT_DIR_REPLY)
+		*ctinfo += IP_CT_IS_REPLY;
+
 	/* Update skb to refer to this connection */
 	skb->nfct = &nf_ct_tuplehash_to_ctrack(h)->ct_general;
 	skb->nfctinfo = *ctinfo;
