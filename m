From: Harald Welte <laforge@gnumonks.org>
Subject: Re: [PATCH] ip_tables.h does not compile when using g++
Date: Mon, 16 Sep 2002 18:44:17 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20020916184417.P3810@sunbeam.de.gnumonks.org>
References: <1032190296.458.21.camel@localhost.localdomain> <20020916140850.GA8967@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VtO80Grm6b12p/hj"
Cc: Scott Andrew Baillie <sbaillie@bigpond.net.au>,
	netfilter List <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick Schaaf <bof@bof.de>
Content-Disposition: inline
In-Reply-To: <20020916140850.GA8967@oknodo.bof.de>; from bof@bof.de on Mon, Sep 16, 2002 at 04:08:50PM +0200
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--VtO80Grm6b12p/hj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 16, 2002 at 04:08:50PM +0200, Patrick Schaaf wrote:
> > The header file ip_tables.h is included by the kernel and by user
> > space programs so it should compile when using g++.
>=20
> I don't understand why you arrive at this conclusion. ip_tables.h is in
> no way a valid documented user level API, and the fact that the existing
> iptables user level code base (all implemented in C) is including it,
> is a design error in the iptables userlevel - good style would be to
> copy those headers into the userlevel distribution, thus properly
> seperating kernel and userlevel headers.

Patrick, you are right. It is not a userspace API.  But unfortunately
it is included by libiptc, and if you as an application include libiptc.h,
you will in turn include ip_tables.h

> A future userlevel C++ API to iptables would indeed need to concern
> itself with such things - but there is no such thing in existence
> (and I don't know whether it is under consideration to have a C++
> callable API).

Well, you can call the C api from C++, but we don't intend to release
any real C++ classes for iptables manipulation.

> I strongly disagree with the "void *" -> "char *" conversion in pure
> kernel headers, because the kernel is by definition geared towards
> gcc with most extensions (and void * arithmetic is one that makes
> sense).

I share this disagreemenent.  However, if it's the only way we can make
C++ apps use libiptc (for now), I am willing to pay this 'price'.

> best regards
>   Patrick

--=20
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
GCS/E/IT d- s-: a-- C+++ UL++++$ P+++ L++++$ E--- W- N++ o? K- w--- O- M+=
=20
V-- PS++ PE-- Y++ PGP++ t+ 5-- !X !R tv-- b+++ !DI !D G+ e* h--- r++ y+(*)

--VtO80Grm6b12p/hj
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE9hgphXaXGVTD0i/8RAg+mAJ0ejX5UapUmm9XF0s3jq5KyAf/kDQCgiknf
wQrvQgwn/hHs4JBxxBIJmqA=
=gvz0
-----END PGP SIGNATURE-----

--VtO80Grm6b12p/hj--
