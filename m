From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 00/22]: Netfilter update/fixes
Date: Mon, 12 Feb 2007 11:36:21 +0100 (MET)
Message-ID: <20070212103621.661.65165.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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

following are a number of fixes for netfilter, fixing RCU issues all over the
place, including the invalid preemption assumptions in the NF_CT_STAT_INC macro.
Additionally there are a few minor enhancements for things I noticed while going
over the code: replacement of a few unnecessary spinlocks by mutexes, some
cleanup for nf_log.c and some return value cleanup for unregistration functions.

With these patches I think there should be nothing left holding back the
preemptable RCU merge from netfilter's perspective.

Please apply, thanks.


 include/linux/netfilter.h                      |    4 
 include/linux/netfilter_ipv4/ip_conntrack.h    |    6 
 include/net/netfilter/nf_conntrack.h           |    6 
 include/net/netfilter/nf_conntrack_l3proto.h   |    4 
 include/net/netfilter/nf_conntrack_l4proto.h   |    2 
 net/bridge/netfilter/ebt_log.c                 |    2 
 net/bridge/netfilter/ebt_ulog.c                |    2 
 net/ipv4/netfilter/Kconfig                     |    8 
 net/ipv4/netfilter/ip_conntrack_core.c         |   53 +++---
 net/ipv4/netfilter/ip_conntrack_standalone.c   |    9 -
 net/ipv4/netfilter/ip_nat_core.c               |   74 ++++----
 net/ipv4/netfilter/ipt_LOG.c                   |    2 
 net/ipv4/netfilter/ipt_ULOG.c                  |    2 
 net/ipv4/netfilter/nf_conntrack_proto_icmp.c   |    2 
 net/ipv4/netfilter/nf_nat_core.c               |   75 ++++----
 net/ipv6/netfilter/Kconfig                     |    3 
 net/ipv6/netfilter/ip6t_LOG.c                  |    2 
 net/ipv6/netfilter/ip6t_mh.c                   |    7 
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c |    4 
 net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c |    1 
 net/netfilter/Kconfig                          |   12 +
 net/netfilter/core.c                           |   45 +++--
 net/netfilter/nf_conntrack_core.c              |   72 +++++---
 net/netfilter/nf_conntrack_expect.c            |    2 
 net/netfilter/nf_conntrack_ftp.c               |   14 -
 net/netfilter/nf_conntrack_h323_main.c         |   20 +-
 net/netfilter/nf_conntrack_irc.c               |    2 
 net/netfilter/nf_conntrack_l3proto_generic.c   |    2 
 net/netfilter/nf_conntrack_netbios_ns.c        |    2 
 net/netfilter/nf_conntrack_netlink.c           |  106 ++++++------
 net/netfilter/nf_conntrack_pptp.c              |    2 
 net/netfilter/nf_conntrack_proto.c             |   73 ++------
 net/netfilter/nf_conntrack_proto_sctp.c        |   72 ++++----
 net/netfilter/nf_conntrack_proto_tcp.c         |  210 ++++++++++++-------------
 net/netfilter/nf_conntrack_sip.c               |    6 
 net/netfilter/nf_conntrack_standalone.c        |    2 
 net/netfilter/nf_conntrack_tftp.c              |    2 
 net/netfilter/nf_internals.h                   |    2 
 net/netfilter/nf_log.c                         |   69 ++++----
 net/netfilter/nf_queue.c                       |   22 +-
 net/netfilter/nf_sockopt.c                     |   12 -
 net/netfilter/nfnetlink.c                      |   10 -
 net/netfilter/nfnetlink_log.c                  |   54 +++---
 net/netfilter/nfnetlink_queue.c                |   84 +++++-----
 net/netfilter/x_tables.c                       |   12 -
 net/netfilter/xt_CLASSIFY.c                    |   12 -
 net/netfilter/xt_MARK.c                        |    4 
 net/netfilter/xt_NFQUEUE.c                     |    4 
 net/netfilter/xt_NOTRACK.c                     |    4 
 net/netfilter/xt_SECMARK.c                     |    2 
 net/netfilter/xt_conntrack.c                   |   32 +--
 net/netfilter/xt_dccp.c                        |   20 +-
 net/netfilter/xt_hashlimit.c                   |    8 
 net/netfilter/xt_helper.c                      |   18 +-
 net/netfilter/xt_length.c                      |    4 
 net/netfilter/xt_limit.c                       |    2 
 net/netfilter/xt_mac.c                         |    7 
 net/netfilter/xt_mark.c                        |    6 
 net/netfilter/xt_multiport.c                   |    2 
 net/netfilter/xt_physdev.c                     |    2 
 net/netfilter/xt_policy.c                      |   24 +-
 net/netfilter/xt_quota.c                       |    4 
 net/netfilter/xt_realm.c                       |    2 
 net/netfilter/xt_sctp.c                        |   30 +--
 net/netfilter/xt_string.c                      |    8 
 net/netfilter/xt_tcpmss.c                      |    4 
 66 files changed, 709 insertions(+), 667 deletions(-)

Masahide NAKAMURA:
      [NETFILTER]: ip6t_mh: drop piggyback payload packet on MH packets

Patrick McHardy:
      [NETFILTER]: Properly use RCU in nf_ct_attach
      [NETFILTER]: Remove unnecessary synchronize_net() in nf_register_hook
      [NETFILTER]: Switch nf_register_afinfo/nf_unregister_afinfo to mutex
      [NETFILTER]: Switch nf_register_hook/nf_unregister_hook to mutex
      [NETFILTER]: nf_log: use rcu_assign_pointer for RCU protected pointer
      [NETFILTER]: nf_log: make nf_log_unregister_pf return void
      [NETFILTER]: nf_log: switch logger registration/unregistration to mutex
      [NETFILTER]: nf_log: minor cleanups
      [NETFILTER]: ip_nat: properly use RCU API for ip_nat_protos array
      [NETFILTER]: nf_nat: properly use RCU API for nf_nat_protos array
      [NETFILTER]: ip_conntrack: properly use RCU API for ip_ct_protos array
      [NETFILTER]: nf_conntrack: properly use RCU API for nf_ct_protos/nf_ct_l3protos arrays
      [NETFILTER]: ip_conntrack: fix invalid conntrack statistics RCU assumption
      [NETFILTER]: nf_conntrack: fix invalid conntrack statistics RCU assumption
      [NETFILTER]: ip_conntrack: properly use RCU for ip_conntrack_destroyed callback
      [NETFILTER]: nf_conntrack: properly use RCU for nf_conntrack_destroyed callback
      [NETFILTER]: nf_conntrack: change nf_conntrack_l[34]proto_unregister to void
      [NETFILTER]: xt_mac/xt_CLASSIFY: use IPv6 hook names for IPv6 registration
      [NETFILTER]: Kconfig: improve dependency handling
      [NETFILTER]: nf_conntrack_tcp: make sysctl variables static

YOSHIFUJI Hideaki:
      [NETFILTER]: Fix whitespace errors
