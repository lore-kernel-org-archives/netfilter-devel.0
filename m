From: "Oskar Andreasson" <blueflux@koffein.net>
Subject: Re: Security flaw in Stateful filtering ??????
Date: Mon, 10 Jun 2002 10:04:56 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <015d01c21055$82f7aed0$6501a8c0@multisofteducation.com>
References: <Pine.LNX.4.33.0206071425210.4373-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Cc: <netfilter-devel@lists.samba.org>
Return-path: <netfilter-devel-admin@lists.samba.org>
To: "Jozsef Kadlecsik" <kadlec@blackhole.kfki.hu>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Jozsef,

Sorry for the late reply. I never suggested that this usage (see below) =
is only theoretical and I'm very sorry if it was misinterpreted as that. =


My proposal was to create a way of doing more secure, and stateful, =
redundancy mechanism. For example, 2 or more firewalls which shares =
their conntrack tables via some userspace daemons. This would require =
the daemon to have read/write access to the conntrack tables via netlink =
however, and I am not fully aware of the possibilities of this.=20

Once again, I am extremely sorry if you misinterpreted the whole mail as =
a suggestion that this is only theoretical. I know that you among others =
have told me and others that you've already implemented this in =
practice.=20

Oskar Andreasson
http://www.boingworld.com
http://people.unix-fu.org/andreasson/
mailto: blueflux@koffein.net

----- Original Message -----=20
From: "Jozsef Kadlecsik" <kadlec@blackhole.kfki.hu>
To: "Oskar Andreasson" <blueflux@koffein.net>
Cc: <netfilter-devel@lists.samba.org>
Sent: Friday, June 07, 2002 2:27 PM
Subject: Re: Security flaw in Stateful filtering ??????


> On Fri, 7 Jun 2002, Oskar Andreasson wrote:
>=20
> > Another, related, usage is
> > if we have a redundant firewall (I haven't seen this discussed so =
far
> > so.... Consider this:
> >
> > 1 main firewall
> > 1 router
> > and a secondary firewall.
> >
> > The three are set up in a routing zone. If the main firewall goes
> > down, the router will notice, and route packets through the =
redundant
> > firewall. If the NEW target was to allow only SYN packets, this =
would
> > be impossible as you can understand from this.
>=20
> We have been using such a redundant setup for more than a year.
> It's *not* theoretical.
>=20
> Regards,
> Jozsef
> -
> E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
> WWW-Home: http://www.kfki.hu/~kadlec
> Address : KFKI Research Institute for Particle and Nuclear Physics
>           H-1525 Budapest 114, POB. 49, Hungary
>=20
>=20
