From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH] fix NAT ICMP reply translation of inner packet
Date: Wed, 26 Feb 2003 19:49:37 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030226184937.GB15997@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4bRzO86E/ozDv8r1"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
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


--4bRzO86E/ozDv8r1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave!

Attached patch solves a couple of problems with the translation of the
inner (encapsulated) IP packet in ICMP reply packets.

For further info see:
https://bugzilla.netfilter.org/cgi-bin/bugzilla/show_bug.cgi?id=3D2
https://bugzilla.netfilter.org/cgi-bin/bugzilla/show_bug.cgi?id=3D55

Credits for this patch to Balazs Scheidler <bazsi@balabit.hu>

(don't be confused by the 72 line offset while applying the patch)

Please apply,

thanks.

--- linux-2.4.20-plain/net/ipv4/netfilter/ip_nat_core.c		Mon May 27 04:53:0=
9 2002
+++ linux-2.4.20-natfix/net/ipv4/netfilter/ip_nat_core.c	Mon May 27 05:00:2=
3 2002
@@ -843,7 +843,7 @@
 		   packet, except it was never src/dst reversed, so
 		   where we would normally apply a dst manip, we apply
 		   a src, and vice versa. */
-		if (info->manips[i].hooknum =3D=3D opposite_hook[hooknum]) {
+		if (info->manips[i].hooknum =3D=3D hooknum) {
 			DEBUGP("icmp_reply: inner %s -> %u.%u.%u.%u %u\n",
 			       info->manips[i].maniptype =3D=3D IP_NAT_MANIP_SRC
 			       ? "DST" : "SRC",
@@ -854,9 +854,9 @@
 				  &info->manips[i].manip,
 				  !info->manips[i].maniptype,
 				  &skb->nfcache);
-		/* Outer packet needs to have IP header NATed like
-                   it's a reply. */
-		} else if (info->manips[i].hooknum =3D=3D hooknum) {
+			/* Outer packet needs to have IP header NATed like
+	                   it's a reply. */
+
 			/* Use mapping to map outer packet: 0 give no
                            per-proto mapping */
 			DEBUGP("icmp_reply: outer %s -> %u.%u.%u.%u\n",



--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--4bRzO86E/ozDv8r1
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+XQxBXaXGVTD0i/8RAvUHAKCeheL1F75XPGTjw6eAJAVYks8dPACaAow2
YTPJeSxRAN/eJRx67VKk6Ew=
=mQkC
-----END PGP SIGNATURE-----

--4bRzO86E/ozDv8r1--
