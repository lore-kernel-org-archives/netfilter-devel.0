From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 02/14]: ctnetlink: add MODULE_ALIAS for expectation
	subsystem
Date: Fri,  3 Feb 2006 14:44:01 +0100 (MET)
Message-ID: <20060203134401.2141.19553.sendpatchset@localhost.localdomain>
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

[NETFILTER]: ctnetlink: add MODULE_ALIAS for expectation subsystem

Add load-on-demand support for expectation request. eg. conntrack -L expect

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 04e7be099c349b1c9646ad3cc2c409775c846334
tree 7aad9c450f279b8bd0d0b833eb015141efc8957b
parent 4fd076987107a8ffa2b330d20b69a54b5ef9b554
author Pablo Neira Ayuso <pablo@netfilter.org> Fri, 03 Feb 2006 12:26:49 +0100
committer Patrick McHardy <kaber@trash.net> Fri, 03 Feb 2006 12:26:49 +0100

 net/ipv4/netfilter/ip_conntrack_netlink.c |    1 +
 net/netfilter/nf_conntrack_netlink.c      |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/net/ipv4/netfilter/ip_conntrack_netlink.c b/net/ipv4/netfilter/ip_conntrack_netlink.c
index b62518b..e0b5926 100644
--- a/net/ipv4/netfilter/ip_conntrack_netlink.c
+++ b/net/ipv4/netfilter/ip_conntrack_netlink.c
@@ -1567,6 +1567,7 @@ static struct nfnetlink_subsystem ctnl_e
 };
 
 MODULE_ALIAS_NFNL_SUBSYS(NFNL_SUBSYS_CTNETLINK);
+MODULE_ALIAS_NFNL_SUBSYS(NFNL_SUBSYS_CTNETLINK_EXP);
 
 static int __init ctnetlink_init(void)
 {
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index e98d00c..9ff3463 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1589,6 +1589,7 @@ static struct nfnetlink_subsystem ctnl_e
 };
 
 MODULE_ALIAS_NFNL_SUBSYS(NFNL_SUBSYS_CTNETLINK);
+MODULE_ALIAS_NFNL_SUBSYS(NFNL_SUBSYS_CTNETLINK_EXP);
 
 static int __init ctnetlink_init(void)
 {
