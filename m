From: Stephen Frost <sfrost@snowman.net>
Subject: Re: Netfilter+IPsec patches
Date: Tue, 17 Aug 2004 22:40:25 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040818024025.GC21419@ns.snowman.net>
References: <20040526033537.GH4402@samad.com.au> <40B53CCE.40704@trash.net> <20040527044613.GC24464@samad.com.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4qnW9meeKZ7ZkKaT"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>,
        Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Content-Disposition: inline
In-Reply-To: <20040527044613.GC24464@samad.com.au>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--4qnW9meeKZ7ZkKaT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

* Alexander Samad (alex@samad.com.au) wrote:
> On Thu, May 27, 2004 at 02:56:46AM +0200, Patrick McHardy wrote:
> > Please give some more details on the configuration, like:
> >=20
> > Are you using NAT ?
> > Are you marking the packets in the mangle table ?
> > Are the packets forwarded when they get out of the tunnel ?
> >=20
> > When you see the packets in the INPUT chain, does their source- and
> > destination address match your policy ?
> I did some futher testing, I was in NAT-T mode, when I removed the
> nat'ing it started to work.

I've run into a rather annoying problem.  I'm not sure if it's due to
the IPSEC patches, but I have some suspicion that it is.  Basically the
story goes like this:

I've got a bunch of network cards in my gateway, in this example we're
concerned w/ 3 of them- two connections to the internet, one internal.
For this to work I have to have source-based routing working (which it
used to, back when I was using 2.4).  It appears to still work fine for
connections which are *not* NAT'd.  For connections which are NAT'd it
goes like this:

eth0 - internet1 (has the 'default' route going out it)
eth1 - internet2 (has a seperate route table w/ a default route)
eth2 - internal

SYN comes in on eth0, NAT'd, goes out eth2, SYN+ACK comes back, that
gets NAT'd and goes out eth0.  All's happy there.

SYN comes in on eth1, NAT'd, goes out eth2, SYN+ACK comes back, that
gets NAT'd to the eth1 address but then gets sent out *eth0* instead.

pings (which aren't NAT'd) to the eth1 address work fine.  So do
traceroute's (again, not NAT'd).  If NAT'ing is turned off and the
machine accepts connections directly then TCP connections also work
fine.

Policy-based routing is in effect, and is working for things which are
not NAT'd.  Things which are NAT'd appear to be going out the main
table's default route though instead of being properly routed.

This is using 2.6.7 w/ recent (week-old) CVS iptables/pom-ng, the=20
IPSEC patches and some others (though *not* the new conntrack code).

Thoughts?

	Thanks,

		Stephen

--4qnW9meeKZ7ZkKaT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFBIsGZrzgMPqB3kigRAqKGAJ4uS9M0Ay/p7CwLcIw9WdpoAOR1xwCfVaGV
JdUbG4vzI3BE0kdSKxHGApM=
=CaqC
-----END PGP SIGNATURE-----

--4qnW9meeKZ7ZkKaT--
