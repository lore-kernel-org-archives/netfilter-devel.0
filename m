From: Patrick McHardy <kaber@trash.net>
Subject: Re: Bug (?) in ipt_reject doesn't follow policy routing (2.4.x)
Date: Tue, 15 Apr 2003 16:16:12 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3E9C142C.5010909@trash.net>
References: <Pine.LNX.4.21.0304141317090.763-100000@debian.besselink> <3E9B2398.8020109@trash.net> <20030415074049.GX6866@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040302060809050109000608"
Cc: leen@wirehub.nl,  netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20030415074049.GX6866@sunbeam.de.gnumonks.org>
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
--------------040302060809050109000608
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hi Harald,
this is an updated version, description follows below.
If davem gives his blessing i will make a patch for MIRROR as well.

Harald Welte wrote:

>We should talk to David Miller about this issue.  Could you please write
>a short summary like 'old behaviour was X and we had Problem Y with it,
>now we try to fix it with this patch doing Z'?  I would then put the
>patch together with this summary (as .help file) in patch-o-matic
>pending and discuss it with davem.
>

Ok here it goes:

ipt_REJECT uses saddr=0 for lookups with ip_route_output for non-local ips,
therefore routing rules like "from a.b.c.d/x" don't apply for tcp-resets 
generated
by ipt_REJECT.

This patch makes reject call ip_route_output to find an interface where 
the source
ip may have come from (for reverse-path filters) and then call 
ip_route_input with
the source/dest address of the tcp-reset. It also fixes a bug introduced 
by last fix
for asym. routing, source and dest were switched so ip_route_output 
returned a
route in the wrong direction.

Best regards,
Patrick


--------------040302060809050109000608
Content-Type: text/plain;
 name="ipt_REJECT-tcprst-route.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ipt_REJECT-tcprst-route.diff"

===== net/ipv4/netfilter/ipt_REJECT.c 1.10 vs edited =====
--- 1.10/net/ipv4/netfilter/ipt_REJECT.c	Mon Mar 31 17:00:55 2003
+++ edited/net/ipv4/netfilter/ipt_REJECT.c	Tue Apr 15 15:55:36 2003
@@ -11,7 +11,6 @@
 #include <net/icmp.h>
 #include <net/ip.h>
 #include <net/tcp.h>
-struct in_device;
 #include <net/route.h>
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv4/ipt_REJECT.h>
@@ -64,12 +63,29 @@
 			 csum_partial((char *)otcph, otcplen, 0)) != 0)
 		return;
 
-	/* Routing: if not headed for us, route won't like source */
-	if (ip_route_output(&rt, oldskb->nh.iph->daddr,
-			    local ? oldskb->nh.iph->saddr : 0,
-			    RT_TOS(oldskb->nh.iph->tos) | RTO_CONN,
-			    0) != 0)
+	if (local) {
+		if (ip_route_output(&rt, oldskb->nh.iph->saddr,
+		                    oldskb->nh.iph->daddr,
+				    RT_TOS(oldskb->nh.iph->tos), 0) != 0)
 		return;
+	} else {
+		/* non-local source - we use ip_route_input to respect policy
+		 * routing rules. the call to ip_route_output is necessary to
+		 * get a valid interface where the source may have come from.
+		 */ 
+		if (ip_route_output(&rt, oldskb->nh.iph->daddr, 0, 0, 0) != 0)
+			return;
+		if (ip_route_input(oldskb, oldskb->nh.iph->saddr,
+		                   oldskb->nh.iph->daddr,
+				   RT_TOS(oldskb->nh.iph->tos),
+				   rt->u.dst.dev) != 0) {
+			dst_release(&rt->u.dst);
+			return;
+		}
+		dst_release(&rt->u.dst);
+		rt = (struct rtable *)oldskb->dst;
+		dst_hold(&rt->u.dst);
+	}
 
 	hh_len = (rt->u.dst.dev->hard_header_len + 15)&~15;
 

--------------040302060809050109000608--
