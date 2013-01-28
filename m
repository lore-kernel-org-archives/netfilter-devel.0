From: pablo@netfilter.org
Subject: [stable-3.7 00/14] netfilter stable fixes for 3.7
Date: Mon, 28 Jan 2013 20:31:19 +0100
Message-ID: <1359401493-6196-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: davem@davemloft.net, netfilter-devel@vger.kernel.org
To: stable@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50425 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751306Ab3A1Tbp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 Jan 2013 14:31:45 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pablo Neira Ayuso <pablo@netfilter.org>

This patchset contain netfilter stable fixes for 3.7, original
commits (in no particular order) are:

0c36b48 netfilter: nfnetlink_log: fix mac address for 6in4 tunnels
e035edd netfilter: nfnetlink_log: fix possible compilation issue due to missing include
665e205 netfilter: xt_recent: fix namespace destroy path
2727de7 netfilter: xt_recent: avoid high order page allocations
5b76c49 netfilter: x_tables: print correct hook names for ARP
4fe198e netfilter: ipset: Fix range bug in hash:ip,port,net
c6f4089 netfilter: ip[6]t_REJECT: fix wrong transport header pointer in TCP reset
32263dd netfilter: xt_hashlimit: fix namespace destroy path
0918184 netfilter: xt_hashlimit: fix race that results in duplicated entries
1310b95 netfilter: ctnetlink: fix leak in error path of ctnetlink_create_expect
97cf00e netfilter: nf_ct_reasm: fix conntrack reassembly expire code
10db906 netfilter: xt_CT: recover NOTRACK target support
757ae31 netfilter: fix missing dependencies for the NOTRACK target
1e47ee8 netfilter: nf_conntrack: fix BUG_ON while removing nf_conntrack with netns

Please, apply. Thanks!

Bob Hockney (1):
  netfilter: nfnetlink_log: fix mac address for 6in4 tunnels

Eric Dumazet (1):
  netfilter: xt_recent: avoid high order page allocations

Haibo Xi (1):
  netfilter: nf_ct_reasm: fix conntrack reassembly expire code

Jan Engelhardt (1):
  netfilter: x_tables: print correct hook names for ARP

Jesper Juhl (1):
  netfilter: ctnetlink: fix leak in error path of ctnetlink_create_expect

Mukund Jampala (1):
  netfilter: ip[6]t_REJECT: fix wrong transport header pointer in TCP reset

Pablo Neira Ayuso (6):
  netfilter: nfnetlink_log: fix possible compilation issue due to missing include
  netfilter: xt_CT: recover NOTRACK target support
  netfilter: fix missing dependencies for the NOTRACK target
  netfilter: xt_hashlimit: fix race that results in duplicated entries
  netfilter: xt_CT: fix unset return value if conntrack zone are disabled
  netfilter: nf_conntrack: fix BUG_ON while removing nf_conntrack with netns

Vitaly E. Lavrov (2):
  netfilter: xt_recent: fix namespace destroy path
  netfilter: xt_hashlimit: fix namespace destroy path

 include/net/netfilter/nf_conntrack_core.h |    2 ++
 include/net/netns/x_tables.h              |    1 +
 net/ipv4/netfilter/ipt_REJECT.c           |    1 +
 net/ipv6/netfilter/ip6t_REJECT.c          |    1 +
 net/ipv6/netfilter/nf_conntrack_reasm.c   |    5 ++-
 net/netfilter/Kconfig                     |    7 ++++
 net/netfilter/nf_conntrack_core.c         |    9 ++---
 net/netfilter/nf_conntrack_netlink.c      |    2 +-
 net/netfilter/nf_conntrack_standalone.c   |    1 +
 net/netfilter/nfnetlink_log.c             |   16 +++++++--
 net/netfilter/x_tables.c                  |   28 ++++++++++-----
 net/netfilter/xt_CT.c                     |   54 +++++++++++++++++++++++++++--
 net/netfilter/xt_hashlimit.c              |   54 ++++++++++++++++++++++++-----
 net/netfilter/xt_recent.c                 |   43 ++++++++++++++++++-----
 14 files changed, 187 insertions(+), 37 deletions(-)

--
1.7.10.4

