From: Harald Welte <laforge@gnumonks.org>
Subject: Re: New Target: ipt_ACCOUNT
Date: Mon, 6 Jan 2003 14:24:22 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030106132422.GJ9467@sunbeam.de.gnumonks.org>
References: <200212161736.gBGHaPn01458@moonlight.crew-kg.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="G2d+m75Tjo442KmM"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Rolf Wuerdemann <rowue@crew-kg.de>
Content-Disposition: inline
In-Reply-To: <200212161736.gBGHaPn01458@moonlight.crew-kg.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--G2d+m75Tjo442KmM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 16, 2002 at 06:36:22PM +0100, Rolf Wuerdemann wrote:
> Hi there ...

Hi, sorry for my late reply.

> we've developed a new target for iptables: ipt_ACCOUNT.
> This Target accounts Traffik on a packet-base on source and
> target ip using netfilter (similar to nacctd - but using iptables).
>=20
> It's in use on our routers (app. 60MBit/s Bandwitdh) since three month
> (app.) without any trouble and was tested with some DDoS-Tools before
> use ;)

great news.  A couple of comments:

 I think this is the wrong approach, there are way too much data
strucctures in non-swappable kernel momory allocated.  And kernel-OOM is
not something we should provoke.  A better architecture from my point of
view was: - use ULOG to copy the IP+TCP header of all packets to
userspace [it is very efficient in doing so!!!] and then do all the
accounting in userspace

Leaving this personal view aside, I still dislike a couple of issues
with your patch

- It doesn't adhere to the kernel CodingStyle=20
	- german variables
	- C++ style comments
	- more than 80chars per line
- the kernel/userspace interface using a socket option

So if you want to contribute it into patch-o-matic, you will have to
at least conform to the coding style, sorry.

> PS: We've developed it 'cause nacctd was=20
> 	a) to much use of cpu
> 	b) looses packets during kernel-problems with PF_PACKET

I am (as a long time nacctd user and hacker) aware of those issues.  But
this doesn't mean that moving everything into the kernel is the right
thing..

--=20
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
"If this were a dictatorship, it'd be a heck of a lot easier, just so long
 as I'm the dictator."  --  George W. Bush Dec 18, 2000

--G2d+m75Tjo442KmM
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+GYOGXaXGVTD0i/8RArNRAKCB9GasGDPQS8MvfTMjL1wRa55XMgCdGw9V
+gSV90C2FoNIB6VXRuBc/bs=
=pNfr
-----END PGP SIGNATURE-----

--G2d+m75Tjo442KmM--
