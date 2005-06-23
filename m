From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH 2.6] ipt_CLUSTERIP: fix ARP mangling
Date: Thu, 23 Jun 2005 10:34:16 +0200
Message-ID: <20050623083416.GU4551@obroa-skai.de.gnumonks.org>
References: <20050622122902.GI4551@obroa-skai.de.gnumonks.org>
	<20050622.124341.95064256.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0iexB5Bk8cF8G6DP"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
Content-Disposition: inline
In-Reply-To: <20050622.124341.95064256.davem@davemloft.net>
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


--0iexB5Bk8cF8G6DP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 22, 2005 at 12:43:41PM -0700, David S. Miller wrote:
> 1) Please use my correct email address, davem@davemloft.net

I'm currently travelling, an my notebook's 'aliases' file apparently
still had the old alias.  fixed now.

> 2) Patch does not apply, because of the patches that went into
>    2.6.x yesterday from Patrick McHardy which removed all the
>    lockhelp stuff.

Thanks, I only read about his patches after sending my fix.  Also due to
travelling, I had very limited connectivity [1] and=20

> tree.  Every patch that doesn't apply cleanly makes lots of extra
> work for me.

Sorry.  I'll re-send a fixed version soon.

[1] http://gnumonks.org/~laforge/weblog/2005/06/22#20050622-network-at-linu=
xtag
--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--0iexB5Bk8cF8G6DP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFCunQHXaXGVTD0i/8RAgu9AJsEAE9WXWEXTK74WfzPNDJNNOzuNgCfXYlK
XRspjZGztCX5MBhC1o3HFTE=
=bh+X
-----END PGP SIGNATURE-----

--0iexB5Bk8cF8G6DP--
