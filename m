From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 00/33]: Netfilter Update
Date: Wed, 29 Nov 2006 03:08:43 +0100 (MET)
Message-ID: <20061129020843.21082.69507.sendpatchset@localhost.localdomain>
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

following is a large netfilter update for 2.6.20. It contains some
cleanup of the nf_conntrack code and nf_conntrack sysctl/proc
compatibility with ip_conntrack, which both move a lot of code
around. Besides that there are some small enhancements for
nfnetlink_queue, nfnetlink_log and ctnetlink, a port of the hashlimit
match to xtables, a new NFLOG target for using the address family
independant nfnetlink_log mechanism, a set of patches to clean up
the SIP helper and fix multiple issues with the NAT helper, and a
few assorted fixes.

These patches contain all NAT unrelated parts from my nf_nat tree,
which is now down to about 10 patches adding NAT support and
ports of all helpers. I hope to get them ready for submission within
a week.

Please apply, thanks.

PS: You can (hopefully) also pull these changes from
http://people.netfilter.org/~kaber/nf-2.6.20.git


 include/linux/netfilter.h                             |   10 
 include/linux/netfilter/Kbuild                        |    2 
 include/linux/netfilter/nfnetlink_log.h               |    2 
 include/linux/netfilter/nfnetlink_queue.h             |    1 
 include/linux/netfilter/xt_NFLOG.h                    |   18 
 include/linux/netfilter/xt_hashlimit.h                |   40 
 include/linux/netfilter_bridge/ebt_nat.h              |    1 
 include/linux/netfilter_bridge/ebtables.h             |    4 
 include/linux/netfilter_ipv4/ip_conntrack.h           |    2 
 include/linux/netfilter_ipv4/ip_conntrack_sip.h       |   36 
 include/linux/netfilter_ipv4/ipt_LOG.h                |    2 
 include/linux/netfilter_ipv4/ipt_hashlimit.h          |   42 
 include/linux/netfilter_ipv6/ip6t_LOG.h               |    2 
 include/net/netfilter/ipv4/nf_conntrack_ipv4.h        |    7 
 include/net/netfilter/ipv6/nf_conntrack_ipv6.h        |   25 
 include/net/netfilter/nf_conntrack.h                  |  135 ---
 include/net/netfilter/nf_conntrack_core.h             |   20 
 include/net/netfilter/nf_conntrack_ecache.h           |   95 ++
 include/net/netfilter/nf_conntrack_expect.h           |   74 +
 include/net/netfilter/nf_conntrack_helper.h           |   20 
 include/net/netfilter/nf_conntrack_l3proto.h          |   15 
 include/net/netfilter/nf_conntrack_l4proto.h          |  146 +++
 include/net/netfilter/nf_conntrack_protocol.h         |  129 ---
 net/Kconfig                                           |    2 
 net/bridge/netfilter/ebt_mark.c                       |    6 
 net/bridge/netfilter/ebt_snat.c                       |   27 
 net/ipv4/netfilter/Kconfig                            |   25 
 net/ipv4/netfilter/Makefile                           |    6 
 net/ipv4/netfilter/ip_conntrack_amanda.c              |    9 
 net/ipv4/netfilter/ip_conntrack_core.c                |    8 
 net/ipv4/netfilter/ip_conntrack_ftp.c                 |    8 
 net/ipv4/netfilter/ip_conntrack_helper_h323.c         |  164 ++-
 net/ipv4/netfilter/ip_conntrack_helper_pptp.c         |   33 
 net/ipv4/netfilter/ip_conntrack_irc.c                 |   12 
 net/ipv4/netfilter/ip_conntrack_netlink.c             |   61 -
 net/ipv4/netfilter/ip_conntrack_proto_gre.c           |    2 
 net/ipv4/netfilter/ip_conntrack_sip.c                 |  126 +-
 net/ipv4/netfilter/ip_conntrack_standalone.c          |    6 
 net/ipv4/netfilter/ip_conntrack_tftp.c                |    6 
 net/ipv4/netfilter/ip_nat_amanda.c                    |    9 
 net/ipv4/netfilter/ip_nat_ftp.c                       |    9 
 net/ipv4/netfilter/ip_nat_helper_h323.c               |   58 -
 net/ipv4/netfilter/ip_nat_helper_pptp.c               |   29 
 net/ipv4/netfilter/ip_nat_irc.c                       |    9 
 net/ipv4/netfilter/ip_nat_sip.c                       |  223 ++---
 net/ipv4/netfilter/ip_nat_tftp.c                      |    9 
 net/ipv4/netfilter/ipt_CLUSTERIP.c                    |   25 
 net/ipv4/netfilter/ipt_LOG.c                          |    9 
 net/ipv4/netfilter/ipt_hashlimit.c                    |  733 -----------------
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c        |  156 +--
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c |  412 +++++++++
 net/ipv4/netfilter/nf_conntrack_proto_icmp.c          |   54 +
 net/ipv6/netfilter/ip6_queue.c                        |    2 
 net/ipv6/netfilter/ip6t_LOG.c                         |    9 
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c        |   99 --
 net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c        |   38 
 net/netfilter/Kconfig                                 |   25 
 net/netfilter/Makefile                                |   13 
 net/netfilter/core.c                                  |    4 
 net/netfilter/nf_conntrack_core.c                     |  620 +-------------
 net/netfilter/nf_conntrack_ecache.c                   |   93 ++
 net/netfilter/nf_conntrack_expect.c                   |  370 ++++++++
 net/netfilter/nf_conntrack_ftp.c                      |   12 
 net/netfilter/nf_conntrack_helper.c                   |  158 +++
 net/netfilter/nf_conntrack_l3proto_generic.c          |    7 
 net/netfilter/nf_conntrack_netlink.c                  |  118 +-
 net/netfilter/nf_conntrack_proto.c                    |  486 ++++++++++-
 net/netfilter/nf_conntrack_proto_generic.c            |   47 +
 net/netfilter/nf_conntrack_proto_sctp.c               |  195 ++--
 net/netfilter/nf_conntrack_proto_tcp.c                |  262 +++++-
 net/netfilter/nf_conntrack_proto_udp.c                |   82 +
 net/netfilter/nf_conntrack_standalone.c               |  385 --------
 net/netfilter/nf_sysctl.c                             |  134 +++
 net/netfilter/nfnetlink_log.c                         |   19 
 net/netfilter/nfnetlink_queue.c                       |    8 
 net/netfilter/xt_CONNMARK.c                           |    3 
 net/netfilter/xt_NFLOG.c                              |   86 ++
 net/netfilter/xt_hashlimit.c                          |  772 ++++++++++++++++++
 78 files changed, 4310 insertions(+), 2801 deletions(-)

Bart De Schuymer:
      [NETFILTER]: ebtables: add --snap-arp option

Eric Leblond:
      [NETFILTER]: nfnetlink_queue: allow changing queue length through netlink

Martin Josefsson:
      [NETFILTER]: nf_conntrack: split out expectation handling
      [NETFILTER]: nf_conntrack: split out helper handling
      [NETFILTER]: nf_conntrack: split out the event cache
      [NETFILTER]: nf_conntrack: split out protocol handling
      [NETFILTER]: More __read_mostly annotations
      [NETFILTER]: nf_conntrack: rename struct nf_conntrack_protocol
      [NETFILTER]: nf_conntrack: more sanity checks in protocol registration/unregistration
      [NETFILTER]: nf_conntrack: remove ASSERT_{READ,WRITE}_LOCK
      [NETFILTER]: nf_conntrack: minor __nf_ct_refresh_acct() whitespace cleanup
      [NETFILTER]: nf_conntrack: remove unused struct list_head from protocols
      [NETFILTER]: nf_conntrack: reduce timer updates in __nf_ct_refresh_acct()

Pablo Neira Ayuso:
      [NETFILTER]: ctnetlink: check for status attribute existence on conntrack creation
      [NETFILTER]: ctnetlink: rework conntrack fields dumping logic on events
      [NETFILTER]: remove the reference to ipchains from Kconfig

Patrick McHardy:
      [NETFILTER]: nf_conntrack_ftp: fix missing helper mask initilization
      [NETFILTER]: nf_conntrack: move extern declaration to header files
      [NETFILTER]: nf_conntrack: automatic sysctl registation for conntrack protocols
      [NETFILTER]: nf_conntrack: move conntrack protocol sysctls to individual modules
      [NETFILTER]: nf_conntrack: sysctl compatibility with old connection tracking
      [NETFILTER]: nf_conntrack: /proc compatibility with old connection tracking
      [NETFILTER]: ip_conntrack: fix NAT helper unload races
      [NETFILTER]: sip conntrack: minor cleanup
      [NETFILTER]: sip conntrack: do case insensitive SIP header search
      [NETFILTER]: sip conntrack: make header shortcuts optional
      [NETFILTER]: sip conntrack: better NAT handling
      [NETFILTER]: nfnetlink_log: remove useless prefix length limitation
      [NETFILTER]: x_tables: add port of hashlimit match for IPv4 and IPv6
      [NETFILTER]: x_tables: add NFLOG target
      [NETFILTER]: remove remaining ASSERT_{READ,WRITE}_LOCK
      [NETFILTER]: Fix PROC_FS=n warnings

Yasuyuki Kozakai:
      [NETFILTER]: conntrack: add '_get' to {ip, nf}_conntrack_expect_find
