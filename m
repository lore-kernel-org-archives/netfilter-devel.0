From: Harald Welte <laforge@netfilter.org>
Subject: Re: IPT_ENTRY_ITERATE
Date: Sun, 26 Sep 2004 09:41:12 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <20040926074111.GL3236@sunbeam.de.gnumonks.org>
References: <415274A7.9030203@rediffmail.com>
	<Pine.LNX.4.58.0409230932400.20426@tux.rsn.bth.se>
	<41528432.3020702@rediffmail.com>
	<1095927514.2709.0.camel@nienna.balabit>
	<41528A5D.7080803@rediffmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dYpzLy1CJFIhs6l3"
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>,
	Martin Josefsson <gandalf@wlug.westbo.se>,
	KOVACS Krisztian <hidden@balabit.hu>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Swapnil Nagle <swapsn@rediffmail.com>
Content-Disposition: inline
In-Reply-To: <41528A5D.7080803@rediffmail.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--dYpzLy1CJFIhs6l3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 23, 2004 at 02:03:33PM +0530, Swapnil Nagle wrote:

> Thanks :) I had no idea that it was in the iptables kernel headers & not=
=20
> in the userspace program !

Both have to iterate the ruleset, so it is logical to have them only in
one place.  An since you can compile the kernel without iptables
userspace (but not vice versa) it becomes completely obvious ;)

> -- Swapnil

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--dYpzLy1CJFIhs6l3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFBVnKXXaXGVTD0i/8RAsPzAJsFBrvHoUGG78+6cdrLXl8avT7qUgCeKxLd
PckQBAHWj8H/dvYu42H0Puo=
=cABK
-----END PGP SIGNATURE-----

--dYpzLy1CJFIhs6l3--
