From: Harald Welte <laforge@netfilter.org>
Subject: Re: string match -> new option
Date: Sun, 2 Mar 2003 10:59:15 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030302095915.GC2296@naboo.clug.de>
References: <15760529186.20030301025308@yahoo.es> <20030301063948.GF24025@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bKyqfOwhbdpXa4YI"
Cc: macadanet@yahoo.es,
	lista de correo netfilter <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick Schaaf <bof@bof.de>
Content-Disposition: inline
In-Reply-To: <20030301063948.GF24025@oknodo.bof.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--bKyqfOwhbdpXa4YI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Mar 01, 2003 at 07:39:48AM +0100, Patrick Schaaf wrote:
> > I modificated ipt_string.c
>=20
> Sigh. Why is it that people must work on the pieces that others
> already abandoned as fundamentally broken? See my point 1), below.
>=20
> > This patch acepts regular expresions.
>=20
> It was only a question of time...

please, again:

Look at 'libqsearch' from Philipe Biondi.  (I don't have the URL here
right now, but 'libqsearch' + 'kernel' on google gives you the result).

This is the way to do pattern matching on TCP streams in the kernel...

> best regards
>   Patrick

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--bKyqfOwhbdpXa4YI
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+YdXzXaXGVTD0i/8RAvmWAKCYaCXVoTLv8V8VxReL40Zmeh3L4gCfRqn9
nu3p3X9TGe1sVb4+py8vVt4=
=mDcb
-----END PGP SIGNATURE-----

--bKyqfOwhbdpXa4YI--
