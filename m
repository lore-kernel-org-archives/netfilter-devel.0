From: Harald Welte <laforge@netfilter.org>
Subject: Re: [RFC] let arptables see bridged frames
Date: Fri, 13 Jun 2003 17:12:50 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030613151250.GC32593@sunbeam.de.gnumonks.org>
References: <200306112128.39326.bdschuym@pandora.be> <20030612.012223.82124840.davem@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9C8JZALFROMdO0HE"
Cc: bdschuym@pandora.be, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "David S. Miller" <davem@redhat.com>
Content-Disposition: inline
In-Reply-To: <20030612.012223.82124840.davem@redhat.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--9C8JZALFROMdO0HE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 12, 2003 at 01:22:23AM -0700, David S. Miller wrote:

>    I'm planning on letting arptables see bridged frames.
>  ...  =20
>    Are there any objections against this, or comments?
>=20
> No objections.

I agree with davem, this could really be an useful feature for filtering
bridges...  so please go ahead with your implementation :)

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--9C8JZALFROMdO0HE
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE+6enyXaXGVTD0i/8RAms2AJsFRB9H2iBya4teaoAqSSgQc3b3ZgCbBY/K
y6OYpohdVkXBv5KFiTfzyWw=
=He53
-----END PGP SIGNATURE-----

--9C8JZALFROMdO0HE--
