From: Torsten Luettgert <t.luettgert@pressestimmen.de>
Subject: [PATCH] ROUTE target
Date: Sun, 28 May 2006 19:44:45 +0200
Message-ID: <1148838285.2516.5.camel@scaramouche.combox.de>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-BlqSd9+bvayLQ3KRnUAT"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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


--=-BlqSd9+bvayLQ3KRnUAT
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi,

here's another simple patch for the ROUTE target. It fails to compile
if CONFIG_NETFILTER_DEBUG is set, because there's no nf_debug member
in skb any longer. The patch just removes the skb->nf_debug = 0;

Regards,
Torsten

--=-BlqSd9+bvayLQ3KRnUAT
Content-Disposition: attachment; filename=ROUTE.patch
Content-Type: text/x-patch; name=ROUTE.patch; charset=UTF-8
Content-Transfer-Encoding: 7bit

Index: ROUTE/linux-2.6/net/ipv4/netfilter/ipt_ROUTE.c
===================================================================
--- ROUTE/linux-2.6/net/ipv4/netfilter/ipt_ROUTE.c	(revision 6622)
+++ ROUTE/linux-2.6/net/ipv4/netfilter/ipt_ROUTE.c	(working copy)
@@ -378,9 +378,6 @@
 		skb->nfct = &route_tee_track.ct_general;
 		skb->nfctinfo = IP_CT_NEW;
 		nf_conntrack_get(skb->nfct);
-#ifdef CONFIG_NETFILTER_DEBUG
-		skb->nf_debug = 0;
-#endif
 	}
 
 	if (route_info->oif[0] != '\0') {

--=-BlqSd9+bvayLQ3KRnUAT--
