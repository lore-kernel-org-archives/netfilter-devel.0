From: Harald Welte <laforge@netfilter.org>
Subject: Re: Kernel patch for nat/conntrack xdmcp
Date: Wed, 21 May 2003 08:37:44 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030521063744.GZ28587@sunbeam.de.gnumonks.org>
References: <Pine.LNX.4.44.0305201029560.7078-100000@luna.as.arizona.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3bc47Eih9dS+biPM"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: nlauver@as.arizona.edu
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0305201029560.7078-100000@luna.as.arizona.edu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--3bc47Eih9dS+biPM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 20, 2003 at 10:32:56AM -0700, Neal Lauver wrote:
> Hello,
>=20
> I see that you have developed a netfilter module to handle XDMCP=20
> connection tracking for NATed connections.  Do you happen to have either =
a=20
> kernel patch that I can apply to 2.4.20 or instructions for manually=20
> building the modules?  Any assistance you can offer would be greatly=20
> appreciated.  Thanks for all of your work on this.

It wasn't me, who developed the patches.  I have just taken a
contributed implementation and did some modifications.  The original
code did implement NAT support, but would at the same time introduce
severe security holes.

Unfortunately XDMCP never was important enough to have this work
finished. =20

Due to time restrictions, I am not sure when I will be able to continue
my work on those helper modules.

I'm sorry for this un-satisfactory reply :(

Maybe you can find somebody at netfilter-devel who is willing to spend
some time on the code, it is available from the netfilter-extensions CVS
repository.

> Neal Lauver
> Steward Observatory
> University of Arizona
> Tucson, AZ, USA

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--3bc47Eih9dS+biPM
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE+yx64XaXGVTD0i/8RAg5AAJ9Rgp/L5SCaqISzX1wWexKrYCIo0ACeIJUF
FvHe22snq4eHCIoMdYa/yBk=
=TCQN
-----END PGP SIGNATURE-----

--3bc47Eih9dS+biPM--
