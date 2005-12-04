From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 8/9]: Fix unbalanced read_unlock_bh in ctnetlink
Date: Sun, 04 Dec 2005 22:01:25 +0100
Message-ID: <20051204210125.24032.41541.sendpatchset@localhost.localdomain>
References: <20051204210116.24032.9802.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: David S. Miller <davem@davemloft.net>
In-Reply-To: <20051204210116.24032.9802.sendpatchset@localhost.localdomain>
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

[NETFILTER]: Fix unbalanced read_unlock_bh in ctnetlink

NFA_NEST calls NFA_PUT which jumps to nfattr_failure if the skb has no
room left. We call read_unlock_bh at nfattr_failure for the NFA_PUT inside
the locked section, so move NFA_NEST inside the locked section too.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit cd85228eea7c7ab9d701090e3dc9643397cf271d
tree e3fa7a6a24c5b199d311a9f74c312fee3b18eae7
parent 96c75906027f008ed3a4058a606938901e9c6d99
author Patrick McHardy <kaber@trash.net> Sun, 04 Dec 2005 20:56:05 +0100
committer Patrick McHardy <kaber@trash.net> Sun, 04 Dec 2005 20:56:05 +0100

 net/ipv4/netfilter/ip_conntrack_proto_tcp.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/net/ipv4/netfilter/ip_conntrack_proto_tcp.c b/net/ipv4/netfilter/ip_conntrack_proto_tcp.c
index aeb7353..e7fa29e 100644
--- a/net/ipv4/netfilter/ip_conntrack_proto_tcp.c
+++ b/net/ipv4/netfilter/ip_conntrack_proto_tcp.c
@@ -341,9 +341,10 @@ static int tcp_print_conntrack(struct se
 static int tcp_to_nfattr(struct sk_buff *skb, struct nfattr *nfa,
 			 const struct ip_conntrack *ct)
 {
-	struct nfattr *nest_parms = NFA_NEST(skb, CTA_PROTOINFO_TCP);
+	struct nfattr *nest_parms;
 	
 	read_lock_bh(&tcp_lock);
+	nest_parms = NFA_NEST(skb, CTA_PROTOINFO_TCP);
 	NFA_PUT(skb, CTA_PROTOINFO_TCP_STATE, sizeof(u_int8_t),
 		&ct->proto.tcp.state);
 	read_unlock_bh(&tcp_lock);
