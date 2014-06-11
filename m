From: Kirill Tkhai <ktkhai@parallels.com>
Subject: Re: [PATCH] ipt_CLUSTERIP: Add network device notifier
Date: Wed, 11 Jun 2014 15:44:39 +0400
Message-ID: <1402487079.32126.54.camel@tkhai>
References: <1396871929.3741.6.camel@tkhai>
	 <20140428142306.GA28547@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: <netfilter-devel@vger.kernel.org>,
	Patrick McHardy <kaber@trash.net>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>, <tkhai@yandex.ru>,
	"Pavel Emelyanov" <xemul@parallels.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from relay.parallels.com ([195.214.232.42]:54953 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817AbaFKLot (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Jun 2014 07:44:49 -0400
In-Reply-To: <20140428142306.GA28547@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi, Pablo,

=D0=92 =D0=9F=D0=BD, 28/04/2014 =D0=B2 16:23 +0200, Pablo Neira Ayuso =D0=
=BF=D0=B8=D1=88=D0=B5=D1=82:
> Hi,
>=20
> On Mon, Apr 07, 2014 at 03:58:49PM +0400, Kirill Tkhai wrote:
> > Clusterip target does dev_hold() in .checkentry, while dev_put() in=
 .destroy.
> > So, unregister_netdevice catches the leak:
> >=20
> > # modprobe dummy
> > # iptables -A INPUT -d 10.31.3.236 -j CLUSTERIP --new --hashmode so=
urceip -i dummy0 --clustermac 01:aa:7b:47:f7:d7 --total-nodes 2 --local=
-node 1
> > # rmmod dummy
> >
> >   Message from syslogd@localhost ...
> >     kernel: unregister_netdevice: waiting for dummy0 to become free=
=2E Usage count =3D 1
> >
> [...]
> >  1 file changed, 134 insertions(+), 12 deletions(-)
>=20
> I have spinned several times on this patch, and I'm not very happy
> with taking this fix:
>=20
> 1) It's quite large fix for a situation that seems unlikely to me.

We have several reports from containers users, who bumped into this.
The hang happens on netns stop, it's 100% reproducible. Every time
a container is stopping or a device is going away, the unregistration
fails and hungs if CLUSTERIP is used. So, we'd want to have some fix
of this.

> 2) We have this problem since the beginning, since the CLUSTERIP
>    target was merged mainstream.

Some time ago we discovered, several our BUGs are connected with this
problem. It's not once-only for us.

> 3) We have theses days the cluster match, which is more flexible as
>    you can also use it not only for backend, but also in active-activ=
e
>    gateway setups. It just requires a couple of arptables rules for
>    mangling ARP replies to include the multicast MAC there.

Yes, but CLUSTERIP is still in upstream, and some people still use it.
This bug potentially is a bomb, when the only user of a container can
kill all the system.

> Perhaps linking net_device structure with the module that have create=
d
> would simplify this, but I guess David won't take such patch just to
> fix this rare iptables extension, unless this is manifesting in other
> netdev code, eg. tunneling protocols.

Is there a better decidion? We'd could fix it in other way if you sugge=
st.

Thanks,
Kirill

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
