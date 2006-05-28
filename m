From: Torsten Luettgert <t.luettgert@pressestimmen.de>
Subject: [PATCH] ip_nat_sip: fix compiler warning
Date: Sun, 28 May 2006 15:46:19 +0200
Message-ID: <1148823979.32002.2.camel@scaramouche.combox.de>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-xgAnuD1zTydTmp2T9v+0"
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


--=-xgAnuD1zTydTmp2T9v+0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi,

here's a trivial patch for ip_nat_sip which fixes the following
compiler warning:

net/ipv4/netfilter/ip_nat_sip.c:97: warning: ISO C90 forbids mixed
declarations and code

Regards,
Torsten

--=-xgAnuD1zTydTmp2T9v+0
Content-Disposition: attachment; filename=ip_nat_sip.patch
Content-Type: text/x-patch; name=ip_nat_sip.patch; charset=UTF-8
Content-Transfer-Encoding: 7bit

Index: linux-2.6.13/net/ipv4/netfilter/ip_nat_sip.c
===================================================================
--- linux-2.6.13/net/ipv4/netfilter/ip_nat_sip.c	(revision 6622)
+++ linux-2.6.13/net/ipv4/netfilter/ip_nat_sip.c	(working copy)
@@ -61,6 +61,7 @@
 	unsigned int bufflen, dataoff;
 	uint32_t ip;
 	uint16_t port;
+   const char *aux;
 	
 	dataoff = (*pskb)->nh.iph->ihl*4 + sizeof(struct udphdr);
 	
@@ -93,7 +94,7 @@
 		}
 		
 		/* This search should ignore case, but later.. */
-		const char *aux = ct_sip_search("CSeq:", *dptr, sizeof("CSeq:") - 1, 
+		aux = ct_sip_search("CSeq:", *dptr, sizeof("CSeq:") - 1, 
 								(*pskb)->len - dataoff);
 		if (!aux)
 			return 0;

--=-xgAnuD1zTydTmp2T9v+0--
