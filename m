From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] CLASSIFY target
Date: Sun, 13 Apr 2003 18:22:52 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030413162252.GV1922@sunbeam.de.gnumonks.org>
References: <3E92F2F8.1020707@trash.net> <1049832299.1318.19.camel@tux.rsn.bth.se>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tV/+6PImfyFtriLg"
Cc: Patrick McHardy <kaber@trash.net>,
	Netfilter-devel <netfilter-devel@lists.netfilter.org>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
Content-Disposition: inline
In-Reply-To: <1049832299.1318.19.camel@tux.rsn.bth.se>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--tV/+6PImfyFtriLg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 08, 2003 at 10:05:00PM +0200, Martin Josefsson wrote:
> On Tue, 2003-04-08 at 18:04, Patrick McHardy wrote:
> > This patch adds a new target "CLASSIFY" which sets skb->priority.
> > Several qdiscs can use this for classification. A list of the qdiscs
> > currently capable of doing so is in the help text. Please consider
> > for inclusion.
>=20
> Hi Patrick,
>=20
> It's usually Harald who decides which patches go in or not. And Harald
> has been quite hard to get a response from during the last weeks :(
> He seems to have a lot of things in the air at the same time.
> I have a memory-corruption fix that havn't been OK'd yet...

Just a quick note: I've re-appeared from the dark voids of
again-being-two-months-too-late-with-a-commercial-project-and-not-wanting-t=
o-be-any-later.

> /Martin

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--tV/+6PImfyFtriLg
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+mY7cXaXGVTD0i/8RAuVjAJ9je/07SjBer4K0YFktGaM8GHBDJwCdHbF+
0njiKkmxtylpdGuIlxSKqBI=
=LYMO
-----END PGP SIGNATURE-----

--tV/+6PImfyFtriLg--
