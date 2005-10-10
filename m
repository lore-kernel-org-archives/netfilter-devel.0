From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH 4/5] NETFILTER ctnetlink: allow userspace to change tcp
	state
Date: Mon, 10 Oct 2005 10:33:21 +0200
Message-ID: <20051010083320.GC5091@rama.customers.eurospot.com>
References: <20051007222625.GO4450@rama.customers.eurospot.com>
	<20051009.214922.109057183.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nmemrqcdn5VTmUEE"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
Content-Disposition: inline
In-Reply-To: <20051009.214922.109057183.davem@davemloft.net>
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


--nmemrqcdn5VTmUEE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Oct 09, 2005 at 09:49:22PM -0700, David S. Miller wrote:
> From: Harald Welte <laforge@netfilter.org>
> Date: Sat, 8 Oct 2005 00:26:25 +0200
>=20
> > this is clearly a new feature, so it can wait for 2.6.15.
> >=20
> > Please apply to your 2.6.15 queue, or tell me to resubmit later, thanks.
>=20
> It's be a shame for ctnetlink to be handicapped in it's
> first release in 2.6.14, so I applied both patches 4 and 5 :)

Thanks a lot for merging everything.  Let's hope we now finally have
resolved all issues with netfilter netlink.

As indicated, I'll work on that iptables cpu-count issue asap.  I'm
unable to test it on my notebook (still travelling), but since you're
running various sparc beastst, maybe you can give it a test once I've
worked it out.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--nmemrqcdn5VTmUEE
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFDSidQXaXGVTD0i/8RAqPNAJsEA/IOIt/VzixvPpXzQLeFvR/AVwCfX0Mz
+4eghzxoZTNerMns7PJembk=
=pg3h
-----END PGP SIGNATURE-----

--nmemrqcdn5VTmUEE--
