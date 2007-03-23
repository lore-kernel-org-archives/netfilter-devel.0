From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 00/12]: Netfilter update part II
Date: Fri, 23 Mar 2007 15:04:58 +0100 (MET)
Message-ID: <20070323140433.22987.44867.sendpatchset@localhost.localdomain>
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

these patches for 2.6.22 contain mostly cleanups: some nfnetlink_log cleanup
and micro-optimizations, removal of changelogs in C files, conversion to use
setup_timer in netfilter code and a size-reduction of struct nf_conntrack
and struct sk_buff when connection tracking is disabled-

Please apply, thanks.


 include/linux/netfilter.h                      |   12 ++-
 include/linux/skbuff.h                         |   28 ++-----
 net/bridge/netfilter/ebt_ulog.c                |    4 -
 net/core/skbuff.c                              |    4 -
 net/ipv4/netfilter/ip_queue.c                  |   12 ---
 net/ipv4/netfilter/ip_tables.c                 |    6 -
 net/ipv4/netfilter/ipt_ECN.c                   |    2 
 net/ipv4/netfilter/ipt_REJECT.c                |    2 
 net/ipv4/netfilter/ipt_SAME.c                  |   15 ----
 net/ipv4/netfilter/ipt_ULOG.c                  |   23 ------
 net/ipv4/netfilter/ipt_ecn.c                   |    2 
 net/ipv4/netfilter/ipt_ttl.c                   |    2 
 net/ipv4/netfilter/iptable_mangle.c            |    2 
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c |    8 --
 net/ipv4/netfilter/nf_conntrack_proto_icmp.c   |    5 -
 net/ipv4/netfilter/nf_nat_snmp_basic.c         |    4 -
 net/ipv6/netfilter/ip6_queue.c                 |   12 ---
 net/ipv6/netfilter/ip6_tables.c                |    9 --
 net/ipv6/netfilter/ip6table_mangle.c           |    2 
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c |   11 --
 net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c |    7 -
 net/ipv6/netfilter/nf_conntrack_reasm.c        |    7 -
 net/netfilter/core.c                           |   23 ++++--
 net/netfilter/nf_conntrack_core.c              |   27 +------
 net/netfilter/nf_conntrack_expect.c            |    4 -
 net/netfilter/nf_conntrack_ftp.c               |    6 -
 net/netfilter/nf_conntrack_netlink.c           |    5 -
 net/netfilter/nf_conntrack_proto_generic.c     |    5 -
 net/netfilter/nf_conntrack_proto_sctp.c        |    9 --
 net/netfilter/nf_conntrack_proto_tcp.c         |   18 ----
 net/netfilter/nf_conntrack_proto_udp.c         |    5 -
 net/netfilter/nf_conntrack_standalone.c        |   11 --
 net/netfilter/nfnetlink.c                      |    4 -
 net/netfilter/nfnetlink_log.c                  |   92 +++++++------------------
 net/netfilter/xt_DSCP.c                        |    2 
 net/netfilter/xt_connbytes.c                   |    9 --
 net/netfilter/xt_dscp.c                        |    2 
 net/netfilter/xt_hashlimit.c                   |    4 -
 net/netfilter/xt_helper.c                      |    3 
 net/netfilter/xt_limit.c                       |    7 -
 net/netfilter/xt_realm.c                       |    2 
 41 files changed, 75 insertions(+), 342 deletions(-)

Michal Miroslaw (6):
      [NETFILTER]: nfnetlink_log: don't count max(a,b) twice
      [NETFILTER]: nfnetlink_log: kill duplicate code
      [NETFILTER]: nfnetlink_log: micro-optimization for inst==NULL in nfulnl_recv_config()
      [NETFILTER]: nfnetlink_log: micro-optimization: don't modify destroyed instance
      [NETFILTER]: nfnetlink_log: iterator functions need iter_state * only
      [NETFILTER]: nfnetlink_log: micro-optimization: inst->skb != NULL in __nfulnl_send()

Patrick McHardy (3):
      [NETFILTER]: Remove changelogs and CVS IDs
      [NETFILTER]: nfnetlink_log: remove conditional locking
      [NETFILTER]: Use setup_timer

Thomas Graf (1):
      [NETFILTER] nfnetlink: netlink_run_queue() already checks for NLM_F_REQUEST

Yasuyuki Kozakai (2):
      [NETFILTER]: nf_conntrack: don't use nfct in skb if conntrack is disabled
      [NETFILTER]: nf_conntrack: kill destroy() in struct nf_conntrack for diet
