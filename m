From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH]: several small patches
Date: Tue, 17 Jun 2003 18:18:16 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030617161816.GJ936@naboo>
References: <3EECBFF1.2070503@trash.net> <3EECF170.6070002@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bWEb1MG/o7IKOlQF"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <3EECF170.6070002@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--bWEb1MG/o7IKOlQF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 16, 2003 at 12:21:36AM +0200, Patrick McHardy wrote:
> >5. ip-conntrack-expect-drop-refcnt.diff:
> >drop master conntrack refcnt before setting expectant =3D NULL in
> >remove_expectations. untested but seems to make sense.
>=20
>=20
> this patch seems to fix the ip_conntrack unload-loop. I can reliably
> trigger the loop by unloading ip_conntrack after unloading an
> conntrack helper which is helping some connection. No problems
> with this patch applied.

sounds promising, I'll put it in pending.

> Best regards,
> Patrick

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--bWEb1MG/o7IKOlQF
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE+7z9HXaXGVTD0i/8RAoXvAJ9+GdU9dyTFYj9s9M8JEIu+v/OmJgCePgBe
8n+9lTh6P/R9mt/BYwovqo4=
=/9/D
-----END PGP SIGNATURE-----

--bWEb1MG/o7IKOlQF--
