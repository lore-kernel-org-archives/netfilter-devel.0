From: Harald Welte <laforge@gnumonks.org>
Subject: Re: netfilter on solaris?
Date: Sat, 15 Jun 2002 16:28:44 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020615162844.A2543@sunbeam.de.gnumonks.org>
References: <20020614100540.GA6399@balabit.hu> <20020615145212.S2543@sunbeam.de.gnumonks.org> <20020615133725.GC13464@balabit.hu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZATCr4BkWovzAAkA"
Cc: netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Balazs Scheidler <bazsi@balabit.hu>
Content-Disposition: inline
In-Reply-To: <20020615133725.GC13464@balabit.hu>; from bazsi@balabit.hu on Sat, Jun 15, 2002 at 03:37:25PM +0200
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--ZATCr4BkWovzAAkA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jun 15, 2002 at 03:37:25PM +0200, Balazs Scheidler wrote:
> On Sat, Jun 15, 2002 at 02:52:12PM +0200, Harald Welte wrote:
> > On Fri, Jun 14, 2002 at 12:05:40PM +0200, Balazs Scheidler wrote:
> > > Hi,
> > >=20
> > > It is a strange idea I know, but I'd be interested in what the opinio=
n of
> > > the core netfilter developers is on porting the whole netfilter subsy=
stem to
> > > Solaris?
> >=20
> > After my netfilter presentation at linuxtag, somebody was asking me exa=
ctly
> > this question.
>=20
> And your answer was?

what a weird idea. I told him that it is technically not easy and the core
team certainly has no plans of ever supporting this thing. I didn't even st=
art
to talk about licensing issues.

> > This is basically the same question like binary-only kernel modules.=20
>=20
> I think it is more similar to Gimp plugins under Photoshop case.

I'm not aware of this case - we are not talking about .so's [libraries]
being linked to an application, which is what the GPL is talking about.

> Under binary-only you mean propriatery, or something nonGPLd? Solaris ker=
nel
> source _is_ available, though it doesn't use the GPL.

well, source is available if you sign some very interesting license conditi=
ons,
IIRC.  Anyway, this is not important.  When I was talking about proprietary
or binary-only, I should have said: GPL-incompatible.

> Bazsi

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

--ZATCr4BkWovzAAkA
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE9C08bXaXGVTD0i/8RAvxmAKCW4u8i3G2MbKsS3dlGeRi8nL1LWQCfUyIQ
BcKMcUxPjIu2qEVBGr7dFlE=
=vQJn
-----END PGP SIGNATURE-----

--ZATCr4BkWovzAAkA--
