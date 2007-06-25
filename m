From: Tomas Mandys <tomas.mandys@2p.cz>
Subject: Re: Changing source/destination address for local packets
Date: Mon, 25 Jun 2007 18:56:20 +0200
Message-ID: <200706251856.21115.tomas.mandys@2p.cz>
References: <200706251758.00586.tomas.mandys@2p.cz>
	<467FE8A1.6030905@trash.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Cc: Patrick McHardy <kaber@trash.net>
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <467FE8A1.6030905@trash.net>
Content-Disposition: inline
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

Dne pond=C4=9Bl=C3=AD 25 =C4=8Derven 2007 18:09 Patrick McHardy napsal(a):
> Tomas Mandys wrote:
> > Hi,
> > I playing in my RTPPROXY module (finally almost ready) with change of
> > source and destination addresses. It works but there is problem when is
> > changed address for locally generated packets to another local address.
> >
> >
> > IP: 192.168.1.1
> > UDP packet:  192.168.1.1:10000  -->  192.168.1.1:50000
> > OUTPUT hook changes destination address (like DNAT) resp. dest port onl=
y:
> > 50000 --> 20000
> > POSTROUTING changes source port (like SNAT): 10000 --> 60000
> > now PREROUTING is called but conntrack (ip_conntrack_get) is related to
> > session 192.168.1.1:10000  -->  192.168.1.1:50000
> > (ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.ip/udp.port) instead
> > address from (*pskb)->nh.iph->daddr (192.168.1.1:60000), pudph->dest
> > (192.168.1.1:20000).
>
> You need to change the conntrack tuples as well if you mangle
> a packet in case you're not using the standard NAT functions
> for this (which you probably should). If you change the destination
> address to a local one you additionally need to perform rerouting
> (you *should* do that whenever you change the destination in OUTPUT,
> but for this case it really is necessary).

I'm changing destination address in OUTPUT resp. destination UDP port only =
in=20
this case, source port will be changed in POSTROUTING. Session#1 is=20
identified by source/dest address before rerouting is done to source2/dest2=
 -=20
this is second session! But when packet leaves POSTROUTING then enters=20
PREROUTING immediately, conntrack high priority callback see =20
(*pskb)->nfct !=3D NULL and won't check IP and provides non corresponding i=
nfo.=20
I must drop such packets because it's confusing.

Note I cannot use NAT it's is different task. There are 2 (conntract) sessi=
ons=20
and RTPPROXY is responsible for routing.=20

I'm going to write a HOWTO.

=2D-=20
=2D-------------------------------------------------------
ing. Tomas Mandys              email: tomas.mandys@2p.cz
2p plus, s.r.o.                mobil: +420-604690589
Na Skalce 23, 150 00 Praha 5   tel:   +420-234139232
Czech republic                 fax:   +420-251561418
http://www.2p.cz               ICQ:   14187044=20
=2D-------------------------------------------------------
