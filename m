From: Patrick McHardy <kaber@trash.net>
Subject: Re: Fw: Re: 2.6.11-rc2 TCP ignores PMTU ICMP (Re: Linux 2.6.11-rc2)
Date: Fri, 28 Jan 2005 02:56:08 +0100
Message-ID: <41F99BB8.4070409@trash.net>
References: <20050127154118.45e59991.davem@davemloft.net>
	<41F992E3.20005@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------080607040901090805050209"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
In-Reply-To: <41F992E3.20005@trash.net>
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

This is a multi-part message in MIME format.
--------------080607040901090805050209
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Patrick McHardy wrote:

> IP (tos 0xd0, ttl  64, id 40755, offset 0, flags [none], length: 88) 
> 172.16.1.123 > 172.16.1.123: icmp 68: type-#142 for IP (tos 0x10, ttl 
> 180, id 13605, offset 0, flags [DF], length: 60, bad cksum e8b3 
> (->73d8)!) 172.16.1.123 > 172.16.195.55:  ip-proto-225 40
>
> This patch fixes it.

This patch on top fixes corrupt checksums of ICMP errors. The
function returns before recalculating the checksum in some cases.

>
> Signed-off-by: Patrick McHardy <kaber@trash.net>



--------------080607040901090805050209
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

===== net/ipv4/netfilter/ip_nat_core.c 1.67 vs edited =====
--- 1.67/net/ipv4/netfilter/ip_nat_core.c	2005-01-18 21:27:23 +01:00
+++ edited/net/ipv4/netfilter/ip_nat_core.c	2005-01-28 02:48:04 +01:00
@@ -450,6 +450,13 @@
 		       !manip))
 		return 0;
 
+	/* Reloading "inside" here since manip_pkt inner. */
+	inside = (void *)(*pskb)->data + (*pskb)->nh.iph->ihl*4;
+	inside->icmp.checksum = 0;
+	inside->icmp.checksum = csum_fold(skb_checksum(*pskb, hdrlen,
+						       (*pskb)->len - hdrlen,
+						       0));
+
 	/* Change outer to look the reply to an incoming packet
 	 * (proto 0 means don't invert per-proto part). */
 
@@ -468,13 +475,6 @@
 			return 0;
 	}
 
-	/* Reloading "inside" here since manip_pkt inner. */
-	inside = (void *)(*pskb)->data + (*pskb)->nh.iph->ihl*4;
-
-	inside->icmp.checksum = 0;
-	inside->icmp.checksum = csum_fold(skb_checksum(*pskb, hdrlen,
-						       (*pskb)->len - hdrlen,
-						       0));
 	return 1;
 }
 

--------------080607040901090805050209--
