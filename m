From: Harald Welte <laforge@netfilter.org>
Subject: Re: timeout storms make the box unresponsive
Date: Fri, 25 Jul 2003 22:21:14 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030725202113.GK10897@naboo>
References: <20030725185644.GA7625@balabit.hu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Rex5+51txc1ort/q"
Cc: netfilter-devel@lists.netfilter.org,
	Rusty Russell <rusty@rustcorp.com.au>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Balazs Scheidler <bazsi@balabit.hu>
Content-Disposition: inline
In-Reply-To: <20030725185644.GA7625@balabit.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--Rex5+51txc1ort/q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 25, 2003 at 08:56:44PM +0200, Balazs Scheidler wrote:

> Maybe we should consider removing expired entries from the NAT hash at a
> single go, instead of the current lock-remove-unlock for each entry. Or
> create a cleanup thread which cleans up conntrack entries regularly, but =
not
> in the timer interrupt context.

Rusty, Jamal and I were talking about this conntrack cleanup yesterday
(we're currently all at OLS).  The conclusion was that a cleanup kernel thr=
ead=20
is what we want to have.

This can be combined with the ip_conntrack timer change.  Instead of
resetting the timer inside struct ip_conntrack every time, we just write
jiffies+timeout into a field. =20

And then there is a kernel thread that cleans up all expired entries in
regular intervals.

If I understood correctly, Rusty already has some old patches in this
area, and he is most likely to put an update of these patches out in the
next weeks before the netfilter developer workshop.

If this is too late and somebody else wants to work on this, please
coordinate with Rusty to not duplicate any work. =20

> Bazsi
> PGP info: KeyID 9AF8D0A9 Fingerprint CD27 CFB0 802C 0944 9CFD 804E C82C 8=
EB1
>=20

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--Rex5+51txc1ort/q
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE/IZE5XaXGVTD0i/8RAlMrAJ9aRuGvTbGN0OunSyEgruC39P1u7wCgoara
oVhSMx4jNuEStYihkIxj+28=
=3haZ
-----END PGP SIGNATURE-----

--Rex5+51txc1ort/q--
