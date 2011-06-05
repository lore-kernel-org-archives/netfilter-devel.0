From: pablo@netfilter.org
Subject: [PATCH 00/20] netfilter updates for 3.0.0-rc1
Date: Mon,  6 Jun 2011 01:08:51 +0200
Message-ID: <1307315350-17782-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: davem@davemloft.net, Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52009 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756366Ab1FEXJX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 5 Jun 2011 19:09:23 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pablo Neira Ayuso <pablo@netfilter.org>

Hi David,

the following patches contain Netfilter updates for 3.0.0-rc1
The highlights are:

- ipset updates from Jozsef.

- one IPVS fix from Julian Anastasov.

- one enhancement for the SIP tracker to handle Cisco 7941/7945 IP phones

- deprecate /proc/net/nf_conntrack interface from Jan.

- one fix for nf_nat_csum mangling also from Julian.

- one fix for a refcount leak in the untracked conntrack by myself.

Please pull from:

git://1984.lsi.us.es/net-next-2.6 pablo/nf-next-2.6-updates

Thanks!

Dave Jones (1):
  netfilter: use unsigned variables for packet lengths in ip[6]_queue.

Eric Dumazet (2):
  netfilter: add more values to enum ip_conntrack_info
  netfilter: nf_conntrack: remove one synchronize_net()

Jan Engelhardt (1):
  netfilter: nf_conntrack: provide config option to disable ancient
    procfs parts

Jesper Juhl (1):
  ipvs: Avoid undefined order of evaluation in assignments to struct
    nf_conn *

Jozsef Kadlecsik (11):
  netfilter: ipset: Options and flags support added to the kernel API
  netfilter: ipset: Support listing setnames and headers too
  netfilter: ipset: Fix adding ranges to hash types
  netfilter: ipset: Set type support with multiple revisions added
  netfilter: ipset: Support range for IPv4 at adding/deleting elements
    for hash:*net* types
  netfilter: ipset: Take into account cidr value for the from address
    when creating the set
  netfilter: ipset: Add xt_action_param to the variant level kadt
    functions
  netfilter: ipset: Fix return code for destroy when sets are in use
  netfilter: ipset: Use the stored first cidr value instead of '1'
  netfilter: ipset: hash:net,iface type introduced
  netfilter: ipset: Whitespace and coding fixes, detected by
    checkpatch.pl

Julian Anastasov (2):
  ipvs: restore support for iptables SNAT
  netfilter: nf_nat: fix crash in nf_nat_csum

Kevin Cernekee (1):
  netfilter: nf_conntrack_sip: Handle Cisco 7941/7945 IP phones

Pablo Neira Ayuso (1):
  netfilter: nf_conntrack: fix ct refcount leak in l4proto->error()

 include/linux/netfilter/ipset/ip_set.h         |   47 ++-
 include/linux/netfilter/ipset/ip_set_ahash.h   |   33 +-
 include/linux/netfilter/ipset/ip_set_hash.h    |    4 +
 include/linux/netfilter/ipset/ip_set_timeout.h |    3 +
 include/linux/netfilter/ipset/pfxlen.h         |   11 +-
 include/linux/netfilter/nf_conntrack_common.h  |    3 +
 include/linux/netfilter/nf_conntrack_sip.h     |    3 +
 include/linux/netfilter/xt_set.h               |   15 +-
 net/ipv4/netfilter/Kconfig                     |    2 +-
 net/ipv4/netfilter/ip_queue.c                  |    3 +-
 net/ipv4/netfilter/ipt_CLUSTERIP.c             |    6 +-
 net/ipv4/netfilter/ipt_MASQUERADE.c            |    2 +-
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c |    3 +-
 net/ipv4/netfilter/nf_conntrack_proto_icmp.c   |    2 +-
 net/ipv4/netfilter/nf_nat_core.c               |    2 +-
 net/ipv4/netfilter/nf_nat_helper.c             |    2 +-
 net/ipv4/netfilter/nf_nat_rule.c               |    2 +-
 net/ipv4/netfilter/nf_nat_sip.c                |   26 +-
 net/ipv4/netfilter/nf_nat_standalone.c         |    4 +-
 net/ipv6/netfilter/ip6_queue.c                 |    3 +-
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c |    2 +-
 net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c |    2 +-
 net/netfilter/Kconfig                          |   10 +
 net/netfilter/ipset/Kconfig                    |   10 +
 net/netfilter/ipset/Makefile                   |    1 +
 net/netfilter/ipset/ip_set_bitmap_ip.c         |   17 +-
 net/netfilter/ipset/ip_set_bitmap_ipmac.c      |   19 +-
 net/netfilter/ipset/ip_set_bitmap_port.c       |   13 +-
 net/netfilter/ipset/ip_set_core.c              |  165 +++---
 net/netfilter/ipset/ip_set_hash_ip.c           |   37 +-
 net/netfilter/ipset/ip_set_hash_ipport.c       |   55 ++-
 net/netfilter/ipset/ip_set_hash_ipportip.c     |   59 ++-
 net/netfilter/ipset/ip_set_hash_ipportnet.c    |  135 +++--
 net/netfilter/ipset/ip_set_hash_net.c          |   88 +++-
 net/netfilter/ipset/ip_set_hash_netiface.c     |  762 ++++++++++++++++++++++++
 net/netfilter/ipset/ip_set_hash_netport.c      |  113 +++-
 net/netfilter/ipset/ip_set_list_set.c          |   14 +-
 net/netfilter/ipset/pfxlen.c                   |   23 +-
 net/netfilter/ipvs/ip_vs_core.c                |   16 +-
 net/netfilter/ipvs/ip_vs_nfct.c                |    2 +-
 net/netfilter/ipvs/ip_vs_xmit.c                |    8 +-
 net/netfilter/nf_conntrack_core.c              |    7 +-
 net/netfilter/nf_conntrack_expect.c            |   12 +-
 net/netfilter/nf_conntrack_ftp.c               |    2 +-
 net/netfilter/nf_conntrack_h323_main.c         |   10 +-
 net/netfilter/nf_conntrack_irc.c               |    3 +-
 net/netfilter/nf_conntrack_pptp.c              |    3 +-
 net/netfilter/nf_conntrack_sane.c              |    2 +-
 net/netfilter/nf_conntrack_sip.c               |   19 +-
 net/netfilter/nf_conntrack_standalone.c        |    4 +-
 net/netfilter/xt_set.c                         |  152 ++++--
 net/netfilter/xt_socket.c                      |    4 +-
 52 files changed, 1581 insertions(+), 364 deletions(-)
 create mode 100644 net/netfilter/ipset/ip_set_hash_netiface.c

-- 
1.7.2.5

