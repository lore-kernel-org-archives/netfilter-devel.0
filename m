From: Harald Welte <laforge@gnumonks.org>
Subject: Re: [PATCH] big endian patch against netfilter after PPTP NAT pat ch
Date: Mon, 10 Feb 2003 12:01:44 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030210110144.GX24861@sunbeam.de.gnumonks.org>
References: <771F217D7A4AF84494632457889470A412D77E@bcmsg011.corp.ads> <3E41A7BC.20209@snapgear.com> <20030209092911.GO13269@naboo.fugue.com> <20030209165347.GA1737@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zxEKvxCKojqA/Afl"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick Schaaf <bof@bof.de>
Content-Disposition: inline
In-Reply-To: <20030209165347.GA1737@oknodo.bof.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--zxEKvxCKojqA/Afl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Feb 09, 2003 at 05:53:47PM +0100, Patrick Schaaf wrote:
> > yes.  David Miller has indicated that he wants us to use
> > individual-member initialization instead of our '{{{{ }}, }}' stuff.
> > So maybe this is the time to do the change - or at least use named
> > initializers like '{ asdf: 0xffff, }'
>=20
> Nowaways, we'd rather use the C99 syntax: { .asdf =3D 0xffff, }.

Yes, Iforgot about that.

> I'm all for a change towards such initializers; the current stuff
> is completely opaque.

Anybody volunteering to make a patch?  It's very easy, you don't even
need to know how to program ;)

If nobody raises his hand, I'll put it on my todo list [and you know,
it is long...]

> best regards
>   Patrick

--=20
- Harald Welte <laforge@gnumonks.org>               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
"If this were a dictatorship, it'd be a heck of a lot easier, just so long
 as I'm the dictator."  --  George W. Bush Dec 18, 2000

--zxEKvxCKojqA/Afl
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+R4aYXaXGVTD0i/8RAkBmAKCn0K3WXZ3xymnJzPr89jL2bDybpwCfdhV3
ayVee4UNzmLySFP6cXI/X3E=
=imIG
-----END PGP SIGNATURE-----

--zxEKvxCKojqA/Afl--
