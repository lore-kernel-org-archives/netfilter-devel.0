From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] ipt_CLUSTERIP: Add network device notifier
Date: Wed, 11 Jun 2014 13:49:57 +0200
Message-ID: <20140611114957.GA23352@localhost>
References: <1396871929.3741.6.camel@tkhai>
 <20140428142306.GA28547@localhost>
 <1402487079.32126.54.camel@tkhai>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org, Patrick McHardy <kaber@trash.net>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>, tkhai@yandex.ru,
	Pavel Emelyanov <xemul@parallels.com>
To: Kirill Tkhai <ktkhai@parallels.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49747 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755400AbaFKLuF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Jun 2014 07:50:05 -0400
Content-Disposition: inline
In-Reply-To: <1402487079.32126.54.camel@tkhai>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jun 11, 2014 at 03:44:39PM +0400, Kirill Tkhai wrote:
> Hi, Pablo,
>=20
> =D0=92 =D0=9F=D0=BD, 28/04/2014 =D0=B2 16:23 +0200, Pablo Neira Ayuso=
 =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
> > Hi,
> >=20
> > On Mon, Apr 07, 2014 at 03:58:49PM +0400, Kirill Tkhai wrote:
> > > Clusterip target does dev_hold() in .checkentry, while dev_put() =
in .destroy.
> > > So, unregister_netdevice catches the leak:
> > >=20
> > > # modprobe dummy
> > > # iptables -A INPUT -d 10.31.3.236 -j CLUSTERIP --new --hashmode =
sourceip -i dummy0 --clustermac 01:aa:7b:47:f7:d7 --total-nodes 2 --loc=
al-node 1
> > > # rmmod dummy
> > >
> > >   Message from syslogd@localhost ...
> > >     kernel: unregister_netdevice: waiting for dummy0 to become fr=
ee. Usage count =3D 1
> > >
> > [...]
> > >  1 file changed, 134 insertions(+), 12 deletions(-)
> >=20
> > I have spinned several times on this patch, and I'm not very happy
> > with taking this fix:
> >=20
> > 1) It's quite large fix for a situation that seems unlikely to me.
>=20
> We have several reports from containers users, who bumped into this.
> The hang happens on netns stop, it's 100% reproducible. Every time
> a container is stopping or a device is going away, the unregistration
> fails and hungs if CLUSTERIP is used. So, we'd want to have some fix
> of this.

How it this combination being triggered there? I mean:

# modprobe dummy
# iptables -A INPUT -d 10.31.3.236 -j CLUSTERIP ...
# rmmod dummy

Is it something included in some scripts that automate the setup?
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
