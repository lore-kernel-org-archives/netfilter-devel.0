From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH 2.4] netfilter ipt_REJECT: Add RFC1812 ICMP_PKT_FILTERED
Date: Fri, 25 Jul 2003 22:51:11 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030725205111.GO3244@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3wDDcJ525A5nbDoJ"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: David Miller <davem@redhat.com>
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--3wDDcJ525A5nbDoJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave!

The seven patch set of bugfixes for 2.4 is now complete.  Well, one more
thing, depending on the definition of 'bug' (since Marcelo only accepts
bug fixes from now on).

We now have a small patch that adds an ICMP type to the REJECT target.
But since before this patch, we don't fully comply with RFC1812, you
might also consider it as a bugfix.


Author: Maciej Soltysiak <solt@dns.toxicfilms.tv>

This patch adds support for the iptables '--reject-with admin-prohib'
option of the REJECT target, making it compliant with RFC 1812.


Please apply,


diff -Nru linux.bak/include/linux/netfilter_ipv4/ipt_REJECT.h linux/include=
/linux/netfilter_ipv4/ipt_REJECT.h
--- linux.bak/include/linux/netfilter_ipv4/ipt_REJECT.h	2003-04-08 20:21:22=
=2E000000000 +0200
+++ linux/include/linux/netfilter_ipv4/ipt_REJECT.h	2003-04-09 16:40:05.000=
000000 +0200
@@ -9,7 +9,8 @@
 	IPT_ICMP_ECHOREPLY,
 	IPT_ICMP_NET_PROHIBITED,
 	IPT_ICMP_HOST_PROHIBITED,
-	IPT_TCP_RESET
+	IPT_TCP_RESET,
+	IPT_ICMP_ADMIN_PROHIBITED
 };

 struct ipt_reject_info {
diff -Nru linux.bak/net/ipv4/netfilter/ipt_REJECT.c linux/net/ipv4/netfilte=
r/ipt_REJECT.c
--- linux.bak/net/ipv4/netfilter/ipt_REJECT.c	2003-04-08 20:21:56.000000000=
 +0200
+++ linux/net/ipv4/netfilter/ipt_REJECT.c	2003-04-09 16:41:07.000000000 +02=
00
@@ -1,6 +1,7 @@
 /*
  * This is a module which is used for rejecting packets.
  * Added support for customized reject packets (Jozsef Kadlecsik).
+ * Added support for ICMP type-3-code-13 (Maciej Soltysiak). [RFC 1812]
  */
 #include <linux/config.h>
 #include <linux/module.h>
@@ -330,6 +331,9 @@
 	case IPT_ICMP_HOST_PROHIBITED:
     		send_unreach(*pskb, ICMP_HOST_ANO);
     		break;
+    	case IPT_ICMP_ADMIN_PROHIBITED:
+		send_unreach(*pskb, ICMP_PKT_FILTERED);
+		break;
 	case IPT_TCP_RESET:
 		send_reset(*pskb, hooknum =3D=3D NF_IP_LOCAL_IN);
 	case IPT_ICMP_ECHOREPLY:
--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--3wDDcJ525A5nbDoJ
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE/IZg/XaXGVTD0i/8RAogtAJ9Bun71ggWdzdulCYV/gpF8edroDACbB4xi
WpNqZGf8gYpG70DyiwXqTjo=
=zYbt
-----END PGP SIGNATURE-----

--3wDDcJ525A5nbDoJ--
