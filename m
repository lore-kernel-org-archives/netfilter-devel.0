From: "zze-Proxy GRALL O ext FTRD/SVA/LAN" <ograll.ext@rd.francetelecom.com>
Subject: RE : RE : RE : Apply rules to 1 UDP port but port used as a socket: possible?
Date: Thu, 12 Feb 2004 10:38:04 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <D4EF10CCEB2CE742BEEA9838C590B0E8011CB76E@ftrdmel2.rd.francetelecom.fr>
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

I've tried with success the QUEUE target... In fact, when I activate the =
rule:
> iptables -t mangle -A PREROUTING -p udp -s REMOTE_ADDR --sport=20
> REMOTE_PORT -d LOCAL_ADDR --dport 1727 -j QUEUE
Then packets which arrive on the socket stop

That's what I want!

Now I must use a Netlink socket to intercept packet and validate it... =
Is there another way to reenter the packet in the kernel ?

>Maybe -m state --state NEW may be sufficient for your task but=20
>keep in mind that this also matches retransmissions until traffic is =
seen=20
>in both directions.
I will just approve the packet in my queue handler and I must receive =
packets from the other side so I think it will be OK hoping it won't =
load CPU too much more because I must treat thousands connection at the =
end...


Thanks a lot for your help!
It's really helping me.
Best regards,


Olivier GRALL
www.neotip.com


=20
-----Message d'origine-----
De : Henrik Nordstrom [mailto:hno@marasystems.com]=20
Envoy=E9 : mercredi 11 f=E9vrier 2004 17:59
=C0 : zze-Proxy GRALL O ext FTRD/SVA/LAN
Cc : netfilter-devel@lists.netfilter.org
Objet : Re: RE : RE : Apply rules to 1 UDP port but port used as a =
socket: possible?


On Wed, 11 Feb 2004, zze-Proxy GRALL O ext FTRD/SVA/LAN wrote:

> For the moment I need an UDP socket. After treatment, I want the=20
> following packets to be NATed. If I inspect these packets thanks to=20
> QUEUE target(passing to userspace, isn't it?) I don't know what will=20
> permit to apply NAT rules... I don't understand exactly what you mean=20
> ?

You can not let the initial packet be accepted by the local IP stack.=20
If you do that then the session will be fully created and future packets =

of the same session will go the smae way.

You MUST intercept the packet before it reaches the local IP stack, or =
to=20
be precise before the packet reaches netfilter nat PREROUTING.

One good way of doing this is to use QUEUE in mangle PREROUTING. The=20
mangle PREROUTING hook is called just before nat PREROUTING.

> So your solution is to use libipq after a rule like this:
>=20
> iptables -t mangle -A PREROUTING -p udp -s REMOTE_ADDR --sport=20
> REMOTE_PORT -d LOCAL_ADDR --dport 1727 -j QUEUE
>=20
> Is it what you mean ?
>=20
> In this way I can inspect the packet in userspace.

Exacly.

> Do you want to say I do the NAT in the userspace ?

No. The packet will reenter the kernel once you are done with it in your =

queue handler, and will then enter the nat table and a NAT session will =
be=20
created.

> But if conntrack is already set up, packets won't arrive to mangle=20
> PREROUTING, isn't it ?

All packets get to mangle PREROUTING. It is only the nat table that is=20
magic.

You will need some rules in mangle to determine that this is the first =
packet. Maybe -m state --state NEW may be sufficient for your task but=20
keep in mind that this also matches retransmissions until traffic is =
seen=20
in both directions.

Regards
Henrik
