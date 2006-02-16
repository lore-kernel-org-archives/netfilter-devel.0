From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 00/13]: Netfilter patches for 2.6.17
Date: Thu, 16 Feb 2006 22:32:07 +0100 (MET)
Message-ID: <20060216213207.6933.99672.sendpatchset@localhost.localdomain>
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

these are my netfilter patches for 2.6.17. The last patch (ctnetlink:
avoid unneccessary event message generation) depends on the netlink
patch I sent yesterday. Please apply on top of that patch.

 
 include/linux/netfilter/nfnetlink.h        |    1 
 include/linux/netfilter/x_tables.h         |   37 ++++-
 include/linux/netfilter/xt_policy.h        |   58 ++++++++
 include/linux/netfilter_ipv4/ipt_policy.h  |   67 ++-------
 include/linux/netfilter_ipv6/ip6t_policy.h |   67 ++-------
 include/net/ipv6.h                         |   12 +
 net/ipv4/netfilter/Kconfig                 |   10 -
 net/ipv4/netfilter/Makefile                |    1 
 net/ipv4/netfilter/arp_tables.c            |   19 +-
 net/ipv4/netfilter/arpt_mangle.c           |   23 +--
 net/ipv4/netfilter/ip_conntrack_netlink.c  |    7 
 net/ipv4/netfilter/ip_nat_helper_pptp.c    |    8 -
 net/ipv4/netfilter/ip_nat_rule.c           |   45 +-----
 net/ipv4/netfilter/ip_tables.c             |   67 +++++----
 net/ipv4/netfilter/ipt_CLUSTERIP.c         |   27 +--
 net/ipv4/netfilter/ipt_DSCP.c              |   17 --
 net/ipv4/netfilter/ipt_ECN.c               |   18 --
 net/ipv4/netfilter/ipt_LOG.c               |   11 -
 net/ipv4/netfilter/ipt_MASQUERADE.c        |   18 --
 net/ipv4/netfilter/ipt_NETMAP.c            |   19 --
 net/ipv4/netfilter/ipt_REDIRECT.c          |   17 --
 net/ipv4/netfilter/ipt_REJECT.c            |   24 ---
 net/ipv4/netfilter/ipt_SAME.c              |   19 --
 net/ipv4/netfilter/ipt_TCPMSS.c            |   16 --
 net/ipv4/netfilter/ipt_TOS.c               |   17 --
 net/ipv4/netfilter/ipt_TTL.c               |   25 ---
 net/ipv4/netfilter/ipt_ULOG.c              |   12 -
 net/ipv4/netfilter/ipt_addrtype.c          |   20 --
 net/ipv4/netfilter/ipt_ah.c                |   25 +--
 net/ipv4/netfilter/ipt_dscp.c              |   19 --
 net/ipv4/netfilter/ipt_ecn.c               |   14 -
 net/ipv4/netfilter/ipt_esp.c               |   25 +--
 net/ipv4/netfilter/ipt_hashlimit.c         |   21 +-
 net/ipv4/netfilter/ipt_iprange.c           |   28 ---
 net/ipv4/netfilter/ipt_multiport.c         |   31 ----
 net/ipv4/netfilter/ipt_owner.c             |   21 --
 net/ipv4/netfilter/ipt_policy.c            |  182 -------------------------
 net/ipv4/netfilter/ipt_recent.c            |   22 +--
 net/ipv4/netfilter/ipt_tos.c               |   18 --
 net/ipv4/netfilter/ipt_ttl.c               |   19 --
 net/ipv6/netfilter/Kconfig                 |   10 -
 net/ipv6/netfilter/Makefile                |    1 
 net/ipv6/netfilter/ip6_tables.c            |   85 +++++------
 net/ipv6/netfilter/ip6t_HL.c               |   19 --
 net/ipv6/netfilter/ip6t_LOG.c              |   11 -
 net/ipv6/netfilter/ip6t_REJECT.c           |   25 ---
 net/ipv6/netfilter/ip6t_ah.c               |   12 -
 net/ipv6/netfilter/ip6t_dst.c              |   13 -
 net/ipv6/netfilter/ip6t_esp.c              |   12 -
 net/ipv6/netfilter/ip6t_eui64.c            |   27 ---
 net/ipv6/netfilter/ip6t_frag.c             |   13 -
 net/ipv6/netfilter/ip6t_hbh.c              |   13 -
 net/ipv6/netfilter/ip6t_hl.c               |   22 ---
 net/ipv6/netfilter/ip6t_ipv6header.c       |    8 -
 net/ipv6/netfilter/ip6t_multiport.c        |   11 -
 net/ipv6/netfilter/ip6t_owner.c            |   18 --
 net/ipv6/netfilter/ip6t_policy.c           |  188 --------------------------
 net/ipv6/netfilter/ip6t_rt.c               |   12 -
 net/ipv6/netfilter/nf_conntrack_reasm.c    |    8 -
 net/netfilter/Kconfig                      |   10 +
 net/netfilter/Makefile                     |    1 
 net/netfilter/nf_conntrack_netlink.c       |    7 
 net/netfilter/nfnetlink.c                  |    6 
 net/netfilter/x_tables.c                   |   72 +++++++++
 net/netfilter/xt_CLASSIFY.c                |   42 +----
 net/netfilter/xt_CONNMARK.c                |   27 +--
 net/netfilter/xt_MARK.c                    |   37 +----
 net/netfilter/xt_NFQUEUE.c                 |   24 ---
 net/netfilter/xt_NOTRACK.c                 |   45 +-----
 net/netfilter/xt_comment.c                 |   18 --
 net/netfilter/xt_connbytes.c               |   15 +-
 net/netfilter/xt_connmark.c                |   28 +--
 net/netfilter/xt_conntrack.c               |   18 --
 net/netfilter/xt_dccp.c                    |   45 +-----
 net/netfilter/xt_helper.c                  |   18 +-
 net/netfilter/xt_length.c                  |   24 ---
 net/netfilter/xt_limit.c                   |    7 
 net/netfilter/xt_mac.c                     |   34 +---
 net/netfilter/xt_mark.c                    |   16 +-
 net/netfilter/xt_physdev.c                 |   14 +
 net/netfilter/xt_pkttype.c                 |   23 ---
 net/netfilter/xt_policy.c                  |  209 +++++++++++++++++++++++++++++
 net/netfilter/xt_realm.c                   |   27 ---
 net/netfilter/xt_sctp.c                    |   66 ++-------
 net/netfilter/xt_state.c                   |   21 --
 net/netfilter/xt_string.c                  |   10 -
 net/netfilter/xt_tcpmss.c                  |   52 -------
 net/netfilter/xt_tcpudp.c                  |  112 +++------------
 net/sched/act_ipt.c                        |   10 -
 89 files changed, 1003 insertions(+), 1650 deletions(-)

Holger Eitzenberger:
      [NETFILTER]: Fix CID offset bug in PPTP NAT helper debug message

Patrick McHardy:
      [NETFILTER]: xt_tables: add centralized error checking
      [NETFILTER]: Change {ip,ip6,arp}_tables to use centralized error checking
      [NETFILTER]: Convert ip_tables matches/targets to centralized error checking
      [NETFILTER]: Convert arp_tables targets to centralized error checking
      [NETFILTER]: Convert ip6_tables matches/targets to centralized error checking
      [NETFILTER]: Convert x_tables matches/targets to centralized error checking
      [NETFILTER]: x_tables: pass registered match/target data to match/target functions
      [NETFILTER]: x_tables: add xt_{match,target} arguments to match/target functions
      [NETFILTER]: Move ip6_masked_addrcmp to include/net/ipv6.h
      [NETFILTER]: x_tables: replace IPv4/IPv6 policy match by address family independant version
      [NETFILTER]: ctnetlink: avoid unneccessary event message generation

Yasuyuki Kozakai:
      [NETFILTER]: nf_conntrack: use ipv6_addr_equal in nf_ct_reasm
