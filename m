From: Harald Welte <laforge@netfilter.org>
Subject: Re: nf_conntrack (l3 independent conntrack)
Date: Wed, 19 Nov 2003 14:24:44 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031119132444.GW5075@sunbeam.de.gnumonks.org>
References: <20031115105020.GI656@obroa-skai.de.gnumonks.org> <200311180305.MAA20518@toshiba.co.jp> <20031118165138.GO5075@sunbeam.de.gnumonks.org> <200311190246.LAA10515@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ugCSa1rMkiCAmd9S"
Cc: netfilter-devel@lists.netfilter.org, usagi-core@linux-ipv6.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Content-Disposition: inline
In-Reply-To: <200311190246.LAA10515@toshiba.co.jp>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--ugCSa1rMkiCAmd9S
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 19, 2003 at 11:45:29AM +0900, Yasuyuki Kozakai wrote:

> > > I read. It's very usefull to implement nf_conntrack. Thank you.
> >=20
> > Well, I doubt it is, but anyway ;)
>=20
> Did I missread something enough to make you suspect that I read it...

No, this was just self-ironic.  I just don't think it is that much
useful in it's current form.=20

> > And to reply to your question: The tuple is part of the 'dynamic' part,
> > along with other fields.
>=20
> Thank you for datail explanation. I try to rewrite the codes that process=
es
> nf_conntrack and tuple. At first, I'll move only tuple to the dynamic par=
t of
> nf_conntrack. I may ask you about other question, I'm happy if you reply.

Sure, feel free to ask.  It's probably best to Cc netfilter-devel, since
I sometimes need a couple of days to respond all my email - and maybe
somebody else also has an answer to your question.

> > > I'll send the patches as snapshot when I finish debugging.
> > > Or should I send them after I finish implementing above items ?
> >=20
> > If possible, I think it is good to have the development as open as
> > possible.  It's not important that the code runs (or even compiles).
> > But if your current status of development was public, other netfilter
> > developers could have a look at the code and comment.
>=20
> OK, I'll send it ASAP. But maybe I take a week to get permission.

Would you need to get that permission every time you publish a certain
version of the code?  Isn't it possible to publish it once and get a
general permission to publish changes to that already-published code?

Thanks again.

> Yasuyuki KOZAKAI
>=20
> Communication Platform Laboratory,
> Corporate Research & Development Center,
> Toshiba Corporation

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--ugCSa1rMkiCAmd9S
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/u28cXaXGVTD0i/8RAjvFAJ4yLK7L9O84XyjP/uUW2jr94cQOvwCfZ9vw
m03KReTKIvGCkxlmNpJkPGA=
=PZuD
-----END PGP SIGNATURE-----

--ugCSa1rMkiCAmd9S--
