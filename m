From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH 2.4] netfilter ipt_recent Configure.help fix
Date: Fri, 25 Jul 2003 22:51:03 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030725205103.GM3244@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3BjoNV5KkjW1cxnK"
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


--3BjoNV5KkjW1cxnK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave!

This is the 6th of a set of bugfixes (all tested against 2.4.22-pre7).
You might need to apply them incrementally (didn't test it in a
different order).  You will receive 2.6 merges of those patches soon.


Author: Adrian Bunk <bunk@fs.tum.de>, Harald Welte <laforge@netfilter.org>

Add the missing Configure.help entry for ipt_recent

Please apply,

--- linuxppc-040703-nfpending/Documentation/Configure.help	2003-07-02 09:07=
:33.000000000 +0200
+++ linuxppc-040703-nfpom/Documentation/Configure.help	2003-07-18 19:17:31.=
000000000 +0200
@@ -2589,6 +2700,17 @@
   If you want to compile it as a module, say M here and read
   <file:Documentation/modules.txt>.  If unsure, say `N'.
=20
+recent match support
+CONFIG_IP_NF_MATCH_RECENT
+  This match is used for creating one or many lists of recently
+  used addresses and then matching against that/those list(s).
+
+  Short options are available by using 'iptables -m recent -h'
+  Official Website: <http://snowman.net/projects/ipt_recent/>
+
+  If you want to compile it as a module, say M here and read
+  Documentation/modules.txt.  If unsure, say `N'.
+
 limit match support
 CONFIG_IP_NF_MATCH_LIMIT
   limit matching allows you to control the rate at which a rule can be
--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--3BjoNV5KkjW1cxnK
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE/IZg3XaXGVTD0i/8RAgmsAJ9loN+mJIMHIS35HvLxmlDSOGZPaACfWtiE
LgKbR7d+pr6+x5lRKJA9bco=
=Aagn
-----END PGP SIGNATURE-----

--3BjoNV5KkjW1cxnK--
