From: Harald Welte <laforge@gnumonks.org>
Subject: Re: Corruption on mangle/INPUT when MARKing packets
Date: Wed, 8 Jan 2003 18:07:33 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030108170733.GR9467@sunbeam.de.gnumonks.org>
References: <37584.195.97.5.193.1041644841.squirrel@fs.tsaousis.gr> <20030106125230.GE9467@sunbeam.de.gnumonks.org> <3E19AE4F.5020908@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/eSpIzx5LyAe5lwl"
Cc: Costa Tsaousis <costa@tsaousis.gr>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <3E19AE4F.5020908@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--/eSpIzx5LyAe5lwl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 06, 2003 at 05:26:55PM +0100, Patrick McHardy wrote:
> I think the problem lies within ip_route_me_harder. It is called on=20
> mangled packets in the INPUT chain
> and changes skb->dst with new route after setting key.src =3D 0 if it's=
=20
> not a local address.

well spotted. This is exactly the problem.

So the question is: Do we really need to call route_me_harder() in the
INPUT chain?  We could argue that if somebody wants to do a change
affecting the routing decision should make that change before the
routing decison, not after it. =20

If we agree on this change, the solution is easy. Just call
ipt_route_hook() instead of ipt_local_hook() at NF_IP_LOCAL_IN.

Otherwise we'd need a seperate route_me_harder function for the case of
non-local packets.  But I don't think this makes sense at all.

Patch attached (and put into 'pending').=20

Thanks.

> Regards,
> Patrick

--=20
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
"If this were a dictatorship, it'd be a heck of a lot easier, just so long
 as I'm the dictator."  --  George W. Bush Dec 18, 2000

--/eSpIzx5LyAe5lwl
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+HFrVXaXGVTD0i/8RAjUEAKCHKwPILke/06XH6FgMfex58ySBEQCcDiYX
qWQXDwWkFIi/1iAvWgJFYyw=
=/nD1
-----END PGP SIGNATURE-----

--/eSpIzx5LyAe5lwl--
