From: Harald Welte <laforge@gnumonks.org>
Subject: Re: Comments about IPT_ALIGN
Date: Fri, 31 Jan 2003 12:55:12 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030131115512.GW9073@naboo.cybercafe42>
References: <3E335CB1.9070101@hipac.org> <20030126120159.A3045@linux.karinthy.hu> <3E33C665.9080106@fugmann.dhs.org> <20030126152227.A6811@linux.karinthy.hu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BuGwuXnZwGGQ9GEc"
Cc: Anders Fugmann <afu@fugmann.dhs.org>, Thomas Heinz <creatix@hipac.org>,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Laszlo Valko <valko@linux.karinthy.hu>
Content-Disposition: inline
In-Reply-To: <20030126152227.A6811@linux.karinthy.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--BuGwuXnZwGGQ9GEc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jan 26, 2003 at 03:22:27PM +0100, Laszlo Valko wrote:
> Currently, I see two ways:
> 1) make a translation function for all currently existing netfilter struc=
tures
>    that use longs or pointers (difficult, as modules can be added
>    independently), like those in arch/sparc64/sys_sparc32.c, and its
>    friends,

it's a hack, but it would work.

> 2) introduce a new way of passing structures, with new structures, probab=
ly
>    with new setsockopt/getsockopt numbers, essentially creating an API
>    incompatible with the existing one (there are a few other bleeding wou=
nds
>    waiting to be solved in the existing interface as I saw).

please don't go for solution #2.  There is already one new interface
between kernel an userspace in development... we don't need more
interfaces than we already have. =20

And yes, the new interface still has the matchinfo of all matches
concatenated in one memory area.  Everything else has linked lists,
though (e.g. every rule is a seperately allocated memory chunk).

> Regards,
> Laszlo

--=20
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
GCS/E/IT d- s-: a-- C+++ UL++++$ P+++ L++++$ E--- W- N++ o? K- w--- O- M-=
=20
V-- PS+ PE-- Y+ PGP++ t++ 5-- !X !R tv-- b+++ DI? !D G+ e* h+ r% y+(*)

--BuGwuXnZwGGQ9GEc
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+OmQgXaXGVTD0i/8RAuqSAKCBVgtEIw1Ymp7com0jNS4hZ8XNvwCeNN1D
LcTLuRpubWggLqiXpLvelew=
=QgzG
-----END PGP SIGNATURE-----

--BuGwuXnZwGGQ9GEc--
