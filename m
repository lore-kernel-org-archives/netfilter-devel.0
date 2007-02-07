From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 09/15]: NAT: optional source port randomization support
Date: Wed,  7 Feb 2007 09:22:54 +0100 (MET)
Message-ID: <20070207082253.27478.73747.sendpatchset@localhost.localdomain>
References: <20070207082228.27478.19484.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070207082228.27478.19484.sendpatchset@localhost.localdomain>
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

[NETFILTER]: NAT: optional source port randomization support

This patch adds support to NAT to randomize source ports.

Signed-off-by: Eric Leblond <eric@inl.fr>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 7ef8c3390c8e383f7bf590b11623aed2cf493dfa
tree 2b56ae564f08577e1ff747f941daac38fe97651a
parent b7bc3a6250a99d42d8ba890cf89339a23b011a5e
author Eric Leblond <eric@inl.fr> Tue, 06 Feb 2007 07:37:00 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 06 Feb 2007 08:53:11 +0100

 include/linux/netfilter_ipv4/ip_nat.h |    1 +
 include/net/netfilter/nf_nat.h        |    1 +
 net/ipv4/netfilter/ip_nat_core.c      |   12 ++++++++++--
 net/ipv4/netfilter/ip_nat_proto_tcp.c |    5 +++++
 net/ipv4/netfilter/ip_nat_proto_udp.c |    5 +++++
 net/ipv4/netfilter/ip_nat_rule.c      |    4 ++++
 net/ipv4/netfilter/nf_nat_core.c      |   12 ++++++++++--
 net/ipv4/netfilter/nf_nat_proto_tcp.c |    4 ++++
 net/ipv4/netfilter/nf_nat_proto_udp.c |    4 ++++
 net/ipv4/netfilter/nf_nat_rule.c      |    4 ++++
 10 files changed, 48 insertions(+), 4 deletions(-)

diff --git a/include/linux/netfilter_ipv4/ip_nat.h b/include/linux/netfilter_ipv4/ip_nat.h
index bdf5536..bbca89a 100644
--- a/include/linux/netfilter_ipv4/ip_nat.h
+++ b/include/linux/netfilter_ipv4/ip_nat.h
@@ -16,6 +16,7 @@ #define HOOK2MANIP(hooknum) ((hooknum) !
 
 #define IP_NAT_RANGE_MAP_IPS 1
 #define IP_NAT_RANGE_PROTO_SPECIFIED 2
+#define IP_NAT_RANGE_PROTO_RANDOM 4 /* add randomness to "port" selection */
 
 /* NAT sequence number modifications */
 struct ip_nat_seq {
diff --git a/include/net/netfilter/nf_nat.h b/include/net/netfilter/nf_nat.h
index 61c6206..bc57dd7 100644
--- a/include/net/netfilter/nf_nat.h
+++ b/include/net/netfilter/nf_nat.h
@@ -16,6 +16,7 @@ #define HOOK2MANIP(hooknum) ((hooknum) !
 
 #define IP_NAT_RANGE_MAP_IPS 1
 #define IP_NAT_RANGE_PROTO_SPECIFIED 2
+#define IP_NAT_RANGE_PROTO_RANDOM 4
 
 /* NAT sequence number modifications */
 struct nf_nat_seq {
diff --git a/net/ipv4/netfilter/ip_nat_core.c b/net/ipv4/netfilter/ip_nat_core.c
index 9d1a517..5e08c2b 100644
--- a/net/ipv4/netfilter/ip_nat_core.c
+++ b/net/ipv4/netfilter/ip_nat_core.c
@@ -246,8 +246,9 @@ get_unique_tuple(struct ip_conntrack_tup
 	if (maniptype == IP_NAT_MANIP_SRC) {
 		if (find_appropriate_src(orig_tuple, tuple, range)) {
 			DEBUGP("get_unique_tuple: Found current src map\n");
-			if (!ip_nat_used_tuple(tuple, conntrack))
-				return;
+			if (!(range->flags & IP_NAT_RANGE_PROTO_RANDOM))
+				if (!ip_nat_used_tuple(tuple, conntrack))
+					return;
 		}
 	}
 
@@ -261,6 +262,13 @@ get_unique_tuple(struct ip_conntrack_tup
 
 	proto = ip_nat_proto_find_get(orig_tuple->dst.protonum);
 
+	/* Change protocol info to have some randomization */
+	if (range->flags & IP_NAT_RANGE_PROTO_RANDOM) {
+		proto->unique_tuple(tuple, range, maniptype, conntrack);
+		ip_nat_proto_put(proto);
+		return;
+	}
+
 	/* Only bother mapping if it's not already in range and unique */
 	if ((!(range->flags & IP_NAT_RANGE_PROTO_SPECIFIED)
 	     || proto->in_range(tuple, maniptype, &range->min, &range->max))
diff --git a/net/ipv4/netfilter/ip_nat_proto_tcp.c b/net/ipv4/netfilter/ip_nat_proto_tcp.c
index b586d18..14ff24f 100644
--- a/net/ipv4/netfilter/ip_nat_proto_tcp.c
+++ b/net/ipv4/netfilter/ip_nat_proto_tcp.c
@@ -8,6 +8,7 @@
 
 #include <linux/types.h>
 #include <linux/init.h>
+#include <linux/random.h>
 #include <linux/netfilter.h>
 #include <linux/ip.h>
 #include <linux/tcp.h>
@@ -75,6 +76,10 @@ tcp_unique_tuple(struct ip_conntrack_tup
 		range_size = ntohs(range->max.tcp.port) - min + 1;
 	}
 
+	/* Start from random port to avoid prediction */
+	if (range->flags & IP_NAT_RANGE_PROTO_RANDOM)
+		port =  net_random();
+
 	for (i = 0; i < range_size; i++, port++) {
 		*portptr = htons(min + port % range_size);
 		if (!ip_nat_used_tuple(tuple, conntrack)) {
diff --git a/net/ipv4/netfilter/ip_nat_proto_udp.c b/net/ipv4/netfilter/ip_nat_proto_udp.c
index 5ced087..dfd5216 100644
--- a/net/ipv4/netfilter/ip_nat_proto_udp.c
+++ b/net/ipv4/netfilter/ip_nat_proto_udp.c
@@ -8,6 +8,7 @@
 
 #include <linux/types.h>
 #include <linux/init.h>
+#include <linux/random.h>
 #include <linux/netfilter.h>
 #include <linux/ip.h>
 #include <linux/udp.h>
@@ -74,6 +75,10 @@ udp_unique_tuple(struct ip_conntrack_tup
 		range_size = ntohs(range->max.udp.port) - min + 1;
 	}
 
+	/* Start from random port to avoid prediction */
+	if (range->flags & IP_NAT_RANGE_PROTO_RANDOM)
+		port = net_random();
+
 	for (i = 0; i < range_size; i++, port++) {
 		*portptr = htons(min + port % range_size);
 		if (!ip_nat_used_tuple(tuple, conntrack))
diff --git a/net/ipv4/netfilter/ip_nat_rule.c b/net/ipv4/netfilter/ip_nat_rule.c
index a176aa3..6ebaad3 100644
--- a/net/ipv4/netfilter/ip_nat_rule.c
+++ b/net/ipv4/netfilter/ip_nat_rule.c
@@ -193,6 +193,10 @@ static int ipt_dnat_checkentry(const cha
 		printk("DNAT: multiple ranges no longer supported\n");
 		return 0;
 	}
+	if (mr->range[0].flags & IP_NAT_RANGE_PROTO_RANDOM) {
+		printk("DNAT: port randomization not supported\n");
+		return 0;
+	}
 	return 1;
 }
 
diff --git a/net/ipv4/netfilter/nf_nat_core.c b/net/ipv4/netfilter/nf_nat_core.c
index 86a9227..998b255 100644
--- a/net/ipv4/netfilter/nf_nat_core.c
+++ b/net/ipv4/netfilter/nf_nat_core.c
@@ -254,8 +254,9 @@ get_unique_tuple(struct nf_conntrack_tup
 	if (maniptype == IP_NAT_MANIP_SRC) {
 		if (find_appropriate_src(orig_tuple, tuple, range)) {
 			DEBUGP("get_unique_tuple: Found current src map\n");
-			if (!nf_nat_used_tuple(tuple, ct))
-				return;
+			if (!(range->flags & IP_NAT_RANGE_PROTO_RANDOM))
+				if (!nf_nat_used_tuple(tuple, ct))
+					return;
 		}
 	}
 
@@ -269,6 +270,13 @@ get_unique_tuple(struct nf_conntrack_tup
 
 	proto = nf_nat_proto_find_get(orig_tuple->dst.protonum);
 
+	/* Change protocol info to have some randomization */
+	if (range->flags & IP_NAT_RANGE_PROTO_RANDOM) {
+		proto->unique_tuple(tuple, range, maniptype, ct);
+		nf_nat_proto_put(proto);
+		return;
+	}
+
 	/* Only bother mapping if it's not already in range and unique */
 	if ((!(range->flags & IP_NAT_RANGE_PROTO_SPECIFIED) ||
 	     proto->in_range(tuple, maniptype, &range->min, &range->max)) &&
diff --git a/net/ipv4/netfilter/nf_nat_proto_tcp.c b/net/ipv4/netfilter/nf_nat_proto_tcp.c
index 7e26a7e..439164c 100644
--- a/net/ipv4/netfilter/nf_nat_proto_tcp.c
+++ b/net/ipv4/netfilter/nf_nat_proto_tcp.c
@@ -8,6 +8,7 @@
 
 #include <linux/types.h>
 #include <linux/init.h>
+#include <linux/random.h>
 #include <linux/ip.h>
 #include <linux/tcp.h>
 
@@ -75,6 +76,9 @@ tcp_unique_tuple(struct nf_conntrack_tup
 		range_size = ntohs(range->max.tcp.port) - min + 1;
 	}
 
+	if (range->flags & IP_NAT_RANGE_PROTO_RANDOM)
+		port =  net_random();
+
 	for (i = 0; i < range_size; i++, port++) {
 		*portptr = htons(min + port % range_size);
 		if (!nf_nat_used_tuple(tuple, ct))
diff --git a/net/ipv4/netfilter/nf_nat_proto_udp.c b/net/ipv4/netfilter/nf_nat_proto_udp.c
index ab0ce4c..8cae6e0 100644
--- a/net/ipv4/netfilter/nf_nat_proto_udp.c
+++ b/net/ipv4/netfilter/nf_nat_proto_udp.c
@@ -8,6 +8,7 @@
 
 #include <linux/types.h>
 #include <linux/init.h>
+#include <linux/random.h>
 #include <linux/ip.h>
 #include <linux/udp.h>
 
@@ -73,6 +74,9 @@ udp_unique_tuple(struct nf_conntrack_tup
 		range_size = ntohs(range->max.udp.port) - min + 1;
 	}
 
+	if (range->flags & IP_NAT_RANGE_PROTO_RANDOM)
+		port = net_random();
+
 	for (i = 0; i < range_size; i++, port++) {
 		*portptr = htons(min + port % range_size);
 		if (!nf_nat_used_tuple(tuple, ct))
diff --git a/net/ipv4/netfilter/nf_nat_rule.c b/net/ipv4/netfilter/nf_nat_rule.c
index b868ee0..3745efe 100644
--- a/net/ipv4/netfilter/nf_nat_rule.c
+++ b/net/ipv4/netfilter/nf_nat_rule.c
@@ -226,6 +226,10 @@ static int ipt_dnat_checkentry(const cha
 		printk("DNAT: multiple ranges no longer supported\n");
 		return 0;
 	}
+	if (mr->range[0].flags & IP_NAT_RANGE_PROTO_RANDOM) {
+		printk("DNAT: port randomization not supported\n");
+		return 0;
+	}
 	return 1;
 }
 
