From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 01/14]: ctnetlink: Fix subsystem used for expectation
	events
Date: Fri,  3 Feb 2006 14:43:59 +0100 (MET)
Message-ID: <20060203134359.2141.92810.sendpatchset@localhost.localdomain>
References: <20060203134358.2141.63426.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20060203134358.2141.63426.sendpatchset@localhost.localdomain>
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

[NETFILTER]: ctnetlink: Fix subsystem used for expectation events

The ctnetlink expectation events should use the NFNL_SUBSYS_CTNETLINK_EXP
subsystem, not NFNL_SUBSYS_CTNETLINK.

Signed-off-by: Marcus Sundberg <marcus@ingate.com>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 4fd076987107a8ffa2b330d20b69a54b5ef9b554
tree 2b35cf1ee1da6023ef2e3db31aacacbaa41bb485
parent 826eeb53a6f264842200d3311d69107d2eb25f5e
author Marcus Sundberg <marcus@ingate.com> Fri, 03 Feb 2006 12:25:13 +0100
committer Patrick McHardy <kaber@trash.net> Fri, 03 Feb 2006 12:25:13 +0100

 net/ipv4/netfilter/ip_conntrack_netlink.c |    2 +-
 net/netfilter/nf_conntrack_netlink.c      |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/netfilter/ip_conntrack_netlink.c b/net/ipv4/netfilter/ip_conntrack_netlink.c
index c9ebbe0..b62518b 100644
--- a/net/ipv4/netfilter/ip_conntrack_netlink.c
+++ b/net/ipv4/netfilter/ip_conntrack_netlink.c
@@ -1216,7 +1216,7 @@ static int ctnetlink_expect_event(struct
 
 	b = skb->tail;
 
-	type |= NFNL_SUBSYS_CTNETLINK << 8;
+	type |= NFNL_SUBSYS_CTNETLINK_EXP << 8;
 	nlh   = NLMSG_PUT(skb, 0, 0, type, sizeof(struct nfgenmsg));
 	nfmsg = NLMSG_DATA(nlh);
 
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 73ab16b..e98d00c 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1232,7 +1232,7 @@ static int ctnetlink_expect_event(struct
 
 	b = skb->tail;
 
-	type |= NFNL_SUBSYS_CTNETLINK << 8;
+	type |= NFNL_SUBSYS_CTNETLINK_EXP << 8;
 	nlh   = NLMSG_PUT(skb, 0, 0, type, sizeof(struct nfgenmsg));
 	nfmsg = NLMSG_DATA(nlh);
 
