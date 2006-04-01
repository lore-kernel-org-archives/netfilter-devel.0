From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH 4/4] first conntrack ID must be 1 not 2
Date: Sat, 1 Apr 2006 21:31:38 +0200
Message-ID: <20060401193138.GG11031@sunbeam.de.gnumonks.org>
References: <Pine.LNX.4.58.0602160943060.26770@blackhole.kfki.hu>
	<43F43FA9.4000906@trash.net>
	<Pine.LNX.4.58.0602161005450.26770@blackhole.kfki.hu>
	<43F4426D.9060807@trash.net>
	<Pine.LNX.4.58.0602161017590.26770@blackhole.kfki.hu>
	<43F4DBDF.9010008@trash.net> <442B9765.2020105@ufomechanic.net>
	<442C81A6.3040501@trash.net>
	<Pine.LNX.4.58.0603312026030.9154@blackhole.kfki.hu>
	<442D78A8.4050300@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UfEAyuTBtIjiZzX6"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Content-Disposition: inline
In-Reply-To: <442D78A8.4050300@trash.net>
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


--UfEAyuTBtIjiZzX6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 31, 2006 at 08:44:56PM +0200, Patrick McHardy wrote:

> Me neither :) I was just pointing out the idea behind the ID, not
> necessarily condoning it. After discussing it with Rusty in Sevilla,
> it became clear that we can provide guarantees similar to filesystems
> without it, which seems to be good enough. So I have absolutely
> nothing against removing it. In fact, IIRC the last discussion
> stopped after I had sent a patch to remove it. I need to dig out that
> patch again :)

I didn't contribute to any of these discussions anymore, since I already
made my opinion on this quite clear very early on:  I don't have any
problem whatsoever with non-uniqueness ;)

So if there's now a majority of people who want to delete the ID: Go for
it :)

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--UfEAyuTBtIjiZzX6
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2.2 (GNU/Linux)

iD8DBQFELtUaXaXGVTD0i/8RAhQgAJ0cK1T0vfTYOkWsS68aYa0EKfbA/wCgjOlM
RZMJYMi/wuSZ66DeYGj7Xg4=
=ISlp
-----END PGP SIGNATURE-----

--UfEAyuTBtIjiZzX6--
