From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: static data reduction, 2010-02-10
Date: Wed, 10 Feb 2010 15:59:09 +0100
Message-ID: <1265813954-13854-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:49983 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754556Ab0BJO7Y (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Feb 2010 09:59:24 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>



Hehe, thanks for your patience :-)
[grmbl, vger's list name standardization is <90%]


The following changes since commit 9ab99d5a43e9f283738fd9fd365539306d13eaac:
  Patrick McHardy (1):
        Merge branch 'master' of /repos/git/net-next-2.6

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
