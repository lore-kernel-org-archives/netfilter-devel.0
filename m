From: Harald Welte <laforge@netfilter.org>
Subject: Re: [RFC] h323 module unloading fix
Date: Wed, 9 Feb 2005 11:05:51 +0100
Message-ID: <20050209100551.GB6878@sunbeam.de.gnumonks.org>
References: <20050208145908.GS6878@sunbeam.de.gnumonks.org>
	<420946FF.107@trash.net>
	<20050209082459.GY6878@sunbeam.de.gnumonks.org>
	<Pine.LNX.4.58.0502090933250.2846@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eOZ5LUtYRk41oVSR"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0502090933250.2846@blackhole.kfki.hu>
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


--eOZ5LUtYRk41oVSR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 09, 2005 at 09:59:09AM +0100, Jozsef Kadlecsik wrote:
> Hi,
>=20
> On Wed, 9 Feb 2005, Harald Welte wrote:
>=20
> > On Wed, Feb 09, 2005 at 12:10:55AM +0100, Patrick McHardy wrote:
> > > But I think splitting the code to evict expectations and expected
> > > conntracks from ip_conntrack_helper_unregister is a cleaner solution.
> >
> > Mh, but then every author of a helper would explicitly have to take care
> > of calling the 'evicting function'.  Considering that any existing
> > helper, tutorial and other documentation tells him that he doesn't have
> > to, it's easy to get it wrong and introduce further bugs.
>=20
> I like Patrick's idea. There are not so many modules wich rely on
> unregistered helpers, and we could retain backward compatibility in the
> API like in the attached (untested) patch. What do you think?

ok, but let's rename the function. 'evict expectations' sounds to me
(non-native-english-speaker) like we would be dropping the expectations.
'unhelp' is clumsy but more precise.  any better suggestions?

> Jozsef

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--eOZ5LUtYRk41oVSR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFCCeB/XaXGVTD0i/8RAmUfAJ9Q9UuCQYlG8cH61Q1Fm3EVPM4VkgCcC0lJ
BVbohStPYFAeamAArkbTwXY=
=ws1F
-----END PGP SIGNATURE-----

--eOZ5LUtYRk41oVSR--
