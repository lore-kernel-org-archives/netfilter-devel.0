From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] conntrack-event-api
Date: Wed, 20 Jul 2005 20:15:15 -0400
Message-ID: <20050721001515.GA4384@rama.eicat.ca>
References: <20050719201646.GH3768@rama> <42DD039B.4090207@ufomechanic.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yrj/dFKFPuw6o+aM"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Amin Azez <azez@ufomechanic.net>
Content-Disposition: inline
In-Reply-To: <42DD039B.4090207@ufomechanic.net>
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


--yrj/dFKFPuw6o+aM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 19, 2005 at 02:43:55PM +0100, Amin Azez wrote:

> I'm just trying to understand the basis of this change.
> Is it that:
> 1) a CPU is only processing one SKB at a time

yes.

> 2) then it entirely finishes that SKB before it processes another

no, we can have stuff like ip_queue in between prerouting and
postrouting.   This is why the event cache keeps a pointer to the
connection that it last worked on, and if we enter for a different
connection, it sends out the cached events before dealing with the new.

> 3) and that the event data does not need to persist for the life of the
> conntrack, only the life of that skb

yes, the idea is only to accumulate all the events happening for a
single data packet, instead of sending N events down the notifiers for
every packet.

> Do we see this breaking anytime, perhaps through some extended kernel
> pre-emption trick or something, or is the conntrack stuff here always
> going to run as a bh?

see above, we deal correctly with async handling.

[please don't full-quote patches!]

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--yrj/dFKFPuw6o+aM
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFC3ukSXaXGVTD0i/8RAhkaAKCZz204qY0axtwr2CnArS7kW5QQXQCfYNJZ
EnKqqJpYL84H+tYDvBDwbEg=
=6LIc
-----END PGP SIGNATURE-----

--yrj/dFKFPuw6o+aM--
