From: Kirill Tkhai <ktkhai@parallels.com>
Subject: Re: [PATCH] ipt_CLUSTERIP: Add network device notifier
Date: Wed, 11 Jun 2014 15:55:18 +0400
Message-ID: <1402487718.32126.63.camel@tkhai>
References: <1396871929.3741.6.camel@tkhai>
	 <20140428142306.GA28547@localhost> <1402487079.32126.54.camel@tkhai>
	 <20140611114957.GA23352@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: <netfilter-devel@vger.kernel.org>,
	Patrick McHardy <kaber@trash.net>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>, <tkhai@yandex.ru>,
	"Pavel Emelyanov" <xemul@parallels.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from relay.parallels.com ([195.214.232.42]:56935 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753691AbaFKLzZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Jun 2014 07:55:25 -0400
In-Reply-To: <20140611114957.GA23352@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=D0=92 =D0=A1=D1=80, 11/06/2014 =D0=B2 13:49 +0200, Pablo Neira Ayuso =D0=
=BF=D0=B8=D1=88=D0=B5=D1=82:
> On Wed, Jun 11, 2014 at 03:44:39PM +0400, Kirill Tkhai wrote:
> > Hi, Pablo,
> >=20
> > =D0=92 =D0=9F=D0=BD, 28/04/2014 =D0=B2 16:23 +0200, Pablo Neira Ayu=
so =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
> > > Hi,
> > >=20
> > > On Mon, Apr 07, 2014 at 03:58:49PM +0400, Kirill Tkhai wrote:
> > > > Clusterip target does dev_hold() in .checkentry, while dev_put(=
) in .destroy.
> > > > So, unregister_netdevice catches the leak:
> > > >=20
> > > > # modprobe dummy
> > > > # iptables -A INPUT -d 10.31.3.236 -j CLUSTERIP --new --hashmod=
e sourceip -i dummy0 --clustermac 01:aa:7b:47:f7:d7 --total-nodes 2 --l=
ocal-node 1
> > > > # rmmod dummy
> > > >
> > > >   Message from syslogd@localhost ...
> > > >     kernel: unregister_netdevice: waiting for dummy0 to become =
free. Usage count =3D 1
> > > >
> > > [...]
> > > >  1 file changed, 134 insertions(+), 12 deletions(-)
> > >=20
> > > I have spinned several times on this patch, and I'm not very happ=
y
> > > with taking this fix:
> > >=20
> > > 1) It's quite large fix for a situation that seems unlikely to me=
=2E
> >=20
> > We have several reports from containers users, who bumped into this=
=2E
> > The hang happens on netns stop, it's 100% reproducible. Every time
> > a container is stopping or a device is going away, the unregistrati=
on
> > fails and hungs if CLUSTERIP is used. So, we'd want to have some fi=
x
> > of this.
>=20
> How it this combination being triggered there? I mean:
>=20
> # modprobe dummy
> # iptables -A INPUT -d 10.31.3.236 -j CLUSTERIP ...
> # rmmod dummy
>=20
> Is it something included in some scripts that automate the setup?

It's a sample of how to trigger this. The problem is not in rmmod.

Really it happens when container is stopping and device is going away.
It's not OpenVZ related, current LXC has the same problem.

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
