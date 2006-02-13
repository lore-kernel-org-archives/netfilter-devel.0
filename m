From: Harald Welte <laforge@netfilter.org>
Subject: Re: [RFC][LIBNFNETLINK 3/3] API changes
Date: Mon, 13 Feb 2006 12:44:52 +0100
Message-ID: <20060213114452.GY4601@sunbeam.de.gnumonks.org>
References: <43EFAB2A.4030204@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KH9S6eoVXLBawpUJ"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira Ayuso <pablo@eurodev.net>
Content-Disposition: inline
In-Reply-To: <43EFAB2A.4030204@eurodev.net>
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


--KH9S6eoVXLBawpUJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Feb 12, 2006 at 10:39:54PM +0100, Pablo Neira Ayuso wrote:
> This patch introduces the following changes:
>=20
> a) nfnl_handle_msg: this function completes the message iterator API.

looks nice to me.

> b) nfnl_handle_packet: This function is simpler interface to handle a
> netfilter netlink message. It loops over every message contained in a
> packet but, in this case, the programmer has no control on the looping
> process. Moreover, this function now has a done flag that is set under
> the same circunstances exposed above.

this change looks also fine to me, but since it changes an existing
function, it introduces library incompatibility between the users
(libnetfilter_*) and libnfnetlink.

> c) nfnl_communicate: This function supersedes nfnl_listen and nfnl_talk.
> It provides an interface to communicate with the nfnetlink subsystem.

also sound reasonable.

So how do we proceed?

I think at the moment, a new release of [most of] the libraries is
needed due to accumulated bugfixes anyway.  So I'd rather make a
maintainance release with what we've got now than to introduce API
changes.  Addidional API (nfnl_communicate, nfnl_handle_msg) is not a
problem at all.

As for the only API change (nfnl_handle_packet), I would like to know if
there is an urgent need for the 'done' flag in any of the users.

Ideally, I think we would

1) add new API
2) release new libnfnetlink and libnetfilter_* (where needed)
3) convert libnetfilter_* to use new API where reasonable
4) introduce API change to libnetfilter
5) adapt remaining handle_packet useres in libnetfilter* to changed api
6) release all of them together, incompatible with old versions.

Whcih is still messy.  I would actually prefer if we'd not change
existing API but rather only add new API's.  Another alternative might
be symbol versioning, though I've never used that before.

Cheers,
	Harald
--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--KH9S6eoVXLBawpUJ
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFD8HE0XaXGVTD0i/8RAm5dAKCxY3LTbMLqIp0U/NE2R+uXHJnE5gCeMy1u
0rHl++BKMOvcOL0QXDRbqvs=
=cCHm
-----END PGP SIGNATURE-----

--KH9S6eoVXLBawpUJ--
