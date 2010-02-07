From: Jan Engelhardt <jengelh@medozas.de>
Subject: Stomping Static Data pull, 2010-02-07
Date: Sun,  7 Feb 2010 12:49:40 +0100
Message-ID: <1265543385-7420-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:50116 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750741Ab0BGLts (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 7 Feb 2010 06:49:48 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Hi,


as previously tested, the hook function compaction has no measurable
difference in execution speed. I thus propose this submission that
has been updated to kaber-next/2.6.33.


The following changes since commit 84f3bb9ae9db90f7fb15d98b55279a58ab1b2363:
  Patrick McHardy (1):
        netfilter: xtables: add CT target

are available in the git repository at:

  git://dev.medozas.de/linux master

Jan Engelhardt (4):
      netfilter: xtables: compact table hook functions (1/2)
      netfilter: xtables: compact table hook functions (2/2)
      netfilter: xtables: use xt_table for hook instantiation
      netfilter: xtables: generate initial table on-demand

 include/linux/netfilter/x_tables.h        |    5 +
 include/linux/netfilter_arp/arp_tables.h  |    1 +
 include/linux/netfilter_ipv4/ip_tables.h  |    1 +
 include/linux/netfilter_ipv6/ip6_tables.h |    1 +
 net/ipv4/netfilter/arp_tables.c           |    7 ++
 net/ipv4/netfilter/arptable_filter.c      |   87 +++-------------
 net/ipv4/netfilter/ip_tables.c            |    7 ++
 net/ipv4/netfilter/iptable_filter.c       |  114 +++++-----------------
 net/ipv4/netfilter/iptable_mangle.c       |  153 ++++++-----------------------
 net/ipv4/netfilter/iptable_raw.c          |   86 ++++------------
 net/ipv4/netfilter/iptable_security.c     |  106 ++++----------------
 net/ipv4/netfilter/nf_nat_rule.c          |   38 +------
 net/ipv6/netfilter/ip6_tables.c           |    7 ++
 net/ipv6/netfilter/ip6table_filter.c      |  104 ++++----------------
 net/ipv6/netfilter/ip6table_mangle.c      |  132 ++++++-------------------
 net/ipv6/netfilter/ip6table_raw.c         |   77 +++------------
 net/ipv6/netfilter/ip6table_security.c    |   99 +++----------------
 net/netfilter/x_tables.c                  |   70 +++++++++++++-
 net/netfilter/xt_repldata.h               |   35 +++++++
 19 files changed, 333 insertions(+), 797 deletions(-)
 create mode 100644 net/netfilter/xt_repldata.h
