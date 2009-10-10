From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: stomping static data pull
Date: Sat, 10 Oct 2009 11:22:10 +0200
Message-ID: <1255166535-6386-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:56624 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755879AbZJJJW7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 10 Oct 2009 05:22:59 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Hi Patrick,


I incorporated your suggestions and propose this new 4-series set.


The following changes since commit 374576a8b6f865022c0fd1ca62396889b23d66dd:
  Linus Torvalds (1):
        Linux 2.6.32-rc3

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
