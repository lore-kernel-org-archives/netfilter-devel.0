From: Harald Welte <laforge@netfilter.org>
Subject: Re: NAT problem with related connections
Date: Mon, 3 Nov 2003 12:08:15 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031103110815.GD5081@sunbeam.de.gnumonks.org>
References: <20031103074805.GN1536@sunbeam.de.gnumonks.org> <DAELKAPIKOFAFFKELNHOCEAICAAA.Nikolai.Dahlem@epygi.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YD3LsXFS42OYHhNZ"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Nikolai Dahlem <Nikolai.Dahlem@epygi.de>
Content-Disposition: inline
In-Reply-To: <DAELKAPIKOFAFFKELNHOCEAICAAA.Nikolai.Dahlem@epygi.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--YD3LsXFS42OYHhNZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

[Cc'ing netfilter-devel again, without your attachment]

On Mon, Nov 03, 2003 at 11:15:40AM +0100, Nikolai Dahlem wrote:
> Hi,
>=20
> we talked about the implementation of a conntrack-module for SIP @ linuxt=
ag,
> maybe you remember ...

yes, I do remember the company/domain name 'epygi', but I didn't
remember your name.

> I attached my code, which I just started working on, so its still very be=
ta,
> but at least I managed to make some SIP-calls with it ;-) Main parts are =
not
> implemented: handling of hostnames instead of ips, safely getting
> consecutive ports, SIP-state machine, support for 2 SIP-calls with the
> sample tuple (2 or more phone on one machine using the same server).
> Please tell me what you think of my efforts so far.

I have to be honest that I didn't read the code thoroughly.  But
according to a quick guess, what you are lacking is a call to
ip_conntrack_change_expect() from the nat helper.  The NAT helper has to
alter the expectation raised by conntrack...

See the ftp/irc helpers as an example.

> kind regards
>=20
> Nikolai Dahlem


--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--YD3LsXFS42OYHhNZ
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/pjcfXaXGVTD0i/8RAvN3AJ49ZHzOBxGtK0RA98JDuSFNzKjPywCgjLqr
Y0M6LWdb3O00Sgm8ceuCc94=
=Hw4Z
-----END PGP SIGNATURE-----

--YD3LsXFS42OYHhNZ--
