From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 00/12]: Netfilter Update
Date: Thu,  6 Apr 2006 12:04:52 +0200 (MEST)
Message-ID: <20060406100452.17409.37120.sendpatchset@localhost.localdomain>
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

following are a couple of netfilter fixes and enhancements: a couple of
patches to fix the section mismatch warnings and clean up the netfilter
hook registration, checksumming consolidation with better HW checksum
error handling and some cleanup patches for the H.323 helper. The
diffstat is a bit misleading, there is a lot of noise from the renaming
of two large H.323 header files and a lot of reindentation of netfilter
structures, its not as bad as it looks :) If you think its too large
for -rc1 I can hold on to the checksumming patches, the others should
go in as they actually fix stuff. Thanks.


 include/linux/netfilter.h                                     |   42 
 include/linux/netfilter_ipv4.h                                |    2 
 include/linux/netfilter_ipv4/ip_conntrack_h323.h              |   52 
 include/linux/netfilter_ipv4/ip_conntrack_helper_h323_asn1.h  |   98 +
 include/linux/netfilter_ipv4/ip_conntrack_helper_h323_types.h |  938 ++++++++++
 include/linux/netfilter_ipv6.h                                |    3 
 net/ipv4/netfilter.c                                          |   50 
 net/ipv4/netfilter/Kconfig                                    |    1 
 net/ipv4/netfilter/arptable_filter.c                          |   19 
 net/ipv4/netfilter/ip_conntrack_helper_h323.c                 |   50 
 net/ipv4/netfilter/ip_conntrack_helper_h323_asn1.c            |    2 
 net/ipv4/netfilter/ip_conntrack_helper_h323_asn1.h            |   98 -
 net/ipv4/netfilter/ip_conntrack_helper_h323_types.h           |  938 ----------
 net/ipv4/netfilter/ip_conntrack_proto_icmp.c                  |   23 
 net/ipv4/netfilter/ip_conntrack_proto_tcp.c                   |    7 
 net/ipv4/netfilter/ip_conntrack_proto_udp.c                   |    7 
 net/ipv4/netfilter/ip_conntrack_standalone.c                  |  270 +-
 net/ipv4/netfilter/ip_nat_helper_h323.c                       |   58 
 net/ipv4/netfilter/ip_nat_standalone.c                        |  161 -
 net/ipv4/netfilter/ip_queue.c                                 |   31 
 net/ipv4/netfilter/ipt_CLUSTERIP.c                            |   40 
 net/ipv4/netfilter/ipt_REJECT.c                               |    9 
 net/ipv4/netfilter/iptable_filter.c                           |   21 
 net/ipv4/netfilter/iptable_mangle.c                           |   33 
 net/ipv4/netfilter/iptable_raw.c                              |   35 
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c                |  227 --
 net/ipv4/netfilter/nf_conntrack_proto_icmp.c                  |   20 
 net/ipv6/netfilter.c                                          |   51 
 net/ipv6/netfilter/ip6_queue.c                                |   31 
 net/ipv6/netfilter/ip6table_filter.c                          |   21 
 net/ipv6/netfilter/ip6table_mangle.c                          |   33 
 net/ipv6/netfilter/ip6table_raw.c                             |   15 
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c                |  181 -
 net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c                |   12 
 net/netfilter/core.c                                          |   51 
 net/netfilter/nf_conntrack_proto_tcp.c                        |   50 
 net/netfilter/nf_conntrack_proto_udp.c                        |   50 
 net/netfilter/nf_conntrack_standalone.c                       |  115 -
 net/netfilter/nf_queue.c                                      |   49 
 net/netfilter/nfnetlink_log.c                                 |   25 
 net/netfilter/nfnetlink_queue.c                               |   27 
 41 files changed, 1799 insertions(+), 2147 deletions(-)

Jing Min Zhao:
      [NETFILTER]: H.323 helper: move some function prototypes to ip_conntrack_h323.h
      [NETFILTER]: H.323 helper: change EXPORT_SYMBOL to EXPORT_SYMBOL_GPL
      [NETFILTER]: H.323 helper: make get_h245_addr() static
      [NETFILTER]: H.323 helper: add parameter 'default_rrq_ttl'
      [NETFILTER]: H.323 helper: update Changelog

Patrick McHardy:
      [NETFILTER]: Add helper functions for mass hook registration/unregistration
      [NETFILTER]: Clean up hook registration
      [NETFILTER]: Fix section mismatch warnings
      [NETFILTER]: Fix IP_NF_CONNTRACK_NETLINK dependency
      [NETFILTER]: Introduce infrastructure for address family specific operations
      [NETFILTER]: Add address family specific checksum helpers
      [NETFILTER]: Convert conntrack/ipt_REJECT to new checksumming functions
