From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH 1/4] fix leak of fragment queue at unloading
	nf_conntrack_ipv6
Date: Sun, 13 Nov 2005 14:03:34 +0100
Message-ID: <20051113130334.GN17476@sunbeam.de.gnumonks.org>
References: <200511130850.jAD8ohfY012005@toshiba.co.jp>
	<20051113100837.GG17476@sunbeam.de.gnumonks.org>
	<200511131238.jADCcbHR017662@toshiba.co.jp>
	<20051113125627.GM17476@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BtmVPk+Smchi6n7w"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>,
	netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <20051113125627.GM17476@sunbeam.de.gnumonks.org>
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


--BtmVPk+Smchi6n7w
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Nov 13, 2005 at 01:56:27PM +0100, Harald Welte wrote:
> > Sorry for short explanation. This function may be called when memory us=
age
> > exceeds threshold. And I just want to be noticed existence of bug
> > in memory tracking and avoid NULL pointer access.
>=20
> ok, in this case I think the error message should be more verbose.
>=20
> > > Please comment.
> >=20
> > Is it overly cautions to avoid NULL pointer access in this case ?
>=20
> I'd have to study the code in more detail.  It depends on the question:
> Under which circumstances can we have a NULL pointer?

After looking at the code, this function is only called from
1) module unload time

Here it is clear, that there are valid cases where we would have a NULL
pointer (empty fraq queue).  Let's assume we've never even processed a
single fragment [or even not a single ipv6 packet], e.g.

So in this case, it is a bug to print a KERN_ERR message.

2) when the amount of memory used by the defrag code is higher than the
   threshold

In this case, there's actually a bug in the memory usage accounting
code.  Do you suspect any such errors at the moment?  I think this is a
candidate for an ASSERT, or maybe even better a BUG_ON(). =20

We're talking about a condition that should never happen, and if it
does, we want to make sure to have users report it and fix it fast.  If
the kernel oopses, that condition is fulfilled ;)

So unless I'm missing some point (I'm not as familiar with the code as
you), I'd suggest that you resubmit the patch with a BUG_ON(tmp =3D=3D NULL)
statement.

Thanks!

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--BtmVPk+Smchi6n7w
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFDdzmmXaXGVTD0i/8RApbJAJ4kyPiscOcmsD2S53h+Fp8Vag7qAwCfQ175
JGSfo287qwHQKgYS4X2AsaQ=
=bUSN
-----END PGP SIGNATURE-----

--BtmVPk+Smchi6n7w--
