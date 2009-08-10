From: Jan Engelhardt <jengelh@medozas.de>
Subject: Pull request for Stomping Static Data
Date: Mon, 10 Aug 2009 21:19:46 +0200
Message-ID: <1249931992-18761-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:33973 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468AbZHJTUA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 Aug 2009 15:20:00 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Summary:
	In this 6-patch set, large quantities of static data are
	eliminated and replaced by generate-at-runtime structures
	(memory savings outside of the initialization phase).


The following changes since commit e2fe35c17fed62d4ab5038fa9bc489e967ff8416:
  Jan Engelhardt (1):
        netfilter: xtables: check for standard verdicts in policies

are available in the git repository at:

  git://dev.medozas.de/linux master

Jan Engelhardt (6):
      netfilter: xtables: consolidate table hook functions
      netfilter: xtables: compact table hook functions
      netfilter: xtables: generate nf_hook_ops on-demand
      netfilter: xtables: mark initial tables constant
      netfilter: xtables: use xt_table for hook instantiation
      netfilter: xtables: generate initial table on-demand

 include/linux/netfilter/x_tables.h        |    7 +-
 include/linux/netfilter_arp/arp_tables.h  |    2 +-
 include/linux/netfilter_bridge/ebtables.h |    2 +-
 include/linux/netfilter_ipv4/ip_tables.h  |    2 +-
 include/linux/netfilter_ipv6/ip6_tables.h |    2 +-
 net/bridge/netfilter/ebtable_broute.c     |    2 +-
 net/bridge/netfilter/ebtable_filter.c     |    2 +-
 net/bridge/netfilter/ebtables.c           |   13 ++-
 net/ipv4/netfilter/arp_tables.c           |    3 +-
 net/ipv4/netfilter/arptable_filter.c      |   91 ++++-------------
 net/ipv4/netfilter/ip_tables.c            |    3 +-
 net/ipv4/netfilter/iptable_filter.c       |  118 +++++-----------------
 net/ipv4/netfilter/iptable_mangle.c       |  157 ++++++-----------------------
 net/ipv4/netfilter/iptable_raw.c          |   90 ++++------------
 net/ipv4/netfilter/iptable_security.c     |  110 ++++----------------
 net/ipv4/netfilter/nf_nat_rule.c          |   40 ++------
 net/ipv6/netfilter/ip6_tables.c           |    3 +-
 net/ipv6/netfilter/ip6table_filter.c      |  108 ++++----------------
 net/ipv6/netfilter/ip6table_mangle.c      |  134 ++++++-------------------
 net/ipv6/netfilter/ip6table_raw.c         |   81 ++++------------
 net/ipv6/netfilter/ip6table_security.c    |  103 ++++----------------
 net/netfilter/x_tables.c                  |  125 ++++++++++++++++++++++-
 22 files changed, 365 insertions(+), 833 deletions(-)
