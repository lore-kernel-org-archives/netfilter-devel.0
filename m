From: Harald Welte <laforge@netfilter.org>
Subject: Re: nth patch on linux >= 2.6.15-git10
Date: Sat, 21 Jan 2006 15:51:13 +0100
Message-ID: <20060121145113.GA4603@sunbeam.de.gnumonks.org>
References: <BAY103-F214AE3E26DB2A5F8484C6AB21F0@phx.gbl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4uMdeSyPFwfKNOAv"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Marco Berizzi <pupilla@hotmail.com>
Content-Disposition: inline
In-Reply-To: <BAY103-F214AE3E26DB2A5F8484C6AB21F0@phx.gbl>
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


--4uMdeSyPFwfKNOAv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 20, 2006 at 03:37:31PM +0100, Marco Berizzi wrote:
> I'm getting this warning, with gcc 3.3.6, compiling pom-ng nth
> patch with the latest bleeding edge kernel (those with x_tables):

patches to fix this are welcome :)

'pom-ng' is something like a 'contrib' directory.  It lives from
contributions by users.  We can't expect the core developers to always
take care of merging/porting those contributions.

So unless the contributors (or users) submit patches/fixes, the code wil
bitrot like it does at the moment :(

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--4uMdeSyPFwfKNOAv
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFD0kphXaXGVTD0i/8RAhl+AKCVt+RXD4quRH7srgIfv8jGPjPUiACfTyhl
6hqrEbh6bqFVfCT3zGKeQrA=
=UD+a
-----END PGP SIGNATURE-----

--4uMdeSyPFwfKNOAv--
