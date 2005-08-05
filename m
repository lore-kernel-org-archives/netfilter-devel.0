From: Harald Welte <laforge@netfilter.org>
Subject: Re: [ANNOUNCE] netfilter-2.6.14 git tree / TODO
Date: Fri, 5 Aug 2005 20:27:40 +0200
Message-ID: <20050805182740.GD13345@rama.de.gnumonks.org>
References: <20050731080143.GA10374@rama.de.gnumonks.org>
	<m21x5czj2p.fsf@cerbere.dyndns.info>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="s9fJI615cBHmzTOP"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Netfilter Mailinglist <netfilter@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Samir Bellabes <sbellabes@mandriva.com>
Content-Disposition: inline
In-Reply-To: <m21x5czj2p.fsf@cerbere.dyndns.info>
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


--s9fJI615cBHmzTOP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 02, 2005 at 01:14:54PM +0200, Samir Bellabes wrote:
> Harald Welte <laforge@netfilter.org> writes:
>=20
> > I suggest pulling the git tree from=20
> >
> > rsync://people.netfilter.org/users/laforge/scm/netfilter-2.6.14.git
> >
> > It is based on David Miller's net-2.6.14.git, and only contains those
> > new features and fixes that I intend to push to him soon (or have
> > already submitted but have not yet been included).
> >
>=20
> I started a tree for extensions in the p-o-m.
> The git tree has already around 30 extensions, and is based on davem's
> net-2.6.git
>=20
> you can dowload the tarball of this tree here:
> http://people.mandriva.com/~sbellabes/nf-2.6.git.tar.gz
> http://people.mandriva.com/~sbellabes/git/nf-2.6.git/
>=20
> Yes, i know, a rsync should be better, but the only server i got which
> can host a rsync server, has a DSL link :/=20

> Harald, can you provide hosting ?=20

sure, you can get a people.netfilter.org account.   Please send me your
sshv2 public key and the preferred username.

>   - updating patch for being sync with svn, but for now, we got a
> structured tree.
>   - add more extensions (sip, ..)
>=20
> Here is the changelog against davem's tree for each branches
> (main updates are kill lockhelp.h and fix compile problems, the branches
> mdv is the merge branches of all extensions)

ok, so you have one local branch per extension?  makes a lot of sense...

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--s9fJI615cBHmzTOP
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFC86+cXaXGVTD0i/8RAv1eAKCIEodfeplrfVzdDzhFz+DEXzwRDACfc04O
VV6O1N8BWTuYTbvX29QpF2c=
=XrG7
-----END PGP SIGNATURE-----

--s9fJI615cBHmzTOP--
