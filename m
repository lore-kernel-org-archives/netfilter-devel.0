From: Harald Welte <laforge@netfilter.org>
Subject: nf_debug = 0 in arp.c and IPVS (Re: Fw: [PATCH] Fix of wrong ipt
	debug messages)
Date: Thu, 2 Sep 2004 13:09:05 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <20040902110905.GD26263@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="w2JjAQZceEVGylhD"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Content-Disposition: inline
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--w2JjAQZceEVGylhD
Content-Type: multipart/mixed; boundary="wtjvnLv0o8UUzur2"
Content-Disposition: inline


--wtjvnLv0o8UUzur2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

wrong address of netfilter-devel in original mail...

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--wtjvnLv0o8UUzur2
Content-Type: message/rfc822
Content-Disposition: inline

Date: Thu, 2 Sep 2004 12:14:52 +0200
From: Harald Welte <laforge@netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
Cc: netfilter-devel@netfilter.org, wensong@linux-vs.org
Subject: nf_debug = 0 in arp.c and IPVS (Re: Fw: [PATCH] Fix of wrong ipt
	debug messages)
Message-ID: <20040902101452.GC26263@sunbeam.de.gnumonks.org>
References: <20040831134846.1d990c61.davem@davemloft.net>
	<20040831213623.GP5824@sunbeam.de.gnumonks.org>
	<20040831230845.1e7f65b8.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tVmo9FyGdCe4F4YN"
Content-Disposition: inline
In-Reply-To: <20040831230845.1e7f65b8.davem@davemloft.net>
User-Agent: Mutt/1.5.6+20040818i


--tVmo9FyGdCe4F4YN
Content-Type: multipart/mixed; boundary="+KJYzRxRHjYqLGl5"
Content-Disposition: inline


--+KJYzRxRHjYqLGl5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 31, 2004 at 11:08:45PM -0700, David S. Miller wrote:
=20
> > > This patch fixes wrong ipt debug messages.
> > > The problem is that when CONFIG_NETFILTER_DEBUG is set,
> > > parp_redo() can flood debug output like this:
> >=20
> > I'm fine with this change, feel free to apply it (2.4.x and 2.6.x), Dav=
e.
>=20
> I thought about this change some more, and wouldn't a call
> to nf_reset() be more appropriate?

Indeed. It's not that much of a practical problem, since there is no
connection tracking for arp packets... so whether we drop the nfct
reference or not doesn't matter.

But in principle nf_reset() is more apropriate, since we re-submit the
packet to the stack, and it will re-iterate the netfilter hooks (where
in theory some not-existing-yet connection tracking module could be attache=
d).

Please find the attached (untested) patch.
=20
> There are other places that explicitly clear nf_debug which also
> should probably be nf_reset() calls, all the IPVS xmit routines
> for example.

Mh, as I can see, the nf_debug statements are always followed by an
unconditional IP_VS_XMIT, which  has the packet iterate the LOCAL_OUT
hook, thus any netfilter modules thinking of it being a locally-created
packet.  Therefore, it cannot belong to the previous, old connection but
rather is part of a new connection.

I guess all IPVS users won't be using connection tracking - since the
whole reason for IPVS' own state tracking was that ip_conntrack was
apparently too slow for their purpose.=20

But if somebody would try to use IPVS and ip_conntrack on the same
machine, he would definitely run into the check we do at
ip_conntrack_in():

        /* Previously seen (loopback or untracked)?  Ignore. */
	        if ((*pskb)->nfct)
	                return NF_ACCEPT;

Where the packet bypasses all of conntrack and just appears like it
belongs to the original connection.   While those semantics might seem
as apropriate as seeing two different connections, the current mode of
operation clashes with any state-based operations, especially
iptable_nat.

While again I find it a very hypothetical setup (combining ip_conntrack,
iptable_nat and ipvs on one box), to me it is a bug.  IPVS should be
calling nf_reset instead of their nf_debug=3D0 statements.

It won't hurt them, since nf_reset is inlined, and as long as any sane
user doesn't load ip_conntrack at the same time, there is no additional
performance penalty.

btw: Just tried to find a MAINTAINERS entry for IPVS, but there
apparently is none.  Anybody from the IPVS team: please add one.

> Comments?

[why do I always feel stupid if I submit something and then you find the
 most obvious errors. *sigh*

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--+KJYzRxRHjYqLGl5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="linux-2.6.8.1-arp-nf_reset.patch"
Content-Transfer-Encoding: quoted-printable

--- linux-old/net/ipv4/arp.c	2004-09-02 12:12:57.000000000 +0200
+++ linux/net/ipv4/arp.c	2004-09-02 12:13:46.000000000 +0200
@@ -695,6 +695,7 @@
=20
 static void parp_redo(struct sk_buff *skb)
 {
+	nf_reset(skb);
 	arp_rcv(skb, skb->dev, NULL);
 }
=20

--+KJYzRxRHjYqLGl5--

--tVmo9FyGdCe4F4YN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFBNvKcXaXGVTD0i/8RAtuUAJ9x6KIREMFdaqLnNE1GgqgjuMwLrwCeNr6k
0R/wB96Am4oX2qXVRIpZPdA=
=PZER
-----END PGP SIGNATURE-----

--tVmo9FyGdCe4F4YN--

--wtjvnLv0o8UUzur2--

--w2JjAQZceEVGylhD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFBNv9RXaXGVTD0i/8RApxdAKCGmMuwAx8IoLMDkZs5W2XV65/r6gCeMHmx
hCxhaztiwPHWZhHI3EFTrts=
=8BN/
-----END PGP SIGNATURE-----

--w2JjAQZceEVGylhD--
