From: Cong Wang <xiyou.wangcong@gmail.com>
Subject: Re: [PATCH RFC/RFT net-next 00/17] net: Convert neighbor tables to per-namespace
Date: Tue, 17 Jul 2018 10:53:21 -0700
Message-ID: <CAM_iQpWabZorkMNswyfHyS4KT=f_bgMtK8K35=84uah6Kfqxew@mail.gmail.com>
References: <20180717120651.15748-1-dsahern@kernel.org> <CAM_iQpW4g2v6xk49Gz+WBasKaO9VUk3Q-umX7iBRK-mAhn21Fw@mail.gmail.com>
 <1a3f59a9-0ba5-c83f-16a6-f9550a84f693@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Linux Kernel Network Developers <netdev@vger.kernel.org>,
        nikita.leshchenko@oracle.com,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Ido Schimmel <idosch@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>, alex.aring@gmail.com,
        linux-wpan@vger.kernel.org,
        NetFilter <netfilter-devel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
To: David Ahern <dsahern@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1a3f59a9-0ba5-c83f-16a6-f9550a84f693@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Tue, Jul 17, 2018 at 10:43 AM David Ahern <dsahern@gmail.com> wrote:
>
> On 7/17/18 11:40 AM, Cong Wang wrote:
> > On Tue, Jul 17, 2018 at 5:11 AM <dsahern@kernel.org> wrote:
> >>
> >> From: David Ahern <dsahern@gmail.com>
> >>
> >> Nikita Leshenko reported that neighbor entries in one namespace can
> >> evict neighbor entries in another. The problem is that the neighbor
> >> tables have entries across all namespaces without separate accounting
> >> and with global limits on when to scan for entries to evict.
> >
> > It is nothing new, people including me already noticed this before.
> >
> >
> >>
> >> Resolve by making the neighbor tables for ipv4, ipv6 and decnet per
> >> namespace and making the accounting and threshold limits per namespace.
> >
> >
> > The last discussion about this a long time ago concluded that neigh
> > table entries are controllable by remote, so after moving it to per netns,
> > it would be easier to DOS the host.
> >
>
> There are still limits on the total number of entries and with
> per-namespace limits an admin has better control.

Per-netns limit is *exactly* the problem here.

Quote from David Miller:
"
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 25 Jun 2014 18:17:08 -0700

> I disagree that removing a global DOS prevention check is a benefit.
> Certainly large semantics changes like that should not happen without
> being discussed in the patch description.

Agreed, this is the most important core issue.

If we just make these things per netns, then as a result if you create
N namespaces we will allow N times more neighbour entries to be
sitting in the system at once.

Actually, I'm really surprised the limits get hit and this actually
causes problems.
"

You can see the original discussion here:
https://marc.info/?l=linux-netdev&m=140356141019653&w=2
