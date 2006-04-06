From: Harald Welte <laforge@netfilter.org>
Subject: The future of patch-o-matic-ng
Date: Thu, 6 Apr 2006 09:35:14 +0200
Message-ID: <20060406073514.GE6887@sunbeam.de.gnumonks.org>
References: <Pine.GSO.4.63.0604040002220.15645@galaxy.agh.edu.pl>
	<20060405152628.GI20558@sunbeam.de.gnumonks.org>
	<Pine.GSO.4.63.0604052144350.1472@galaxy.agh.edu.pl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ALfTUftag+2gvp1h"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Grzegorz Janoszka <Grzegorz@Janoszka.pl>
Content-Disposition: inline
In-Reply-To: <Pine.GSO.4.63.0604052144350.1472@galaxy.agh.edu.pl>
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


--ALfTUftag+2gvp1h
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 05, 2006 at 09:52:48PM +0200, Grzegorz Janoszka wrote:
> On Wed, 5 Apr 2006, Harald Welte wrote:
>=20
> >So unless somebody actually wants to become patch-o-matic maintainer
> >(yes, we once had somebody for that job), I think it's going to die.
>=20
> I can try.=20

Well, as it seems I should have read netfilter-devel in chronological
order rather than backwards.  Patrick has already posted on how to
proceed with patch-o-matic-ng a couple of days ago:  Have the original
authors (or other people who want to maintain patchlets) host their own
repositories.  Patch-o-matic-ng would then mostly only contain a list of
URL's to such remote repositories.  This way there is no need for the
netfilter developers themselves to maintain patchsets.

> Pom is used by many people, please don't let it die. If you have
> nobody to take care of it, give it to me.

As indicated in Patricks mail, there's a 30 day grace period.  Until
then the original authors (if they care) or other people can take
maintenance for individual patchlets and send us URL's to those
repositories.  We will add them to our list file, and distribute a
'runme' script which downloads those repositories off the net.

If you want to help, I suggest to wait for those patchlets that nobody
takes care of, and run a repository for them.

Also, I assume that there is a lot that can be done to improve that
patchlet-handling script, i.e. add suport for GPG signature checking and
the like.  I suggest you coordinate with Patrick on this.

If any of the 'patchlet maintainers' require a place where they can put
repositories online via http/ftp, please let me know, we have
people.netfilter.org accounts exactly for this purpose.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--ALfTUftag+2gvp1h
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2.2 (GNU/Linux)

iD8DBQFENMSyXaXGVTD0i/8RAt6NAJ9b+Y8FfdChpogW7pCZxQYL5pNSWACePQg+
RkakRUdD4bPBUJFRWWhA+UM=
=9EUq
-----END PGP SIGNATURE-----

--ALfTUftag+2gvp1h--
