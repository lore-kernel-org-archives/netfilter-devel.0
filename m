From: Harald Welte <laforge@netfilter.org>
Subject: Re: ctnetlink questions
Date: Tue, 21 Oct 2003 01:09:17 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031020230917.GI20288@sunbeam.de.gnumonks.org>
References: <20031020071545.GA21521@sunbeam.de.gnumonks.org> <3F9426C1.6070908@trash.net> <20031020185258.GD20288@sunbeam.de.gnumonks.org> <3F943CE5.80809@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Q59ABw34pTSIagmi"
Cc: Henrik Nordstrom <hno@marasystems.com>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <3F943CE5.80809@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--Q59ABw34pTSIagmi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 20, 2003 at 09:52:05PM +0200, Patrick McHardy wrote:

> I agree. Removing is not very important. Modifying also requires a way to
> identify the expectation. Currently (as you might have noticed) the
> expectations also include an id. The namespace could probably be smaller
> than for conntracks but I need to think about this some more after catchi=
ng
> breakfast.

yes, I've noted that they also have id's.  However, as you will have
noticed by now, I feel very reluctant to add id's to our structures ;)

> BTW: I thought a bit about userspace helpers, they need to be synchronous
> like they are now so we don't get races were an expectation arrives before
> it's registered. So they should probably receive their packets though
> ip_queue.=20

for local helpers this is true.  But think about even more complex
setups, like the envisioned SIP proxy (that might even run on a totally
different machine than your packet filter).  They are inherently racy -
and there's nothing we can do about that.

> How realistic do you think is it to move ftp/irc/amanda... to
> userspace ? All of them operate on low traffic protocols, but if they sent
> packets to userspace through netlink sockets operation can easily be
> interrupted be sending lots of traffic that will fill up the socket buffe=
r.

yes, that is a problem.  another problem is that there can only be one
userspace process be attached to the queue.  And no, we don't want to
use ipqmpd - that is just a hack and doesn't scale at all.

btw: I already have a patch of a l3 independent queue implementation.
The only problem is that it has to change the packet format - and thus
will introduce incompatibility :(

> I have not studied the code intensively, but can't you just sync the tabl=
es
> in order of the hierachie:
>=20
> conntrack
> conntrack, master-expect, sibling-conntrack, sibling-conntrack, ...
> conntrack
> ...

well, this means I cannot use the existing iterator functions, and
locking might become complex once we have per-bucket locks.

Also, I don't like the idea of hiding too much information in the
packet/message order.  Yes, ordering is guaranteed by the protocol - but
even then...

I'll have to think about that... but now I'm off for some sleep. Maybe
tomorrow ;)

> Best regards,
> Patrick

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--Q59ABw34pTSIagmi
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/lGsdXaXGVTD0i/8RAhfRAKCdQCYQLPlyRDPk5E+GorPdRgDDIACfQrdX
JCIDEagy0YIsytwW7nYN+Lk=
=uZJz
-----END PGP SIGNATURE-----

--Q59ABw34pTSIagmi--
