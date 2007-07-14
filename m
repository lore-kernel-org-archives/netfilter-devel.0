From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 07/08]: nf_conntrack: mark protocols __read_mostly
Date: Sat, 14 Jul 2007 17:12:43 +0200 (MEST)
Message-ID: <20070714151159.9829.27848.sendpatchset@localhost.localdomain>
References: <20070714151150.9829.47674.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070714151150.9829.47674.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nf_conntrack: mark protocols __read_mostly

Also remove two unnecessary EXPORT_SYMBOLs and move the
nf_conntrack_l3proto_ipv4 declaration to the correct file.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 48b2bed5b1229eb77b3df402e70c9c7e8360212d
tree 12da18400ae69862c1c31ad6d84cf847a781b2c1
parent ce0ae6ad80f3673eaaa2fb1cab9771939c7e84c6
author Patrick McHardy <kaber@trash.net> Sat, 14 Jul 2007 17:02:30 +0200
committer Patrick McHardy <kaber@trash.net> Sat, 14 Jul 2007 17:05:35 +0200

 include/net/netfilter/ipv4/nf_conntrack_ipv4.h |    2 ++
 include/net/netfilter/nf_conntrack_l3proto.h   |    2 --
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c |    2 +-
 net/ipv4/netfilter/nf_conntrack_proto_icmp.c   |    3 +--
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c |    2 +-
 net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c |    4 +---
 net/netfilter/nf_conntrack_l3proto_generic.c   |    2 +-
 net/netfilter/nf_conntrack_proto_generic.c     |    2 +-
 net/netfilter/nf_conntrack_proto_gre.c         |    2 +-
 net/netfilter/nf_conntrack_proto_sctp.c        |    4 ++--
 net/netfilter/nf_conntrack_proto_tcp.c         |    4 ++--
 net/netfilter/nf_conntrack_proto_udp.c         |    4 ++--
 12 files changed, 15 insertions(+), 18 deletions(-)

diff --git a/include/net/netfilter/ipv4/nf_conntrack_ipv4.h b/include/net/netfilter/ipv4/nf_conntrack_ipv4.h
index 3ed4e14..7a67160 100644
--- a/include/net/netfilter/ipv4/nf_conntrack_ipv4.h
+++ b/include/net/netfilter/ipv4/nf_conntrack_ipv4.h
@@ -12,6 +12,8 @@
 /* Returns new sk_buff, or NULL */
 struct sk_buff *nf_ct_ipv4_ct_gather_frags(struct sk_buff *skb);
 
+extern struct nf_conntrack_l3proto nf_conntrack_l3proto_ipv4;
+
 extern struct nf_conntrack_l4proto nf_conntrack_l4proto_tcp4;
 extern struct nf_conntrack_l4proto nf_conntrack_l4proto_udp4;
 extern struct nf_conntrack_l4proto nf_conntrack_l4proto_icmp;
diff --git a/include/net/netfilter/nf_conntrack_l3proto.h b/include/net/netfilter/nf_conntrack_l3proto.h
index e3708a6..3c58a2c 100644
--- a/include/net/netfilter/nf_conntrack_l3proto.h
+++ b/include/net/netfilter/nf_conntrack_l3proto.h
@@ -89,8 +89,6 @@ extern struct nf_conntrack_l3proto *nf_ct_l3proto_find_get(u_int16_t l3proto);
 extern void nf_ct_l3proto_put(struct nf_conntrack_l3proto *p);
 
 /* Existing built-in protocols */
-extern struct nf_conntrack_l3proto nf_conntrack_l3proto_ipv4;
-extern struct nf_conntrack_l3proto nf_conntrack_l3proto_ipv6;
 extern struct nf_conntrack_l3proto nf_conntrack_l3proto_generic;
 
 static inline struct nf_conntrack_l3proto *
diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
index ee29f4e..64552af 100644
--- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
+++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
@@ -405,7 +405,7 @@ static struct nf_sockopt_ops so_getorigdst = {
 	.get		= &getorigdst,
 };
 
-struct nf_conntrack_l3proto nf_conntrack_l3proto_ipv4 = {
+struct nf_conntrack_l3proto nf_conntrack_l3proto_ipv4 __read_mostly = {
 	.l3proto	 = PF_INET,
 	.name		 = "ipv4",
 	.pkt_to_tuple	 = ipv4_pkt_to_tuple,
diff --git a/net/ipv4/netfilter/nf_conntrack_proto_icmp.c b/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
index f965733..6593fd2 100644
--- a/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
+++ b/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
@@ -312,7 +312,7 @@ static struct ctl_table icmp_compat_sysctl_table[] = {
 #endif /* CONFIG_NF_CONNTRACK_PROC_COMPAT */
 #endif /* CONFIG_SYSCTL */
 
-struct nf_conntrack_l4proto nf_conntrack_l4proto_icmp =
+struct nf_conntrack_l4proto nf_conntrack_l4proto_icmp __read_mostly =
 {
 	.l3proto		= PF_INET,
 	.l4proto		= IPPROTO_ICMP,
@@ -338,4 +338,3 @@ struct nf_conntrack_l4proto nf_conntrack_l4proto_icmp =
 #endif
 #endif
 };
-EXPORT_SYMBOL_GPL(nf_conntrack_l4proto_icmp);
diff --git a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
index 9b7eaaa..36df221 100644
--- a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
+++ b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
@@ -373,7 +373,7 @@ static int ipv6_nfattr_to_tuple(struct nfattr *tb[],
 }
 #endif
 
-struct nf_conntrack_l3proto nf_conntrack_l3proto_ipv6 = {
+struct nf_conntrack_l3proto nf_conntrack_l3proto_ipv6 __read_mostly = {
 	.l3proto		= PF_INET6,
 	.name			= "ipv6",
 	.pkt_to_tuple		= ipv6_pkt_to_tuple,
diff --git a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c b/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
index 0fca7e8..ab154fb 100644
--- a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
+++ b/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
@@ -276,7 +276,7 @@ static struct ctl_table icmpv6_sysctl_table[] = {
 };
 #endif /* CONFIG_SYSCTL */
 
-struct nf_conntrack_l4proto nf_conntrack_l4proto_icmpv6 =
+struct nf_conntrack_l4proto nf_conntrack_l4proto_icmpv6 __read_mostly =
 {
 	.l3proto		= PF_INET6,
 	.l4proto		= IPPROTO_ICMPV6,
@@ -297,5 +297,3 @@ struct nf_conntrack_l4proto nf_conntrack_l4proto_icmpv6 =
 	.ctl_table		= icmpv6_sysctl_table,
 #endif
 };
-
-EXPORT_SYMBOL(nf_conntrack_l4proto_icmpv6);
diff --git a/net/netfilter/nf_conntrack_l3proto_generic.c b/net/netfilter/nf_conntrack_l3proto_generic.c
index 0691642..991c52c 100644
--- a/net/netfilter/nf_conntrack_l3proto_generic.c
+++ b/net/netfilter/nf_conntrack_l3proto_generic.c
@@ -69,7 +69,7 @@ static int generic_get_l4proto(const struct sk_buff *skb, unsigned int nhoff,
 }
 
 
-struct nf_conntrack_l3proto nf_conntrack_l3proto_generic = {
+struct nf_conntrack_l3proto nf_conntrack_l3proto_generic __read_mostly = {
 	.l3proto	 = PF_UNSPEC,
 	.name		 = "unknown",
 	.pkt_to_tuple	 = generic_pkt_to_tuple,
diff --git a/net/netfilter/nf_conntrack_proto_generic.c b/net/netfilter/nf_conntrack_proto_generic.c
index 6faf1be..d8b5018 100644
--- a/net/netfilter/nf_conntrack_proto_generic.c
+++ b/net/netfilter/nf_conntrack_proto_generic.c
@@ -98,7 +98,7 @@ static struct ctl_table generic_compat_sysctl_table[] = {
 #endif /* CONFIG_NF_CONNTRACK_PROC_COMPAT */
 #endif /* CONFIG_SYSCTL */
 
-struct nf_conntrack_l4proto nf_conntrack_l4proto_generic =
+struct nf_conntrack_l4proto nf_conntrack_l4proto_generic __read_mostly =
 {
 	.l3proto		= PF_UNSPEC,
 	.l4proto		= 0,
diff --git a/net/netfilter/nf_conntrack_proto_gre.c b/net/netfilter/nf_conntrack_proto_gre.c
index 771c4c2..bdbead8 100644
--- a/net/netfilter/nf_conntrack_proto_gre.c
+++ b/net/netfilter/nf_conntrack_proto_gre.c
@@ -261,7 +261,7 @@ static void gre_destroy(struct nf_conn *ct)
 }
 
 /* protocol helper struct */
-static struct nf_conntrack_l4proto nf_conntrack_l4proto_gre4 = {
+static struct nf_conntrack_l4proto nf_conntrack_l4proto_gre4 __read_mostly = {
 	.l3proto	 = AF_INET,
 	.l4proto	 = IPPROTO_GRE,
 	.name		 = "gre",
diff --git a/net/netfilter/nf_conntrack_proto_sctp.c b/net/netfilter/nf_conntrack_proto_sctp.c
index debfe61..04192ac 100644
--- a/net/netfilter/nf_conntrack_proto_sctp.c
+++ b/net/netfilter/nf_conntrack_proto_sctp.c
@@ -601,7 +601,7 @@ static struct ctl_table sctp_compat_sysctl_table[] = {
 #endif /* CONFIG_NF_CONNTRACK_PROC_COMPAT */
 #endif
 
-struct nf_conntrack_l4proto nf_conntrack_l4proto_sctp4 = {
+static struct nf_conntrack_l4proto nf_conntrack_l4proto_sctp4 __read_mostly = {
 	.l3proto		= PF_INET,
 	.l4proto 		= IPPROTO_SCTP,
 	.name 			= "sctp",
@@ -622,7 +622,7 @@ struct nf_conntrack_l4proto nf_conntrack_l4proto_sctp4 = {
 #endif
 };
 
-struct nf_conntrack_l4proto nf_conntrack_l4proto_sctp6 = {
+static struct nf_conntrack_l4proto nf_conntrack_l4proto_sctp6 __read_mostly = {
 	.l3proto		= PF_INET6,
 	.l4proto 		= IPPROTO_SCTP,
 	.name 			= "sctp",
diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index 1c8206e..87ad3cc 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -1372,7 +1372,7 @@ static struct ctl_table tcp_compat_sysctl_table[] = {
 #endif /* CONFIG_NF_CONNTRACK_PROC_COMPAT */
 #endif /* CONFIG_SYSCTL */
 
-struct nf_conntrack_l4proto nf_conntrack_l4proto_tcp4 =
+struct nf_conntrack_l4proto nf_conntrack_l4proto_tcp4 __read_mostly =
 {
 	.l3proto		= PF_INET,
 	.l4proto 		= IPPROTO_TCP,
@@ -1401,7 +1401,7 @@ struct nf_conntrack_l4proto nf_conntrack_l4proto_tcp4 =
 };
 EXPORT_SYMBOL_GPL(nf_conntrack_l4proto_tcp4);
 
-struct nf_conntrack_l4proto nf_conntrack_l4proto_tcp6 =
+struct nf_conntrack_l4proto nf_conntrack_l4proto_tcp6 __read_mostly =
 {
 	.l3proto		= PF_INET6,
 	.l4proto 		= IPPROTO_TCP,
diff --git a/net/netfilter/nf_conntrack_proto_udp.c b/net/netfilter/nf_conntrack_proto_udp.c
index 3620ecc..13d94a0 100644
--- a/net/netfilter/nf_conntrack_proto_udp.c
+++ b/net/netfilter/nf_conntrack_proto_udp.c
@@ -191,7 +191,7 @@ static struct ctl_table udp_compat_sysctl_table[] = {
 #endif /* CONFIG_NF_CONNTRACK_PROC_COMPAT */
 #endif /* CONFIG_SYSCTL */
 
-struct nf_conntrack_l4proto nf_conntrack_l4proto_udp4 =
+struct nf_conntrack_l4proto nf_conntrack_l4proto_udp4 __read_mostly =
 {
 	.l3proto		= PF_INET,
 	.l4proto		= IPPROTO_UDP,
@@ -218,7 +218,7 @@ struct nf_conntrack_l4proto nf_conntrack_l4proto_udp4 =
 };
 EXPORT_SYMBOL_GPL(nf_conntrack_l4proto_udp4);
 
-struct nf_conntrack_l4proto nf_conntrack_l4proto_udp6 =
+struct nf_conntrack_l4proto nf_conntrack_l4proto_udp6 __read_mostly =
 {
 	.l3proto		= PF_INET6,
 	.l4proto		= IPPROTO_UDP,
