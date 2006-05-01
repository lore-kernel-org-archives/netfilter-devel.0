From: Harald Welte <laforge@netfilter.org>
Subject: Re: Libnetfilter_conntrack problems
Date: Mon, 1 May 2006 14:53:53 -0300
Message-ID: <20060501175353.GD5267@rama>
References: <ca021ab30604270455q5cf093c9s990558209bca3e1d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gE7i1rD7pdK0Ng3j"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: =?iso-8859-1?Q?S=E9bastien?= LAVEZE <slaveze@gmail.com>
Content-Disposition: inline
In-Reply-To: <ca021ab30604270455q5cf093c9s990558209bca3e1d@mail.gmail.com>
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


--gE7i1rD7pdK0Ng3j
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 27, 2006 at 01:55:13PM +0200, S=E9bastien LAVEZE wrote:
> but not for destroy =3D=3D> nfct_open(CONNTRACK,
> NF_NETLINK_CONNTRACK_DESTROY), i never get any event

are you sure?  did you wait until the respective entries really timed
out from the conntrack table?

what does 'conntrack -E -e DESTROY' say?  do you then see the events?

> 2) I also would like to work with ids, when i get a conntrack via a
> callback the id field is always set to zero, is it normal ?

IIRC, we dropped ID's recently. I'm a bit lagging behind, though.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--gE7i1rD7pdK0Ng3j
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3 (GNU/Linux)

iD8DBQFEVksxXaXGVTD0i/8RAl1lAJ9v9pnv7dzgmj9Pt4a5JRZyD3DYxgCeLX+Q
DF3D0Ceq5ZT7DSNeOifQ+uA=
=1Ryk
-----END PGP SIGNATURE-----

--gE7i1rD7pdK0Ng3j--
