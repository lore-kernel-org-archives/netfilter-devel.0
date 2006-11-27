From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 03/04]: ctnetlink: fix reference count leak
Date: Mon, 27 Nov 2006 19:20:57 +0100 (MET)
Message-ID: <20061127182057.17688.59026.sendpatchset@localhost.localdomain>
References: <20061127182053.17688.57354.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20061127182053.17688.57354.sendpatchset@localhost.localdomain>
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

[NETFILTER]: ctnetlink: fix reference count leak

When NFA_NEST exceeds the skb size the protocol reference is leaked.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 7d79b94fc3d91498b8f2ff655839ad84d3390b13
tree 696fa16de7c8051fee047121a9747301c65b94f5
parent a88ad2f562c2c108f76adfda4d5ee954e09e6d98
author Patrick McHardy <kaber@trash.net> Mon, 27 Nov 2006 18:56:26 +0100
committer Patrick McHardy <kaber@trash.net> Mon, 27 Nov 2006 19:10:45 +0100

 net/ipv4/netfilter/ip_conntrack_netlink.c |    1 +
 net/netfilter/nf_conntrack_netlink.c      |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/net/ipv4/netfilter/ip_conntrack_netlink.c b/net/ipv4/netfilter/ip_conntrack_netlink.c
index 262d0d4..55f0ae6 100644
--- a/net/ipv4/netfilter/ip_conntrack_netlink.c
+++ b/net/ipv4/netfilter/ip_conntrack_netlink.c
@@ -153,6 +153,7 @@ ctnetlink_dump_protoinfo(struct sk_buff 
 	return ret;
 
 nfattr_failure:
+	ip_conntrack_proto_put(proto);
 	return -1;
 }
 
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 77a46ee..ab67c2b 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -161,6 +161,7 @@ ctnetlink_dump_protoinfo(struct sk_buff 
 	return ret;
 
 nfattr_failure:
+	nf_ct_proto_put(proto);
 	return -1;
 }
 
