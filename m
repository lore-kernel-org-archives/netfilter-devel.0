From: Harald Welte <laforge@netfilter.org>
Subject: nfnetlink/ctnetlink (was Re: iptables2)
Date: Mon, 31 Mar 2003 16:40:01 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030331144001.GA28962@sunbeam.de.gnumonks.org>
References: <200303191103.47656.joshua@myinternet.com.au> <20030326145802.GV21953@sunbeam.de.gnumonks.org> <20030331141424.GA3108@myinternet.com.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gKMricLos+KVdGMg"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Joshua Goodall <joshua@myinternet.com.au>
Content-Disposition: inline
In-Reply-To: <20030331141424.GA3108@myinternet.com.au>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--gKMricLos+KVdGMg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 01, 2003 at 12:14:24AM +1000, Joshua Goodall wrote:
> On Wed, Mar 26, 2003 at 03:58:02PM +0100, Harald Welte wrote:
> > ctnetlink (the patch from patch-o-matic) as well as the libctnetlink
> > _do_ work, they are independent from the other iptables2 stuff.  see the
> > 'ctnltest' example application.
>=20
> ctnetlink used to work, but the old ctrace binaries aren't online
> any more. =20

the whole notfier API has been removed, since I didn't think the design
was optimal enough. So ctrace doesn't make sense without the notifiers,
and thus it is not there.

> nfnetlink appears to, after hacking up the Makefiles to
> actually make it build (overriding apparent assumptions about kernel
> header locations, libiptables, manpages etc), but ctnltest isn't much of
> a sample (and it doesn't seem to work well with 2.4.20, hanging after
> its first few lines on my nfnetlink-patched kernel), and there's no
> documentation I can see.

It did work at 2.4.18/2.4.19 time.  Documentation? well, there's about
four API functions of libctnetlink... don't think there is a need for
much documentation at that time.  And I don't think it is wise to change
something in an early stage of development anyway.

> I did some work on the old ctnetlink, adding octet-counting to create
> something very similar to Netflow v1, but left it to gather dust when
> nfnetlink was announced.
>=20
> Is this now an abandoned project?

no, definitely not.  It's just that I have about 20 times the work I can
possibly get done.  All I can do is schedule between the highest
priority items and try to get them done in a reasonable time.

I'm hapyy if I get through the bug reports, have the time to do releases
and look through contributed patches.  There's not much time left for my
iptables2 playground, unfortunately.

Again, I'm sorry :(

> J

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--gKMricLos+KVdGMg
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+iFNBXaXGVTD0i/8RAhbfAJ9kDpbmPsv8rc5nFtxSsPGu4zJG/QCfX9KG
mK6XMDXD2mCzx8jBHP5tq9o=
=X4rd
-----END PGP SIGNATURE-----

--gKMricLos+KVdGMg--
