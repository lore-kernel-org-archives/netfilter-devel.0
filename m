From: Yafang Shao <laoar.shao@gmail.com>
Subject: Re: [PATCH 4/5] netfilter: fix missed NULL check in nf_conntrack_proto_pernet_init()
Date: Thu, 13 Dec 2018 17:50:23 +0800
Message-ID: <CALOAHbDfYD-nEWrW5pryibafg7tEYDsyu-6-Ey2Sdwa9O64Xnw@mail.gmail.com>
References: <1544014590-14429-1-git-send-email-laoar.shao@gmail.com>
 <1544014590-14429-4-git-send-email-laoar.shao@gmail.com> <20181212232648.qsvyuc3g2jj5v2ej@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: kadlec@blackhole.kfki.hu, fw@strlen.de,
        David Miller <davem@davemloft.net>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev <netdev@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
To: pablo@netfilter.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181212232648.qsvyuc3g2jj5v2ej@salvia>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Thu, Dec 13, 2018 at 7:26 AM Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>
> On Wed, Dec 05, 2018 at 08:56:29PM +0800, Yafang Shao wrote:
> > nf_ct_l4proto_net() may return NULL.
> > That may happens if some module forget to set both l4proto->get_net_proto
> > and l4proto->net_id.
> > We'd check the return value here, in case crash happens.
> >
> > Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> > ---
> >  net/netfilter/nf_conntrack_proto.c | 3 +++
> >  1 file changed, 3 insertions(+)
> >
> > diff --git a/net/netfilter/nf_conntrack_proto.c b/net/netfilter/nf_conntrack_proto.c
> > index 154e8c0..316fef3 100644
> > --- a/net/netfilter/nf_conntrack_proto.c
> > +++ b/net/netfilter/nf_conntrack_proto.c
> > @@ -946,6 +946,9 @@ int nf_conntrack_proto_pernet_init(struct net *net)
> >       struct nf_proto_net *pn = nf_ct_l4proto_net(net,
> >                                       &nf_conntrack_l4proto_generic);
>
> There is another spot missing in this file that is missing the check
> for NULL.
>
> We can probably simplify all this is we place the gre conntracker in
> the conntrack core, as it's been suggested already. It's the only one
> remaining as a module and it now supports for IPv6, so it's probably
> better follow that path.

Got it.
Thanks for your explanation.

Thanks
Yafang
