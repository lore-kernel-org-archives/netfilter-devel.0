From: "zze-Proxy GRALL O ext FTRD/SVA/LAN" <ograll.ext@rd.francetelecom.com>
Subject: RE : RE : RE : RE : Apply rules to 1 UDP port but port used as a socket: possible?
Date: Fri, 13 Feb 2004 09:01:12 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <D4EF10CCEB2CE742BEEA9838C590B0E8011CBAA3@ftrdmel2.rd.francetelecom.fr>
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

Maybe I wasn't clear at the beginning...

-I have an UDP socket listening on port 1727.

-I must receive some (5 to 10) proprietary UDP packets from a Nated =
client (it's for VoIP...).

-These packets contains an ID that permits me to know the destination =
(and so the NAT rule to apply) which must be another Nated client.

-When I've received the packets from the 2 Nated clients (they are =
behind a Router), I can apply the NAT rules SNAT+DNAT).

-Next packets are RTP or RTCP packets...

-My problem was that the rules wasn't applied... And so the socket =
receives all RTP/RTCP packets.

Thanks to you :

-Now I can apply a new rule (mangle table PREROUTING -> QUEUE) after the =
NAT rules.

-I'm building a NetLink socket to receive the packet

-You said last time that the packet (coming from QUEUE) will go to NAT =
table and will apply my NAT rules.

Maybe I haven't well understood what you said. I wonder wether I =
shouldn't=20
-not use socket on port 1727,
-only intercept the packet with QUEUE target and my handler,
-finally reenter packet in the nat table.
... That's what you meant maybe ?

Regards,

Olivier GRALL=20

-----Message d'origine-----
De : Henrik Nordstrom [mailto:hno@marasystems.com]=20
Envoy=E9 : jeudi 12 f=E9vrier 2004 12:35
=C0 : zze-Proxy GRALL O ext FTRD/SVA/LAN
Cc : netfilter-devel@lists.netfilter.org
Objet : Re: RE : RE : RE : Apply rules to 1 UDP port but port used as a =
socket: possible?


On Thu, 12 Feb 2004, zze-Proxy GRALL O ext FTRD/SVA/LAN wrote:

> Then packets which arrive on the socket stop

Yes.

> That's what I want!

There is unfortunately not much to choose from here. Either you allow =
the=20
packet to be delivered locally and accept that all further packets of =
the=20
same session will be dealt with in the same manner, or you intercept the =

packet early in the processing via QUEUE and have control over what=20
happens with the session.


> I will just approve the packet in my queue handler and I must receive=20
> packets from the other side so I think it will be OK hoping it won't=20
> load CPU too much more because I must treat thousands connection at=20
> the end...

You can not approve the packet until you have set up the required NAT=20
rules for how this session is to be forwarded.

If you let a single packet be forwarded to the local socket then all=20
further packets of this session will be forwarded the same way.


If you perhaps described what the actual problem you are trying to solve =

is then we could help you finding a reasonable approach.

Regards
Henrik
