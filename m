From: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH] bug fixes and introducing skb_header_pointer() to
 ip6t_multiport.c
Date: Thu, 07 Oct 2004 12:47:07 +0900 (JST)
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <200410070347.i973l9ki009839@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Thu_Oct__7_12:47:08_2004_735)--"
Content-Transfer-Encoding: 7bit
Cc: usagi-core@linux-ipv6.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

----Next_Part(Thu_Oct__7_12:47:08_2004_735)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit


Hi,

The first patch fixes following bugs in ip6t_multiport.c,

	- missing check the size of the preference data.
	- IP6T_INV_PROTO should check with not ip->flags but ip->invflags.

And the second patch enables ip6t_multiport.c to work without skb_linearize().

Before trying these patches, don't forget to apply the patch which prepare
to removing skb_linearize().

https://lists.netfilter.org/pipermail/netfilter-devel/2004-October/017028.html

Regards,

-----------------------------------------------------------------
Yasuyuki KOZAKAI @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>



----Next_Part(Thu_Oct__7_12:47:08_2004_735)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="multiport-fix.patch"

--- linux-2.6.9-rc3-nolin/net/ipv6/netfilter/ip6t_multiport.c	2004-09-30 19:36:23.000000000 +0900
+++ linux-2.6.9-rc3-nolin-extfix/net/ipv6/netfilter/ip6t_multiport.c	2004-10-06 09:44:30.000000000 +0900
@@ -86,9 +86,12 @@ checkentry(const char *tablename,
 {
 	const struct ip6t_multiport *multiinfo = matchinfo;
 
+	if (matchsize != IP6T_ALIGN(sizeof(struct ip6t_multiport)))
+		return 0;
+
 	/* Must specify proto == TCP/UDP, no unknown flags or bad count */
 	return (ip->proto == IPPROTO_TCP || ip->proto == IPPROTO_UDP)
-		&& !(ip->flags & IP6T_INV_PROTO)
+		&& !(ip->invflags & IP6T_INV_PROTO)
 		&& matchsize == IP6T_ALIGN(sizeof(struct ip6t_multiport))
 		&& (multiinfo->flags == IP6T_MULTIPORT_SOURCE
 		    || multiinfo->flags == IP6T_MULTIPORT_DESTINATION

----Next_Part(Thu_Oct__7_12:47:08_2004_735)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="multiport-nolin.patch"

--- linux-2.6.9-rc3-nolin-extfix/net/ipv6/netfilter/ip6t_multiport.c	2004-10-06 09:44:30.000000000 +0900
+++ linux-2.6.9-rc3-nolin-ext/net/ipv6/netfilter/ip6t_multiport.c	2004-10-06 09:36:40.000000000 +0900
@@ -56,24 +56,29 @@ match(const struct sk_buff *skb,
       unsigned int protoff,
       int *hotdrop)
 {
-	const struct udphdr *udp = (const struct udphdr *)(skb->data + protoff);
+	u16 _ports[2], *pptr;
 	const struct ip6t_multiport *multiinfo = matchinfo;
 
-	/* Must be big enough to read ports. */
-	if (offset == 0 && skb->len - protoff < sizeof(struct udphdr)) {
+	/* Must not be a fragment. */
+	if (offset)
+		return 0;
+
+	/* Must be big enough to read ports (both UDP and TCP have
+	   them at the start). */
+	pptr = skb_header_pointer(skb, protoff, sizeof(_ports), &_ports[0]);
+	if (pptr == NULL) {
 		/* We've been asked to examine this packet, and we
-		   can't.  Hence, no choice but to drop. */
-			duprintf("ip6t_multiport:"
-				 " Dropping evil offset=0 tinygram.\n");
-			*hotdrop = 1;
-			return 0;
+		 * can't.  Hence, no choice but to drop.
+		 */
+		duprintf("ip6t_multiport:"
+			 " Dropping evil offset=0 tinygram.\n");
+		*hotdrop = 1;
+		return 0;
 	}
 
-	/* Must not be a fragment. */
-	return !offset
-		&& ports_match(multiinfo->ports,
-			       multiinfo->flags, multiinfo->count,
-			       ntohs(udp->source), ntohs(udp->dest));
+	return ports_match(multiinfo->ports,
+			   multiinfo->flags, multiinfo->count,
+			   ntohs(pptr[0]), ntohs(pptr[1]));
 }
 
 /* Called when user tries to insert an entry of this type. */

----Next_Part(Thu_Oct__7_12:47:08_2004_735)----
