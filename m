From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] fix iptables on systems with discontiguous processor ids
Date: Tue, 11 Oct 2005 16:23:47 +0200
Message-ID: <20051011142347.GB4756@rama.de.gnumonks.org>
References: <20051010164141.GG5627@rama> <434AE1A0.5030400@frankengul.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qlTNgmc+xy1dBmNv"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: =?iso-8859-1?Q?S=E9bastien?= Bernard <seb@frankengul.org>
Content-Disposition: inline
In-Reply-To: <434AE1A0.5030400@frankengul.org>
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


--qlTNgmc+xy1dBmNv
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 10, 2005 at 11:48:16PM +0200, S=E9bastien Bernard wrote:
> >Signed-off-by: Harald Welte <laforge@netfilter.org>
> >---
> >commit e759eaa9e9e92330c5fcfd760d767d4f39375a03
> >tree 63b96f7df57f51dc7e284969c3a08b9264cc2c5f
> >parent 1ab8dccdbf16c09f8da124fc4c82024de24dfae2
> >author Harald Welte <laforge@netfilter.org> Mon, 10 Oct 2005 18:29:24 +0=
200
> >committer Harald Welte <laforge@netfilter.org> Mon, 10 Oct 2005 18:29:24=
 +0200
> >[snip]
> >=20
> I tested this patch on my machine.
> It ooops instantly in get_counters() from ip_tables.c.

Mh, can you capture the oops and send it?  I'm travelling and don't have
access to any SMP box, so it's unlikely I will be able to resolve this
alone.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--qlTNgmc+xy1dBmNv
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFDS8rzXaXGVTD0i/8RAiGwAJ9XHiXjHJDcxMbrfLHyzGEg4KtbgwCeOGZE
d+owJ1bAGAX1Kk2Za6J5f1o=
=s1+D
-----END PGP SIGNATURE-----

--qlTNgmc+xy1dBmNv--
