From: Harald Welte <laforge@netfilter.org>
Subject: Re: [ANNOUNCE] ulogd-1.21 released
Date: Wed, 16 Feb 2005 16:21:23 +0100
Message-ID: <20050216152123.GA3829@sunbeam.de.gnumonks.org>
References: <20050216125634.GT3829@sunbeam.de.gnumonks.org>
	<35925.213.236.112.75.1108560883.squirrel@213.236.112.75>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PeSNlYkxSF9b/2wn"
Cc: ulogd@lists.gnumonks.org,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	netfilter-announce@lists.netfilter.org
To: Martijn Lievaart <m@rtij.nl>
Content-Disposition: inline
In-Reply-To: <35925.213.236.112.75.1108560883.squirrel@213.236.112.75>
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


--PeSNlYkxSF9b/2wn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 16, 2005 at 02:34:43PM +0100, Martijn Lievaart wrote:
> Harald Welte said:
> > Hi!
> >
> > I have released version 1.21 of the iptables userspace logging
> > daemon (ulogd).  This release is a minur bugfix update to the 'brown
> > paper bag' release 1.20. 1.20 was probably one of the last 'new feature'
> > updates for ulogd, since I'm already working on ulogd2, which includes
> > support for plugin stacks, IPFIX and ct_acct.
>=20
> So adding ipv6 support to 1.21 is probably a waste of time...?

I think it's probably not that much of a good idea.  Patches for the
http://svn.gnumonks.org/branches/ulog/ulogd2/ branch are more welcome.

ulogd2 doesn't yet compile, but I think you can try to figure out how to
integrate ipv6 support anyway.

I think the best idea is to do it right and add support for layer 2/3/4
protocols, very much like a real network stack.

this way we can have a single ethernet interpreter for mac addresses, a
ipv4 and ipv6 plugin for the respective headers, and a single tcp (and
udp) plugin that works both on ipv4 and ipv6.

If you have any better ideas, I'm open for suggestions.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--PeSNlYkxSF9b/2wn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFCE2TzXaXGVTD0i/8RAo/SAJkBiFNRHuqlFYYz1HgGQ2PF36iBvwCfSU3K
FgnMW56VBI4T52iU+YgsByQ=
=J/f+
-----END PGP SIGNATURE-----

--PeSNlYkxSF9b/2wn--
