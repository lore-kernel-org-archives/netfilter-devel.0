From: pablo@netfilter.org
Subject: [PATCH 00/14] netfilter updates for 3.2
Date: Tue,  1 Nov 2011 10:11:22 +0100
Message-ID: <1320138696-28048-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: davem@davemloft.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37196 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752544Ab1KAJLo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 1 Nov 2011 05:11:44 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pablo Neira Ayuso <pablo@netfilter.org>

Hi Dave,

The following patchset includes netfilter updates for 3.2. Basically,
they are:

- Two fixes from Florian Westpal. One refcount leak fix for the IPv6
  routing templates and one fix nf_queue if the bypass mechanism is used.
  I'll pass these two to stable once they hit Linus tree.

- Export missing NAT definitions to user-space. Anthony G. Basile
  reported that several tools are internal defining the NAT structures
  because of the lack of public definition in the kernel tree.

- Lots of cleanups, one documentation update and one compilation fix
  from the IPVS guys (Simon Horman and Krzysztof Wilczynski).

- Update the MAINTAINERS file to include me. I have also deleted
  developers that were not active in the netfilter field since long
  time ago.

- One cleanup from Joe Perches, to reduce unnecessary OOM logging
  messages.

You can pull them from my nf branch at:

	git://1984.lsi.us.es/net/.git nf

Thanks!

Florian Westphal (2):
  netfilter: ipv6: fix afinfo->route refcnt leak on error
  netfilter: do not propagate nf_queue errors in nf_hook_slow

Joe Perches (1):
  netfilter: Remove unnecessary OOM logging messages

Krzysztof Wilczynski (3):
  ipvs: Expose ip_vs_ftp module parameters via sysfs.
  ipvs: Remove unused variable "cs" from ip_vs_leave function.
  ipvs: Fix compilation error in ip_vs.h for ip_vs_confirm_conntrack
    function.

Pablo Neira Ayuso (2):
  netfilter: export NAT definitions through
    linux/netfilter_ipv4/nf_nat.h
  MAINTAINERS: update netfilter maintainers

Simon Horman (6):
  ipvs: Add documentation for new sysctl entries
  ipvs: Remove unused parameter from ip_vs_confirm_conntrack()
  ipvs: Remove unused return value of protocol state transitions
  ipvs: Removed unused variables
  ipvs: secure_tcp does provide alternate state timeouts
  ipvs: Enhance grammar used to refer to Kconfig options

 Documentation/networking/ipvs-sysctl.txt   |   62 ++++++++++++++++++++++++---
 MAINTAINERS                                |    4 +-
 include/linux/netfilter_ipv4/Kbuild        |    1 +
 include/linux/netfilter_ipv4/nf_nat.h      |   58 ++++++++++++++++++++++++++
 include/net/ip_vs.h                        |   11 ++---
 include/net/netfilter/nf_conntrack_tuple.h |   27 +------------
 include/net/netfilter/nf_nat.h             |   26 +-----------
 net/bridge/netfilter/ebt_ulog.c            |    7 +--
 net/ipv4/netfilter/ipt_CLUSTERIP.c         |    1 -
 net/ipv4/netfilter/ipt_ULOG.c              |    4 +-
 net/ipv4/netfilter/nf_nat_snmp_basic.c     |   22 +---------
 net/ipv6/netfilter.c                       |   13 ++++-
 net/ipv6/netfilter/nf_conntrack_reasm.c    |    7 +--
 net/netfilter/core.c                       |   11 ++---
 net/netfilter/ipset/ip_set_core.c          |    4 +-
 net/netfilter/ipvs/ip_vs_core.c            |   20 ++++-----
 net/netfilter/ipvs/ip_vs_ctl.c             |   22 +++-------
 net/netfilter/ipvs/ip_vs_dh.c              |    5 +-
 net/netfilter/ipvs/ip_vs_ftp.c             |    5 +-
 net/netfilter/ipvs/ip_vs_lblc.c            |    9 +---
 net/netfilter/ipvs/ip_vs_lblcr.c           |   13 ++----
 net/netfilter/ipvs/ip_vs_nfct.c            |    2 +-
 net/netfilter/ipvs/ip_vs_proto.c           |    5 +-
 net/netfilter/ipvs/ip_vs_proto_sctp.c      |   14 ++----
 net/netfilter/ipvs/ip_vs_proto_tcp.c       |    6 +--
 net/netfilter/ipvs/ip_vs_proto_udp.c       |    5 +-
 net/netfilter/ipvs/ip_vs_sh.c              |    5 +-
 net/netfilter/ipvs/ip_vs_wrr.c             |    5 +-
 net/netfilter/ipvs/ip_vs_xmit.c            |    2 +-
 net/netfilter/nf_conntrack_core.c          |    5 +--
 net/netfilter/nfnetlink_log.c              |    7 +--
 net/netfilter/xt_IDLETIMER.c               |    2 -
 net/netfilter/xt_hashlimit.c               |    5 +--
 33 files changed, 194 insertions(+), 201 deletions(-)
 create mode 100644 include/linux/netfilter_ipv4/nf_nat.h

-- 
1.7.2.5

