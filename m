From: Harald Welte <laforge@netfilter.org>
Subject: Re: NAT problem with related connections
Date: Mon, 3 Nov 2003 16:39:42 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031103153941.GF5081@sunbeam.de.gnumonks.org>
References: <20031103110815.GD5081@sunbeam.de.gnumonks.org> <DAELKAPIKOFAFFKELNHOGEAICAAA.Nikolai.Dahlem@epygi.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mR8QP4gmHujQHb1c"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Nikolai Dahlem <Nikolai.Dahlem@epygi.de>
Content-Disposition: inline
In-Reply-To: <DAELKAPIKOFAFFKELNHOGEAICAAA.Nikolai.Dahlem@epygi.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--mR8QP4gmHujQHb1c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 03, 2003 at 01:28:29PM +0100, Nikolai Dahlem wrote:
> -----Original Message-----
> From: Harald Welte [mailto:laforge@netfilter.org]
> Sent: Montag, 3. November 2003 12:08
> To: Nikolai Dahlem
> Cc: Netfilter Development Mailinglist
> Subject: Re: NAT problem with related connections
>=20
> On Mon, Nov 03, 2003 at 11:15:40AM +0100, Nikolai Dahlem wrote:
> >> we talked about the implementation of a conntrack-module for SIP @
> linuxtag,
> >> maybe you remember ...
>=20
> >yes, I do remember the company/domain name 'epygi', but I didn't
> >remember your name.
> I'm the inconspicuous student ;-)
>=20
> >I have to be honest that I didn't read the code thoroughly.  But
> >according to a quick guess, what you are lacking is a call to
> >ip_conntrack_change_expect() from the nat helper.  The NAT helper has to
> >alter the expectation raised by conntrack...
> >See the ftp/irc helpers as an example.
>=20
> do I have to change the expectation, if I inserted a complete tuple in
> conntrack ?

a conntrack helper should just insert the tuple provided by the protocol
payload (SIP/sdp).  The nat helper then changes the protocol payload
(i.e. the IP address / port number) inside the master connection, and
has to alter the expectation accordingly.

> SIP provides all the information, so I thought why not fill the complete
> tuple or is this completely wrong ?

take the example of FTP (more common, and I already forgot most SIP
relevant stuff):

client: 1.2.3.4, firewall: 10.20.30.40, ftp-server: 9.9.9.9

packet received: client -> server PORT 1,2,3,4,5,6
	- conntrack helper raises expectation 9.9.9.9:any->1.2.3.4:(5<<16 & 6)
	- nat helper alters packet payload to PORT 10,20,30,40,5,6
	- nat helper alters expectation to 9.9.9.9:any->10.20.30.40:(5<<16 & 6)

> kind regards
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

--mR8QP4gmHujQHb1c
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/pna9XaXGVTD0i/8RAvRPAJ9tbFM0WF6dh363tt1MO/NN/rPGXACggmXh
q7JCWwup3HUUMJXr6J3xgOQ=
=SCuD
-----END PGP SIGNATURE-----

--mR8QP4gmHujQHb1c--
