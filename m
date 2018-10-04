From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH RFC,net-next 0/3] ip_tunnel: specify tunnel type via template
Date: Thu,  4 Oct 2018 02:03:42 +0200
Message-ID: <20181004000345.2380-1-pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, roopa@cumulusnetworks.com,
        amir@vadai.me, pshelar@ovn.org, u9012063@gmail.com
To: netdev@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi,

The following patchset adds a new field to the tunnel metadata template
to restrict the configuration to a given tunnel driver. Currently, a
misconfiguration may result in packets going to the wrong tunnel driver.

Although we have the tunnel option flags, they are not mandatory for
some tunnel drivers, eg. vxlan, which may use it or not; and gre which
does not use them.

This patch updates tc's tunnel action and netfilter's tunnel extension
to use this new field. OVS netlink interface has been left unset, although they
could be updated to use this.

By extending the existing tc action to support the IP_TUNNEL_INFO_BRIDGE
mode, I think it should be possible to expose IP_TUNNEL_TYPE_VLAN too,
although this patchset doesn't address this scenario.

The field is initialized to zero, which maps to IP_TUNNEL_TYPE_UNSPEC to
retain the existing behaviour, so the existing flexibility is still in
place while this new feature is added.

Cc'ing people that git annotate show as dealing with these bits more
recently.

Compile tested only.

Comments welcome, thanks.

Pablo Neira Ayuso (3):
  ip_tunnel: add type field to struct ip_tunnel_info
  net: act_tunnel_key: support for tunnel type
  netfilter: nft_tunnel: support for tunnel type

 drivers/net/geneve.c                      |  3 ++-
 drivers/net/vxlan.c                       | 13 +++++++------
 include/net/dst_metadata.h                |  1 +
 include/net/ip_tunnels.h                  | 16 ++++++++++++++++
 include/uapi/linux/netfilter/nf_tables.h  | 10 ++++++++++
 include/uapi/linux/tc_act/tc_tunnel_key.h | 10 ++++++++++
 net/ipv4/ip_gre.c                         |  2 ++
 net/ipv6/ip6_gre.c                        |  2 ++
 net/netfilter/nft_tunnel.c                |  9 ++++++++-
 net/openvswitch/flow_netlink.c            |  1 +
 net/sched/act_tunnel_key.c                |  9 +++++++++
 11 files changed, 68 insertions(+), 8 deletions(-)
