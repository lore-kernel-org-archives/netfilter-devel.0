From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH]: fix ipt_REJECT broken UDP crc firewall spotting (phrack
 60)
Date: Sun, 05 Jan 2003 20:40:52 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3E188A44.4000606@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090904000901070603020500"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
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
--------------090904000901070603020500
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Hi.

Sorry if this mail arrives twice, mozilla crashed while sending and it 
seems it did not make it out before.
ipt_REJECT sends unreachables in response to UDP packets with invalid 
checksums, thereby exposing the
existance of a firewall  (as described in phrack #60, "broken crc 
firewall spotting" (or something like this), www.phrack.com).
to verify please try this:
# send udp with correct checksum
hping -2 host -p 20000
# send udp with invalid checksum
hping -2 host -p 20000 -b

now insert a rule to reject those packets on host or somewhere between 
you and host and try it again.
The patch makes ipt_REJECT verify UDP checksums if set.

Regards,
Patrick


--------------090904000901070603020500
Content-Type: text/plain;
 name="ipt_REJECT-fwspotting-phrack60-fix.diff"
Content-Disposition: inline;
 filename="ipt_REJECT-fwspotting-phrack60-fix.diff"
Content-Transfer-Encoding: quoted-printable
X-MIME-Autoconverted: from 8bit to quoted-printable by el-zoido.localnet id h05JdvR14093

diff -urN linux-2.4.21-pre2-clean/net/ipv4/netfilter/ipt_REJECT.c linux-2=
.4.21-pre2/net/ipv4/netfilter/ipt_REJECT.c
--- linux-2.4.21-pre2-clean/net/ipv4/netfilter/ipt_REJECT.c	2002-11-29 00=
:53:15.000000000 +0100
+++ linux-2.4.21-pre2/net/ipv4/netfilter/ipt_REJECT.c	2003-01-05 19:59:27=
.000000000 +0100
@@ -6,6 +6,8 @@
 #include <linux/module.h>
 #include <linux/skbuff.h>
 #include <linux/ip.h>
+#include <linux/udp.h>
+#include <linux/icmp.h>
 #include <net/icmp.h>
 #include <net/ip.h>
 #include <net/tcp.h>
@@ -157,6 +159,7 @@
 static void send_unreach(struct sk_buff *skb_in, int code)
 {
 	struct iphdr *iph;
+	struct udphdr *udph;
 	struct icmphdr *icmph;
 	struct sk_buff *nskb;
 	u32 saddr;
@@ -186,6 +189,19 @@
 	if (iph->frag_off&htons(IP_OFFSET))
 		return;
=20
+	/* if UDP checksum is set, verify it's correct */
+	if (iph->protocol =3D=3D IPPROTO_UDP
+	    && skb_in->tail-(u8*)iph >=3D sizeof(struct udphdr)) {
+		int datalen =3D skb_in->len - (iph->ihl<<2);
+		udph =3D (struct udphdr *)((char *)iph + (iph->ihl<<2));
+		if (udph->check
+		    && csum_tcpudp_magic(iph->saddr, iph->daddr,
+		                         datalen, IPPROTO_UDP,
+		                         csum_partial((char *)udph, datalen,
+		                                      0)) !=3D 0)
+			return;
+	}
+		   =20
 	/* If we send an ICMP error to an ICMP error a mess would result.. */
 	if (iph->protocol =3D=3D IPPROTO_ICMP
 	    && skb_in->tail-(u8*)iph >=3D sizeof(struct icmphdr)) {
Bin=E4rdateien linux-2.4.21-pre2-clean/net/ipv4/netfilter/.ipt_REJECT.c.s=
wp and linux-2.4.21-pre2/net/ipv4/netfilter/.ipt_REJECT.c.swp sind versch=
ieden.

--------------090904000901070603020500--
