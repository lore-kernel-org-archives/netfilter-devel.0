From: Harald Welte <laforge@netfilter.org>
Subject: Re: iptables-save counters on builtin chains not restored?
Date: Thu, 19 Aug 2004 12:13:14 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040819101314.GD3921@sunbeam.de.gnumonks.org>
References: <20040817211821.GE23109@eychenne.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rG8Oha4Ryswg1dZ8"
Cc: Netfilter Development <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Herve Eychenne <rv@wallfire.org>
Content-Disposition: inline
In-Reply-To: <20040817211821.GE23109@eychenne.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--rG8Oha4Ryswg1dZ8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 17, 2004 at 11:18:21PM +0200, Herve Eychenne wrote:
=20
> When fed with the result of iptables-save -c, iptables-restore -c
> does not seem to restore counters on chains (I'm not talking about
> rules), as I simply cannot find any parsing code for that.
>=20
> Note that it would make sense only on builtin chains, but not
> user-chains, because only builtin chains have a policy, and the
> counters are about packets that hit the policy.
>=20
> Anyway, it doesn't seem to be restored at all, and I suspect an
> omission, so... a bug. Can someone confirm?

Yes, now that you say it, I don't remember having written that code ;)

Please put it in bugzilla... and patches are obviously always welcome.

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

--rG8Oha4Ryswg1dZ8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFBJH06XaXGVTD0i/8RAmP0AJ4zFBuECaKkgmpceA4SmTAeA25xYQCeNKV8
mIH8wVtjyRbRFzvzwrEKu+s=
=OHJh
-----END PGP SIGNATURE-----

--rG8Oha4Ryswg1dZ8--
