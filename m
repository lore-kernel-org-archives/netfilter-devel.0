From: Harald Welte <laforge@netfilter.org>
Subject: Re: Question about reference count of expectations in 2.6.14 tree
Date: Thu, 11 Aug 2005 21:20:50 +0200
Message-ID: <20050811192050.GH5353@rama.de.gnumonks.org>
References: <200508100111.j7A1Bok9010084@toshiba.co.jp>
	<20050811133545.GI4130@rama.de.gnumonks.org>
	<20050811135135.GJ4130@rama.de.gnumonks.org>
	<42FB6360.9010003@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kjpMrWxdCilgNbo1"
Cc: netfilter-devel@lists.netfilter.org, pablo@eurodev.net,
	Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <42FB6360.9010003@trash.net>
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


--kjpMrWxdCilgNbo1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 11, 2005 at 04:40:32PM +0200, Patrick McHardy wrote:

> >I think it would be possible to remove the second atomic_inc() and all
> >the ip_conntrack_put() that immediately follow ulink_expect() - but
> >would it be worth the effort?  Isn't it an over-optimization that is
> >likely to cause bugs later on?
>=20
> There is one spot where it isn't possible, in find_expectation
> the timer reference isn't dropped but returned to the caller.
> Changing it would either require a special version of unlink_expect
> or an additional atomic_inc in this function. I don't think its
> worth the trouble, we do take two references so this seems the
> cleanest way to me.

I think I'll add some comment to the code explaining why we need to get
two references. =20

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--kjpMrWxdCilgNbo1
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFC+6USXaXGVTD0i/8RAtnNAJ9DKVUukSPCsjtQGJn0LCMVTw5x9QCbBjPS
8vaYxd+KCMsNMTg0mWdM6i8=
=vypV
-----END PGP SIGNATURE-----

--kjpMrWxdCilgNbo1--
