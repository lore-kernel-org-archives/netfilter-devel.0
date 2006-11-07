From: Harald Welte <laforge@netfilter.org>
Subject: Re: [RFC] new API for libnetfilter_conntrack
Date: Tue, 7 Nov 2006 20:24:58 +0100
Message-ID: <12500.4802052446$1162935543@news.gmane.org>
References: <45456285.4010609@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KSyhVCl2eeZHT0Rn"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>, Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Content-Disposition: inline
In-Reply-To: <45456285.4010609@netfilter.org>
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


--KSyhVCl2eeZHT0Rn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 30, 2006 at 03:25:09AM +0100, Pablo Neira Ayuso wrote:
> Hi,
>=20
> Attached a patch, yet incomplete, that introduces the new API for
> libnetfilter_conntrack. Basically the idea consists of providing
> "conntrack" objects constructor/destructor functions and an interface to
> get and set object attributes. The conntrack object structure is
> encapsulated therefore we can add new attributes without breaking binary
> backward compatibility. There is an example of the new API use in the
> patch (see test.c file)

I like that API and I think it's the right way to go.

> The reason why I posted this patch is because I'm thinking about
> generalizing this a bit more and provide a complete high level API that
> would be the same for all the netfilter subsystems.=20

Makes sense.

> This will result in a single library to rules them all with a
> subdirectory that contains the details of every specific subsystem.

I disagree with that proposition.  I don't really understand why
completely independent netfilter subsystems should share a high-level
userspace library.  Every time some obscure bug in libnetfilter_log
happens, libnetfilter_conntrack will be affected, too.

This is especially difficult if meanwhile you have commited
not-yet-completely-stable code for one subsystem, and then need to make
a bugfix releease of the other (svn branching is an option, but it all
sounds a bit too complex for my taste).

One option would be implement the subsystem specific parts as plugins
and to dlopen() them at runtime, providing a way of updating only
individual subystem-plugins
--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--KSyhVCl2eeZHT0Rn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQFFUN2KXaXGVTD0i/8RAk5jAKCSRLhVBkq40GfAoLOySyyBj/E33QCdE5oS
WyEtBqULKQMqz92wCrA63lY=
=Z6aI
-----END PGP SIGNATURE-----

--KSyhVCl2eeZHT0Rn--
