From: "Preston A. Elder" <prez@srealm.net.au>
Subject: Re: [netfilter-core] iptables/conntrack in enterprise environment.
Date: Fri, 30 May 2003 03:37:56 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200305300338.05101.prez@srealm.net.au>
References: <20030530072818.E2AAB2C053@lists.samba.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Cc: netfilter@lists.netfilter.org,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Rusty Russell <rusty@rustcorp.com.au>
In-Reply-To: <20030530072818.E2AAB2C053@lists.samba.org>
Content-Description: clearsigned data
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

=2D----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On Thursday 29 May 2003 05:08 am, Rusty Russell wrote:
> In message <200305290113.58552.prez@srealm.net.au> you write:
> > We have a system that acts as a router, however any new inbound
> > connection for any machine behind this router is re-directed to a
> > specific port on the local machine, where an application responds as if
> > it were the system behind the router.  These systems experience some ve=
ry
> > high volumes of traffic
>
> Sounds a lot like something is happening to the FIN or RST packets: as
> soon as conntrack sees a FIN or RST, it'll leave ESTABLISHED and
> timeout fairly quickly.
>
> Now, there are several simple things you can do here, as well as
> dropping the ESTABLISHED timeout:
>
> 1) Try 2.4.21-rc5.  The hashing algorithm was markedly improved, which
>    you could well be hitting.
I'll look into this, thanks.

> 2) You set the conntrack_max to 524280, but on a 1GB machine you'll
>    only have about 8192 hash chains, making each chain 64 long.  Up
>    the hashsize module parameter to around 100000 (or edit the kernel
>    source if builtin, sorry).
Already made the hashsize the largest prime less than (524280 / 2), on=20
recommendation from someone on core.

> > We have multiple systems performing this task (essentially for load
> > balancing and to remove a single point of faulure).
>
> Um, how are you load balancing?  Remember, if the connection tracking
> code doesn't see all the packets for a connection, it can't work.
Well, not quite load balancing in that way.  I mean we have a whole mess of=
=20
systems 'behind' the routers, and we're splitting them up, so one router=20
takes portion A, the next takes portion B, etc.  I'm not actually load=20
balancing (ie. distributing between servers realtime), so much as splitting=
=20
the load across servers.

=2D --=20
PreZ
Systems Administrator
Shadow Realm

PGP FingerPrint: B3 0C F3 32 DE 5A 7D 90  26 F6 FA 38 CC 0A 2D D8
=46inger prez@srealm.net.au for full PGP public key.

Shadow Realm, a hobbyist ISP supplying real internet services.
http://www.srealm.net.au
=2D----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE+1wpcKFp14D8AGEQRAv2BAJ9zMkWSacT2Nk0bmjempwGqfOdsIQCcD8PS
WDAt/rDsgN5nHhbufM+FOAY=3D
=3DZzHB
=2D----END PGP SIGNATURE-----
