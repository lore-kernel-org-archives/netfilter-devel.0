From: Christophe Saout <christophe@saout.de>
Subject: 2.6.16-rc1-mm3 XFRM+NAT issue
Date: Sun, 29 Jan 2006 20:41:49 +0100
Message-ID: <1138563710.26998.22.camel@leto.intern.saout.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-145nAqMTCx/eFq7yHAht"
Cc: Patrick McHardy <kaber@trash.net>, Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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


--=-145nAqMTCx/eFq7yHAht
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

I'm very glad that you found some time to get these patches into the
mainline kernel. Unfortunately I think I'm running into a case where
it's not working (it's working with 2.6.12 + the old unofficial IPSEC
+NAT patches).

          .--- gateway host ---.            .-- pub. host -.
priv net -|NAT + IPSEC endpoint|- internet -|IPSEC endpoint|
          '--------------------'            '--------------'

ping ----->---*NAT*---*XFRM*********>*********XFRM*--------.
                                                           v
                   ???.....*********<*********XFRM*- pong -'

Without IPSEC turned on I can reach the host on the far right from any
host in the private network on the left without problem. The private
address is source-NATted (masqueraeded) at the gateway.

When turning on the IPSEC connection between the gateway and the
internet host, the host in the private network can't reach the internet
host (on the right) anymore. It's still reachable from the gateway
itself though.

When pinging from the host behind the gateway the packet passes through
the gateway, gets to the internet host, which responds to the ping and
sends an encrypted packet back through the IPSEC connection which then
arrives at the gatway. But then the gateway simply ignores the packet
instead of decapsulating and DNATting it back to the host in the private
network. At least that's what I can gather from tcpdump. If I run
tcpdump on ppp0 on the gateway I can see encrypted packets go out to the
host on the right and encrypted packets coming back and that's it.

I couldn't exactly keep track with all the changes since 2.6.12 and I
was hoping that this kernel would just work and fulfill my needs... and
I still don't really "get" the networking stack I have no clue where to
start looking what could go wrong.

So, do you perhaps have any ideas?


--=-145nAqMTCx/eFq7yHAht
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Dies ist ein digital signierter Nachrichtenteil

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQBD3Rp9ZCYBcts5dM0RAiOlAJ4qPSCN9hKw9Ii+/d+AZoZA8ZhlRgCgjU4p
v/Vdz3ehRe2AGs/cZwIXYbI=
=nAzT
-----END PGP SIGNATURE-----

--=-145nAqMTCx/eFq7yHAht--
