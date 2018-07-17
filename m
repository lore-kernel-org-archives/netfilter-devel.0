From: David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH RFC/RFT net-next 00/17] net: Convert neighbor tables to
 per-namespace
Date: Tue, 17 Jul 2018 13:02:18 -0600
Message-ID: <1a27e301-3275-b349-a2f8-afdfdc02f04f@gmail.com>
References: <20180717120651.15748-1-dsahern@kernel.org>
 <CAM_iQpW4g2v6xk49Gz+WBasKaO9VUk3Q-umX7iBRK-mAhn21Fw@mail.gmail.com>
 <1a3f59a9-0ba5-c83f-16a6-f9550a84f693@gmail.com>
 <CAM_iQpWabZorkMNswyfHyS4KT=f_bgMtK8K35=84uah6Kfqxew@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
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
To: Cong Wang <xiyou.wangcong@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAM_iQpWabZorkMNswyfHyS4KT=f_bgMtK8K35=84uah6Kfqxew@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On 7/17/18 11:53 AM, Cong Wang wrote:
> You can see the original discussion here:
> https://marc.info/?l=linux-netdev&m=140356141019653&w=2
> 

Thanks for the reference.

I was surprised that the tables are still global. A number of objections
raised in that thread were due to a large patch tackling multiple
issues. This set is focused one thing - moving the tables to net - and
does so in small incremental changes to make it easy to review.

One of DaveM's comments:

"Finally, another problem are permanent neigh entries as those cannot
be reclaimed, that might be part of the main problem here.

One idea wrt. permanent entries is that we could decide that, since
they are administratively added, they don't count against the
thresholds and limits."

this is another we have hit and with same thinking ... permanent entries
should not count in the gc numbers. We need to address this for EVPN.

As for the per-namespace tables, it is 4 years later and over that time
Linux supports a number of features: EVPN which is very mac heavy, VRR
which doubles mac entries (one against the VRR device and one against
the lower device) and NOS level features such as mlxsw which has to
ensure mac entries for nexthop gateaways stay active. In addition there
are other features on the horizon - like the ability to use namespaces
to create virtual switches (what Cisco calls a VDC) where you absolutely
want isolation and not allowing entries from virtual switch to evict
entries from another. And of course the continued proliferation of
containerized workloads where isolation is desired.

I understand the concern about global resource and limits: as it stands
you have to increase the limits in init_net to the max expected and hope
for the best. With per namespace limits you can lower the limits of each
namespace better control the total impact on the total memory used.
Perhaps the defaults for namespaces after init_net could have really low
defaults (e.g., 16 / 32 / 64 for gc_thresh 1/2/3) requiring admin
intervention.
