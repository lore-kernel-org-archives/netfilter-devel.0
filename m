From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 00/39]: Netfilter update for 2.6.19
Date: Wed, 20 Sep 2006 10:23:51 +0200 (MEST)
Message-ID: <20060920082442.14636.6806.sendpatchset@localhost.localdomain>
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

following is another netfilter update for 2.6.19, consisting of a number of
random cleanup and fixes, a rework of the iptables compat code including
compat support for (AFAICT) all missing matches/targets and some cleanup
and fixes for the PPtP connection tracking helper. Some of these should also
go in -stable, I'll prepare backports and send them seperately.

Please apply, thanks.


 include/linux/netfilter/nf_conntrack_tcp.h            |    1 
 include/linux/netfilter/x_tables.h                    |   33 
 include/linux/netfilter_ipv4/ip_conntrack_helper.h    |    2 
 include/linux/netfilter_ipv4/ip_conntrack_pptp.h      |   45 -
 include/linux/netfilter_ipv4/ip_conntrack_proto_gre.h |   22 
 include/linux/netfilter_ipv4/ip_nat_pptp.h            |    4 
 include/linux/netfilter_ipv6.h                        |    1 
 include/linux/netfilter_logging.h                     |   33 
 include/net/ip6_route.h                               |    2 
 net/bridge/netfilter/ebtables.c                       |   76 +-
 net/ipv4/netfilter/arp_tables.c                       |    4 
 net/ipv4/netfilter/ip_conntrack_core.c                |  209 ++---
 net/ipv4/netfilter/ip_conntrack_helper_pptp.c         |  634 +++++++-----------
 net/ipv4/netfilter/ip_conntrack_netlink.c             |   63 -
 net/ipv4/netfilter/ip_conntrack_proto_gre.c           |   52 -
 net/ipv4/netfilter/ip_conntrack_proto_tcp.c           |    4 
 net/ipv4/netfilter/ip_conntrack_standalone.c          |    1 
 net/ipv4/netfilter/ip_nat_core.c                      |    4 
 net/ipv4/netfilter/ip_nat_helper.c                    |    4 
 net/ipv4/netfilter/ip_nat_helper_pptp.c               |  210 ++---
 net/ipv4/netfilter/ip_nat_proto_gre.c                 |   22 
 net/ipv4/netfilter/ip_nat_rule.c                      |    4 
 net/ipv4/netfilter/ip_nat_standalone.c                |    4 
 net/ipv4/netfilter/ip_queue.c                         |    8 
 net/ipv4/netfilter/ip_tables.c                        |  161 +---
 net/ipv4/netfilter/ipt_TCPMSS.c                       |  101 --
 net/ipv4/netfilter/ipt_TTL.c                          |    4 
 net/ipv4/netfilter/ipt_hashlimit.c                    |   29 
 net/ipv6/netfilter/ip6_queue.c                        |    8 
 net/ipv6/netfilter/ip6_tables.c                       |    5 
 net/ipv6/netfilter/ip6t_HL.c                          |    6 
 net/ipv6/netfilter/ip6table_mangle.c                  |    8 
 net/netfilter/nf_conntrack_core.c                     |  205 ++---
 net/netfilter/nf_conntrack_netlink.c                  |   67 -
 net/netfilter/nf_conntrack_proto_tcp.c                |    4 
 net/netfilter/nf_conntrack_standalone.c               |    1 
 net/netfilter/x_tables.c                              |  209 +++--
 net/netfilter/xt_CONNMARK.c                           |   36 +
 net/netfilter/xt_MARK.c                               |   34 
 net/netfilter/xt_connmark.c                           |   36 +
 net/netfilter/xt_conntrack.c                          |  179 ++---
 net/netfilter/xt_limit.c                              |   65 +
 net/netfilter/xt_mark.c                               |   36 +
 net/netfilter/xt_policy.c                             |    2 
 44 files changed, 1238 insertions(+), 1400 deletions(-)

Alexey Dobriyan:
      [NETFILTER]: xt_policy: remove dups in .family

Brian Haley:
      [NETFILTER]: make some netfilter globals __read_mostly

Dmitry Mishin:
      [NETFILTER]: x_tables: small check_entry & module_refcount cleanup

George Hansper:
      [NETFILTER]: TCP conntrack: improve dead connection detection

Pablo Neira Ayuso:
      [NETFILTER]: ctnetlink: simplify the code to dump the conntrack table
      [NETFILTER]: conntrack: fix race condition in early_drop

Patrick McHardy:
      [NETFILTER]: remove unused include file
      [NETFILTER]: kill listhelp.h
      [NETFILTER]: xt_conntrack: clean up overly long lines
      [NETFILTER]: ipt_TCPMSS: reformat
      [NETFILTER]: ipt_TCPMSS: remove impossible condition
      [NETFILTER]: ipt_TCPMSS: misc cleanup
      [NETFILTER]: xt_limit: don't reset state on unrelated rule updates
      [NETFILTER]: ip6table_mangle: reroute when nfmark changes in NF_IP6_LOCAL_OUT
      [NETFILTER]: ipt_TTL: fix checksum update bug
      [NETFILTER]: ip6t_HL: remove write-only variable
      [NETFILTER]: ip_tables: fix module refcount leaks in compat error paths
      [NETFILTER]: ip_tables: revision support for compat code
      [NETFILTER]: x_tables: simplify compat API
      [NETFILTER]: xt_mark: add compat conversion functions
      [NETFILTER]: xt_MARK: add compat conversion functions
      [NETFILTER]: xt_connmark: add compat conversion functions
      [NETFILTER]: xt_CONNMARK: add compat conversion functions
      [NETFILTER]: xt_limit: add compat conversion functions
      [NETFILTER]: ipt_hashlimit: add compat conversion functions
      [NETFILTER]: PPTP conntrack: fix whitespace errors
      [NETFILTER]: PPTP conntrack: get rid of unnecessary byte order conversions
      [NETFILTER]: PPTP conntrack: remove dead code
      [NETFILTER]: PPTP conntrack: remove more dead code
      [NETFILTER]: PPTP conntrack: fix header definitions
      [NETFILTER]: PPTP conntrack: remove unnecessary cid/pcid header pointers
      [NETFILTER]: PPTP conntrack: simplify expectation handling
      [NETFILTER]: PPTP conntrack: consolidate header size checks
      [NETFILTER]: PPTP conntrack: consolidate header parsing
      [NETFILTER]: PPTP conntrack: clean up debugging cruft
      [NETFILTER]: PPTP conntrack: check call ID before changing state
      [NETFILTER]: PPTP conntrack: fix PPTP_IN_CALL message types
      [NETFILTER]: PPTP conntrack: fix GRE keymap leak
      [NETFILTER]: PPTP conntrack: fix another GRE keymap leak
