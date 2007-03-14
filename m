From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 00/22]: Netfilter update for 2.6.22
Date: Wed, 14 Mar 2007 09:50:02 +0100 (MET)
Message-ID: <20070314084946.15282.58609.sendpatchset@localhost.localdomain>
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

following is a first batch of netfilter patches for 2.6.22, containing the
scheduled removal of ip_conntrack/ip_nat, some further nf_conntrack locking
cleanup, nfnetlink cleanup and a few minor enhancements in various places.
The patches should apply cleanly to the current net-2.6.22 tree.

Please apply, thanks.


 Documentation/feature-removal-schedule.txt            |    9 
 include/linux/jhash.h                                 |    2 
 include/linux/netfilter/nf_conntrack_tcp.h            |    5 
 include/linux/netfilter/nfnetlink.h                   |   13 
 include/linux/netfilter/nfnetlink_conntrack.h         |    4 
 include/linux/netfilter_ipv4/Kbuild                   |   14 
 include/linux/netfilter_ipv4/ip_conntrack.h           |  402 ---
 include/linux/netfilter_ipv4/ip_conntrack_amanda.h    |   11 
 include/linux/netfilter_ipv4/ip_conntrack_core.h      |   61 
 include/linux/netfilter_ipv4/ip_conntrack_ftp.h       |   44 
 include/linux/netfilter_ipv4/ip_conntrack_h323.h      |   89 
 include/linux/netfilter_ipv4/ip_conntrack_helper.h    |   46 
 include/linux/netfilter_ipv4/ip_conntrack_icmp.h      |    6 
 include/linux/netfilter_ipv4/ip_conntrack_irc.h       |   32 
 include/linux/netfilter_ipv4/ip_conntrack_pptp.h      |  326 ---
 include/linux/netfilter_ipv4/ip_conntrack_proto_gre.h |  114 -
 include/linux/netfilter_ipv4/ip_conntrack_protocol.h  |   98 
 include/linux/netfilter_ipv4/ip_conntrack_sctp.h      |    6 
 include/linux/netfilter_ipv4/ip_conntrack_sip.h       |   40 
 include/linux/netfilter_ipv4/ip_conntrack_tcp.h       |    6 
 include/linux/netfilter_ipv4/ip_conntrack_tftp.h      |   20 
 include/linux/netfilter_ipv4/ip_conntrack_tuple.h     |  146 -
 include/linux/netfilter_ipv4/ip_nat.h                 |   79 
 include/linux/netfilter_ipv4/ip_nat_core.h            |   18 
 include/linux/netfilter_ipv4/ip_nat_helper.h          |   33 
 include/linux/netfilter_ipv4/ip_nat_pptp.h            |   11 
 include/linux/netfilter_ipv4/ip_nat_protocol.h        |   74 
 include/linux/netfilter_ipv4/ip_nat_rule.h            |   28 
 include/linux/netfilter_ipv4/ipt_SAME.h               |    2 
 include/linux/skbuff.h                                |   30 
 include/net/netfilter/nf_conntrack.h                  |    5 
 include/net/netfilter/nf_conntrack_compat.h           |  145 -
 include/net/netfilter/nf_conntrack_core.h             |    3 
 include/net/netfilter/nf_conntrack_ecache.h           |   30 
 include/net/netfilter/nf_conntrack_l3proto.h          |    5 
 include/net/netfilter/nf_nat_rule.h                   |   10 
 net/core/skbuff.c                                     |   28 
 net/ipv4/ip_output.c                                  |   13 
 net/ipv4/netfilter/Kconfig                            |  267 --
 net/ipv4/netfilter/Makefile                           |   45 
 net/ipv4/netfilter/ip_conntrack_amanda.c              |  229 --
 net/ipv4/netfilter/ip_conntrack_core.c                | 1549 ---------------
 net/ipv4/netfilter/ip_conntrack_ftp.c                 |  520 -----
 net/ipv4/netfilter/ip_conntrack_helper_h323.c         | 1840 ------------------
 net/ipv4/netfilter/ip_conntrack_helper_pptp.c         |  684 ------
 net/ipv4/netfilter/ip_conntrack_irc.c                 |  314 ---
 net/ipv4/netfilter/ip_conntrack_netbios_ns.c          |  143 -
 net/ipv4/netfilter/ip_conntrack_netlink.c             | 1577 ---------------
 net/ipv4/netfilter/ip_conntrack_proto_generic.c       |   74 
 net/ipv4/netfilter/ip_conntrack_proto_gre.c           |  328 ---
 net/ipv4/netfilter/ip_conntrack_proto_icmp.c          |  315 ---
 net/ipv4/netfilter/ip_conntrack_proto_sctp.c          |  659 ------
 net/ipv4/netfilter/ip_conntrack_proto_tcp.c           | 1163 -----------
 net/ipv4/netfilter/ip_conntrack_proto_udp.c           |  148 -
 net/ipv4/netfilter/ip_conntrack_sip.c                 |  520 -----
 net/ipv4/netfilter/ip_conntrack_standalone.c          |  962 ---------
 net/ipv4/netfilter/ip_conntrack_tftp.c                |  161 -
 net/ipv4/netfilter/ip_nat_amanda.c                    |   85 
 net/ipv4/netfilter/ip_nat_core.c                      |  633 ------
 net/ipv4/netfilter/ip_nat_ftp.c                       |  180 -
 net/ipv4/netfilter/ip_nat_helper.c                    |  436 ----
 net/ipv4/netfilter/ip_nat_helper_h323.c               |  611 -----
 net/ipv4/netfilter/ip_nat_helper_pptp.c               |  350 ---
 net/ipv4/netfilter/ip_nat_irc.c                       |  122 -
 net/ipv4/netfilter/ip_nat_proto_gre.c                 |  174 -
 net/ipv4/netfilter/ip_nat_proto_icmp.c                |   87 
 net/ipv4/netfilter/ip_nat_proto_tcp.c                 |  154 -
 net/ipv4/netfilter/ip_nat_proto_udp.c                 |  144 -
 net/ipv4/netfilter/ip_nat_proto_unknown.c             |   55 
 net/ipv4/netfilter/ip_nat_rule.c                      |  314 ---
 net/ipv4/netfilter/ip_nat_sip.c                       |  282 --
 net/ipv4/netfilter/ip_nat_snmp_basic.c                | 1333 -------------
 net/ipv4/netfilter/ip_nat_standalone.c                |  384 ---
 net/ipv4/netfilter/ip_nat_tftp.c                      |   70 
 net/ipv4/netfilter/ipt_CLUSTERIP.c                    |   18 
 net/ipv4/netfilter/ipt_MASQUERADE.c                   |   57 
 net/ipv4/netfilter/ipt_NETMAP.c                       |   22 
 net/ipv4/netfilter/ipt_REDIRECT.c                     |   24 
 net/ipv4/netfilter/ipt_SAME.c                         |   25 
 net/ipv4/netfilter/nf_nat_h323.c                      |    4 
 net/ipv4/netfilter/nf_nat_pptp.c                      |    2 
 net/ipv6/ip6_output.c                                 |   18 
 net/netfilter/Kconfig                                 |   63 
 net/netfilter/nf_conntrack_core.c                     |   27 
 net/netfilter/nf_conntrack_ecache.c                   |   23 
 net/netfilter/nf_conntrack_proto.c                    |  168 -
 net/netfilter/nf_conntrack_proto_tcp.c                |   63 
 net/netfilter/nfnetlink.c                             |  171 -
 net/netfilter/x_tables.c                              |   26 
 net/netfilter/xt_CONNMARK.c                           |   32 
 net/netfilter/xt_CONNSECMARK.c                        |   18 
 net/netfilter/xt_NOTRACK.c                            |    4 
 net/netfilter/xt_connbytes.c                          |   10 
 net/netfilter/xt_connmark.c                           |   17 
 net/netfilter/xt_conntrack.c                          |  110 -
 net/netfilter/xt_helper.c                             |   57 
 net/netfilter/xt_state.c                              |    4 
 97 files changed, 384 insertions(+), 19499 deletions(-)

Pablo Neira Ayuso:
      [NETFILTER]: nfnetlink: remove early debugging messages from nfnetlink
      [NETFILTER]: nfnetlink: remove duplicate checks in nfnetlink_check_attributes
      [NETFILTER]: nfnetlink: remove unrequired check in nfnetlink_get_subsys
      [NETFILTER]: nfnetlink: remove unused includes in nfnetlink.c
      [NETFILTER]: nfnetlink: move EXPORT_SYMBOL declarations next to the exported symbol
      [NETFILTER]: ctnetlink: add support for internal tcp connection tracking flags handling
      [NETFILTER]: nfnetlink: parse attributes with nfattr_parse in nfnetlink_check_attribute

Patrick McHardy:
      [NETFILTER]: Remove IPv4 only connection tracking/NAT
      [NETFILTER]: nf_conntrack: switch protocol registration/unregistration to mutex
      [NETFILTER]: nf_conntrack: remove ugly hack in l4proto registration
      [NETFILTER]: nf_conntrack: simplify protocol locking
      [NETFILTER]: nf_conntrack: simplify l4 protocol array allocation
      [NETFILTER]: nfnetlink: use mutex instead of semaphore
      [NETFILTER]: nfnetlink: use netlink_run_queue()
      [NETFILTER]: nf_conntrack: uninline notifier registration functions
      [JHASH]: Use const in jhash2

Sami Farin:
      [NETFILTER]: nf_conntrack: use jhash2 in __hash_conntrack

Tobias Klauser:
      [NETFILTER]: x_tables: remove duplicate of xt_prefix

Willy Tarreau:
      [NETFILTER]: TCP conntrack: accept RST|PSH as valid
      [NETFILTER]: TCP conntrack: factorize out the PUSH flag

Yasuyuki Kozakai:
      [NETFILTER]: nf_conntrack: add __nf_copy() to copy members in skb
      [NETFILTER]: nf_conntrack: add nf_copy() to safely copy members in skb
