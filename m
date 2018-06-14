From: Tom Herbert <tom@herbertland.com>
Subject: Re: [PATCH net-next,RFC 00/13] New fast forwarding path
Date: Thu, 14 Jun 2018 13:52:03 -0700
Message-ID: <CALx6S345B2-sejH52beewdiHuGo5nAY0v0uFmNuiJ0hQ6Wu3xw@mail.gmail.com>
References: <20180614141947.3580-1-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180614141947.3580-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Thu, Jun 14, 2018 at 7:19 AM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Hi,
>
> This patchset proposes a new fast forwarding path infrastructure that
> combines the GRO/GSO and the flowtable infrastructures. The idea is to
> add a hook at the GRO layer that is invoked before the standard GRO
> protocol offloads. This allows us to build custom packet chains that we
> can quickly pass in one go to the neighbour layer to define fast
> forwarding path for flows.
>
> For each packet that gets into the GRO layer, we first check if there is
> an entry in the flowtable, if so, the packet is placed in a list until
> the GRO infrastructure decides to send the batch from gro_complete to
> the neighbour layer. The first packet in the list takes the route from
> the flowtable entry, so we avoid reiterative routing lookups.
>
> In case no entry is found in the flowtable, the packet is passed up to
> the classic GRO offload handlers. Thus, this packet follows the standard
> forwarding path. Note that the initial packets of the flow always go
> through the standard IPv4/IPv6 netfilter forward hook, that is used to
> configure what flows are placed in the flowtable. Therefore, only a few
> (initial) packets follow the standard forwarding path while most of the
> follow up packets take this new fast forwarding path.
>

IIRC, there was a similar proposal a while back that want to bundle
packets of the same flow together (without doing GRO) so that they
could be processed by various functions by looking at just one
representative packet in the group. The concept had some promise, but
in the end it created quite a bit of complexity since at some point
the packet bundle needed to be undone to go back to processing the
individual packets.

Tom

> The fast forwarding path is enabled through explicit user policy, so the
> user needs to request this behaviour from control plane, the following
> example shows how to place flows in the new fast forwarding path from
> the netfilter forward chain:
>
>  table x {
>         flowtable f {
>                 hook early_ingress priority 0; devices = { eth0, eth1 }
>         }
>
>         chain y {
>                 type filter hook forward priority 0;
>                 ip protocol tcp flow offload @f
>         }
>  }
>
> The example above defines a fastpath for TCP flows that are placed in
> the flowtable 'f', this flowtable is hooked at the new early_ingress
> hook. The initial TCP packets that match this rule from the standard
> fowarding path create an entry in the flowtable, thus, GRO creates chain
> of packets for those that find an entry in the flowtable and send
> them through the neighbour layer.
>
> This new hook is happening before the ingress taps, therefore, packets
> that follow this new fast forwarding path are not shown by tcpdump.
>
> This patchset supports both layer 3 IPv4 and IPv6, and layer 4 TCP and
> UDP protocols. This fastpath also integrates with the IPSec
> infrastructure and the ESP protocol.
>
> We have collected performance numbers:
>
>         TCP TSO         TCP Fast Forward
>         32.5 Gbps       35.6 Gbps
>
>         UDP             UDP Fast Forward
>         17.6 Gbps       35.6 Gbps
>
>         ESP             ESP Fast Forward
>         6 Gbps          7.5 Gbps
>
> For UDP, this is doubling performance, and we almost achieve line rate
> with one single CPU using the Intel i40e NIC. We got similar numbers
> with the Mellanox ConnectX-4. For TCP, this is slightly improving things
> even if TSO is being defeated given that we need to segment the packet
> chain in software. We would like to explore HW GRO support with hardware
> vendors with this new mode, we think that should improve the TCP numbers
> we are showing above even more. For ESP traffic, performance improvement
> is ~25%, in this case, perf shows the bottleneck becomes the crypto layer.
>
> This patchset is co-authored work with Steffen Klassert.
>
> Comments are welcome, thanks.
>
>
> Pablo Neira Ayuso (6):
>   netfilter: nft_chain_filter: add support for early ingress
>   netfilter: nf_flow_table: add hooknum to flowtable type
>   netfilter: nf_flow_table: add flowtable for early ingress hook
>   netfilter: nft_flow_offload: enable offload after second packet is seen
>   netfilter: nft_flow_offload: remove secpath check
>   netfilter: nft_flow_offload: make sure route is not stale
>
> Steffen Klassert (7):
>   net: Add a helper to get the packet offload callbacks by priority.
>   net: Change priority of ipv4 and ipv6 packet offloads.
>   net: Add a GSO feature bit for the netfilter forward fastpath.
>   net: Use one bit of NAPI_GRO_CB for the netfilter fastpath.
>   netfilter: add early ingress hook for IPv4
>   netfilter: add early ingress support for IPv6
>   netfilter: add ESP support for early ingress
>
>  include/linux/netdev_features.h         |   4 +-
>  include/linux/netdevice.h               |   6 +-
>  include/linux/netfilter.h               |   6 +
>  include/linux/netfilter_ingress.h       |   1 +
>  include/linux/skbuff.h                  |   2 +
>  include/net/netfilter/early_ingress.h   |  24 +++
>  include/net/netfilter/nf_flow_table.h   |   4 +
>  include/uapi/linux/netfilter.h          |   1 +
>  net/core/dev.c                          |  50 ++++-
>  net/ipv4/af_inet.c                      |   1 +
>  net/ipv4/netfilter/Makefile             |   1 +
>  net/ipv4/netfilter/early_ingress.c      | 327 +++++++++++++++++++++++++++++
>  net/ipv4/netfilter/nf_flow_table_ipv4.c |  12 ++
>  net/ipv6/ip6_offload.c                  |   1 +
>  net/ipv6/netfilter/Makefile             |   1 +
>  net/ipv6/netfilter/early_ingress.c      | 315 ++++++++++++++++++++++++++++
>  net/ipv6/netfilter/nf_flow_table_ipv6.c |   1 +
>  net/netfilter/Kconfig                   |   8 +
>  net/netfilter/Makefile                  |   1 +
>  net/netfilter/core.c                    |  35 +++-
>  net/netfilter/early_ingress.c           | 361 ++++++++++++++++++++++++++++++++
>  net/netfilter/nf_flow_table_inet.c      |   1 +
>  net/netfilter/nf_flow_table_ip.c        |  72 +++++++
>  net/netfilter/nf_tables_api.c           | 120 ++++++-----
>  net/netfilter/nft_chain_filter.c        |   6 +-
>  net/netfilter/nft_flow_offload.c        |  13 +-
>  net/xfrm/xfrm_output.c                  |   4 +
>  27 files changed, 1297 insertions(+), 81 deletions(-)
>  create mode 100644 include/net/netfilter/early_ingress.h
>  create mode 100644 net/ipv4/netfilter/early_ingress.c
>  create mode 100644 net/ipv6/netfilter/early_ingress.c
>  create mode 100644 net/netfilter/early_ingress.c
>
> --
> 2.11.0
>
>
