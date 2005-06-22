From: Pawel Sikora <pluto@agmk.net>
Subject: [PATCH] ip6t_REJECT.c vs 2.6.12.
Date: Wed, 22 Jun 2005 14:06:01 +0200
Message-ID: <200506221406.01960.pluto@agmk.net>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_pQVuC6U29lj6mdW"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org,
 Patrick McHardy <kaber@trash.net>
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

--Boundary-00=_pQVuC6U29lj6mdW
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,

In 2.6.12 the net/ipv6.h was changed.

(...)
extern int ipv6_skip_exthdr(const struct sk_buff *, int start,
-                           u8 *nexthdrp, int len);
+                           u8 *nexthdrp);

ip6t_REJECT.c needs minor fix.

-- 
The only thing necessary for the triumph of evil
  is for good men to do nothing.
                                           - Edmund Burke

--Boundary-00=_pQVuC6U29lj6mdW
Content-Type: text/x-diff;
  charset="utf-8";
  name="0.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="0.diff"

Index: ip6t_REJECT.c
===================================================================
--- ip6t_REJECT.c	(revision 3984)
+++ ip6t_REJECT.c	(working copy)
@@ -72,9 +72,7 @@
 	}
 
 	proto = oip6h->nexthdr;
-	tcphoff = ipv6_skip_exthdr(oldskb, ((u8*)(oip6h+1) - oldskb->data),
-				   &proto, oldskb->len - ((u8*)(oip6h+1)
-							  - oldskb->data));
+	tcphoff = ipv6_skip_exthdr(oldskb, (u8*)(oip6h+1) - oldskb->data, &proto);
 
 	if ((tcphoff < 0) || (tcphoff > oldskb->len)) {
 		DEBUGP("ip6t_REJECT: Can't get TCP header.\n");

--Boundary-00=_pQVuC6U29lj6mdW--
