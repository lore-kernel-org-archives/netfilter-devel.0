From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 00/09]: Netfilter update
Date: Tue, 21 Mar 2006 02:55:49 +0100 (MET)
Message-ID: <20060321015549.11977.45799.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Hi Dave,

following are my pending netfilter patches for 2.6.17, most notable is
a very nice and clean H.323 connection tracking helper by Jing Min Zhao.
Please apply.

 
 include/linux/netfilter/x_tables.h                  |   64 
 include/linux/netfilter_arp/arp_tables.h            |   37 
 include/linux/netfilter_ipv4/ip_conntrack.h         |    2 
 include/linux/netfilter_ipv4/ip_conntrack_h323.h    |   30 
 include/linux/netfilter_ipv4/ip_tables.h            |   72 
 include/linux/netfilter_ipv6/ip6_tables.h           |   71 
 include/net/netfilter/nf_conntrack.h                |    4 
 include/net/tc_act/tc_ipt.h                         |    4 
 net/ipv4/netfilter/Kconfig                          |   26 
 net/ipv4/netfilter/Makefile                         |    5 
 net/ipv4/netfilter/arp_tables.c                     |    6 
 net/ipv4/netfilter/ip_conntrack_core.c              |    4 
 net/ipv4/netfilter/ip_conntrack_helper_h323.c       | 1731 +++++++++++++++++
 net/ipv4/netfilter/ip_conntrack_helper_h323_asn1.c  |  870 +++++++++
 net/ipv4/netfilter/ip_conntrack_helper_h323_asn1.h  |   98 +
 net/ipv4/netfilter/ip_conntrack_helper_h323_types.c | 1926 ++++++++++++++++++++
 net/ipv4/netfilter/ip_conntrack_helper_h323_types.h |  938 +++++++++
 net/ipv4/netfilter/ip_conntrack_netlink.c           |   72 
 net/ipv4/netfilter/ip_nat_helper_h323.c             |  605 ++++++
 net/ipv4/netfilter/ip_tables.c                      |   15 
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c      |    1 
 net/ipv6/netfilter/ip6_tables.c                     |   15 
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c      |    1 
 net/netfilter/Kconfig                               |    6 
 net/netfilter/nf_conntrack_core.c                   |   35 
 net/netfilter/nf_conntrack_netlink.c                |   84 
 net/netfilter/nf_conntrack_standalone.c             |    2 
 net/netfilter/nfnetlink_queue.c                     |   19 
 net/netfilter/x_tables.c                            |   16 
 net/netfilter/xt_CLASSIFY.c                         |   12 
 net/netfilter/xt_CONNMARK.c                         |   12 
 net/netfilter/xt_MARK.c                             |   21 
 net/netfilter/xt_NFQUEUE.c                          |   19 
 net/netfilter/xt_NOTRACK.c                          |   12 
 net/netfilter/xt_comment.c                          |   12 
 net/netfilter/xt_connbytes.c                        |   12 
 net/netfilter/xt_connmark.c                         |   29 
 net/netfilter/xt_conntrack.c                        |   33 
 net/netfilter/xt_dccp.c                             |   12 
 net/netfilter/xt_helper.c                           |   29 
 net/netfilter/xt_length.c                           |   12 
 net/netfilter/xt_limit.c                            |   12 
 net/netfilter/xt_mac.c                              |   12 
 net/netfilter/xt_mark.c                             |   12 
 net/netfilter/xt_physdev.c                          |   12 
 net/netfilter/xt_pkttype.c                          |   12 
 net/netfilter/xt_policy.c                           |   18 
 net/netfilter/xt_realm.c                            |    5 
 net/netfilter/xt_sctp.c                             |   12 
 net/netfilter/xt_state.c                            |   41 
 net/netfilter/xt_string.c                           |   12 
 net/netfilter/xt_tcpmss.c                           |   12 
 net/netfilter/xt_tcpudp.c                           |   26 
 scripts/Kbuild.include                              |    6 
 54 files changed, 6802 insertions(+), 364 deletions(-)

Dmitry Mishin:
      [NETFILTER]: futher {ip,ip6,arp}_tables unification

Jing Min Zhao:
      [NETFILTER]: Add H.323 conntrack/NAT helper

Pablo Neira Ayuso:
      [NETFILTER]: ctnetlink: Fix expectaction mask dumping
      [NETFILTER]: nfnetlink_queue: fix nfnetlink message size
      [NETFILTER]: conntrack: cleanup the conntrack ID initialization
      [NETFILTER]: x_tables: set the protocol family in x_tables targets/matches
      [NETFILTER]: nf_conntrack: support for layer 3 protocol load on demand

Patrick McHardy:
      [NETFILTER]: Fix xt_policy address matching

Thomas Voegtle:
      [NETFILTER]: Fix Kconfig typos
