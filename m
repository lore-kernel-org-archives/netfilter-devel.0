From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 9/9]: Don't use conntrack entry after dropping the
	reference
Date: Sun, 04 Dec 2005 22:01:26 +0100
Message-ID: <20051204210126.24032.44556.sendpatchset@localhost.localdomain>
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

[NETFILTER]: Don't use conntrack entry after dropping the reference

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 016ada126fa7f3f46ffeefa14d59edd8464317bf
tree c2586a37bc0af665b9932badc9b2b22dd427a078
parent cd85228eea7c7ab9d701090e3dc9643397cf271d
author Patrick McHardy <kaber@trash.net> Sun, 04 Dec 2005 21:30:33 +0100
committer Patrick McHardy <kaber@trash.net> Sun, 04 Dec 2005 21:30:33 +0100

 net/ipv4/netfilter/ip_conntrack_netlink.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/netfilter/ip_conntrack_netlink.c b/net/ipv4/netfilter/ip_conntrack_netlink.c
index d058ac4..91fe8f2 100644
--- a/net/ipv4/netfilter/ip_conntrack_netlink.c
+++ b/net/ipv4/netfilter/ip_conntrack_netlink.c
@@ -728,11 +728,9 @@ ctnetlink_del_conntrack(struct sock *ctn
 			return -ENOENT;
 		}
 	}	
-	if (del_timer(&ct->timeout)) {
-		ip_conntrack_put(ct);
+	if (del_timer(&ct->timeout))
 		ct->timeout.function((unsigned long)ct);
-		return 0;
-	}
+
 	ip_conntrack_put(ct);
 	DEBUGP("leaving\n");
 
