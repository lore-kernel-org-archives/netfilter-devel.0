From: Harald Welte <laforge@netfilter.org>
Subject: Re: Maximum chain name length
Date: Thu, 11 Dec 2003 14:04:46 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031211130446.GA22826@sunbeam.de.gnumonks.org>
References: <1070674657.3314.9.camel@jasiiitosh.nexusmgmt.com> <1070883753.1932.7.camel@jasiiitosh.nexusmgmt.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wfgmFf0LjPE7xkRl"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "John A. Sullivan III" <john.sullivan@nexusmgmt.com>
Content-Disposition: inline
In-Reply-To: <1070883753.1932.7.camel@jasiiitosh.nexusmgmt.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--wfgmFf0LjPE7xkRl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 08, 2003 at 06:42:33AM -0500, John A. Sullivan III wrote:
> I have posted this to netfilter-devel at the suggestion of the netfilter
> mailing list.
>=20
> We've posted a large number of screen shots on the project web page
> (http://iscs.sourceforge.net/ScreenShots/ScreenShots.html) to show what
> the application looks like and why the thirty character limit is a
> problem for us.  Any help or input will be greatly appreciated - John

Well, you can recompile the kernel and the iptables program, changing
the IPT_FUNCTION_MAXNAMELEN constant (defined in
include/linux/netfilter_ipv4/ip_tables.h) to something more than 30
chars.

We will certainly not do this by default in the kernel, since it would
artificially bloat all the iptables internal structures.

but since you are building a higher layer anyway (and I doubt that you
don't want more abstractions than the simple 'chain' approach we have),
you could implement a translation layer for chain names.  So the User
gets shown some indefinitely long chain name, but the
iptables-chain-name is used more like some id/key that is looked up in a tr=
anslation table (that could even be automagically created).

> --=20
> John A. Sullivan III
=20

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--wfgmFf0LjPE7xkRl
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/2GtuXaXGVTD0i/8RAs2dAKCX6VkVYam+0CLqmm6dYtvOKGUazgCgn0LR
ISvQidWFjHmpEaH56a60u+0=
=XjNB
-----END PGP SIGNATURE-----

--wfgmFf0LjPE7xkRl--
