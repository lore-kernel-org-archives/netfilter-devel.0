From: Harald Welte <laforge@netfilter.org>
Subject: Re: raw table breaks iptables binary compatibility
Date: Sun, 9 Nov 2003 10:32:55 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031109093255.GB1005@sunbeam.de.gnumonks.org>
References: <Pine.LNX.4.44.0311090204280.25676-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GRPZ8SYKNexpdSJ7"
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0311090204280.25676-100000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--GRPZ8SYKNexpdSJ7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Nov 09, 2003 at 02:12:43AM +0100, Henrik Nordstrom wrote:
> I don't quite see why these are required for the 'raw' table. Seems to be=
=20
> related to debugging or error management on rulesets incompatible with=20
> 'raw'. In any case the effect is probably not that desireable from a=20
> p-o-m/base patch..

yes, they are for the 'TRACE' target that is included with the raw
patch.  Initially the patch didn't add these fields, but then jozsef
implemented it for speeding up the logging of rule numbers.

Jozsef: could you split out the raw.patch in=20

a) one that just adds the table (and the NOTRACK target)
b) another one that adds the TRACE target (and thus depends on the LOG chan=
ges)

this way we should be able to have a clean raw.patch that can go
upstream pretty soon (for NOTRACK which a lot of people want).

thanks.

> Regards
> Henrik

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--GRPZ8SYKNexpdSJ7
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/rgnHXaXGVTD0i/8RAl0zAJ9TIxBj2SStflwuJZu1ysCUBHnrgACfdmz7
8QJtbJRbtyHXDt6WjRLsH6w=
=tA6P
-----END PGP SIGNATURE-----

--GRPZ8SYKNexpdSJ7--
