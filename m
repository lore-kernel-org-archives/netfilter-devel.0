From: Harald Welte <laforge@gnumonks.org>
Subject: Re: performance issues (nat / conntrack)
Date: Sat, 22 Jun 2002 18:51:50 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020622185150.D31606@sunbeam.de.gnumonks.org>
References: <027b01c21893$72bbe1d0$0289cb8a@etbx180>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="osDK9TLjxFScVI/L"
Cc: <netfilter-devel@lists.samba.org>
Return-path: <netfilter-devel-admin@lists.samba.org>
To: "Jean-Michel Hemstedt" <jean-michel.hemstedt@alcatel.be>
Content-Disposition: inline
In-Reply-To: <027b01c21893$72bbe1d0$0289cb8a@etbx180>; from jean-michel.hemstedt@alcatel.be on Thu, Jun 20, 2002 at 09:48:27PM +0200
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--osDK9TLjxFScVI/L
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 20, 2002 at 09:48:27PM +0200, Jean-Michel Hemstedt wrote:
> dear netdevels,
>=20
> I'm doing some tcp benches on a netfilter enabled box and noticed
> huge and surprising perf decrease when loading iptable_nat module.=20

Sounds as expected.

> - ip_conntrack is of course also loading the system, but with huge memory
> and a large bucket size, the problem can be solved. The big issue with
> ip_conntrack are the state timeouts: it simply kill the system and drops
> all the traffic with the default ones, because the ip_conntrack table
> becomes quickly full, and it seems that there is no way to recover from
> that  situation... Keeping unused entries (time_close) even 1 minute in
> the cache is really not suitable for configurations handling (relatively)
> large number of connections/s.=20

what is a 'relatively' large number of connections? I've seen a couple
of netfilter firewalls dealing with 200000+ tracked connections.

> o The cumulative effect should be reconsidered.

could you please try to explain what you mean?

> o Are there ways/plans to tune the timeouts dynamically? and what are
>   the valid/invalid ranges of timeouts?

No, see the mailinglist archives for th reason why.

> o looking at the code, it seems that one timer is started by tuple...
>   wouldn't it be more efficient to have a unique periodic callback
>   scanning the whole or part of the table for aged entries?

I think somebody (Martin Josefsson?) is currently looking into optimizing

> - The annoying point is iptable_nat: normally the number of entries in
> the nat table is much lower than the number of entries in the conntrack
> table. So even if the hash function itself could be less efficient than
> the ip_conntrack one (because it takes less arguments: src+dst+proto),
> the load of nat, should be much lower than the load of conntrack.
> o So... why is it the opposite??

? What 'nat table' are  you talking about?  Do you understand how NAT
works and how it interacts with connection tracking?

> o Are there ways to tune the nat performances?

no. NAT (and esp. NAT performance) is not a very strong point of netfilter.
Everybody agrees that NAT is evil and it should be avoided in all circumsta=
nces.
Rusty didn't want to become NAT/masquerading maintainer in the first place,
but rather concentrate on packet filtering.

The NAT subsystem has a number of shortcomings, some of which have been=20
fixed, other still remain. =20

> - Another (old) question: why are conntrack or nat active when there are
> no rules configured (using them or not)? If not fixed it should be at
> least documented...=20

This is standard behaviour.  Does your network driver unload if you=20
'ifconfig down' an interface?  Does a TC qdisc module unload if you=20
delete all instances of the queue?

conntrack is _not_ related/intermangled with iptables at all.  Conntrack
does not know if anybody is using conntrack state in the system.

> Somebody doing "iptables -t nat -L" takes the risk
> of killing its system if it's already under load...=20

?  Please explain why. I see no reason for this.

> In the same spirit,
> iptables -F should unload all unused modules (the ip_tables modules=20
> doesn't hurt). Just one quick fix: replace the 'iptables' executable by
> one 'iptables' script calling the exe (located somewhere else) and=20
> doing an rmmod at the end...

no. this is considered a feature. The current [and past] behaviour is wanted
like this by design.

> -jmhe-

--=20
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
GCS/E/IT d- s-: a-- C+++ UL++++$ P+++ L++++$ E--- W- N++ o? K- w--- O- M+=
=20
V-- PS++ PE-- Y++ PGP++ t+ 5-- !X !R tv-- b+++ !DI !D G+ e* h--- r++ y+(*)

--osDK9TLjxFScVI/L
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD4DBQE9FKslXaXGVTD0i/8RAvA6AJQKxzbX6Bik9FfDwJTL3vxK1QnIAJ4jbJsf
m/u/bxa3Jt4q7xTG+RhCfA==
=oO/m
-----END PGP SIGNATURE-----

--osDK9TLjxFScVI/L--
