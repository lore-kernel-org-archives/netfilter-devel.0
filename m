From: Harald Welte <laforge@netfilter.org>
Subject: DaveM get's removed from Cc (was Re: [PATCH 1/2] string match for
	iptables)
Date: Fri, 26 Aug 2005 15:27:43 +0200
Message-ID: <20050826132743.GZ4226@rama.de.gnumonks.org>
References: <43075517.3070405@eurodev.net> <43075BEA.1030701@trash.net>
	<20050820.131403.37427784.davem@davemloft.net>
	<20050825104258.GU4442@rama.de.gnumonks.org>
	<1124988859.28166.28.camel@localhost.localdomain>
	<1124990355.28166.31.camel@localhost.localdomain>
	<430F0442.5030909@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mF+UrcnZFczIwKjY"
Cc: pablo@eurodev.net, netfilter-devel@lists.netfilter.org,
	Martin Josefsson <gandalf@wlug.westbo.se>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <430F0442.5030909@trash.net>
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


--mF+UrcnZFczIwKjY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 26, 2005 at 02:00:02PM +0200, Patrick McHardy wrote:
> Martin Josefsson wrote:
> > On Thu, 2005-08-25 at 18:54 +0200, Martin Josefsson wrote:
> >=20
> > I wonder why davem got lost on the CC, he's there in my Sent folder but
> > not in the mail I got from netfilter-devel... I hope he makes it this
> > time.
>=20
> Yes, I noticed this multiple times, mails to the list seem to remove
> Dave automatically. Perhaps this has something to do with the
> "may sent to list even if not subscribed" setting that was made
> when he wasn't subscribed to the list.

it's a per-user configuration setting of mailman called "nodupes". =20

If X subscribes to a mailinglist L and sets "nodupes", and Z sends a
message to L with Cc: X, then X will be removed.

DaveM had his netfilter-devel subscription set to "nodupes".  I assume
that was a mistake and have disabled that switch via the admin
interface.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--mF+UrcnZFczIwKjY
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFDDxjPXaXGVTD0i/8RAhJCAKCXG5tE8WBvp+wC1f/v5wP0uN+NsACdFqAk
388iNfBij63w/wto3cvD/Dg=
=intR
-----END PGP SIGNATURE-----

--mF+UrcnZFczIwKjY--
