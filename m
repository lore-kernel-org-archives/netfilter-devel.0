From: Harald Welte <laforge@netfilter.org>
Subject: Re: NAT before IPsec with 2.6
Date: Tue, 27 Jan 2004 11:39:18 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040127103917.GC11761@sunbeam.de.gnumonks.org>
References: <20040124082252.GA19035@alpha.home.local> <Pine.LNX.4.44.0401241015470.32723-100000@filer.marasystems.com> <20040124092721.GA19140@alpha.home.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TiqCXmo5T1hvSQQg"
Cc: Henrik Nordstrom <hno@marasystems.com>,
	Tom Eastep <teastep@shorewall.net>, Michal Ludvig <mludvig@suse.cz>,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Willy Tarreau <willy@w.ods.org>
Content-Disposition: inline
In-Reply-To: <20040124092721.GA19140@alpha.home.local>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--TiqCXmo5T1hvSQQg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jan 24, 2004 at 10:27:21AM +0100, Willy Tarreau wrote:
> On Sat, Jan 24, 2004 at 10:21:12AM +0100, Henrik Nordstrom wrote:
> =20
> > These hooks have not yet been done, mostly because nobody has contribut=
ed
> > the code adding these hooks to the new IPSec implementation in a=20
> > reasonable manner I guess.
>=20
> OK, that's good news. At first, I thought that people were against this
> mode of operation. This is now just a matter of time for anyone of us to
> understand how to add the hooks and send a patch ! I wish I add time...

I have to agree with Henrik.  Once there is an implementation that the
netfilter core team is happy with, we're certainly going to push very
hard to include this in the mainstream kernel.

I have to admit that I haven't yet found a 'perfect' solution of that
problem - but I'm following the ongoing discussion.

JFYI: I really don't like the 'postrouting called twice' solution.  This
violates one of the core basics of netfilter/iptables so far.

I also disagree that an ESP packet should be trated as locally
generated (and thus iterate over OUTPUT).   From my perspective, locally
generated means more something like: sent via a local userspace process
using PF_INET sockets.  If we consider a packet after any kind of change=20
as locally-generated, we could argue doing this with NAT'ed packets,
too.  Please try to convince me, if I'm missing some point.

One of the fundamental principles behind netfilter/iptables, especially
NAT, is it's symmetric behaviour (between incoming and outgoing packets,
between the hooks, ...).   So with any possible solution, this should be
kept in mind.

Also, I could expect way more headaches with regard to NAT of IPsec
encapsulated packets.  NAT is based on connection tracking and thus
connection tracking has to be fully compatible with the 2.6.x IPsec
implementation.

Right now, conntrack doesn't even notice that there are ESP/AH packets.
PREROUTING creates a new conntrack for the unencapsulated packet.  Later
the packet is encapsulated, and confirmed at POSTROUTING time [where it
is still the same skb, but one should argue whether that ESP packet
really belongs to the original connection].

My proposal:
=46rom conntracks view (and thus from NAT view), there (shuld be?) two
seperate connections for any given to-be-encapsulated packet:

- the payload connection (tcp/udp/whatever)
	- conntrack entry created at PREROUTING
	- conntrack entry confirmed (put in hash) at XXX
- the AH/ESP connection=20
	- conntrack entry created at YYY
	- conntrack entry confirmed at POSTROUTING

To do this, somewhen between esp_output() is called and the beginning of
the modification of the packet payload, we need to call
nf_hook(POST_ROUTING).  This way, conntrack would be able to put the
connection in the hash, and people can do SNAT-like operations in
nat->POSTROUTING.  We could even pass a dummy output device structure
with an interface name "esp" so people can SNAT everything heading for
esp encapsulation.

As for the AH/ESP connection, this has to be created just after the
packet was encapsulated.  We need ot clear skb->nfct (and drop refcount
to old conntrack) after encapsulation, and call nf_hook(PRE_ROUTING).

The then-encapsulated packet will then finally go via the traditional
ipv4 stack and come to the POST_ROUTING hook, where the ESP connection
can be confirmed.

This should solve all our NAT problems for free, shouldn't it?

> Regards,
> Willy

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--TiqCXmo5T1hvSQQg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQFAFj/VXaXGVTD0i/8RAr8qAJ9BvzE0sBg5B2tu87HtJF+PDPysxgCfa3Dg
coP2zm8K5oYcjR0cKdcWJ8Q=
=lYAD
-----END PGP SIGNATURE-----

--TiqCXmo5T1hvSQQg--
