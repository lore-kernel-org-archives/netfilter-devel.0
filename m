From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: 64bit changes in cvs
Date: Thu, 27 May 2004 00:12:01 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1085609520.969.128.camel@tux.rsn.bth.se>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ZImnj1pBnC4KeWRy3CLt"
Cc: Netfilter <netfilter@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter-devel <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--=-ZImnj1pBnC4KeWRy3CLt
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi

During the day I've committed some patches into the iptables tree to get
things working better on 64bit kernels (with both 32bit and 64bit
userspace).
(only tested on sparc64 and compile-tested on alpha. x86_64 and ia64
will most likely need more love in order to work correctly with 32bit
userspace, more on that later)

All matches and targets in the 2.6 kernel works fine on the sparc64
kernel now. One thing to mention concerns the ULOG target, the iptables
part of it works fine with both 32bit and 64bit userspace, but the ulogd
daemon _must_ be 64bit compiled in order to recieve packets correctly
from kernel, this is true for all 64bit kernels.

I've reworked the part of the makefile that tries to detect if you are
compiling a 32bit iptables against a 64bit kernel. I hope it works...

To those of you who have 64bit machines, please test and report any
problems (including x86_64 / ia64 if you are feeling brave but it will
probably fail :)

--=20
/Martin

--=-ZImnj1pBnC4KeWRy3CLt
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQBAtRYwWm2vlfa207ERAj0GAJ9Nt1Z1Nn00oXfGnHlrc0Mkf5YuqQCeJG6e
4ulhpTbwjw8SkAsPCxidHek=
=FHVX
-----END PGP SIGNATURE-----

--=-ZImnj1pBnC4KeWRy3CLt--
