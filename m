From: Harald Welte <laforge@netfilter.org>
Subject: Re: Accessing iptables from within an application...
Date: Wed, 26 Mar 2003 15:53:19 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030326145319.GT21953@sunbeam.de.gnumonks.org>
References: <Pine.LNX.4.44.0303152146460.20889-100000@peter.stamf.pr.at>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NKtYx2Ppz7d1tORf"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Peter Stamfest <peter@stamfest.at>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0303152146460.20889-100000@peter.stamf.pr.at>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--NKtYx2Ppz7d1tORf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Mar 15, 2003 at 10:05:51PM +0100, Peter Stamfest wrote:
=20
> The problem now is quite obvious: How to access module specific=20
> iptables extension information ("-m")? I stumbled across the "save" metho=
d=20
> in the iptables modules, but this prints to stdout. Is there any similar=
=20
> mechanism to get the same information in some other form? Even a "sprintf=
"=20
> based solution would be OK in addition to the "printf" version to have th=
e=20
> info in a character buffer, ready to send via SNMP....
>=20
> If anything of this makes any sense to you: Is there any such interface=
=20
> that I simply missed?

no.  There is no API outside the iptables command to access this
information.  We've discovered this as a design mistake, but fixing this
requires the whole architecture to change.

> And another question: When using the libiptc library, I need to call=20
> iptc_init(tablename). How can I free the data structure I obtain through=
=20
> this call when I no longer need it? I guess a simple "free" won't do the=
=20
> trick?

no.  libiptc is not designed as a public interface.  It has even lots of
known memory holes (see the list archives).

> thanks in advance
> peter

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--NKtYx2Ppz7d1tORf
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+gb7fXaXGVTD0i/8RAjXvAJ4uD2CiAZv009m8i99iiwR0R4I+2QCfa33C
1xpx9PW7xmvqMhULCkcV+aM=
=JELA
-----END PGP SIGNATURE-----

--NKtYx2Ppz7d1tORf--
