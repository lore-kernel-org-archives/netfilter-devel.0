From: Harald Welte <laforge@netfilter.org>
Subject: Re: Fw: [Bug 133788] New: ip_conntrack_in: Frag of proto 17
Date: Wed, 29 Sep 2004 12:11:08 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <20040929101108.GO31674@sunbeam.de.gnumonks.org>
References: <20040928130512.57479400.davem@davemloft.net>
	<20040928220532.GN29961@sunbeam.de.gnumonks.org>
	<4159F559.3040400@trash.net>
	<20040929074328.GB31674@sunbeam.de.gnumonks.org>
	<Pine.LNX.4.61.0409291038080.11661@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="s9kDAZ2EyO0AcRYa"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0409291038080.11661@filer.marasystems.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--s9kDAZ2EyO0AcRYa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 29, 2004 at 10:41:31AM +0200, Henrik Nordstrom wrote:

> will get fragmented (by conntrack) and then reinjected..  has it been=20
> fixed so the reinjected traffic (which is the same skbuff) has it's=20
> conntrack state cleared?

no, the nfct remains the same, so we just ignore it from conntrack point
of view (NF_ACCEPT very early, see patrick's patch).

> I remember this issue coming up before wrt NAT where loopback packets wer=
e=20
> seen as NEW twice, but I don't remember what the fix was.

No, this shouldn't happen (now anymore?), since the nfct of
LOCAL_OUT/POST_ROUTING is still present in PRE_ROUTING/LOCAL_IN.

I am not sure whether we can make this 'optimiziation'.  Thinking of TCP
window tracking and someone having packet filter rules for the loopback
device...  But at the moment I cannot think why conntrack'ing the packet
twice would make any difference at all.

NAT on loopback connections.  *sigh*.  I think this is beyond my
imagination at this point.

Most firewalls I've deployed have NOTRACK rules for loopback traffic, so
I tend not to see those issues.

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

--s9kDAZ2EyO0AcRYa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFBWoo8XaXGVTD0i/8RAov1AKCjOBOq1h1SsOBYG8bbIjHnGGlWKwCfRQjF
s9N4CPkmTLloo1A29h9AU8M=
=IJpe
-----END PGP SIGNATURE-----

--s9kDAZ2EyO0AcRYa--
