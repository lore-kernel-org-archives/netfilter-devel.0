From: Stephen Frost <sfrost@snowman.net>
Subject: Re: rp_filter
Date: Sun, 29 Dec 2002 12:28:53 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021229172852.GM677@ns>
References: <20021227211113.GK677@ns> <20021228084614.GB440@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oplxJGu+Ee5xywIT"
Cc: Netfilter Developers <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick Schaaf <bof@bof.de>
Content-Disposition: inline
In-Reply-To: <20021228084614.GB440@oknodo.bof.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--oplxJGu+Ee5xywIT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

* Patrick Schaaf (bof@bof.de) wrote:
> Stephen,
>=20
> >   Can we *please* move the rp_filter cruft into the firewalling code
> >   proper?
>=20
> If that's not a joke, please take your cruisade to the linux-net mailing
> list. It is not up to netfilter / iptables developers to even think
> about removal of base network stack features, in my opinion. Convince
> Dave Miller and Alexey Kusnetsov (speling probably wrong, sorry).
>=20
> I'll refrain from speaking against the idea itself, here.

If we had the functionality in netfilter to do what rp_filter does now I
think it'd make for a much better case to get rid of it as it exists.
For that I think we'd need a match target that checked source IP and
incoming interface and compared it against the routing table.  Not
something I'd expect to be very difficult...

I'll see about bringing it up on the linux-net list if this seems like a
reasonable thing to add to netfilter.  I certainly agree about one of
the problems with rp_filter being that it's not noisy about things it
drops (by default at least, I think there may be an option to turn on
logging of it).  It would seem reasonable to me to have the parts of the
kernel that drop packets following some administrative rule be under the
firewalling framework instead of elsewhere throughout the kernel.

	Stephen

--oplxJGu+Ee5xywIT
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE+DzDUrzgMPqB3kigRAvYEAJ4gg5vXM17fc6n43M6dX2mqp1GEqACeOXFq
So1X0+hyMBvrIxuZ2j440CU=
=DjqN
-----END PGP SIGNATURE-----

--oplxJGu+Ee5xywIT--
