From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 01/06]: x_tables: fix xt_register_table error propagation
Date: Mon, 26 Jun 2006 17:43:08 +0200 (MEST)
Message-ID: <20060626154308.11682.91317.sendpatchset@localhost.localdomain>
References: <20060626154307.11682.28562.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20060626154307.11682.28562.sendpatchset@localhost.localdomain>
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

[NETFILTER]: x_tables: fix xt_register_table error propagation

When xt_register_table fails the error is not properly propagated back.
Based on patch by Lepton Wu <ytht.net@gmail.com>.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit c223657397019f91ab8f7a7b8b417eae4a378c72
tree 016c6c6cd56cd11ef4d4250ab083da1894df03eb
parent 80cd9e86e65901f97f3c77b914985cff387d331d
author Patrick McHardy <kaber@trash.net> Mon, 19 Jun 2006 16:48:07 +0200
committer Patrick McHardy <kaber@trash.net> Mon, 19 Jun 2006 16:48:07 +0200

 net/ipv4/netfilter/arp_tables.c |    3 ++-
 net/ipv4/netfilter/ip_tables.c  |    3 ++-
 net/ipv6/netfilter/ip6_tables.c |    3 ++-
 3 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index d0d1919..ad39bf6 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -1120,7 +1120,8 @@ int arpt_register_table(struct arpt_tabl
 		return ret;
 	}
 
-	if (xt_register_table(table, &bootstrap, newinfo) != 0) {
+	ret = xt_register_table(table, &bootstrap, newinfo);
+	if (ret != 0) {
 		xt_free_table_info(newinfo);
 		return ret;
 	}
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index cee3397..101ad98 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -2113,7 +2113,8 @@ int ipt_register_table(struct xt_table *
 		return ret;
 	}
 
-	if (xt_register_table(table, &bootstrap, newinfo) != 0) {
+	ret = xt_register_table(table, &bootstrap, newinfo);
+	if (ret != 0) {
 		xt_free_table_info(newinfo);
 		return ret;
 	}
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 2e72f89..0b5bd55 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -1281,7 +1281,8 @@ int ip6t_register_table(struct xt_table 
 		return ret;
 	}
 
-	if (xt_register_table(table, &bootstrap, newinfo) != 0) {
+	ret = xt_register_table(table, &bootstrap, newinfo);
+	if (ret != 0) {
 		xt_free_table_info(newinfo);
 		return ret;
 	}
