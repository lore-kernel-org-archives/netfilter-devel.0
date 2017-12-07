From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next RFC,v2 0/6] Flow offload infrastructure
Date: Thu,  7 Dec 2017 13:44:55 +0100
Message-ID: <20171207124501.24325-1-pablo@netfilter.org>
Cc: netdev@vger.kernel.org, f.fainelli@gmail.com,
        simon.horman@netronome.com, ronye@mellanox.com, jiri@mellanox.com,
        nbd@nbd.name, john@phrozen.org, kubakici@wp.pl, fw@strlen.de
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52646 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753284AbdLGMp0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 7 Dec 2017 07:45:26 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id EA8C21BCFD1
        for <netfilter-devel@vger.kernel.org>; Thu,  7 Dec 2017 13:45:23 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BAACFDA86B
        for <netfilter-devel@vger.kernel.org>; Thu,  7 Dec 2017 13:45:08 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

This patchset is a new iteration of the flow offload infrastructure [1].
This round adds a netlink control plane to configure flow table, so
there is no one single flow table, as in the previous patchset, that
gets registered unconditionally.

The following example shows how to create a flow table whose name is 'w',
and a rule that specifies what flows are offloaded into this flow table.

	table ip x {
	        flowtable w {
	                hook ingress priority -100 devices = { eth0, eth1 };
	        }

	        chain y {
	                type filter hook forward priority 0; policy accept;
	                ip protocol tcp flow offload @w
	        }
	}

The flow table control plane is useful to set on specific flow table
configurations, including what devices you want to bind the flow table
to, the priority in the netfilter pipeline at the ingress hooks, custom
timeout for the flow table, and anything else that needs a toggle to be
enabled/disabled through this control plane.

* Patch 1/6 adds the IPS_OFFLOAD status bit for conntrack, the conntrack
  garbage collector does not expire entries that has been offloaded.
  Conntrack entries that have been offloaded in the conntrack table look
  like this:

  ipv4     2 tcp      6 src=10.141.10.2 dst=147.75.205.195 sport=36392 dport=443 src=147.75.205.195 dst=192.168.2.195 sport=443 dport=36392 [OFFLOAD] use=3

* Patch 2/6 adds a netlink control plane, that allows to create, list
  and delete flow tables. This patch also introduces the nf_flow_table
  object, that uses a rhashtable, garbage collector to remove entries
  that has expired, ie. those that we see no traffic for a while, and
  the flow table type, to allow to register IPv4 and IPv6 flow table.
  It's basically boiler plate netlink code that integrates into
  nf_tables.

* Patch 3/6 adds the generic flow table representation, this includes
  the flow table API to create, remove and lookup for entries in the
  flow table, and the generic garbage collector to expire entries. This
  is basically the common code to all flow table types.

* Patch 4/6 provides the IPv4 flow table flavour, that is the only type
  so far. This provides the ingress hook for IPv4, basically to look up
  for an entry in the flow table, then in case of hit, decrement TTL and
  pass it on to the neighbour layer for transmission at a given device,
  otherwise fall back to classic forwarding path.

* Patch 5/6 introduces the "flow offload" action. This allocates the
  flow entry and adds it to the flow table. This allows you to decide
  at what stage you want to offload flows through policy.

* Patch 6/6 adds the net_device ndo to offload flows to hardware, if
  driver implements this feature. This adds a new workqueue to configure
  hardware flow offload from user context. There is no driver so far
  available using this, but I've been approached by several hardware
  driver developers, from different companies, willing to implement
  this, so I'm inclined to keep this in a branch in my nf-next tree
  until we have the first client of this.

This is my TODO list, things I would like to finish:

* netns support.
* IPv6 support.
* Port address translation, so far only layer 3 NATs.
* PMTU interactions.
* stateful flow tracking.

Among other things that I would like to polish, just more fine grain
details.

Cc'ing everyone that have provided feedback privately or publicly since
the last time. If I forgot anyone to be Cc'ed, please accept my apologies.

Comments welcome, thanks.

[1] https://lwn.net/Articles/738214/

Pablo Neira Ayuso (6):
  netfilter: nf_conntrack: add IPS_OFFLOAD status bit
  netfilter: nf_tables: add flow table netlink frontend
  netfilter: add generic flow table infrastructure
  netfilter: flow table support for IPv4
  netfilter: nf_tables: flow offload expression
  netfilter: nft_flow_offload: add ndo hooks for hardware offload

 include/linux/netdevice.h                          |   9 +
 include/net/netfilter/nf_flow_table.h              |  96 +++
 include/net/netfilter/nf_tables.h                  |  51 ++
 include/uapi/linux/netfilter/nf_conntrack_common.h |   4 +
 include/uapi/linux/netfilter/nf_tables.h           |  64 ++
 net/ipv4/netfilter/Kconfig                         |   8 +
 net/ipv4/netfilter/Makefile                        |   3 +
 net/ipv4/netfilter/nf_flow_table_ipv4.c            | 316 +++++++++
 net/netfilter/Kconfig                              |  14 +
 net/netfilter/Makefile                             |   4 +
 net/netfilter/nf_conntrack_core.c                  |  19 +
 net/netfilter/nf_conntrack_netlink.c               |  15 +-
 net/netfilter/nf_conntrack_proto_tcp.c             |   3 +
 net/netfilter/nf_conntrack_standalone.c            |  12 +-
 net/netfilter/nf_flow_table.c                      | 295 ++++++++
 net/netfilter/nf_tables_api.c                      | 749 ++++++++++++++++++++-
 net/netfilter/nft_flow_offload.c                   | 353 ++++++++++
 17 files changed, 2009 insertions(+), 6 deletions(-)
 create mode 100644 include/net/netfilter/nf_flow_table.h
 create mode 100644 net/ipv4/netfilter/nf_flow_table_ipv4.c
 create mode 100644 net/netfilter/nf_flow_table.c
 create mode 100644 net/netfilter/nft_flow_offload.c

-- 
2.11.0

