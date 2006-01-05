From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 03/18]: ctnetlink: remove bogus checks in ICMP protocol
	at dumping
Date: Thu,  5 Jan 2006 05:06:33 +0100 (MET)
Message-ID: <20060105040558.23512.9441.sendpatchset@localhost.localdomain>
References: <20060105040554.23512.27346.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: David S. Miller <davem@davemloft.net>
In-Reply-To: <20060105040554.23512.27346.sendpatchset@localhost.localdomain>
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

[NETFILTER]: ctnetlink: remove bogus checks in ICMP protocol at dumping

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit da3dc79a37546feb6572bff1a36b23830c799c58
tree dd6f197522094a1a9360f42454d7d0de23701ecd
parent 2cc96aa2efb6f3950c9a506eed4c7cab5d8de076
author Pablo Neira Ayuso <pablo@netfilter.org> Thu, 05 Jan 2006 02:52:57 +0100
committer Patrick McHardy <kaber@trash.net> Thu, 05 Jan 2006 02:52:57 +0100

 net/ipv4/netfilter/ip_conntrack_proto_icmp.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/netfilter/ip_conntrack_proto_icmp.c b/net/ipv4/netfilter/ip_conntrack_proto_icmp.c
index 5f9925d..19cc550 100644
--- a/net/ipv4/netfilter/ip_conntrack_proto_icmp.c
+++ b/net/ipv4/netfilter/ip_conntrack_proto_icmp.c
@@ -279,10 +279,6 @@ static int icmp_tuple_to_nfattr(struct s
 	NFA_PUT(skb, CTA_PROTO_ICMP_CODE, sizeof(u_int8_t),
 		&t->dst.u.icmp.code);
 
-	if (t->dst.u.icmp.type >= sizeof(valid_new) 
-	    || !valid_new[t->dst.u.icmp.type])
-		return -EINVAL;
-
 	return 0;
 
 nfattr_failure:
