From: Harald Welte <laforge@netfilter.org>
Subject: Re: the solution to synflood on netfilter
Date: Fri, 26 Dec 2003 09:17:52 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031226081752.GB9391@obroa-skai.de.gnumonks.org>
References: <200312251800109.SM00864@zhengcb>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0ntfKIWw70PvrIHh"
Cc: "netfilter-devel@lists.netfilter.org" <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: ?????? <zhengcb@netpower.com.cn>
Content-Disposition: inline
In-Reply-To: <200312251800109.SM00864@zhengcb>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--0ntfKIWw70PvrIHh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 25, 2003 at 06:11:38PM +0800, ?????? wrote:
>=20
> One is to intercepts the syn packets between the client and the
> server. The firewall sends a syn/ack packet to the client on behalf of
> the server when it receives a syn packet. If the firewall received the
> Ack from the client,it will start another 3-way handshake with the
> server. If not, the connection will be timeout on the firewall,=20
> without influncing on the server.

I think this is definitely not something that should be implemented in a
router/packet filter.  This behaviour simulates the 'server' end is
located on the packet filter.  Thus it should be done in an
application-layer [transparent] proxy.

In fact, a couple of people (including Marc Boucher and Lennert
Buytenhek) have proposed an extension to the linux socket API in order
to make such implementation possible as a transparent proxy. =20
http://www.netfilter.org/documentation/events/netfilter-ws-2001-summary.txt=
&e=3D7418

> The other way is the firewall forward all the syn packets to the
> server. After get the syn/ack from the server, the firewall sends a
> ack to the server on behalf of the client, so that the connection on
> the server is removed from the half-opened queue immediately.  The if
> the ack from the client is received, the connection on the firewall is
> validated.  If not, the connection is timeout. And firewall sends a
> rst to the server.

So then, instead of having all connections in the half-open queue, you
will end up having them as real (stale) connections.  I doubt this will
decrease the load on the to-be-protected server in any way.

> I think it is possible to implement some methods similar to that on Check=
point
> in netfilter.=20

Of course it is possible to implement both of them with netfilter.
However, I think from past discussions it is quite clear that the core
team would never support such a 'solution' going into the mainstream
kernel.  This is, to speak in words of David Miller, a 'quality of
implementation' issue.

I think there is a clear line we really don't want to cross.  Such
awkward breakage of end-to-end and protocol transparency is just not
what we think should be deployed on the internet.=20

Yes, we have nasty things like sequence-number-offset's on the fly, and
packet resizing within a TCP stream.  But that's only in the NAT code.
Nowhere in connection tracking or iptables you can find a behaviour like
that.

I think somebody who 'just' wants to use a packet filter should not have
his firewall produce such protocol breakage.

> Then synflood could be prevented with a netfilter firewall.

I think there is only a very little number of real-world cases where you
can 'prevent' such a flood.  In 99% of all cases I've seen, the firewall
or the uplink bandwidth is the bottleneck.  So the only case where you
could do something about syn flood is, if:

1) your attacker is not able to fill your uplink bandwidth with packets
2) your packet filter is able to deal with more pps than the protected
server

Especially case number 2 is not always true.  People tend to use old=20
used desktop or server machines as packet filter.   This will work for
normal usage traffic, but not if the pps rate is increasing (as it is
the case with any small-packet flood).

If your packet filter is able to deal with the full upplink wire speed of s=
mall
64-byte-packets, then I would recommend using something like the
dstlimit match.

Not to forget:  Most people actually artificially introduce a DoS
vulnerability by implementing static syn-rate limiting.  They limit the
number of syn packets per timeframe to a rate lower than their protected
server would be able to deal with... and thus artificially lower the
connection rate.  As soon as they run into the limiter, they would start
throwing away 'real' connection requests as well as the flood, thus
preventing legitimate users of their service.

I'm curious for your reply :)

> regards,
> Jack Zheng
> zhengcb@netpower.com.cn
--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--0ntfKIWw70PvrIHh
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/6+6vXaXGVTD0i/8RAvcXAKCuVarJ0WRK4YPSw1CzV5HqHwsFXACeP37e
eGHdJ75e103z3IGaJA9vO3w=
=PELT
-----END PGP SIGNATURE-----

--0ntfKIWw70PvrIHh--
