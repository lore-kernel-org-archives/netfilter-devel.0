From: Patrick McHardy <kaber@trash.net>
Subject: nf-2.6.23 tree uploaded
Date: Tue, 26 Jun 2007 12:29:09 +0200
Message-ID: <4680EA75.9040308@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------080807040000060009060707"
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
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

This is a multi-part message in MIME format.
--------------080807040000060009060707
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Since I have quite a few patches queued for 2.6.23 and Dave seems
to be busy currently, I'm uploading my current tree to:

http://people.netfilter.org/kaber/nf-2.6.23.git

We have Yasuyuki's ct_extend patches, Jozsef's TRACE target, Jan's
cleanups and xt_u32 match, a few smaller enhancements and cleanups
and some unfinished work of myself to replace the expectation list
by a hash. I'll probably complete my patches today and update the
tree.

(PS: I've already fixed the incorrect attribution of one patch to
"Yasuyuki Kozaka" in my tree, but don't want to restart the upload,
please ignore).



--------------080807040000060009060707
Content-Type: text/plain;
 name="summary"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="summary"

 include/linux/netfilter/x_tables.h             |   36 ++--
 include/linux/netfilter/xt_u32.h               |   40 +++
 include/linux/netfilter_ipv6/ip6_tables.h      |   10 +-
 include/linux/skbuff.h                         |    4 +-
 include/net/netfilter/ipv4/nf_conntrack_ipv4.h |   23 +--
 include/net/netfilter/nf_conntrack.h           |   60 +-----
 include/net/netfilter/nf_conntrack_core.h      |    3 +
 include/net/netfilter/nf_conntrack_extend.h    |   85 +++++++
 include/net/netfilter/nf_conntrack_helper.h    |    5 +
 include/net/netfilter/nf_conntrack_l3proto.h   |    2 -
 include/net/netfilter/nf_nat.h                 |   26 ++-
 include/net/netfilter/nf_nat_core.h            |    1 +
 net/core/skbuff.c                              |    8 +
 net/ipv4/ip_output.c                           |    4 +
 net/ipv4/netfilter/arp_tables.c                |    6 +-
 net/ipv4/netfilter/arpt_mangle.c               |   10 +-
 net/ipv4/netfilter/ip_tables.c                 |  175 +++++++++++---
 net/ipv4/netfilter/ipt_CLUSTERIP.c             |   51 ++--
 net/ipv4/netfilter/ipt_ECN.c                   |   36 ++--
 net/ipv4/netfilter/ipt_LOG.c                   |   42 ++--
 net/ipv4/netfilter/ipt_MASQUERADE.c            |   20 +-
 net/ipv4/netfilter/ipt_NETMAP.c                |   10 +-
 net/ipv4/netfilter/ipt_REDIRECT.c              |   10 +-
 net/ipv4/netfilter/ipt_REJECT.c                |   20 +-
 net/ipv4/netfilter/ipt_SAME.c                  |   16 +-
 net/ipv4/netfilter/ipt_TOS.c                   |    8 +-
 net/ipv4/netfilter/ipt_TTL.c                   |   14 +-
 net/ipv4/netfilter/ipt_ULOG.c                  |   33 ++--
 net/ipv4/netfilter/ipt_addrtype.c              |   14 +-
 net/ipv4/netfilter/ipt_ah.c                    |   25 +-
 net/ipv4/netfilter/ipt_ecn.c                   |   59 +++---
 net/ipv4/netfilter/ipt_iprange.c               |   20 +-
 net/ipv4/netfilter/ipt_owner.c                 |   20 +-
 net/ipv4/netfilter/ipt_recent.c                |   43 ++--
 net/ipv4/netfilter/ipt_tos.c                   |    6 +-
 net/ipv4/netfilter/ipt_ttl.c                   |   26 +--
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c |   12 -
 net/ipv4/netfilter/nf_nat_core.c               |  101 ++++++--
 net/ipv4/netfilter/nf_nat_helper.c             |   15 +-
 net/ipv4/netfilter/nf_nat_rule.c               |   34 ++--
 net/ipv4/netfilter/nf_nat_sip.c                |    6 +-
 net/ipv4/netfilter/nf_nat_standalone.c         |   33 +--
 net/ipv6/ip6_output.c                          |    4 +
 net/ipv6/netfilter/ip6_tables.c                |  200 ++++++++++++----
 net/ipv6/netfilter/ip6t_HL.c                   |   14 +-
 net/ipv6/netfilter/ip6t_LOG.c                  |   47 ++--
 net/ipv6/netfilter/ip6t_REJECT.c               |   22 +-
 net/ipv6/netfilter/ip6t_ah.c                   |   41 ++--
 net/ipv6/netfilter/ip6t_eui64.c                |   20 +-
 net/ipv6/netfilter/ip6t_frag.c                 |   47 ++--
 net/ipv6/netfilter/ip6t_hbh.c                  |   43 ++--
 net/ipv6/netfilter/ip6t_hl.c                   |   22 +-
 net/ipv6/netfilter/ip6t_ipv6header.c           |   22 +-
 net/ipv6/netfilter/ip6t_mh.c                   |   30 +--
 net/ipv6/netfilter/ip6t_owner.c                |   26 +-
 net/ipv6/netfilter/ip6t_rt.c                   |   68 +++---
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c |    6 -
 net/netfilter/Kconfig                          |   25 ++
 net/netfilter/Makefile                         |    4 +-
 net/netfilter/core.c                           |    6 +-
 net/netfilter/nf_conntrack_core.c              |  312 +++++------------------
 net/netfilter/nf_conntrack_extend.c            |  195 +++++++++++++++
 net/netfilter/nf_conntrack_ftp.c               |   36 +---
 net/netfilter/nf_conntrack_h323_asn1.c         |   18 +-
 net/netfilter/nf_conntrack_helper.c            |   27 ++-
 net/netfilter/nf_conntrack_l3proto_generic.c   |    7 -
 net/netfilter/nf_conntrack_netlink.c           |   37 ++--
 net/netfilter/xt_CLASSIFY.c                    |    2 +-
 net/netfilter/xt_CONNMARK.c                    |   18 +-
 net/netfilter/xt_CONNSECMARK.c                 |   18 +-
 net/netfilter/xt_DSCP.c                        |   18 +-
 net/netfilter/xt_MARK.c                        |   24 +-
 net/netfilter/xt_NFLOG.c                       |   12 +-
 net/netfilter/xt_NFQUEUE.c                     |    2 +-
 net/netfilter/xt_NOTRACK.c                     |    2 +-
 net/netfilter/xt_SECMARK.c                     |   26 +-
 net/netfilter/xt_TCPMSS.c                      |   28 +-
 net/netfilter/xt_TRACE.c                       |   53 ++++
 net/netfilter/xt_comment.c                     |    8 +-
 net/netfilter/xt_connbytes.c                   |   32 ++--
 net/netfilter/xt_connmark.c                    |   26 +-
 net/netfilter/xt_conntrack.c                   |   42 ++--
 net/netfilter/xt_dccp.c                        |   50 ++--
 net/netfilter/xt_dscp.c                        |   48 ++--
 net/netfilter/xt_esp.c                         |   24 +-
 net/netfilter/xt_hashlimit.c                   |   63 +++--
 net/netfilter/xt_helper.c                      |   30 ++--
 net/netfilter/xt_length.c                      |   14 +-
 net/netfilter/xt_limit.c                       |   23 +-
 net/netfilter/xt_mac.c                         |   16 +-
 net/netfilter/xt_mark.c                        |   16 +-
 net/netfilter/xt_multiport.c                   |   54 ++--
 net/netfilter/xt_physdev.c                     |   48 ++--
 net/netfilter/xt_pkttype.c                     |   10 +-
 net/netfilter/xt_policy.c                      |   50 ++--
 net/netfilter/xt_quota.c                       |   21 +-
 net/netfilter/xt_realm.c                       |    8 +-
 net/netfilter/xt_sctp.c                        |   61 ++---
 net/netfilter/xt_state.c                       |   20 +-
 net/netfilter/xt_statistic.c                   |   20 +-
 net/netfilter/xt_string.c                      |   38 ++--
 net/netfilter/xt_tcpmss.c                      |   10 +-
 net/netfilter/xt_tcpudp.c                      |   63 +++---
 net/netfilter/xt_u32.c                         |  130 ++++++++++
 104 files changed, 2058 insertions(+), 1521 deletions(-)
 create mode 100644 include/linux/netfilter/xt_u32.h
 create mode 100644 include/net/netfilter/nf_conntrack_extend.h
 create mode 100644 net/netfilter/nf_conntrack_extend.c
 create mode 100644 net/netfilter/xt_TRACE.c
 create mode 100644 net/netfilter/xt_u32.c

Jan Engelhardt (8):
      [NETFILTER]: x_tables: switch hotdrop to bool
      [NETFILTER]: x_tables: switch xt_match->match to bool
      [NETFILTER]: x_tables: switch xt_match->checkentry to bool
      [NETFILTER]: x_tables: switch xt_target->checkentry to bool
      [NETFILTER]: add some consts, remove some casts
      [NETFILTER]: Remove incorrect inline markers
      [NETFILTER]: Remove redundant parentheses/braces
      [NETFILTER]: Add u32 match

Jerome Borsboom (1):
      [NETFILTER]: nf_nat_sip: only perform RTP DNAT if SIP session was SNATed

Jing Min Zhao (1):
      [NETFILTER]: nf_conntrack_h323: check range first in sequence extension

Jozsef Kadlecsik (1):
      [NETFILTER]: x_tables: add TRACE target

Patrick McHardy (3):
      [NETFILTER]: x_tables: mark matches and targets __read_mostly
      [NETFILTER]: nf_conntrack_extend: use __read_mostly for struct nf_ct_ext_type
      [NETFILTER]: nf_conntrack_ftp: use nf_conntrack_expect_init

Yasuyuki Kozaka (1):
      [NETFILTER]: ip6_tables: fix explanation of valid upper protocol number

Yasuyuki Kozakai (9):
      [NETFILTER]: nf_nat: move NAT declarations from nf_conntrack_ipv4.h to nf_nat.h
      [NETFILTER]: nf_conntrack: introduce extension infrastructure
      [NETFILTER]: nf_conntrack: use extension infrastructure for helper
      [NETFILTER]: nf_nat: add reference to conntrack from entry of bysource list
      [NETFILTER]: nf_nat: use extension infrastructure
      [NETFILTER]: nf_nat: remove unused nf_nat_module_is_loaded
      [NETFILTER]: nf_conntrack: remove old memory allocator of conntrack
      [NETFILTER]: nf_nat: kill global 'destroy' operation
      [NETFILTER]: nf_nat: merge nf_conn and nf_nat_info

--------------080807040000060009060707--
