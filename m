From: "Oskar Andreasson" <blueflux@koffein.net>
Subject: Re: Security flaw in Stateful filtering ??????
Date: Fri, 7 Jun 2002 11:41:07 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <0fef01c20e07$72d707d0$6501a8c0@multisofteducation.com>
References: <E17G6im-0000FK-00@wagner.rustcorp.com.au> <3D006B9E.1040809@cs.auc.dk> <200206071105.42881.hno@marasystems.com> <3D007D73.9030609@cs.auc.dk>
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

No,

Look below

----- Original Message -----=20
From: "Emmanuel Fleury" <fleury@cs.auc.dk>
To: <netfilter-devel@lists.samba.org>
Sent: Friday, June 07, 2002 11:31 AM
Subject: Re: Security flaw in Stateful filtering ??????


> Henrik Nordstrom wrote:
> >=20
> > This configuration can be done just fine with iptables as =
demonstrated in my=20
> > earlier message, but here we go again (but slightly different):
> >=20
> > # Allow existing connections
> > iptables -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT

This line allows all connections that has a connection tracking entry =
which shows that the connection that the packet is part of is =
ESTABLISHED. RELATED means that if the packet is RELATED to a connection =
tracking entry, it will slipp through as well (i.e. FTP-Data is related =
to FTP-Control, and ICMP's may be related to TCP connections, etc.).

In other words, the above line allows all packets that are not =
initiating a new connection to pass through the firewall.

> > # Allow hidden net to initiate new connections (including connection =
pickup)
> > iptables -A FORWARD -i eth0 -j ACCEPT

_this_ line allows all packets from eth0 (probably your LAN) to pass =
through the firewall, including the packets opening a new connection.=20

> > # Drop anything else
> > iptables -A FORWARD -j DROP

finally, we have a rule that DROP's all other packets, including packets =
from the internet trying to initiate a NEW connection.=20

Does this make sense?=3D) Of course, note that this will _not_ block =
traffic directed to the actual firewall itself, but hosts behind the =
firewall.

Oskar Andreasson
http://www.boingworld.com
http://people.unix-fu.org/andreasson/
mailto: blueflux@koffein.net


>=20
> Sorry, I don't understand something ! :-/
>=20
> Does that mean that you DROP all the ACKs, even those which are valid =
?
>=20
> Regards
> --=20
> Emmanuel
>=20
> I am not a vegetarian because I love animals;
> I am a vegetarian because I hate plants.
>    -- A. Whitney Brown
>=20
>=20
>=20
