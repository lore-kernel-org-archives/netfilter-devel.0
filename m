From: Harald Welte <laforge@netfilter.org>
Subject: Re: how to flush conntrack entry?
Date: Tue, 25 Nov 2003 21:50:41 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031125205041.GD2971@obroa-skai.de.gnumonks.org>
References: <003201c39f75$3e40a5c0$0200200a@wangle> <20031103074343.GL1536@sunbeam.de.gnumonks.org> <20031125153043.GC1082@eychenne.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/unnNtmY43mpUSKx"
Cc: sina <wanglonge@vip.sina.com>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Herve Eychenne <rv@wallfire.org>
Content-Disposition: inline
In-Reply-To: <20031125153043.GC1082@eychenne.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--/unnNtmY43mpUSKx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 25, 2003 at 04:30:43PM +0100, Herve Eychenne wrote:
> On Mon, Nov 03, 2003 at 08:43:43AM +0100, Harald Welte wrote:
>=20
>  Hi,
>=20
> > it will not stop working 'obviously'.  It will just stop working because
> > you were using MASQUERADE, and MASQUERADE [still] has the policy of
> > flushing all conntrack/nat entries associated with the IP address of the
> > outgoing interface.  Would you be using SNAT, it would continue to work.
>=20
> By the way, Rusty has written a bit of code during the workshop, that
> enables MASQUERADE not to flush current connections if the interface
> address didn't change after the interface has come up again.
> What is the status regarding its inclusion into vanilla kernel?

this piece of code is actually in patch-o-matic in 'pending'.  Since
noone has reported any problems, it's likely to get submitted for 2.4.24
and 2.6.1

>  Herve

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--/unnNtmY43mpUSKx
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/w8CgXaXGVTD0i/8RAjGZAJ4w2CbahLZBNutHXWmRmkghE5rmdQCeL3Vh
KxGiZ2jkYDitKMDwjhFcnkE=
=UWMs
-----END PGP SIGNATURE-----

--/unnNtmY43mpUSKx--
