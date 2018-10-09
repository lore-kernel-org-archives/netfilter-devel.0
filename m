From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH net-next 0/3] ip_tunnel: specify tunnel type via template
Date: Wed, 10 Oct 2018 00:24:36 +0200
Message-ID: <20181009222439.29399-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org,
        roopa@cumulusnetworks.com, amir@vadai.me, pshelar@ovn.org,
        u9012063@gmail.com, daniel@iogearbox.net,
        jakub.kicinski@netronome.com
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi,

The following patchset adds a new field to the tunnel metadata template.
This new field allows us to restrict the configuration to a given tunnel
driver in order to catch incorrect configuration that may result in
packets going to the wrong tunnel driver.

Changes with regards to initial RFC [1] are:

1) Explicit tunnel type initialization to TUNNEL_TYPE_UNSPEC in existing
   clients for this code, as requested by Daniel.

2) Add TUNNEL_TYPE_* definition through enum tunnel_type in
   uapi/linux/if_tunnel.h, so we don't need to redefine this in every
   client of this infrastructure.

3) Add TUNNEL_TYPE_IPIP, TUNNEL_TYPE_IPIP6 and TUNNEL_TYPE_IP6IP6, which
   were missing in the original RFC.

Let me know if you any more comments, thanks.

[1] https://marc.info/?l=netfilter-devel&m=153861145204094&w=2

Pablo Neira Ayuso (3):
  ip_tunnel: add type field to struct ip_tunnel_info
  net: act_tunnel_key: support for tunnel type
  netfilter: nft_tunnel: support for tunnel type

 drivers/net/geneve.c                      |  3 ++-
 drivers/net/vxlan.c                       | 13 +++++++------
 include/net/dst_metadata.h                |  1 +
 include/net/ip_tunnels.h                  |  8 ++++++++
 include/uapi/linux/if_tunnel.h            | 13 ++++++++++++-
 include/uapi/linux/netfilter/nf_tables.h  |  1 +
 include/uapi/linux/tc_act/tc_tunnel_key.h |  1 +
 net/core/filter.c                         |  1 +
 net/ipv4/ip_gre.c                         |  2 ++
 net/ipv4/ip_tunnel.c                      |  3 ++-
 net/ipv6/ip6_gre.c                        |  2 ++
 net/ipv6/ip6_tunnel.c                     |  6 ++++--
 net/netfilter/nft_tunnel.c                |  9 ++++++++-
 net/openvswitch/flow_netlink.c            |  1 +
 net/sched/act_tunnel_key.c                |  9 +++++++++
 15 files changed, 61 insertions(+), 12 deletions(-)
