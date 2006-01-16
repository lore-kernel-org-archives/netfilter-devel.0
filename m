From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH 1/3]ip{6}tables: get rid of obsoleted matches from Makefile
Date: Mon, 16 Jan 2006 18:37:03 +0900 (JST)
Message-ID: <200601160937.k0G9b4Za007258@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: laforge@netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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


These are replaced with x_tables matches and no longer exist.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

---
commit 1433482f7d367166757dececf529743cde01dacc
tree eb1f7f3c481d9ae9d399b3146f020dd7729d7398
parent 37d8dc82e0cd93eec77c5bcebd725c4ba661351a
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Sat, 14 Jan 2006 17:32:59 +0900
committer Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Sun, 15 Jan 2006 04:00:24 +0900

 net/ipv4/netfilter/Makefile |    1 -
 net/ipv6/netfilter/Makefile |    1 -
 2 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/netfilter/Makefile b/net/ipv4/netfilter/Makefile
index bcefe64..e5c5b32 100644
--- a/net/ipv4/netfilter/Makefile
+++ b/net/ipv4/netfilter/Makefile
@@ -46,7 +46,6 @@ obj-$(CONFIG_IP_NF_NAT) += iptable_nat.o
 obj-$(CONFIG_IP_NF_RAW) += iptable_raw.o
 
 # matches
-obj-$(CONFIG_IP_NF_MATCH_HELPER) += ipt_helper.o
 obj-$(CONFIG_IP_NF_MATCH_HASHLIMIT) += ipt_hashlimit.o
 obj-$(CONFIG_IP_NF_MATCH_IPRANGE) += ipt_iprange.o
 obj-$(CONFIG_IP_NF_MATCH_MULTIPORT) += ipt_multiport.o
diff --git a/net/ipv6/netfilter/Makefile b/net/ipv6/netfilter/Makefile
index 663b474..db6073c 100644
--- a/net/ipv6/netfilter/Makefile
+++ b/net/ipv6/netfilter/Makefile
@@ -4,7 +4,6 @@
 
 # Link order matters here.
 obj-$(CONFIG_IP6_NF_IPTABLES) += ip6_tables.o
-obj-$(CONFIG_IP6_NF_MATCH_LENGTH) += ip6t_length.o
 obj-$(CONFIG_IP6_NF_MATCH_RT) += ip6t_rt.o
 obj-$(CONFIG_IP6_NF_MATCH_OPTS) += ip6t_hbh.o ip6t_dst.o
 obj-$(CONFIG_IP6_NF_MATCH_IPV6HEADER) += ip6t_ipv6header.o
