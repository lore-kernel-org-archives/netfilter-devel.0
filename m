From: Harald Welte <laforge@gnumonks.org>
Subject: Re: PPTP connection tracker
Date: Sat, 26 Jul 2003 00:40:10 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030725224010.GG14321@naboo>
References: <200307211915.23035.jjackson@vortech.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="G6nVm6DDWH/FONJq"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Joshua Jackson <jjackson@vortech.net>
Content-Disposition: inline
In-Reply-To: <200307211915.23035.jjackson@vortech.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--G6nVm6DDWH/FONJq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 21, 2003 at 07:15:23PM -0400, Joshua Jackson wrote:
> Greetings,
>=20
> Just curious if you have had any feedback on the PPTP connection
> tracking code in the 20030107 patch-o-matic.  I implemented it in a
> firewall product of mine for a while and had numerous complaints that
> all PPTP connectivity through the firewall was broken.

without a verbose description about the exact problem, I cannot debug
the problem.  I need to know

- client and server OS/version
- information about the network
- configuration of the PPTP-related ruleset
- log of erroneously dropped packets (if any)
- behaviour of expectations and GRE entries in /proc/net/ip_conntrack
  while session was established
- probably also packet dumps/traces (tcpdump, ethereal) needed.

> I have removed the code from the kernel for now, but still get a lot of=
=20
> complaints about only being able to use a single PPTP session.

of course, since you cannot support more than one session without the
PPTP helper.

> If there have been any updates to this code, is there a place I can downl=
oad=20
> it?

yes, check out patch-o-matic from CVS, or go to
http://netfilter.org/documentation/pomlist/pom-extra.html#pptp-conntrack-nat


> Joshua Jackson
> Vortech Consulting
> http://www.vortech.net

--=20
- Harald Welte <laforge@gnumonks.org>               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
Programming is like sex: One mistake and you have to support it your lifeti=
me

--G6nVm6DDWH/FONJq
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE/IbHJXaXGVTD0i/8RApA3AJ9r54dC9tiiNQmXInbdMltdJhKL3wCeJXcy
gb9ZlQ1wgUcExGDhW4I97UM=
=exdr
-----END PGP SIGNATURE-----

--G6nVm6DDWH/FONJq--
