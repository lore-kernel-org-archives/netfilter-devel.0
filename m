From: Harald Welte <laforge@netfilter.org>
Subject: Re: [nf-failover] Re: [RFC] ct_sync 0.15 (corrected)
Date: Sat, 25 Sep 2004 09:52:53 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <20040925075253.GQ3236@sunbeam.de.gnumonks.org>
References: <1092407190.2402.120.camel@nienna.balabit>
	<1095993739.1044.9.camel@jzny.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="elWSKwo949DbmCL3"
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>,
	Netfilter-failover list <netfilter-failover@lists.netfilter.org>,
	KOVACS Krisztian <hidden@balabit.hu>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: jamal <hadi@cyberus.ca>
Content-Disposition: inline
In-Reply-To: <1095993739.1044.9.camel@jzny.localdomain>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--elWSKwo949DbmCL3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 23, 2004 at 10:42:19PM -0400, jamal wrote:
> Hi Krisztian,
>=20
> I just glanced over your code (30 sec scan) and your state machine
> doesnt allow for active/active (i.e two masters).

yes, this is not a supported mode of operation in this first
implementation.

> I havent actually run it - can you confirm this is impossible?=20
> if ct_sync was blind i.e it just did what it was told "become master" or
> "become slave" regardless of who else is master, then it would be more
> usable - leave policy to whatever tells it to switch.

well it exactly does this, with an additional security:  A master will
be downgraded to slave as soon as another master announces itself.  This
is a security guard against invalid mode of operation.

> cheers,
> jamal

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--elWSKwo949DbmCL3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFBVSPVXaXGVTD0i/8RAtKNAKCMhcn3y/JBoGX/HAfPT6BugwoT3QCeLhtV
Gzh7SCAuIav1HZ4VRgBysRw=
=AynR
-----END PGP SIGNATURE-----

--elWSKwo949DbmCL3--
