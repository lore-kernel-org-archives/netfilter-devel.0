From: Harald Welte <laforge@netfilter.org>
Subject: Re: [RFC][PATCH] kill the fake conntrack
Date: Sun, 28 Aug 2005 14:05:40 +0200
Message-ID: <20050828120540.GG4244@rama.de.gnumonks.org>
References: <42BD513E.6090306@eurodev.net> <42BD52A7.2090107@trash.net>
	<42BD5829.4030002@eurodev.net> <42BD5C41.2080505@trash.net>
	<42BDA6D6.5070604@eurodev.net> <42BDA9D9.5030308@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eMnpOGXCMazMAbfp"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Pablo Neira <pablo@eurodev.net>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <42BDA9D9.5030308@trash.net>
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


--eMnpOGXCMazMAbfp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jun 25, 2005 at 09:00:41PM +0200, Patrick McHardy wrote:
> Pablo Neira wrote:
> >> nf_reset is called independant of the contents of skb->nfct. nfctinfo
> >> needs to be set to 0 so a packet isn't untracked afterwards anymore.
> >> Think of tunnel devices.
> >=20
> > OK. Hm, do you still consider that bad adding a line to nf_reset to
> > reset skb->nfctinfo? This is the only drawback I see at the moment.
>=20
> Its not about the line, I'm not sure about changing the fact that
> nfctinfo is only valid if nfct !=3D NULL. Its too hot to think right
> now, please give me until tommorrow :)

Looking through patchwork.netfilter.org, this thread never came to a
conclusion.  Any news on it?

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--eMnpOGXCMazMAbfp
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFDEaiTXaXGVTD0i/8RAu+cAJ9xHTGpXe2B2Cge01CsFBD2hqL57gCgnWfw
FcqNF8KZkrlf15u0LDsXxrU=
=TgDx
-----END PGP SIGNATURE-----

--eMnpOGXCMazMAbfp--
