From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: [PATCH] don't try to track broadcasts or multicasts (4/4)
Date: 06 Jun 2002 14:24:05 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <1023366027.845.30.camel@tux>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-J0ynkQUcsxAiXDJpnhcT"
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Netfilter-devel <netfilter-devel@lists.samba.org>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--=-J0ynkQUcsxAiXDJpnhcT
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

There exists code to disable tracking of broadcasts but it's insice a
#if 0 / #endif in ip_conntrack_core.c and looks like some old debugging
code as it has printk's and stuff.

this patch removes that chunk and replaces it with a check so if the
packet is a broadcast or multicast we just return NF_ACCEPT since
there's not much point in us trying to track it.

-- 
/Martin

Never argue with an idiot. They drag you down to their level, then beat
you with experience.

--=-J0ynkQUcsxAiXDJpnhcT
Content-Disposition: attachment; filename=ip_conntrack_core.c-broadmulti-diff
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; name=ip_conntrack_core.c-broadmulti-diff; charset=ISO-8859-15

--- linux-2.4.19-pre9/net/ipv4/netfilter/ip_conntrack_core.c.orig	Mon Jun  =
3 20:32:28 2002
+++ linux-2.4.19-pre9/net/ipv4/netfilter/ip_conntrack_core.c	Tue Jun  4 20:=
56:18 2002
@@ -737,20 +737,9 @@
 	/* FIXME: Do this right please. --RR */
 	(*pskb)->nfcache |=3D NFC_UNKNOWN;
=20
-/* Doesn't cover locally-generated broadcast, so not worth it. */
-#if 0
-	/* Ignore broadcast: no `connection'. */
-	if ((*pskb)->pkt_type =3D=3D PACKET_BROADCAST) {
-		printk("Broadcast packet!\n");
+	/* Don't try to track broadcasts or multicasts. */
+	if ((*pskb)->pkt_type =3D=3D PACKET_BROADCAST || (*pskb)->pkt_type =3D=3D=
 PACKET_MULTICAST)
 		return NF_ACCEPT;
-	} else if (((*pskb)->nh.iph->daddr & htonl(0x000000FF))=20
-		   =3D=3D htonl(0x000000FF)) {
-		printk("Should bcast: %u.%u.%u.%u->%u.%u.%u.%u (sk=3D%p, ptype=3D%u)\n",
-		       NIPQUAD((*pskb)->nh.iph->saddr),
-		       NIPQUAD((*pskb)->nh.iph->daddr),
-		       (*pskb)->sk, (*pskb)->pkt_type);
-	}
-#endif
=20
 	/* Previously seen (loopback)?  Ignore.  Do this before
            fragment check. */

--=-J0ynkQUcsxAiXDJpnhcT--
