From: KOVACS Krisztian <hidden@balabit.hu>
Subject: static portptr pointer in tcp/udp_unique_tuple
Date: Mon, 01 Mar 2004 17:33:52 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1078158831.676.78.camel@nienna.balabit>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-P1t6cfTL/pFgXeCC8Lml"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--=-P1t6cfTL/pFgXeCC8Lml
Content-Type: text/plain
Content-Transfer-Encoding: 7bit


  Hi,

  I think I've found two possible problems in the current Netfilter NAT
code. In ip_nat_proto_udp.c the start of udp_unique_tuple() looks like
this:

- 8< -
static int
udp_unique_tuple(struct ip_conntrack_tuple *tuple,
		 const struct ip_nat_range *range,
		 enum ip_nat_manip_type maniptype,
		 const struct ip_conntrack *conntrack)
{
	static u_int16_t port, *portptr;
	unsigned int range_size, min, i;
- 8< -

  This declares the portptr pointer as static, which I think is a
mistake, as portptr is initialized right at the beginning at the
function to the tuple's source/destination port. The same goes for
ip_nat_proto_tcp.c.

  It would mean a serious race condition if two of these functions were
running at the same time, thus corrupting each others' portptr pointers.
Luckily this won't happen, since proto->unique_tuple() is called only
with ip_nat_lock held for write.

  The attached patch fixes the problem, anyway.

-- 
 Regards,
   Krisztian KOVACS

--=-P1t6cfTL/pFgXeCC8Lml
Content-Disposition: attachment; filename=nat_proto_portptr_24.diff
Content-Type: text/x-patch; name=nat_proto_portptr_24.diff; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit

Index: linux-2.4.25/net/ipv4/netfilter/ip_nat_proto_tcp.c
===================================================================
--- linux-2.4.25.orig/net/ipv4/netfilter/ip_nat_proto_tcp.c	Mon Mar  1 16:49:47 2004
+++ linux-2.4.25/net/ipv4/netfilter/ip_nat_proto_tcp.c	Mon Mar  1 17:24:05 2004
@@ -31,7 +31,8 @@
 		 enum ip_nat_manip_type maniptype,
 		 const struct ip_conntrack *conntrack)
 {
-	static u_int16_t port = 0, *portptr;
+	static u_int16_t port = 0;
+	u_int16_t *portptr;
 	unsigned int range_size, min, i;
 
 	if (maniptype == IP_NAT_MANIP_SRC)
Index: linux-2.4.25/net/ipv4/netfilter/ip_nat_proto_udp.c
===================================================================
--- linux-2.4.25.orig/net/ipv4/netfilter/ip_nat_proto_udp.c	Mon Mar  1 16:49:47 2004
+++ linux-2.4.25/net/ipv4/netfilter/ip_nat_proto_udp.c	Mon Mar  1 17:23:47 2004
@@ -32,7 +32,8 @@
 		 enum ip_nat_manip_type maniptype,
 		 const struct ip_conntrack *conntrack)
 {
-	static u_int16_t port = 0, *portptr;
+	static u_int16_t port = 0;
+	u_int16_t *portptr;
 	unsigned int range_size, min, i;
 
 	if (maniptype == IP_NAT_MANIP_SRC)

--=-P1t6cfTL/pFgXeCC8Lml
Content-Disposition: attachment; filename=nat_proto_portptr_26.diff
Content-Type: text/x-patch; name=nat_proto_portptr_26.diff; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit

Index: linux-2.6.3/net/ipv4/netfilter/ip_nat_proto_tcp.c
===================================================================
--- linux-2.6.3.orig/net/ipv4/netfilter/ip_nat_proto_tcp.c	Thu Feb 19 13:17:37 2004
+++ linux-2.6.3/net/ipv4/netfilter/ip_nat_proto_tcp.c	Mon Mar  1 17:29:42 2004
@@ -40,7 +40,8 @@
 		 enum ip_nat_manip_type maniptype,
 		 const struct ip_conntrack *conntrack)
 {
-	static u_int16_t port, *portptr;
+	static u_int16_t port;
+	u_int16_t *portptr;
 	unsigned int range_size, min, i;
 
 	if (maniptype == IP_NAT_MANIP_SRC)
Index: linux-2.6.3/net/ipv4/netfilter/ip_nat_proto_udp.c
===================================================================
--- linux-2.6.3.orig/net/ipv4/netfilter/ip_nat_proto_udp.c	Thu Feb 19 13:17:37 2004
+++ linux-2.6.3/net/ipv4/netfilter/ip_nat_proto_udp.c	Mon Mar  1 17:29:29 2004
@@ -41,7 +41,8 @@
 		 enum ip_nat_manip_type maniptype,
 		 const struct ip_conntrack *conntrack)
 {
-	static u_int16_t port, *portptr;
+	static u_int16_t port;
+	u_int16_t *portptr;
 	unsigned int range_size, min, i;
 
 	if (maniptype == IP_NAT_MANIP_SRC)

--=-P1t6cfTL/pFgXeCC8Lml--
