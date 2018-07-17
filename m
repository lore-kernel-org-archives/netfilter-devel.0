From: Cong Wang <xiyou.wangcong@gmail.com>
Subject: Re: [PATCH RFC/RFT net-next 00/17] net: Convert neighbor tables to per-namespace
Date: Tue, 17 Jul 2018 13:37:26 -0700
Message-ID: <CAM_iQpX-wZooTDqWeqtqAc=a-S2HVcJJtkKdn6gxZx-2YmXpmA@mail.gmail.com>
References: <20180717120651.15748-1-dsahern@kernel.org> <CAM_iQpW4g2v6xk49Gz+WBasKaO9VUk3Q-umX7iBRK-mAhn21Fw@mail.gmail.com>
 <1a3f59a9-0ba5-c83f-16a6-f9550a84f693@gmail.com> <CAM_iQpWabZorkMNswyfHyS4KT=f_bgMtK8K35=84uah6Kfqxew@mail.gmail.com>
 <1a27e301-3275-b349-a2f8-afdfdc02f04f@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Linux Kernel Network Developers <netdev@vger.kernel.org>,
        nikita.leshchenko@oracle.com,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Ido Schimmel <idosch@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Alexander Aring <alex.aring@gmail.com>,
        linux-wpan@vger.kernel.org,
        NetFilter <netfilter-devel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
To: David Ahern <dsahern@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1a27e301-3275-b349-a2f8-afdfdc02f04f@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Tue, Jul 17, 2018 at 12:02 PM David Ahern <dsahern@gmail.com> wrote:
> As for the per-namespace tables, it is 4 years later and over that time
> Linux supports a number of features: EVPN which is very mac heavy, VRR
> which doubles mac entries (one against the VRR device and one against
> the lower device) and NOS level features such as mlxsw which has to
> ensure mac entries for nexthop gateaways stay active. In addition there
> are other features on the horizon - like the ability to use namespaces
> to create virtual switches (what Cisco calls a VDC) where you absolutely
> want isolation and not allowing entries from virtual switch to evict
> entries from another. And of course the continued proliferation of
> containerized workloads where isolation is desired.

As long as no change in neigh table code base itself, these can't
address the concern people raised before.


>
> I understand the concern about global resource and limits: as it stands
> you have to increase the limits in init_net to the max expected and hope
> for the best. With per namespace limits you can lower the limits of each
> namespace better control the total impact on the total memory used.

The problem is that the number of containers in a host is usually
not predictable.

Of course, you can say containers limit kernel memory too, but
memcg is not part of netns. I once told David Miller cpuset is the
isolation for isolating per-CPU softnet_data, he didn't like it. Based
on that I don't think you can convince him with memcg as a solution
here.
