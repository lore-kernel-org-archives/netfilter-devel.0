From: Xin Long <lucien.xin@gmail.com>
Subject: Re: [PATCHv2 net] ipvs: call ip_vs_dst_notifier earlier than ipv6_dev_notf
Date: Sat, 17 Nov 2018 21:19:52 +0900
Message-ID: <CADvbK_f9DCRC6fEv2wJuhGSrks1vt=dHeo81hp1DVWtW4BCjgA@mail.gmail.com>
References: <832d0eccc937ab122b337e627244533df3eb74a5.1542266070.git.lucien.xin@gmail.com>
 <alpine.LFD.2.21.1811160907480.2751@ja.home.ssi.bg> <20181116143711.wwskkrcpqhrybwpq@verge.net.au>
 <20181117111540.ztvaxhoxrpd2h7zv@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Simon Horman <horms@verge.net.au>, Julian Anastasov <ja@ssi.bg>,
        network dev <netdev@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, davem <davem@davemloft.net>,
        Hans Schillstrom <hans@schillstrom.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181117111540.ztvaxhoxrpd2h7zv@salvia>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Sat, Nov 17, 2018 at 8:15 PM Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>
> On Fri, Nov 16, 2018 at 06:37:19AM -0800, Simon Horman wrote:
> > On Fri, Nov 16, 2018 at 09:10:16AM +0200, Julian Anastasov wrote:
> > >
> > >     Hello,
> > >
> > > On Thu, 15 Nov 2018, Xin Long wrote:
> > >
> > > > ip_vs_dst_event is supposed to clean up all dst used in ipvs'
> > > > destinations when a net dev is going down. But it works only
> > > > when the dst's dev is the same as the dev from the event.
> > > >
> > > > Now with the same priority but late registration,
> > > > ip_vs_dst_notifier is always called later than ipv6_dev_notf
> > > > where the dst's dev is set to lo for NETDEV_DOWN event.
> > > >
> > > > As the dst's dev lo is not the same as the dev from the event
> > > > in ip_vs_dst_event, ip_vs_dst_notifier doesn't actually work.
> > > > Also as these dst have to wait for dest_trash_timer to clean
> > > > them up. It would cause some non-permanent kernel warnings:
> > > >
> > > >   unregister_netdevice: waiting for br0 to become free. Usage count = 3
> > > >
> > > > To fix it, call ip_vs_dst_notifier earlier than ipv6_dev_notf
> > > > by increasing its priority to ADDRCONF_NOTIFY_PRIORITY + 5.
> > > >
> > > > Note that for ipv4 route fib_netdev_notifier doesn't set dst's
> > > > dev to lo in NETDEV_DOWN event, so this fix is only needed when
> > > > IP_VS_IPV6 is defined.
> > > >
> > > > v1->v2:
> > > >   - apply it only when CONFIG_IP_VS_IPV6 is defined.
> > > >
> > > > Fixes: 7a4f0761fce3 ("IPVS: init and cleanup restructuring")
> > > > Reported-by: Li Shuang <shuali@redhat.com>
> > > > Signed-off-by: Xin Long <lucien.xin@gmail.com>
> > >
> > > Acked-by: Julian Anastasov <ja@ssi.bg>
> >
> > Thanks,
> >
> > Pablo, could you consider this for nf?
> >
> > Acked-by: Simon Horman <horms@verge.net.au>
>
> Applied, thanks Simon.
Hi Pablo,

The one you just applied is the v1, I'm afraid you need
to revert and apply the v2, which fixed a build error
when IPv6 is disabled.
