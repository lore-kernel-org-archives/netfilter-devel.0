From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH] Fix Typo in netfilter Kconfig file
Date: Wed, 23 Apr 2003 00:49:53 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030422224953.GE10887@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kVXhAStRUZ/+rrGn"
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


--kVXhAStRUZ/+rrGn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Dave, could you please apply this cosmetic fix to your 2.5.x tree?

Thanks.

----- Forwarded message from Jeff Smith <whydoubt@yahoo.com> -----

From: Jeff Smith <whydoubt@yahoo.com>
To: linux-kernel@vger.kernel.org, coreteam@netfilter.org,
  zippel@linux-m68k.org
Subject: [netfilter-core] [PATCH 2.5.68] Typo in a Kconfig file
List-Archive: <https://lists.netfilter.org/cgi-bin/mailman/private/netfilte=
r-core/>
Date: Tue, 22 Apr 2003 12:30:33 -0700 (PDT)

Found this typo in NetFilter's Kconfig file.
- Jeff Smith


--- a/net/ipv4/netfilter/Kconfig	Sat Apr 19 21:50:40 2003
+++ b/net/ipv4/netfilter/Kconfig	Tue Apr 22 12:04:59 2003
@@ -48,7 +48,7 @@
 	  <file:Documentation/modules.txt>.  If unsure, say `Y'.
=20
 config IP_NF_TFTP
-	tristate "TFTP prtocol support"
+	tristate "TFTP protocol support"
 	depends on IP_NF_CONNTRACK
 	help
 	  TFTP connection tracking helper, this is required depending



__________________________________________________
Do you Yahoo!?
The New Yahoo! Search - Faster. Easier. Bingo
http://search.yahoo.com



----- End forwarded message -----

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--kVXhAStRUZ/+rrGn
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+pccRXaXGVTD0i/8RAkY+AJ9Bp/WkGkre46W6GsDwMgFsFFQypQCgoOy3
olJwaKtBRlXoEUYSNwMRIAA=
=Ilkq
-----END PGP SIGNATURE-----

--kVXhAStRUZ/+rrGn--
