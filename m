From: Harald Welte <laforge@netfilter.org>
Subject: remaining libnetfilter_conntrack issues
Date: Fri, 28 Oct 2005 22:59:55 +0200
Message-ID: <20051028205955.GA10568@rama.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TB36FDmn/VVEgNH/"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: pablo@eurodev.net
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


--TB36FDmn/VVEgNH/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Pablo!

I've started to write a new ulogd2 plugin against the new
libnetfilter_conntrack, and found a number of issues, mostly related to
header files:

1) why do we need 'asm/types.h'?  this is unacceptable
2) why do we need 'linux/if.h'?
3) libnetfilter_conntrack needs to be split into two parts:
	a) what is visible to application programs
	b) what is visible to extensions
4) if we do '3', we can get rid of the ugly "linux_list.h" include
5) we'd ideally get rid of the ip_conntrack.h include, too
6) we should ship a copy of both nfnetlink.h and nfnetlink_conntrack.h with=
 the library
   this way userspace programs can be built without any
   nfnetlink-enabled kernel headers installed.

I think everything but '5' should be fairly trivial to do.  Which
definitions do we really need from ip_conntrack.h?  The status bits?
Then we should also ship a copy of only those status bit definitions
with the library. =20

All copies should be performed during the 'distrib' stage, i.e. every
time we make a release we tell the automake/autoconf system where to
take a current copy of those headers from.  They would not be present in
svn.

Cheers,

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--TB36FDmn/VVEgNH/
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFDYpFKXaXGVTD0i/8RAk7OAJ97rHJk61nu+zkJofBjgZGVeXKCHACeOlQA
wvsM0qw710SOnnBB71YYYko=
=4lH2
-----END PGP SIGNATURE-----

--TB36FDmn/VVEgNH/--
