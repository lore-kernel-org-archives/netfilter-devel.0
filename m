From: Harald Welte <laforge@gnumonks.org>
Subject: Re: Fw: [patch] tcp connection tracking 2.4.19
Date: Wed, 9 Oct 2002 17:02:40 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021009170240.Z13233@sunbeam.de.gnumonks.org>
References: <20021008.150030.00574604.davem@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EUwkhXZbCcD53YNR"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "David S. Miller" <davem@redhat.com>
Content-Disposition: inline
In-Reply-To: <20021008.150030.00574604.davem@redhat.com>; from davem@redhat.com on Tue, Oct 08, 2002 at 03:00:30PM -0700
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--EUwkhXZbCcD53YNR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 08, 2002 at 03:00:30PM -0700, David Miller wrote:
> Date: 	Tue, 8 Oct 2002 22:50:54 +0200
> From: Martin Renold <martinxyz@gmx.ch>
> To: linux-kernel@vger.kernel.org
> Subject: [patch] tcp connection tracking 2.4.19

Thanks Dave, we will discuss this in the coreteam and reply to you ASAP.

(jfyi: this 'exploit' is well-known behaviour of the conntrack code,
 and as long as there is no full sequence-number tracking, we will always
 end up with those kind of issues...

--=20
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
"If this were a dictatorship, it'd be a heck of a lot easier, just so long =
as
 I'm the dictator."  --  George W. Bush Dec 18, 2000

--EUwkhXZbCcD53YNR
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE9pEUQXaXGVTD0i/8RAoTaAJ9/XYArV6Qd9HN1ghVDlKIoLU1GlwCeKhfG
ydTmSVhhvSNQqb3flQRVR7A=
=5Ujb
-----END PGP SIGNATURE-----

--EUwkhXZbCcD53YNR--
