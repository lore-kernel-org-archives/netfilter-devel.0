From: Clifford Wolf <clifford@clifford.at>
Subject: [PATCH] ipset type "expire"
Date: Thu, 19 May 2005 15:24:15 +0200
Message-ID: <20050519132414.GH6159@clifford.at>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="V32M1hWVjliPHW+c"
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
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


--V32M1hWVjliPHW+c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

I've already mailed with Jozsef Kadlecsik about this patch in March. It
seamed to me as he liked it, but it did not show up in the netfilter
subversion repository so far..

	http://www.clifford.at/priv/ipset_expire_v2.patch

This patch adds an "expire" ipset type. The entries in such IP sets expire
automatically after the specified timeout. This is useful e.g. for
portknocking setups or blacklisting IPs for some time without any userland
daemons running.

Please apply the patch in the subversion repository or comment on it if you
think it should not be included..

yours,
 - clifford

--=20
SSSS PPPP L     The SPL Programming Language
S    P  P L     http://www.clifford.at/spl/
SSSS PPPP L     ----------------------------------------------------
   S P    L     An object oriented, stateful, simple, small, c-like,
SSSS P    LLLL  embeddable, feature rich, dynamic scripting language
=20
Hardware /nm./: the part of the computer that you can kick.
=20

--V32M1hWVjliPHW+c
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQFCjJN+PNIEsfpKDdERApwsAKCHNCVyREVZel+BKTWNKgBDcFo6bACfQ5jJ
vNZlKr+Kk/zTDngqlVPq+9Q=
=Vr4Z
-----END PGP SIGNATURE-----

--V32M1hWVjliPHW+c--
