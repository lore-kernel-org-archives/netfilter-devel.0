From: Russell Miller <rmiller@duskglow.com>
Subject: additional netfilter queue verdict
Date: Mon, 3 May 2004 21:25:42 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200405032125.46793.rmiller@duskglow.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

=2D----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi,

I am the author/maintainer of a program called packetbl.  It makes use of t=
he=20
netfilter/iptables QUEUE target in order to make decisions as to the=20
disposition of packets based on the results of a DNS blocklist query.  The=
=20
functionality works quite well but I've already come upon several limitatio=
ns=20
of netfilter, and I would like to open up discussion on possible ways of=20
getting around or eliminating these limitations.

I've had some feedback requesting some features to packetbl that are seemin=
gly=20
impossible to implement using the current netfilter base (in 2.6.5, fedora=
=20
core 2, is what I'm using).

 I have a user who would like to use netfilter to, instead of dropping the=
=20
packets, to rewrite them in order to bounce them to another machine to send=
=20
fake SMTP responses.  I have another user who would like to reject the=20
packets with an icmp error if they're found in the blocklist.  In order to =
do=20
this, I was thinking of an additional verdict:

NF_CONTINUE

This verdict would remove the packet from the queue and allow processing to=
=20
continue in the table that the rule is part of.

In the alternative or in addition, an NF_REJECT verdict might be nice too, =
but=20
I note there are multiple ways to reject a packet, and perhaps it would be=
=20
too much trouble to implement.

There are a couple of other things I can see being a good idea, but this is=
 a=20
start, and I won't bore you with the rest yet.  Can you please give me=20
feedback on this idea?  I'm not averse to coding it, but I would like a=20
general idea of a) how involved it would be, b) the degree of impossibility=
=20
of the task I would be taking on, and c) how likely it is of being accepted=
=20
were I to successfully do this.  Of course, if someone else were to take th=
e=20
ball and run with it, I don't think I'd complain too loudly at all.

Thanks for your time.

=2D --Russell

=2D --=20

Russell Miller - rmiller@duskglow.com - Somewhere near Sioux City, IA.
Youth cannot know age, but age is guilty if it forgets youth
    - Professor Dumbledore
Hi! I'm a .signature virus! Copy me into your ~/.signature, please!
=2D----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFAlv8pURTA4VCI9OARAqwfAJ4vmsvMtEjH5CxofslrYu1YSCnIZwCfdmwf
N11VXdgeY+9yiSeuGR6GHMA=3D
=3DB01B
=2D----END PGP SIGNATURE-----
