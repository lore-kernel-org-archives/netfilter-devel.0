From: "zze-Proxy GRALL O ext FTRD/SVA/LAN" <ograll.ext@rd.francetelecom.com>
Subject: RE : RE : RE : RE : RE : Apply rules to 1 UDP port but port used as a socket: possible?
Date: Tue, 17 Feb 2004 09:56:22 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <D4EF10CCEB2CE742BEEA9838C590B0E8011CC286@ftrdmel2.rd.francetelecom.fr>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Cc: <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
content-class: urn:content-classes:message
To: "Henrik Nordstrom" <hno@marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

OK, that's clear for me now.

>> -Next packets are RTP or RTCP packets...
>
>Are these also UDP packets with the same source/destination including=20
>port?=20

Yes RTP/RTCP are UDP packets (Audio packets) from the same source and =
for the same destinations

I've tried all the mechanism and it should be ok... THANKS A LOT !!!
-IP_QUEUE handler catch packets:
      iptables -t mangle -A PREROUTING -m state -state NEW -p udp -d =
LOCAL_ADDR --dport LOCAL_PORT -j QUEUE
-then NAT rules are applied...=20

I still need 2 informations:
-Can I stop the stream ? When I remove the rule (and even Flush) the UDP =
packets can continue to pass ...
-Another thing strange is that during my tests I used 2 client programs =
on 2 different machines. They tried to connect to the same server. =
First, for the NAT I apply a rule:
      iptables -t nat -A POSROUTING -p udp -d SERVER_ADDR --dport =
SERVER_PORT -s CLIENT1_ADDR --sport CLIENT1_PORT -j SNAT --to-source =
PUBLIC_ADDR:PUBLIC_PORT
      iptables -t nat -A POSROUTING -p udp -d SERVER_ADDR --dport =
SERVER_PORT -s CLIENT2_ADDR --sport CLIENT2_PORT -j SNAT --to-source =
PUBLIC_ADDR:PUBLIC_PORT
So when clients sended UDP packets, only the client who sended the first =
packets was NATed and not the other. I changed the new IP source of the =
2nd client to "--to-source PUBLIC_ADDR:PUBLIC_PORT2" and then it was OK. =
Why didn't it work at first time ? As the source address is not the same =
I thought that it should work.

Regards,

Olivier.

-----Message d'origine-----
De : Henrik Nordstrom [mailto:hno@marasystems.com]=20
Envoy=E9 : vendredi 13 f=E9vrier 2004 09:49
=C0 : zze-Proxy GRALL O ext FTRD/SVA/LAN
Cc : netfilter-devel@lists.netfilter.org
Objet : Re: RE : RE : RE : RE : Apply rules to 1 UDP port but port used =
as a socket: possible?


On Fri, 13 Feb 2004, zze-Proxy GRALL O ext FTRD/SVA/LAN wrote:

> Maybe I wasn't clear at the beginning...
>=20
> -I have an UDP socket listening on port 1727.

Ok, sort of.

> -I must receive some (5 to 10) proprietary UDP packets from a Nated=20
> client (it's for VoIP...).

Ok.

> -These packets contains an ID that permits me to know the destination=20
> (and so the NAT rule to apply) which must be another Nated client.

Ok.
=20
> -When I've received the packets from the 2 Nated clients (they are=20
> behind a Router), I can apply the NAT rules SNAT+DNAT).

Ok.
=20
> -Next packets are RTP or RTCP packets...
Are these also UDP packets with the same source/destination including=20
port? If it is then the first packets must be intercepted before they=20
reaches nat PREROUTING. As soon as a single packet have passed nat=20
PREROUTING it is too late to change the NAT mappings of this session =
until=20
it expires from conntrack.
=20
> -My problem was that the rules wasn't applied... And so the socket=20
> receives all RTP/RTCP packets.
>=20
> Thanks to you :
>=20
> -Now I can apply a new rule (mangle table PREROUTING -> QUEUE) after=20
> the NAT rules.

mangle is before NAT which is the whole point. By intercepting the =
packets=20
via QUEUE in mangle you can grab the packet before NAT sees the session.

> -I'm building a NetLink socket to receive the packet

Ok.

> -You said last time that the packet (coming from QUEUE) will go to NAT =

> table and will apply my NAT rules.

Yes.

> Maybe I haven't well understood what you said. I wonder wether I=20
> shouldn't
> -not use socket on port 1727,

You have no use of this socket, unless the two traffic streams are=20
different in which case none of what we have discussed applies.

> -only intercept the packet with QUEUE target and my handler,

Yes.

> -finally reenter packet in the nat table.

Yes.

> ... That's what you meant maybe ?

Yes.

Regards
Henrik
