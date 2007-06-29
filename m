From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 00/20]: Pending netfilter patches
Date: Fri, 29 Jun 2007 02:44:56 +0200 (MEST)
Message-ID: <20070629004354.25566.59266.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>
To: netfilter-devel@lists.netfilter.org
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

I have mostly finished my conntrack hlist and expectation/helper hashing
patches and added some minor other stuff. This is my current set of
patches, since they haven't been posted to the list in this form yet I'm
posting the entire set. A fresh git tree with these and the patches others
have sent me should appear within the hour at

http://people.netfilter.org/kaber/nf-2.6.23.git/

I'll push it upstream after some more testing and when net-2.6.23
is rebased to 2.6.22-rc6, since there is currently a conflict.


 Documentation/feature-removal-schedule.txt         |    8 +
 include/linux/netfilter_ipv4/ipt_CLUSTERIP.h       |    4 +-
 include/net/netfilter/nf_conntrack.h               |    6 +
 include/net/netfilter/nf_conntrack_core.h          |    8 +-
 include/net/netfilter/nf_conntrack_ecache.h        |   17 +-
 include/net/netfilter/nf_conntrack_expect.h        |   41 ++-
 include/net/netfilter/nf_conntrack_helper.h        |   11 +-
 include/net/netfilter/nf_conntrack_tuple.h         |   68 +++--
 include/net/netfilter/nf_nat.h                     |    2 +-
 net/ipv4/netfilter/Kconfig                         |    2 +-
 net/ipv4/netfilter/ipt_CLUSTERIP.c                 |   39 ++-
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c     |    2 +-
 .../netfilter/nf_conntrack_l3proto_ipv4_compat.c   |  100 ++++--
 net/ipv4/netfilter/nf_conntrack_proto_icmp.c       |    4 +-
 net/ipv4/netfilter/nf_nat_amanda.c                 |    4 +-
 net/ipv4/netfilter/nf_nat_core.c                   |   21 +-
 net/ipv4/netfilter/nf_nat_ftp.c                    |    4 +-
 net/ipv4/netfilter/nf_nat_h323.c                   |   26 +-
 net/ipv4/netfilter/nf_nat_irc.c                    |    4 +-
 net/ipv4/netfilter/nf_nat_pptp.c                   |    6 +-
 net/ipv4/netfilter/nf_nat_sip.c                    |    4 +-
 net/ipv4/netfilter/nf_nat_snmp_basic.c             |    6 -
 net/ipv4/netfilter/nf_nat_tftp.c                   |    2 +-
 net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c     |    2 +-
 net/netfilter/nf_conntrack_amanda.c                |   17 +-
 net/netfilter/nf_conntrack_core.c                  |  182 ++++++-----
 net/netfilter/nf_conntrack_ecache.c                |   16 +-
 net/netfilter/nf_conntrack_expect.c                |  354 +++++++++++++-------
 net/netfilter/nf_conntrack_ftp.c                   |   49 +--
 net/netfilter/nf_conntrack_h323_main.c             |  172 ++++------
 net/netfilter/nf_conntrack_helper.c                |  108 +++++--
 net/netfilter/nf_conntrack_irc.c                   |   15 +-
 net/netfilter/nf_conntrack_netbios_ns.c            |   12 +-
 net/netfilter/nf_conntrack_netlink.c               |  149 +++++---
 net/netfilter/nf_conntrack_pptp.c                  |   49 ++--
 net/netfilter/nf_conntrack_sane.c                  |   18 +-
 net/netfilter/nf_conntrack_sip.c                   |   15 +-
 net/netfilter/nf_conntrack_standalone.c            |   28 +-
 net/netfilter/nf_conntrack_tftp.c                  |   15 +-
 39 files changed, 895 insertions(+), 695 deletions(-)

Patrick McHardy (20):
      [NETFILTER]: nf_conntrack: use hlists for conntrack hash
      [NETFILTER]: nf_conntrack: remove 'ignore_conntrack' argument from nf_conntrack_find_get
      [NETFILTER]: nf_conntrack: export hash allocation/destruction functions
      [NETFILTER]: nf_nat: use hlists for bysource hash
      [NETFILTER]: nf_conntrack_expect: function naming unification
      [NETFILTER]: nf_conntrack_ftp: use nf_ct_expect_init
      [NETFILTER]: nf_conntrack: reduce masks to a subset of tuples
      [NETFILTER]: nf_conntrack_expect: avoid useless list walking
      [NETFILTER]: nf_conntrack_netlink: sync expectation dumping with conntrack table dumping
      [NETFILTER]: nf_conntrack: move expectaton related init code to nf_conntrack_expect.c
      [NETFILTER]: nf_conntrack: use hashtable for expectations
      [NETFILTER]: nf_conntrack_expect: convert proc functions to hash
      [NETFILTER]: nf_conntrack_helper/nf_conntrack_netlink: convert to expectation hash
      [NETFILTER]: nf_conntrack_expect: maintain per conntrack expectation list
      [NETFILTER]: nf_conntrack_helper: use hashtable for conntrack helpers
      [NETFILTER]: nf_conntrack: mark helpers __read_mostly
      [NETFILTER]: nf_conntrack: early_drop improvement
      [NETFILTER]: ipt_SAME: add to feature-removal-schedule
      [NETFILTER]: ipt_CLUSTERIP: add compat code
      [NETFILTER]: nf_conntrack_h323: turn some printks into DEBUGPs
