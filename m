From: pablo@netfilter.org
Subject: [PATCH 0/7] netfilter fixes for 3.0.0-rc1 (try 2)
Date: Mon,  6 Jun 2011 02:11:33 +0200
Message-ID: <1307319100-21827-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: davem@davemloft.net, Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54910 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751574Ab1FFALt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 5 Jun 2011 20:11:49 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pablo Neira Ayuso <pablo@netfilter.org>

Hi David,

the following patches contain Netfilter fixes for 3.0.0-rc1.
The highlights are:

- fix compilation warning in conntrack with recent gcc versions by Eric.

- a couple of minor fixes for ipset from Jozsef.

- one fix for IPVS with SNAT from Julian Anastasov.

- one fix for NAT and checksumming also from Julian.

- fix refcount leak in conntrack with ICMP[v6] by myself.

You can pull them from:

git://1984.lsi.us.es/net-2.6 pablo/nf-2.6-updates

Thanks!

Dave Jones (1):
  netfilter: use unsigned variables for packet lengths in ip[6]_queue.

Eric Dumazet (1):
  netfilter: add more values to enum ip_conntrack_info

Jozsef Kadlecsik (2):
  netfilter: ipset: Fix return code for destroy when sets are in use
  netfilter: ipset: Use the stored first cidr value instead of '1'

Julian Anastasov (2):
  ipvs: restore support for iptables SNAT
  netfilter: nf_nat: fix crash in nf_nat_csum

Pablo Neira Ayuso (1):
  netfilter: nf_conntrack: fix ct refcount leak in l4proto->error()

 include/linux/netfilter/nf_conntrack_common.h  |    3 +++
 net/ipv4/netfilter/ip_queue.c                  |    3 ++-
 net/ipv4/netfilter/ipt_CLUSTERIP.c             |    6 +++---
 net/ipv4/netfilter/ipt_MASQUERADE.c            |    2 +-
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c |    2 +-
 net/ipv4/netfilter/nf_conntrack_proto_icmp.c   |    2 +-
 net/ipv4/netfilter/nf_nat_core.c               |    2 +-
 net/ipv4/netfilter/nf_nat_helper.c             |    2 +-
 net/ipv4/netfilter/nf_nat_rule.c               |    2 +-
 net/ipv4/netfilter/nf_nat_standalone.c         |    4 ++--
 net/ipv6/netfilter/ip6_queue.c                 |    3 ++-
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c |    2 +-
 net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c |    2 +-
 net/netfilter/ipset/ip_set_core.c              |    2 +-
 net/netfilter/ipset/ip_set_hash_ipportnet.c    |   10 ++++++----
 net/netfilter/ipset/ip_set_hash_net.c          |    8 ++++++--
 net/netfilter/ipset/ip_set_hash_netport.c      |    6 ++++--
 net/netfilter/ipvs/ip_vs_core.c                |   16 ++++++++--------
 net/netfilter/nf_conntrack_core.c              |    7 +++++--
 net/netfilter/nf_conntrack_ftp.c               |    2 +-
 net/netfilter/nf_conntrack_h323_main.c         |   10 ++++------
 net/netfilter/nf_conntrack_irc.c               |    3 +--
 net/netfilter/nf_conntrack_pptp.c              |    3 +--
 net/netfilter/nf_conntrack_sane.c              |    2 +-
 net/netfilter/nf_conntrack_sip.c               |    2 +-
 net/netfilter/xt_socket.c                      |    4 ++--
 26 files changed, 61 insertions(+), 49 deletions(-)

-- 
1.7.2.5

