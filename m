From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2.6 12/19]: Enable ip6t_multiport.c to work without
	skb_linearize()
Date: Mon, 25 Oct 2004 02:49:45 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <417C4DA9.3090901@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------040701020008080505030004"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@redhat.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------040701020008080505030004
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Convert ip6t_multiport to skb_header_pointer.



--------------040701020008080505030004
Content-Type: text/x-patch;
 name="12.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="12.diff"

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2004/10/20 21:33:37+02:00 yasuyuki.kozakai@toshiba.co.jp 
#   [NETFILTER]: Enable ip6t_multiport.c to work without skb_linearize()
#   
#   Signed-off-by: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv6/netfilter/ip6t_multiport.c
#   2004/10/20 21:33:00+02:00 yasuyuki.kozakai@toshiba.co.jp +18 -13
#   [NETFILTER]: Enable ip6t_multiport.c to work without skb_linearize()
#   
#   Signed-off-by: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
diff -Nru a/net/ipv6/netfilter/ip6t_multiport.c b/net/ipv6/netfilter/ip6t_multiport.c
--- a/net/ipv6/netfilter/ip6t_multiport.c	2004-10-22 03:41:35 +02:00
+++ b/net/ipv6/netfilter/ip6t_multiport.c	2004-10-22 03:41:35 +02:00
@@ -56,24 +56,29 @@
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

--------------040701020008080505030004--
