From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 00/18]: Netfilter Update for 2.6.19
Date: Tue, 22 Aug 2006 00:52:18 +0200 (MEST)
Message-ID: <20060821225217.10288.69738.sendpatchset@localhost.localdomain>
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

following is my first batch of netfilter patches for 2.6.19. Mostly cleanups
and code consolidation and a few ctnetlink updates - it looks a lot larger
than it is :)

Please apply, thanks.


 include/linux/netfilter/nf_conntrack_common.h |    4 
 include/linux/netfilter/nfnetlink.h           |    4 
 include/linux/netfilter/nfnetlink_log.h       |    6 
 include/linux/netfilter/nfnetlink_queue.h     |    8 
 include/linux/netfilter/x_tables.h            |   19 +-
 include/linux/netfilter/xt_DSCP.h             |   20 ++
 include/linux/netfilter/xt_dscp.h             |   23 ++
 include/linux/netfilter_arp/arp_tables.h      |    3 
 include/linux/netfilter_ipv4/ip_tables.h      |    3 
 include/linux/netfilter_ipv4/ipt_DSCP.h       |    6 
 include/linux/netfilter_ipv4/ipt_dscp.h       |   14 -
 include/linux/netfilter_ipv6/ip6_tables.h     |    3 
 net/ipv4/netfilter/Kconfig                    |   22 --
 net/ipv4/netfilter/Makefile                   |    2 
 net/ipv4/netfilter/arp_tables.c               |   14 -
 net/ipv4/netfilter/arpt_mangle.c              |    4 
 net/ipv4/netfilter/arptable_filter.c          |    2 
 net/ipv4/netfilter/ip_conntrack_netlink.c     |   13 -
 net/ipv4/netfilter/ip_nat_rule.c              |   10 -
 net/ipv4/netfilter/ip_tables.c                |   23 --
 net/ipv4/netfilter/ipt_CLUSTERIP.c            |    7 
 net/ipv4/netfilter/ipt_DSCP.c                 |   96 -----------
 net/ipv4/netfilter/ipt_ECN.c                  |   26 +--
 net/ipv4/netfilter/ipt_LOG.c                  |    4 
 net/ipv4/netfilter/ipt_MASQUERADE.c           |    4 
 net/ipv4/netfilter/ipt_NETMAP.c               |    4 
 net/ipv4/netfilter/ipt_REDIRECT.c             |    4 
 net/ipv4/netfilter/ipt_REJECT.c               |    4 
 net/ipv4/netfilter/ipt_SAME.c                 |    7 
 net/ipv4/netfilter/ipt_TCPMSS.c               |    4 
 net/ipv4/netfilter/ipt_TOS.c                  |   26 +--
 net/ipv4/netfilter/ipt_TTL.c                  |   12 -
 net/ipv4/netfilter/ipt_ULOG.c                 |    3 
 net/ipv4/netfilter/ipt_ah.c                   |    1 
 net/ipv4/netfilter/ipt_dscp.c                 |   54 ------
 net/ipv4/netfilter/ipt_ecn.c                  |    3 
 net/ipv4/netfilter/ipt_hashlimit.c            |    4 
 net/ipv4/netfilter/ipt_owner.c                |    1 
 net/ipv4/netfilter/ipt_recent.c               |   13 +
 net/ipv4/netfilter/iptable_filter.c           |    4 
 net/ipv4/netfilter/iptable_mangle.c           |    4 
 net/ipv4/netfilter/iptable_raw.c              |    2 
 net/ipv6/netfilter/Makefile                   |    2 
 net/ipv6/netfilter/ip6_tables.c               |   19 --
 net/ipv6/netfilter/ip6t_HL.c                  |    3 
 net/ipv6/netfilter/ip6t_LOG.c                 |    4 
 net/ipv6/netfilter/ip6t_REJECT.c              |    8 
 net/ipv6/netfilter/ip6t_ah.c                  |    1 
 net/ipv6/netfilter/ip6t_dst.c                 |  220 --------------------------
 net/ipv6/netfilter/ip6t_frag.c                |    1 
 net/ipv6/netfilter/ip6t_hbh.c                 |   49 ++---
 net/ipv6/netfilter/ip6t_ipv6header.c          |    1 
 net/ipv6/netfilter/ip6t_owner.c               |    1 
 net/ipv6/netfilter/ip6t_rt.c                  |    1 
 net/ipv6/netfilter/ip6table_filter.c          |    4 
 net/ipv6/netfilter/ip6table_mangle.c          |    4 
 net/ipv6/netfilter/ip6table_raw.c             |    2 
 net/netfilter/Kconfig                         |   23 ++
 net/netfilter/Makefile                        |    2 
 net/netfilter/nf_conntrack_netlink.c          |   13 -
 net/netfilter/nfnetlink_queue.c               |    4 
 net/netfilter/x_tables.c                      |   60 +++++++
 net/netfilter/xt_CLASSIFY.c                   |   63 +++----
 net/netfilter/xt_CONNMARK.c                   |  128 +++++++--------
 net/netfilter/xt_CONNSECMARK.c                |   61 ++-----
 net/netfilter/xt_DSCP.c                       |  188 ++++++++++++++++++----
 net/netfilter/xt_MARK.c                       |   92 ++++------
 net/netfilter/xt_NFQUEUE.c                    |   71 +++-----
 net/netfilter/xt_NOTRACK.c                    |   50 ++---
 net/netfilter/xt_SECMARK.c                    |   59 ++----
 net/netfilter/xt_comment.c                    |   45 ++---
 net/netfilter/xt_connbytes.c                  |   50 ++---
 net/netfilter/xt_connmark.c                   |   56 ++----
 net/netfilter/xt_conntrack.c                  |    8 
 net/netfilter/xt_dccp.c                       |   52 ++----
 net/netfilter/xt_dscp.c                       |  161 +++++++++++++++----
 net/netfilter/xt_esp.c                        |   52 ++----
 net/netfilter/xt_helper.c                     |   55 ++----
 net/netfilter/xt_length.c                     |   43 ++---
 net/netfilter/xt_limit.c                      |   48 ++---
 net/netfilter/xt_mac.c                        |   52 ++----
 net/netfilter/xt_mark.c                       |   48 ++---
 net/netfilter/xt_multiport.c                  |  115 ++++---------
 net/netfilter/xt_physdev.c                    |   50 ++---
 net/netfilter/xt_pkttype.c                    |   44 ++---
 net/netfilter/xt_policy.c                     |   54 ++----
 net/netfilter/xt_quota.c                      |   53 ++----
 net/netfilter/xt_sctp.c                       |   52 ++----
 net/netfilter/xt_state.c                      |   56 ++----
 net/netfilter/xt_statistic.c                  |   55 ++----
 net/netfilter/xt_string.c                     |   54 ++----
 net/netfilter/xt_tcpmss.c                     |   97 ++++-------
 net/netfilter/xt_tcpudp.c                     |  109 ++++--------
 net/sched/act_ipt.c                           |    7 
 94 files changed, 1292 insertions(+), 1748 deletions(-)

Daniel De Graaf:
      [NETFILTER]: ipt_recent: add module parameter for changing ownership of /proc/net/ipt_recent/*

Pablo Neira Ayuso:
      [NETFILTER]: conntrack: introduce connection mark event
      [NETFILTER]: ctnetlink: dump connection mark
      [NETFILTER]: ctnetlink: check for listeners before sending expectation events
      [NETFILTER]: ctnetlink: remove impossible events tests for updates

Patrick McHardy:
      [NETFILTER]: nfnetlink_queue: fix typo in error message
      [NETFILTER]: replace open coded checksum updates
      [NETFILTER]: xt_CONNMARK: use tabs for indentation
      [NETFILTER]: x_tables: add helpers for mass match/target registration
      [NETFILTER]: x_tables: make use of mass registation helpers
      [NETFILTER]: x_tables: remove unused argument to target functions
      [NETFILTER]: x_tables: remove unused size argument to check/destroy functions
      [NETFILTER]: nfnetlink: remove unnecessary packed attributes
      [NETFILTER]: x_tables: add data member to struct xt_match
      [NETFILTER]: ip6_tables: consolidate dst and hbh matches
      [NETFILTER]: xt_tcpmss: minor cleanups

Yasuyuki Kozakai:
      [NETFILTER]: x_tables: replace IPv4 dscp match by address family independent version
      [NETFILTER]: x_tables: replace IPv4 DSCP target by address family independent version
