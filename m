From: Patrick McHardy <kaber@trash.net>
Subject: Re: Bug (?) in ipt_reject doesn't follow policy routing (2.4.x)
Date: Wed, 16 Apr 2003 02:20:00 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3E9CA1B0.4010507@trash.net>
References: <Pine.LNX.4.21.0304141317090.763-100000@debian.besselink> <3E9B2398.8020109@trash.net> <20030415074049.GX6866@sunbeam.de.gnumonks.org> <3E9C142C.5010909@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000806030803080601080308"
Cc: leen@wirehub.nl,  netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <3E9C142C.5010909@trash.net>
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
--------------000806030803080601080308
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

This is a once-again-updated patch, i discovered two memory leaks,
one introduced by my patch and one from asym. routing fix. Both
are fixed in this version.

Bye,
Patrick


--------------000806030803080601080308
Content-Type: text/plain;
 name="ipt_REJECT-route.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ipt_REJECT-route.diff"

diff -Nru a/net/ipv4/netfilter/ipt_REJECT.c b/net/ipv4/netfilter/ipt_REJECT.c
--- a/net/ipv4/netfilter/ipt_REJECT.c	Wed Apr 16 02:14:52 2003
+++ b/net/ipv4/netfilter/ipt_REJECT.c	Wed Apr 16 02:14:52 2003
@@ -11,7 +11,6 @@
 #include <net/icmp.h>
 #include <net/ip.h>
 #include <net/tcp.h>
-struct in_device;
 #include <net/route.h>
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv4/ipt_REJECT.h>
@@ -40,6 +39,7 @@
 	struct sk_buff *nskb;
 	struct tcphdr *otcph, *tcph;
 	struct rtable *rt;
+	struct dst_entry *odst;
 	unsigned int otcplen;
 	u_int16_t tmp_port;
 	u_int32_t tmp_addr;
@@ -64,12 +64,30 @@
 			 csum_partial((char *)otcph, otcplen, 0)) != 0)
 		return;
 
-	/* Routing: if not headed for us, route won't like source */
-	if (ip_route_output(&rt, oldskb->nh.iph->daddr,
-			    local ? oldskb->nh.iph->saddr : 0,
-			    RT_TOS(oldskb->nh.iph->tos) | RTO_CONN,
-			    0) != 0)
-		return;
+	if (local) {
+		if (ip_route_output(&rt, oldskb->nh.iph->saddr,
+		                    oldskb->nh.iph->daddr,
+				    RT_TOS(oldskb->nh.iph->tos), 0) != 0)
+			return;
+	} else {
+		/* non-local source - we use ip_route_input to respect policy
+		 * routing rules. the call to ip_route_output is necessary to
+		 * get a valid interface where the source ip may have come from.
+		 */ 
+		if (ip_route_output(&rt, oldskb->nh.iph->daddr, 0, 0, 0) != 0)
+			return;
+		odst = oldskb->dst;
+		if (ip_route_input(oldskb, oldskb->nh.iph->saddr,
+		                   oldskb->nh.iph->daddr,
+				   RT_TOS(oldskb->nh.iph->tos),
+				   rt->u.dst.dev) != 0) {
+			dst_release(&rt->u.dst);
+			return;
+		}
+		dst_release(&rt->u.dst);
+		rt = (struct rtable *)oldskb->dst;
+		oldskb->dst = odst;
+	}
 
 	hh_len = (rt->u.dst.dev->hard_header_len + 15)&~15;
 
@@ -80,8 +98,10 @@
 	   hh_len of incoming interface < hh_len of outgoing interface */
 	nskb = skb_copy_expand(oldskb, hh_len, skb_tailroom(oldskb),
 			       GFP_ATOMIC);
-	if (!nskb)
+	if (!nskb) {
+		dst_release(&rt->u.dst);
 		return;
+	}
 
 	dst_release(nskb->dst);
 	nskb->dst = &rt->u.dst;

--------------000806030803080601080308--
