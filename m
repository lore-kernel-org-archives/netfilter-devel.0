From: Harald Welte <laforge@gnumonks.org>
Subject: Re: Linux kernel crashes when incoming/outgoing interfaces differ
Date: Fri, 17 Jan 2003 01:10:44 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030117001044.GL7774@sunbeam.de.gnumonks.org>
References: <20030115130419.GX7242%bowles@ambisys.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/unnNtmY43mpUSKx"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Eric E. Bowles" <bowles@ambisys.com>
Content-Disposition: inline
In-Reply-To: <20030115130419.GX7242%bowles@ambisys.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--/unnNtmY43mpUSKx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 15, 2003 at 10:04:19PM +0900, Eric E. Bowles wrote:
> [I originally sent this to the OpenVPN devel mailing list, and it
>  was suggested that I forward it to other lists since it might be a
>  problem involving netfilter and/or the kernel, so here goes....]
>=20
> Hi there,
>=20
> I've been experiencing kernel crashes with OpenVPN (http://openvpn.sf.net=
)=20
> on Linux under a certain set of conditions, and wondered if anybody else =
can=20
> reproduce this.

Hi!

This bug report sounds very interesting.  I have put it into our
brand-new bugzilla system, you can keep track of the bug at=20
https://bugzilla.netfilter.org/cgi-bin/bugzilla/show_bug.cgi?id=3D22


> Here are the steps needed to cause the crash:
[...]

I'm trying to build a test setup for this case ASAP, I think I'll have
some time at the weekend.

=20
> What I think is happening is this: when an incoming connection arrives
> on Host-A's TUN interface, the REJECT rule is triggered, causing an=20
> "ICMP unreachable" to be sent back.  However, since there is no return=20
> route back across the tunnel, the default route is selected, which causes=
=20
> the ICMP packet to be <<returned on an interface that is different from t=
he
> incoming interface>> (i.e., the tunnel).  Since the incoming (tun) and=20
> outgoing (eth) interfaces have different link layer header sizes, the=20
> kernel is crashing in skb_push().

Sounds like a plausible explanation.   As stated above, as soon as I can
reproduce it, I'll do further debugging and hopefully find a fix for
this issue.

> Thanks,
> --eric

Thanks for reporting this bug.

--=20
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
"If this were a dictatorship, it'd be a heck of a lot easier, just so long
 as I'm the dictator."  --  George W. Bush Dec 18, 2000

--/unnNtmY43mpUSKx
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+J0oEXaXGVTD0i/8RAv7GAJ9C7eAQkCg7GaxJwG0GNAq344rpGQCcDQ3g
2iZ3dXjWnMfDEq77q7lE2Bo=
=mpBC
-----END PGP SIGNATURE-----

--/unnNtmY43mpUSKx--
