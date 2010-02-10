From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: static data reduction
Date: Wed, 10 Feb 2010 17:51:51 +0100
Message-ID: <1265820716-3886-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:36334 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755114Ab0BJQv6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Feb 2010 11:51:58 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


I incorporated the desired changes and hope it's right now.

---
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

 include/linux/netfilter/x_tables.h        |    4 +
 include/linux/netfilter_arp/arp_tables.h  |    1 +
 include/linux/netfilter_ipv4/ip_tables.h  |    1 +
 include/linux/netfilter_ipv6/ip6_tables.h |    1 +
 net/ipv4/netfilter/arp_tables.c           |    7 ++
 net/ipv4/netfilter/arptable_filter.c      |   95 ++++--------------
 net/ipv4/netfilter/ip_tables.c            |    7 ++
 net/ipv4/netfilter/iptable_filter.c       |  122 ++++++-----------------
 net/ipv4/netfilter/iptable_mangle.c       |  154 ++++++-----------------------
 net/ipv4/netfilter/iptable_raw.c          |   94 +++++-------------
 net/ipv4/netfilter/iptable_security.c     |  115 +++++-----------------
 net/ipv4/netfilter/nf_nat_rule.c          |   39 ++------
 net/ipv6/netfilter/ip6_tables.c           |    7 ++
 net/ipv6/netfilter/ip6table_filter.c      |  111 +++++----------------
 net/ipv6/netfilter/ip6table_mangle.c      |  131 +++++-------------------
 net/ipv6/netfilter/ip6table_raw.c         |   84 ++++------------
 net/ipv6/netfilter/ip6table_security.c    |  107 ++++----------------
 net/netfilter/x_tables.c                  |   58 +++++++++++-
 net/netfilter/xt_repldata.h               |   35 +++++++
 19 files changed, 348 insertions(+), 825 deletions(-)
 create mode 100644 net/netfilter/xt_repldata.h
