From: Kovacs Krisztian <hidden@balabit.hu>
Subject: NAT && TIME_WAIT TCP connections
Date: Mon, 29 Sep 2003 14:20:43 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3F78239B.7000406@balabit.hu>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000604040908020702070908"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Devel <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------000604040908020702070908
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit


   Hi,

   I have a proposal regarding connection tracking and NAT. Imagine a 
scenario, where you must SNAT TCP traffic not only to a specific IP range, 
but also to a specific port range. The extreme case of the scenario is of 
course one IP with only one port, for example:

iptables -t nat -A POSTROUTING -s 10.1.0.0/16 -p tcp -j SNAT \
	--to-source 0.2.0.1:1234

   However, such a setup maximizes the number of connections to which NAT 
can be applied, and you must wait for the existing connections to get 
deleted (timeout, etc.) before another connection can be created. However, 
in case of TCP, when the SNAT range is a scarce resource, IP:port pairs 
could be reused for connections where the connection is already in a 
'half-died' state (for example, TCP's TIME_WAIT). The theory of operation 
is the following: a protocol helper marks the conntrack entry 
MAY_BE_DELETED if it thinks that it's in a state where new packages cannot 
be received. Then, if ip_nat_setup_info() finds that while trying to 
allocate a new IP/port pair from the given range, a clashing conntrack 
entry has this flag, it deletes the old one, so the allocation can succeed.

   While the upper example may look a bit extreme, such problems occur 
much more often when using the TPROXY patch and a transparent SQUID proxy. 
The attached patch helped a lot in these cases (and after modifying 
ip_conntrack_proto_tcp.c accordingly, to mark TPROXY-ed TCP connections 
'deletable' when they reach the TIME_WAIT state).

   Any comments? (I don't like the idea of deleting conntrack entries in 
ip_nat_setup_info(), however, I don't have a better idea.)

-- 
   Regards,
     Krisztian KOVACS

--------------000604040908020702070908
Content-Type: text/plain;
 name="nat-delete-conntrack.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="nat-delete-conntrack.diff"

diff -urN linux-2.4.22-orig/include/linux/netfilter_ipv4/ip_conntrack.h linux-2.4.22/include/linux/netfilter_ipv4/ip_conntrack.h
--- linux-2.4.22-orig/include/linux/netfilter_ipv4/ip_conntrack.h	Fri Jun 13 16:51:38 2003
+++ linux-2.4.22/include/linux/netfilter_ipv4/ip_conntrack.h	Mon Sep 29 11:43:55 2003
@@ -46,6 +46,10 @@
 	/* Connection is confirmed: originating packet has left box */
 	IPS_CONFIRMED_BIT = 3,
 	IPS_CONFIRMED = (1 << IPS_CONFIRMED_BIT),
+
+ 	/* May delete conntrack if its tuple is needed for NAT */
+ 	IPS_MAY_DELETE_BIT = 5,
+ 	IPS_MAY_DELETE = (1 << IPS_MAY_DELETE_BIT),
 };
 
 #include <linux/netfilter_ipv4/ip_conntrack_tcp.h>
@@ -219,7 +223,7 @@
 
 /* Is this tuple taken? (ignoring any belonging to the given
    conntrack). */
-extern int
+extern struct ip_conntrack_tuple_hash *
 ip_conntrack_tuple_taken(const struct ip_conntrack_tuple *tuple,
 			 const struct ip_conntrack *ignored_conntrack);
 
diff -urN linux-2.4.22-orig/net/ipv4/netfilter/ip_conntrack_core.c linux-2.4.22/net/ipv4/netfilter/ip_conntrack_core.c
--- linux-2.4.22-orig/net/ipv4/netfilter/ip_conntrack_core.c	Mon Aug 25 13:44:44 2003
+++ linux-2.4.22/net/ipv4/netfilter/ip_conntrack_core.c	Mon Sep 29 11:43:00 2003
@@ -479,7 +479,7 @@
 
 /* Returns true if a connection correspondings to the tuple (required
    for NAT). */
-int
+struct ip_conntrack_tuple_hash *
 ip_conntrack_tuple_taken(const struct ip_conntrack_tuple *tuple,
 			 const struct ip_conntrack *ignored_conntrack)
 {
@@ -489,7 +489,7 @@
 	h = __ip_conntrack_find(tuple, ignored_conntrack);
 	READ_UNLOCK(&ip_conntrack_lock);
 
-	return h != NULL;
+	return h;
 }
 
 /* Returns conntrack if it dealt with ICMP, and filled in skb fields */
diff -urN linux-2.4.22-orig/net/ipv4/netfilter/ip_nat_core.c linux-2.4.22/net/ipv4/netfilter/ip_nat_core.c
--- linux-2.4.22-orig/net/ipv4/netfilter/ip_nat_core.c	Mon Aug 25 13:44:44 2003
+++ linux-2.4.22/net/ipv4/netfilter/ip_nat_core.c	Mon Sep 29 11:53:53 2003
@@ -92,6 +92,35 @@
 	WRITE_UNLOCK(&ip_nat_lock);
 }
 
+static void __ip_nat_cleanup_conntrack(struct ip_conntrack *conn)
+{
+	struct ip_nat_info *info = &conn->nat.info;
+	
+	if (!info->initialized)
+		return;
+
+	IP_NF_ASSERT(info->bysource.conntrack);
+	IP_NF_ASSERT(info->byipsproto.conntrack);
+
+	MUST_BE_WRITE_LOCKED(&ip_nat_lock);
+
+	LIST_DELETE(&bysource[hash_by_src(&conn->tuplehash[IP_CT_DIR_ORIGINAL]
+					  .tuple.src,
+					  conn->tuplehash[IP_CT_DIR_ORIGINAL]
+					  .tuple.dst.protonum)],
+		    &info->bysource);
+
+	LIST_DELETE(&byipsproto
+		    [hash_by_ipsproto(conn->tuplehash[IP_CT_DIR_REPLY]
+				      .tuple.src.ip,
+				      conn->tuplehash[IP_CT_DIR_REPLY]
+				      .tuple.dst.ip,
+				      conn->tuplehash[IP_CT_DIR_REPLY]
+				      .tuple.dst.protonum)],
+		    &info->byipsproto);
+}
+
+
 /* We do checksum mangling, so if they were wrong before they're still
  * wrong.  Also works for incomplete packets (eg. ICMP dest
  * unreachables.) */
@@ -131,9 +160,21 @@
 
 	   We could keep a separate hash if this proves too slow. */
 	struct ip_conntrack_tuple reply;
+	struct ip_conntrack_tuple_hash *h;
 
 	invert_tuplepr(&reply, tuple);
-	return ip_conntrack_tuple_taken(&reply, ignored_conntrack);
+	h = ip_conntrack_tuple_taken(&reply, ignored_conntrack);
+
+	if ((h != NULL) && test_bit(IPS_MAY_DELETE_BIT, &h->ctrack->status)) {
+		DEBUGP(KERN_DEBUG "Deleting old conntrack entry for NAT\n");
+		__ip_nat_cleanup_conntrack(h->ctrack);
+		h->ctrack->nat.info.initialized = 0;
+		if (del_timer(&h->ctrack->timeout))
+			h->ctrack->timeout.function((unsigned long)h->ctrack);
+		h = NULL;
+	}
+	
+	return h != NULL;
 }
 
 /* Does tuple + the source manip come within the range mr */

--------------000604040908020702070908--
