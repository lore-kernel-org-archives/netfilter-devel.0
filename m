From: "Jesper Bengtsson" <jesper.bengtsson@axis.com>
Subject: [PATCH] netfilter: xt_tcpudp.c: wrong struct in udp_checkentry
Date: Fri, 24 Aug 2007 13:50:53 +0200
Message-ID: <BFECAF9E178F144FAEF2BF4CE739C668039A0C6D@exmail1.se.axis.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
To: <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
content-class: urn:content-classes:message
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

I found what looks like a copy-paste error in udp_checkentry, see patch
below.
It doesn't seem to have any effect on the x86 architecture but it does
have effect on the Axis CRIS architecture.

Best regards,
Jesper Bengtsson

diff -u -r1.1.1.5 -r1.2
--- net/netfilter/xt_tcpudp.c	6 Mar 2007 08:51:40 -0000	1.1.1.5
+++ net/netfilter/xt_tcpudp.c	24 Aug 2007 09:22:26 -0000	1.2
@@ -191,7 +191,7 @@
 	       void *matchinfo,
 	       unsigned int hook_mask)
 {
-	const struct xt_tcp *udpinfo =3D matchinfo;
+	const struct xt_udp *udpinfo =3D matchinfo;
=20
 	/* Must specify no unknown invflags */
 	return !(udpinfo->invflags & ~XT_UDP_INV_MASK);
