From: Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 13/18] Netfilter:  Multiport revision with port ranges
	(replaces "mport")
Date: Wed, 05 Jan 2005 14:35:59 +1100
Message-ID: <1104896159.20582.79.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter development mailing list <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Linus Torvalds <torvalds@osdl.org>
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

Name: Multiport revision with port ranges (replaces "mport")
Status: Tested under nfsim
Signed-off-by: Pablo Neira Ayuso <pablo@eurodev.net>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au> (modified)

The multiport match doesn't support ranges of ports, so a new match
called "mport" was written.  Now we have versioning of matches and
targets, we can simply put this extension in multiport revision 1.

Also, removes gratuitous checking in match: we basically trust
iptables userspace these days.

===== net/ipv4/netfilter/ipt_multiport.c 1.8 vs edited =====
Index: linux-2.6.10-bk7-Netfilter/include/linux/netfilter_ipv4/ipt_multiport.h
===================================================================
--- linux-2.6.10-bk7-Netfilter.orig/include/linux/netfilter_ipv4/ipt_multiport.h	2005-01-05 12:59:28.122700808 +1100
+++ linux-2.6.10-bk7-Netfilter/include/linux/netfilter_ipv4/ipt_multiport.h	2005-01-05 13:02:41.176352192 +1100
@@ -18,4 +18,12 @@
 	u_int8_t count;				/* Number of ports */
 	u_int16_t ports[IPT_MULTI_PORTS];	/* Ports */
 };
+
+struct ipt_multiport_v1
+{
+	u_int8_t flags;				/* Type of comparison */
+	u_int8_t count;				/* Number of ports */
+	u_int16_t ports[IPT_MULTI_PORTS];	/* Ports */
+	u_int8_t pflags[IPT_MULTI_PORTS];	/* Port flags */
+};
 #endif /*_IPT_MULTIPORT_H*/
Index: linux-2.6.10-bk7-Netfilter/net/ipv4/netfilter/ipt_multiport.c
===================================================================
--- linux-2.6.10-bk7-Netfilter.orig/net/ipv4/netfilter/ipt_multiport.c	2005-01-05 12:59:28.121700960 +1100
+++ linux-2.6.10-bk7-Netfilter/net/ipv4/netfilter/ipt_multiport.c	2005-01-05 13:02:41.176352192 +1100
@@ -46,6 +46,50 @@
 	return 0;
 }
 
+/* Returns 1 if the port is matched by the test, 0 otherwise. */
+static inline int
+ports_match_v1(const struct ipt_multiport_v1 *minfo,
+	       u_int16_t src, u_int16_t dst)
+{
+	unsigned int i;
+	u_int16_t s, e;
+
+	for (i=0; i < minfo->count; i++) {
+		s = minfo->ports[i];
+
+		if (minfo->pflags[i]) {
+			/* range port matching */
+			e = minfo->ports[++i];
+			duprintf("src or dst matches with %d-%d?\n", s, e);
+
+			if (minfo->flags == IPT_MULTIPORT_SOURCE
+			    && src >= s && src <= e)
+				return 1;
+			if (minfo->flags == IPT_MULTIPORT_DESTINATION
+			    && dst >= s && dst <= e)
+				return 1;
+			if (minfo->flags == IPT_MULTIPORT_EITHER
+			    && ((dst >= s && dst <= e)
+				|| (src >= s && src <= e)))
+				return 1;
+		} else {
+			/* exact port matching */
+			duprintf("src or dst matches with %d?\n", s);
+			if (minfo->flags == IPT_MULTIPORT_SOURCE
+			    && src == s)
+				return 1;
+			if (minfo->flags == IPT_MULTIPORT_DESTINATION
+			    && dst == s)
+				return 1;
+			if (minfo->flags == IPT_MULTIPORT_EITHER
+			    && (src == s || dst == s))
+				return 1;
+		}
+	}
+ 
+ 	return 0;
+}
+
 static int
 match(const struct sk_buff *skb,
       const struct net_device *in,
@@ -57,14 +101,11 @@
 	u16 _ports[2], *pptr;
 	const struct ipt_multiport *multiinfo = matchinfo;
 
-	/* Must not be a fragment. */
 	if (offset)
 		return 0;
 
-	/* Must be big enough to read ports (both UDP and TCP have
-           them at the start). */
 	pptr = skb_header_pointer(skb, skb->nh.iph->ihl * 4,
-				  sizeof(_ports), &_ports[0]);
+				  sizeof(_ports), _ports);
 	if (pptr == NULL) {
 		/* We've been asked to examine this packet, and we
 		 * can't.  Hence, no choice but to drop.
@@ -80,6 +121,35 @@
 			   ntohs(pptr[0]), ntohs(pptr[1]));
 }
 
+static int
+match_v1(const struct sk_buff *skb,
+	 const struct net_device *in,
+	 const struct net_device *out,
+	 const void *matchinfo,
+	 int offset,
+	 int *hotdrop)
+{
+	u16 _ports[2], *pptr;
+	const struct ipt_multiport_v1 *multiinfo = matchinfo;
+
+	if (offset)
+		return 0;
+
+	pptr = skb_header_pointer(skb, skb->nh.iph->ihl * 4,
+				  sizeof(_ports), _ports);
+	if (pptr == NULL) {
+		/* We've been asked to examine this packet, and we
+		 * can't.  Hence, no choice but to drop.
+		 */
+		duprintf("ipt_multiport:"
+			 " Dropping evil offset=0 tinygram.\n");
+		*hotdrop = 1;
+		return 0;
+	}
+
+	return ports_match_v1(multiinfo, ntohs(pptr[0]), ntohs(pptr[1]));
+}
+
 /* Called when user tries to insert an entry of this type. */
 static int
 checkentry(const char *tablename,
@@ -88,36 +158,53 @@
 	   unsigned int matchsize,
 	   unsigned int hook_mask)
 {
-	const struct ipt_multiport *multiinfo = matchinfo;
-
-	if (matchsize != IPT_ALIGN(sizeof(struct ipt_multiport)))
-		return 0;
+	return (matchsize == IPT_ALIGN(sizeof(struct ipt_multiport)));
+}
 
-	/* Must specify proto == TCP/UDP, no unknown flags or bad count */
-	return (ip->proto == IPPROTO_TCP || ip->proto == IPPROTO_UDP)
-		&& !(ip->invflags & IPT_INV_PROTO)
-		&& matchsize == IPT_ALIGN(sizeof(struct ipt_multiport))
-		&& (multiinfo->flags == IPT_MULTIPORT_SOURCE
-		    || multiinfo->flags == IPT_MULTIPORT_DESTINATION
-		    || multiinfo->flags == IPT_MULTIPORT_EITHER)
-		&& multiinfo->count <= IPT_MULTI_PORTS;
+static int
+checkentry_v1(const char *tablename,
+	      const struct ipt_ip *ip,
+	      void *matchinfo,
+	      unsigned int matchsize,
+	      unsigned int hook_mask)
+{
+	return (matchsize == IPT_ALIGN(sizeof(struct ipt_multiport_v1)));
 }
 
 static struct ipt_match multiport_match = {
 	.name		= "multiport",
+	.revision	= 0,
 	.match		= &match,
 	.checkentry	= &checkentry,
 	.me		= THIS_MODULE,
 };
 
+static struct ipt_match multiport_match_v1 = {
+	.name		= "multiport",
+	.revision	= 1,
+	.match		= &match_v1,
+	.checkentry	= &checkentry_v1,
+	.me		= THIS_MODULE,
+};
+
 static int __init init(void)
 {
-	return ipt_register_match(&multiport_match);
+	int err;
+
+	err = ipt_register_match(&multiport_match);
+	if (!err) {
+		err = ipt_register_match(&multiport_match_v1);
+		if (err)
+			ipt_unregister_match(&multiport_match);
+	}
+
+	return err;
 }
 
 static void __exit fini(void)
 {
 	ipt_unregister_match(&multiport_match);
+	ipt_unregister_match(&multiport_match_v1);
 }
 
 module_init(init);
