From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH 2.4+2.6] fix DELETE_LIST netfilter oopses
Date: Mon, 29 Mar 2004 13:32:39 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040329113239.GC7039@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dKeYJkA19bNVVKdr"
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


--dKeYJkA19bNVVKdr
Content-Type: multipart/mixed; boundary="8Bkcj4NmnZ79d4W7"
Content-Disposition: inline


--8Bkcj4NmnZ79d4W7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

We've now narrowed down the issue of kernel oopses in combination with
'LIST_DELETE' syslog messages happening in certain setups.

Apparently people who do not enable CONFIG_IP_NF_NAT_LOCAL and do
DNAT/REDIRECT and want to connect locally from the gateway via DNAT to
the DNAT'ed address experience the bug ;)

Please push the attached patch [courtesy of KOVACS Krisztian and Henrik
Nordstrom] to 2.4.x and 2.6.x ASAP, thanks. =20

I know that patch looks ugly, but considering the verbose comment I
think it's ok.

Thanks,
--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--8Bkcj4NmnZ79d4W7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="renat_confirmed.patch"
Content-Transfer-Encoding: quoted-printable

--- linux-2.4.25/net/ipv4/netfilter/ip_nat_standalone.c	Fri Nov 28 19:26:21=
 2003
+++ linux-2.4.25a/net/ipv4/netfilter/ip_nat_standalone.c	Thu Mar 25 16:43:2=
9 2004
@@ -114,7 +114,16 @@
 		WRITE_LOCK(&ip_nat_lock);
 		/* Seen it before?  This can happen for loopback, retrans,
 		   or local packets.. */
-		if (!(info->initialized & (1 << maniptype))) {
+		if (!(info->initialized & (1 << maniptype))
+#ifndef CONFIG_IP_NF_NAT_LOCAL
+		    /* If this session has already been confirmed we must not
+		     * touch it again even if there is no mapping set up.
+		     * Can only happen on local->local traffic with
+		     * CONFIG_IP_NF_NAT_LOCAL disabled.
+		     */
+		    && !(ct->status & IPS_CONFIRMED)
+#endif
+		    ) {
 			unsigned int ret;
=20
 			if (ct->master

--8Bkcj4NmnZ79d4W7--

--dKeYJkA19bNVVKdr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFAaAlXXaXGVTD0i/8RAl3eAJ0TeVNErY0pvczZXM54J1aah/eF9wCfYZQ9
rw50NNo43osEQjcjPhjp7RY=
=YnL2
-----END PGP SIGNATURE-----

--dKeYJkA19bNVVKdr--
