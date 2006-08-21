From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 07/18]: ctnetlink: remove impossible events tests for
	updates
Date: Tue, 22 Aug 2006 00:52:27 +0200 (MEST)
Message-ID: <20060821225227.10288.44294.sendpatchset@localhost.localdomain>
References: <20060821225217.10288.69738.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20060821225217.10288.69738.sendpatchset@localhost.localdomain>
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

[NETFILTER]: ctnetlink: remove impossible events tests for updates

IPCT_HELPER and IPCT_NATINFO bits are never set on updates.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit b27f40cbcae710e0b68589c9943499d8487a1590
tree 95dc47c638f174eec0c5ab68a1ad7cc9d966093f
parent 67b49f9ce48d6acb259d20a38bf1d131250a01c6
author Pablo Neira Ayuso <pablo@netfilter.org> Fri, 11 Aug 2006 21:01:28 +0200
committer Patrick McHardy <kaber@trash.net> Fri, 11 Aug 2006 21:01:28 +0200

 net/ipv4/netfilter/ip_conntrack_netlink.c |    6 +-----
 net/netfilter/nf_conntrack_netlink.c      |    6 +-----
 2 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/net/ipv4/netfilter/ip_conntrack_netlink.c b/net/ipv4/netfilter/ip_conntrack_netlink.c
index 090df76..194158e 100644
--- a/net/ipv4/netfilter/ip_conntrack_netlink.c
+++ b/net/ipv4/netfilter/ip_conntrack_netlink.c
@@ -329,11 +329,7 @@ static int ctnetlink_conntrack_event(str
 		/* dump everything */
 		events = ~0UL;
 		group = NFNLGRP_CONNTRACK_NEW;
-	} else if (events & (IPCT_STATUS |
-		      IPCT_PROTOINFO |
-		      IPCT_HELPER |
-		      IPCT_HELPINFO |
-		      IPCT_NATINFO)) {
+	} else if (events & (IPCT_STATUS | IPCT_PROTOINFO)) {
 		type = IPCTNL_MSG_CT_NEW;
 		group = NFNLGRP_CONNTRACK_UPDATE;
 	} else 
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 81bcbe8..b5ed955 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -339,11 +339,7 @@ static int ctnetlink_conntrack_event(str
 		/* dump everything */
 		events = ~0UL;
 		group = NFNLGRP_CONNTRACK_NEW;
-	} else  if (events & (IPCT_STATUS |
-		      IPCT_PROTOINFO |
-		      IPCT_HELPER |
-		      IPCT_HELPINFO |
-		      IPCT_NATINFO)) {
+	} else  if (events & (IPCT_STATUS | IPCT_PROTOINFO)) {
 		type = IPCTNL_MSG_CT_NEW;
 		group = NFNLGRP_CONNTRACK_UPDATE;
 	} else
