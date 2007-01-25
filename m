From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 01/03]: nf_nat: fix ICMP translation with statically
	linked conntrack
Date: Thu, 25 Jan 2007 01:21:57 +0100 (MET)
Message-ID: <20070125002157.1883.90981.sendpatchset@localhost.localdomain>
References: <20070125002156.1883.33845.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070125002156.1883.33845.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nf_nat: fix ICMP translation with statically linked conntrack

When nf_nat/nf_conntrack_ipv4 are linked statically, nf_nat is initialized
before nf_conntrack_ipv4, which makes the nf_ct_l3proto_find_get(AF_INET)
call during nf_nat initialization return the generic l3proto instead of
the AF_INET specific one. This breaks ICMP error translation since the
generic protocol always initializes the IPs in the tuple to 0.

Change the linking order and put nf_conntrack_ipv4 first.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 7093c7d9fd00eff7cc3edba17fc8f8e1e6644da7
tree 26626579bb6e50d89602a81b181261a047d0f451
parent eef40519c526f6446a0bf8ecc666af30f2eb5bfa
author Patrick McHardy <kaber@trash.net> Wed, 24 Jan 2007 21:02:56 +0100
committer Patrick McHardy <kaber@trash.net> Thu, 25 Jan 2007 01:17:14 +0100

 net/ipv4/netfilter/Makefile |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/net/ipv4/netfilter/Makefile b/net/ipv4/netfilter/Makefile
index 15e741a..16d177b 100644
--- a/net/ipv4/netfilter/Makefile
+++ b/net/ipv4/netfilter/Makefile
@@ -4,6 +4,14 @@ #
 
 # objects for the standalone - connection tracking / NAT
 ip_conntrack-objs	:= ip_conntrack_standalone.o ip_conntrack_core.o ip_conntrack_proto_generic.o ip_conntrack_proto_tcp.o ip_conntrack_proto_udp.o ip_conntrack_proto_icmp.o
+# objects for l3 independent conntrack
+nf_conntrack_ipv4-objs  :=  nf_conntrack_l3proto_ipv4.o nf_conntrack_proto_icmp.o
+ifeq ($(CONFIG_NF_CONNTRACK_PROC_COMPAT),y)
+ifeq ($(CONFIG_PROC_FS),y)
+nf_conntrack_ipv4-objs	+= nf_conntrack_l3proto_ipv4_compat.o
+endif
+endif
+
 ip_nat-objs	:= ip_nat_core.o ip_nat_helper.o ip_nat_proto_unknown.o ip_nat_proto_tcp.o ip_nat_proto_udp.o ip_nat_proto_icmp.o
 nf_nat-objs	:= nf_nat_core.o nf_nat_helper.o nf_nat_proto_unknown.o nf_nat_proto_tcp.o nf_nat_proto_udp.o nf_nat_proto_icmp.o
 ifneq ($(CONFIG_NF_NAT),)
@@ -20,6 +28,8 @@ ip_nat_h323-objs := ip_nat_helper_h323.o
 
 # connection tracking
 obj-$(CONFIG_IP_NF_CONNTRACK) += ip_conntrack.o
+obj-$(CONFIG_NF_CONNTRACK_IPV4) += nf_conntrack_ipv4.o
+
 obj-$(CONFIG_IP_NF_NAT) += ip_nat.o
 obj-$(CONFIG_NF_NAT) += nf_nat.o
 
@@ -106,13 +116,3 @@ obj-$(CONFIG_IP_NF_ARPFILTER) += arptabl
 
 obj-$(CONFIG_IP_NF_QUEUE) += ip_queue.o
 
-# objects for l3 independent conntrack
-nf_conntrack_ipv4-objs  :=  nf_conntrack_l3proto_ipv4.o nf_conntrack_proto_icmp.o
-ifeq ($(CONFIG_NF_CONNTRACK_PROC_COMPAT),y)
-ifeq ($(CONFIG_PROC_FS),y)
-nf_conntrack_ipv4-objs	+= nf_conntrack_l3proto_ipv4_compat.o
-endif
-endif
-
-# l3 independent conntrack
-obj-$(CONFIG_NF_CONNTRACK_IPV4) += nf_conntrack_ipv4.o
