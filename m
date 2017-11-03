From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH RFC,WIP 0/5] Flow offload infrastructure
Date: Fri,  3 Nov 2017 16:26:31 +0100
Message-ID: <20171103152636.9967-1-pablo@netfilter.org>
Cc: netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43302 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755822AbdKCP0p (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 3 Nov 2017 11:26:45 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id F1AE7C0B26
        for <netfilter-devel@vger.kernel.org>; Fri,  3 Nov 2017 16:26:43 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E05A3B7FE9
        for <netfilter-devel@vger.kernel.org>; Fri,  3 Nov 2017 16:26:43 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

This patch adds the flow offload infrastructure for Netfilter. This adds
a new 'nf_flow_offload' module that registers a hook at ingress. Every
packet that hits the flow table is forwarded to where the flow table
entry specifies in terms of destination/gateway and netdevice. In case
of flow table miss, the packet follows the classic forward path.

This flow table is populated via the new nftables VM action
'flow_offload', so the user can selectively specify what flows are
placed into the flow table, an example ruleset would look like this:

        table inet x {
                chain y {
                        type filter hook forward priority 0; policy accept;
                        ip protocol tcp flow offload counter
                        counter
                }
        }

The 'flow offload' action adds the flow entry once the flow is in
established state, according to the connection tracking definition, ie.
we have seen traffic in both directions. Therefore, only initial packets
of the flow follow the classic forwarding path.

* Patch 1/5 is nothing really interesting, just a little preparation change.

* Patch 2/5 adds a software flow table representation. It uses the
  rhashtable and an API to operate with it, it also introduces the
  'struct flow_offload' that represents a flow table entry. There's a
  garbage collector kernel thread that cleans up entries for which we
  have not seen any packet for a while.

* Patch 3/5 Just adds the missing bits to integrate the software flow
  table with conntrack. The software flow table owns the conntrack
  object, so it is basically responsible for releasing it. Conntrack
  entries that have been offloaded in the conntrack table will look like
  this:

ipv4     2 tcp      6 src=10.141.10.2 dst=147.75.205.195 sport=36392 dport=443 src=147.75.205.195 dst=192.168.2.195 sport=443 dport=36392 [OFFLOAD] use=2

* Patch 4/5 adds the extension for nf_tables that can be used to select
  what flows are offloaded through policy.

* Patch 5/5 Switches and NICs come with built-in flow table, I've been
  observing out of tree patches in OpenWRT/LEDE to integrate this into
  Netfilter for a little while. This patch adds the ndo hooks to
  populate hardware flow table. This patchs a workqueue to configure
  from user context - we need to hold the mdio mutex for this. There
  will be a little time until packets will follow the hardware path.
  So packets will be following the software flow table path for a little
  while until the start going through hardware.

I'm measuring here that the software flow table forwarding path is 2.5
faster than the classic forwarding path in my testbed.

TODO, still many things:

* Only IPv4 at this time.
* Only IPv4 SNAT is supported.
* No netns support yet.
* Missing netlink interface to operate with the flow table, to force the
  handover of flow to the software path.
* Higher configurability, instead of registering the flow table
  inconditionally, add an interface to specify software flow table
  properties.
* No flow counters at this time.

This should serve a number of usecases where we can rely on this kernel
bypass. Packets that need fragmentation / PMTU / IP option handling /
... and any specific handling, then we should pass them up to the
forwarding classic path.

Comments welcome,
Thanks.

Pablo Neira Ayuso (5):
  netfilter: nf_conntrack: move nf_ct_netns_{get,put}() to core
  netfilter: add software flow offload infrastructure
  netfilter: nf_flow_offload: integration with conntrack
  netfilter: nf_tables: flow offload expression
  netfilter: nft_flow_offload: add ndo hooks for hardware offload

 include/linux/netdevice.h                          |   4 +
 include/net/flow_offload.h                         |  67 ++++
 include/net/netfilter/nf_conntrack.h               |   3 +-
 include/uapi/linux/netfilter/nf_conntrack_common.h |   4 +
 include/uapi/linux/netfilter/nf_tables.h           |   9 +
 net/netfilter/Kconfig                              |  14 +
 net/netfilter/Makefile                             |   4 +
 net/netfilter/nf_conntrack_core.c                  |   7 +-
 net/netfilter/nf_conntrack_netlink.c               |  15 +-
 net/netfilter/nf_conntrack_proto.c                 |  37 +-
 net/netfilter/nf_conntrack_proto_tcp.c             |   3 +
 net/netfilter/nf_conntrack_standalone.c            |  12 +-
 net/netfilter/nf_flow_offload.c                    | 421 ++++++++++++++++++++
 net/netfilter/nft_ct.c                             |  39 +-
 net/netfilter/nft_flow_offload.c                   | 430 +++++++++++++++++++++
 15 files changed, 1024 insertions(+), 45 deletions(-)
 create mode 100644 include/net/flow_offload.h
 create mode 100644 net/netfilter/nf_flow_offload.c
 create mode 100644 net/netfilter/nft_flow_offload.c

-- 
2.11.0


