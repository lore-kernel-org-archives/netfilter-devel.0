From: Harald Welte <laforge@netfilter.org>
Subject: Re: New logging module
Date: Fri, 12 Sep 2003 22:39:07 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030912203907.GC4398@obroa-skai.de.gnumonks.org>
References: <20030905140435.GI1597@obroa-skai.de.gnumonks.org> <Pine.LNX.4.44.0309060259570.4937-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yVhtmJPUSI46BTXb"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0309060259570.4937-100000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--yVhtmJPUSI46BTXb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Sep 06, 2003 at 03:13:08AM +0200, Henrik Nordstrom wrote:
> On Fri, 5 Sep 2003, Harald Welte wrote:

Sorry for my late reply.

> > 3) as part of ip_conntrack
> >=20
> > this means that every struct ip_conntrack gets two byte counters (one
> > for each direction).  when a connection is terminated, you send the
> > accounting information about this connection to usrerspace (preferrably
> > via netlink).   you can sum up traffic for certain ports / addresses in
> > userspace.
>=20
> 3 looks very intersting and is something which we have been thinking we
> need for a long time to implement meaningful accounting in a
> iptables+conntrack+NAT based firewall.
>=20
> What we have considered to log from conntrack is maybe a little more than
> described above:
>=20
> 1. Start of session

have you seen the last ctnetlink  changes from Patrick McHardy?  He
already has a event interface where you can receive notifications about
state changes (creation/deletion/...)

> 2. Periodically while the conntrack session is active (preferably=20
> by a configurable interval)

this would be something new.  Does this have to be event-based from the
kernel?  Why can't you just periodically dump the whole table via GET
requests from userspace?

> 3. End of session

again covered by patrick's event code.  If you send the whole conntrack
for every event (start/stop of session), the counters would be included.

> with byte and packet counters in both directions.

> Do you know if anyone else is attempting to do this?  If not we might give
> it a stab shortly..

no, I am not aware of any ongoing effort.  If you would dig into this,
it would be greatly appreciated.

Please make sure that struct ip_conntrack is layed out in a way that all
writeable parts (timer, counters) are packed together in the same
cacheline. this way we don't get cache ping-pong for the whole
structure.

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

--yVhtmJPUSI46BTXb
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE/Yi7qXaXGVTD0i/8RAmRRAJ4/XuIzNv2vX5XUgsZDAB3s59phZQCff0t1
KlAS4OrxaQvUyoOWa/QlEu4=
=+Grl
-----END PGP SIGNATURE-----

--yVhtmJPUSI46BTXb--
