From: "Oskar Andreasson" <blueflux@koffein.net>
Subject: Re: Security flaw in Stateful filtering ??????
Date: Fri, 7 Jun 2002 10:50:02 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <0fb101c20e00$50035620$6501a8c0@multisofteducation.com>
References: <E17G6im-0000FK-00@wagner.rustcorp.com.au> <3D006B9E.1040809@cs.auc.dk>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-admin@lists.samba.org>
To: <netfilter-devel@lists.samba.org>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi all,

Hope I am not bursting in to this thread at a too late point.. but here =
goes.

The --state NEW ! --syn -j DROP rule applied in the iptables tutorial =
(now at 1.1.11, available at http://iptables-tutorial.haringstad.com). =
What does it do? Simple enough, it blocks all packets considered as NEW =
and which does not have the SYN flag set (out of SYN,ACK,FIN). It should =
solve your (Emmanuel Fleury) problem as it looks today. The NEW state =
can be used for, as has already been discussed, connection pick-up =
(i.e., when the firewall reboots). Another, related, usage is if we have =
a redundant firewall (I haven't seen this discussed so far so.... =
Consider this:

1 main firewall
1 router=20
and a secondary firewall.=20

The three are set up in a routing zone. If the main firewall goes down, =
the router will notice, and route packets through the redundant =
firewall. If the NEW target was to allow only SYN packets, this would be =
impossible as you can understand from this.

I have already suggested this, but noone picked up on it. 1. Patch =
netfilter so you can write and read connection tracking entries via a =
netlink socket. On top of this, make a daemon that will share states =
between the firewalls. This will make a much better solution, though a =
bit more "needy" in resources etcetera.=20

Put this idea together with our old behaviour (currently used), and we =
could perhaps make the default behaviour of netfilter to only pick up =
SYN packets as NEW, then make it possible to pick up connections by also =
allowing ACK and other packets, and finally the third solution above. =
All of them together would cover all big areas AFAIK (e.g. small home =
networks, medium networks (pickup) and the big and expensive solution =
(routing zones with several firewalls being able to pick up connections =
from eachother).=20

Finally, I agree with Emmanuel that the current documentation is _not_ =
clear enough on this matter. As he says, this is a huge backdoor that =
most people miss when they make a ruleset.

I'm sorry for this rather long mail, but I am just getting some thoughts =
off of my head. Have a nice day,

Oskar Andreasson
http://www.boingworld.com
http://people.unix-fu.org/andreasson/
mailto: blueflux@koffein.net



----- Original Message -----=20
From: "Emmanuel Fleury" <fleury@cs.auc.dk>
To: <netfilter-devel@lists.samba.org>
Sent: Friday, June 07, 2002 10:15 AM
Subject: Re: Security flaw in Stateful filtering ??????


> Hi,
>=20
> Rusty Russell wrote:
> >=20
> > I disagree.  Consider the original complaint: that --state NEW
> > allowed TCP ACK packets through, which allowed an ack scan.  This
> > surprised the observers, who then blocked acks.
>=20
> Precisely.
>=20
> Actually, my exact complain is now that the documentation is not
> making you awared of what you are exactly doing...
>=20
> Somehow, this is dangerous and can lead you to have a flaw in your
> firewall without being awared of it.
>=20
> Moreover, most of the papers, articles, and web pages about Netfilter
> are wrong about this.
>=20
> Just as an example, the following (very nice) documentation about
> Netfilter (http://www.knowplace.org/netfilter/index.html), state
> that:
>=20
> "Note: An ACK packet is a TCP packet with the ACK flag set only. The=20
> important thing to note here is that after the three-way handshake is=20
> completed, and the connection is complete, every packet that is part =
of=20
> this TCP connection will always have the ACK bit set.
>=20
> This is also the reason why connection tracking is so important. =
Without=20
> connection tracking, there is no way for your firewall to know whether =

> an arriving ACK packet is really a part of an established connection.=20
> When simple packet filters (and Ipchains) receives a packet with the =
ACK=20
> flag set, it simply allows the packet through (does this sound like a=20
> good idea?). When a stateful firewall received an ACK packet, it'll=20
> consult a connection table to see if the packet belongs to an=20
> established connection. If it does not, the packet is dropped."
>=20
> See: http://www.knowplace.org/netfilter/ip_overview.html
>=20
> Which is obviously wrong in respect of what we were discussing...
>=20
> I think that this is due (as Rusty said) to a confusion between the
> TCP protocol's states and the connection tracking module's states
> which are different.
>=20
> This should definitely be emphased in the documentation (IMHO).
>=20
>=20
> The other points are more about the policy you want to apply for
> the development of Netfilter. I mean, should it be left up to
> the user to patch this in the ruleset or fixed in the code...
>=20
> This could be discussed forever without any result.
> Therefore, it makes no point to just keep going on this way.
>=20
>=20
> It appears, also, to me that you are focusing more on an
> "advanced NAT", than on real "stateful inspection". You agreed
> on loosing some stateful key features to increase the connectivity
> because as you are using stateful inspection to do NAT, the features
> that you loose does not affect so much the security of your network.
> But loosing this feature prevent you to use Netfilter as a real
> stateful inspection firewall (I'll explain this point later in this
> post).
>=20
> Actually, this discussion start to make aware of the difference
> between "connection tracking" and "stateful inspection". :-)
>=20
>=20
> > Of course, you can still use SYNs to scan the network, so they
> > haven't actually won anything here, except that if their firewall
> > reboots, established connections will die.
>=20
> Well, if you consider a full implementation of a stateful inspection
> firewall, you should be able to "hide" a network from outside without
> using NAT.
>=20
> For example, you can make up the following ruleset:
>=20
> o DENY SYN from outside -> inside
> o Allow NEW, ESTABLISHED, RELATED
>=20
>                        +-----------+
> +--------+    +--+    | Hidden Net|
> |Internet|----|FW|----| w/o NAT   |
> +--------+    +--+    +-----------+
>=20
> On this configuration, you allow all the computers of your hidden net
> to have their own IP address and you disallow any sort of scan from
> outside. You can even imagine to have a web server somewhere in your
> hidden network (you just have to add as first rule that you allow
> all the traffic on the port 80 to this precise IP address).
>=20
> This configuration can't be done with Netfilter because you are doing
> what we could call "connection tracking" and not "stateful =
inspection".
>=20
>=20
> > The confusion here comes from the "TCP connection" vs
> > "connection tracking connection" distinction, which is subtle and
> > usually harmless.
>=20
> Harmless if you are running NAT. But, if you are trying to use =
Netfilter
> as a complete stateful inspection firewall, then you are in trouble
> (IMHO).
>=20
> > Hope that helps,
>=20
> Yes. Thanks. :-)
>=20
> Regards
> --=20
> Emmanuel
>=20
> Security is a process, not a product.
>    -- Bruce Schneier (Crypto-gram, February 15, 2002)
>=20
>=20
>=20
