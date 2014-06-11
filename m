From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] ipt_CLUSTERIP: Add network device notifier
Date: Wed, 11 Jun 2014 14:00:27 +0200
Message-ID: <20140611120027.GA23485@localhost>
References: <1396871929.3741.6.camel@tkhai>
 <20140428142306.GA28547@localhost>
 <1402487079.32126.54.camel@tkhai>
 <20140611114957.GA23352@localhost>
 <1402487718.32126.63.camel@tkhai>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org, Patrick McHardy <kaber@trash.net>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>, tkhai@yandex.ru,
	Pavel Emelyanov <xemul@parallels.com>
To: Kirill Tkhai <ktkhai@parallels.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58099 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750730AbaFKMAx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Jun 2014 08:00:53 -0400
Content-Disposition: inline
In-Reply-To: <1402487718.32126.63.camel@tkhai>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jun 11, 2014 at 03:55:18PM +0400, Kirill Tkhai wrote:
> =D0=92 =D0=A1=D1=80, 11/06/2014 =D0=B2 13:49 +0200, Pablo Neira Ayuso=
 =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
> > On Wed, Jun 11, 2014 at 03:44:39PM +0400, Kirill Tkhai wrote:
> > > Hi, Pablo,
> > >=20
> > > =D0=92 =D0=9F=D0=BD, 28/04/2014 =D0=B2 16:23 +0200, Pablo Neira A=
yuso =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
> > > > Hi,
> > > >=20
> > > > On Mon, Apr 07, 2014 at 03:58:49PM +0400, Kirill Tkhai wrote:
> > > > > Clusterip target does dev_hold() in .checkentry, while dev_pu=
t() in .destroy.
> > > > > So, unregister_netdevice catches the leak:
> > > > >=20
> > > > > # modprobe dummy
> > > > > # iptables -A INPUT -d 10.31.3.236 -j CLUSTERIP --new --hashm=
ode sourceip -i dummy0 --clustermac 01:aa:7b:47:f7:d7 --total-nodes 2 -=
-local-node 1
> > > > > # rmmod dummy
> > > > >
> > > > >   Message from syslogd@localhost ...
> > > > >     kernel: unregister_netdevice: waiting for dummy0 to becom=
e free. Usage count =3D 1
> > > > >
> > > > [...]
> > > > >  1 file changed, 134 insertions(+), 12 deletions(-)
> > > >=20
> > > > I have spinned several times on this patch, and I'm not very ha=
ppy
> > > > with taking this fix:
> > > >=20
> > > > 1) It's quite large fix for a situation that seems unlikely to =
me.
> > >=20
> > > We have several reports from containers users, who bumped into th=
is.
> > > The hang happens on netns stop, it's 100% reproducible. Every tim=
e
> > > a container is stopping or a device is going away, the unregistra=
tion
> > > fails and hungs if CLUSTERIP is used. So, we'd want to have some =
fix
> > > of this.
> >=20
> > How it this combination being triggered there? I mean:
> >=20
> > # modprobe dummy
> > # iptables -A INPUT -d 10.31.3.236 -j CLUSTERIP ...
> > # rmmod dummy
> >=20
> > Is it something included in some scripts that automate the setup?
>=20
> It's a sample of how to trigger this. The problem is not in rmmod.
>=20
> Really it happens when container is stopping and device is going away=
=2E
> It's not OpenVZ related, current LXC has the same problem.

But that sample should be really easy to trigger if you're getting
lost of reports for this.

Are your users really hitting that problem by accident? It seems quite
rare condition to me. Please, clarify.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
