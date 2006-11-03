From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 00/05]: updated nf_nat patch
Date: Fri,  3 Nov 2006 17:46:24 +0100 (MET)
Message-ID: <20061103164836.15103.46291.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kadlec@blackhole.kfki.hu
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

I've updated your nf_nat patch to apply on top of Martin's patches
(on top of the current git tree) and merged the changes we had in
IPv4 NAT since then.

I've also reviewed the patch a bit, the main problem I found so
far is the nf_conntrack allocation scheme, which requires all
features to be known at creation time, so it doesn't allow
nf_conntrack_alter_reply to assign a helper to a connection
that previously didn't have one (same problem for helpers
like H.323 which manually assign helpers in their expectfns).

Other than that it seems (and works) fine so far, if we find
a good solution for the helper problem I would like to merge
this as fast as possible if you don't have any objections.


 include/linux/netfilter/nf_conntrack_ftp.h     |    6 
 include/net/netfilter/ipv4/nf_conntrack_ipv4.h |   20 
 include/net/netfilter/nf_conntrack.h           |   28 
 include/net/netfilter/nf_conntrack_core.h      |    3 
 include/net/netfilter/nf_conntrack_expect.h    |    2 
 include/net/netfilter/nf_nat.h                 |   88 ++-
 include/net/netfilter/nf_nat_core.h            |   34 +
 include/net/netfilter/nf_nat_helper.h          |   33 +
 include/net/netfilter/nf_nat_protocol.h        |   74 ++
 include/net/netfilter/nf_nat_rule.h            |   38 +
 net/ipv4/netfilter/Kconfig                     |   73 +-
 net/ipv4/netfilter/Makefile                    |   12 
 net/ipv4/netfilter/ipt_MASQUERADE.c            |   29 -
 net/ipv4/netfilter/ipt_NETMAP.c                |    4 
 net/ipv4/netfilter/ipt_REDIRECT.c              |    6 
 net/ipv4/netfilter/ipt_SAME.c                  |   12 
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c |    7 
 net/ipv4/netfilter/nf_nat_core.c               |  725 +++++++++++++++++++++++--
 net/ipv4/netfilter/nf_nat_ftp.c                |  192 ++++++
 net/ipv4/netfilter/nf_nat_helper.c             |  531 +++++++++++++++++-
 net/ipv4/netfilter/nf_nat_proto_icmp.c         |   99 +++
 net/ipv4/netfilter/nf_nat_proto_tcp.c          |  168 +++++
 net/ipv4/netfilter/nf_nat_proto_udp.c          |  159 +++++
 net/ipv4/netfilter/nf_nat_proto_unknown.c      |   55 +
 net/ipv4/netfilter/nf_nat_rule.c               |  349 +++++++++++-
 net/ipv4/netfilter/nf_nat_standalone.c         |  428 ++++++++++++++
 net/netfilter/Kconfig                          |   47 +
 net/netfilter/nf_conntrack_core.c              |   20 
 net/netfilter/nf_conntrack_netlink.c           |   48 -
 net/netfilter/nf_conntrack_proto_tcp.c         |    2 
 net/netfilter/nf_conntrack_standalone.c        |    5 
 31 files changed, 3096 insertions(+), 201 deletions(-)

Patrick McHardy:
      [NETFILTER]: The IPv4 NAT ported to nf_conntrack
      [NETFILTER]: nf_nat: get rid of HW checksum invalidation
      [NETFILTER]: nf_nat: use tcp_sack_block_wire
      [NETFILTER]: nf_nat: NAT annotations
      [NETFILTER]: nf_nat: work around crash in nf_conntrack_alter_reply
