From: Jan Engelhardt <jengelh@medozas.de>
Subject: xt2 table core
Date: Tue, 29 Jun 2010 10:42:40 +0200
Message-ID: <1277801017-30600-1-git-send-email-jengelh@medozas.de>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:44213 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753826Ab0F2Ink (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Jun 2010 04:43:40 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Hi,


This patchset adds the xtables2 main proper, and incrementally
changes ip6_tables to use it. There are more patches for iptables
and arptables and, but to not make it larger than needed, just this
much for now.

Previously featured on http://lwn.net/Articles/345176/ .

The full piece is in the xt2-20100629 branch and would look like:
  38 files changed, 3361 insertions(+), 5644 deletions(-)
  [40% reduction; the remaining 10% were merged already]


Please leave some comments!


thanks,
Jan


-------------------------------
The following changes since commit fe6fb552858f686f39e33d7b0a33fe56dacea0bf:

  netfilter: fix simple typo in KConfig for netfiltert xt_TEE (2010-06-22 08:22:21 +0200)

are available in the git repository at:
  git://dev.medozas.de/linux master

Jan Engelhardt (33):
      netfilter: ebtables: simplify a device in/out check
      netfilter: ebtables: change ebt_basic_match to xt convention
      netfilter: xtables: move functions around
      netfilter: xtables: convert basic nfproto match functions into xt matches
      netfilter: xtables2: initial table skeletal functions
      netfilter: xtables2: initial chain skeletal functions
      netfilter: xtables2: initial rule skeletal functions
      netfilter: xtables: alternate size checking in xt_check_match
      netfilter: xtables: alternate size checking in xt_check_target
      netfilter: xtables2: per-rule match skeletal functions
      netfilter: xtables2: per-rule target skeletal functions
      netfilter: xtables2: xt_check_target in combination with xt2 contexts
      netfilter: xtables2: jumpstack (de)allocation functions
      netfilter: xtables2: table traversal
      netfilter: xtables: add xt_quota revision 3
      netfilter: xtables2: make a copy of the ipv6_filter table
      netfilter: xtables2: initial xt1->xt2 translation for tables
      netfilter: xtables2: xt2->xt1 translation - GET_INFO support
      netfilter: xtables2: xt2->xt1 translation - GET_ENTRIES support
      netfilter: xtables2: xt1->xt2 translation - SET_REPLACE support
      netfilter: xtables2: return counters after SET_REPLACE
      netfilter: xtables2: xt1->xt2 translation - ADD_COUNTERS support
      netfilter: xtables2: xt2->xt1 translation - compat GET_INFO support
      netfilter: ip6tables: move mark_chains to xt1_perproto.c
      netfilter: xtables2: xt2<->xt1 translation - compat GET_ENTRIES/SET_REPLACE support
      netfilter: xtables2: compat->normal match data translation
      netfilter: xtables2: compat->normal target data translation
      netfilter: xtables2: outsource code into xts_match_to_xt1 function
      netfilter: xtables2: normal->compat match data translation
      netfilter: xtables2: normal->compat target data translation
      netfilter: xtables2: packet tracing
      netfilter: xtables: turn procfs entries to walk xt2 table list
      netfilter: xtables2: switch ip6's tables to the xt2 table format

 include/linux/netfilter/x_tables.h        |  305 ++++++++++++-
 include/linux/netfilter/xt_quota.h        |   30 ++-
 include/linux/netfilter_ipv6/ip6_tables.h |   16 +
 include/net/net_namespace.h               |    1 +
 include/net/netns/x_tables.h              |    8 +
 net/bridge/netfilter/ebt_arpreply.c       |    2 +-
 net/bridge/netfilter/ebtables.c           |  128 ++++--
 net/ipv4/netfilter/arp_tables.c           |  199 +++++----
 net/ipv4/netfilter/ip_tables.c            |  281 ++++++------
 net/ipv4/netfilter/ipt_CLUSTERIP.c        |   17 +-
 net/ipv4/netfilter/ipt_ECN.c              |    4 +-
 net/ipv4/netfilter/ipt_REJECT.c           |    6 +-
 net/ipv6/netfilter/Kconfig                |    1 +
 net/ipv6/netfilter/ip6_tables.c           |  576 ++++++++++++------------
 net/ipv6/netfilter/ip6t_REJECT.c          |    6 +-
 net/ipv6/netfilter/ip6table_filter.c      |   24 +-
 net/ipv6/netfilter/ip6table_mangle.c      |   37 +-
 net/ipv6/netfilter/ip6table_raw.c         |   23 +-
 net/ipv6/netfilter/ip6table_security.c    |   24 +-
 net/netfilter/Kconfig                     |    6 +
 net/netfilter/Makefile                    |    1 +
 net/netfilter/x_tables.c                  |  717 ++++++++++++++++++++++++++++-
 net/netfilter/xt1_postshared.c            |   52 ++
 net/netfilter/xt1_support.c               |  597 ++++++++++++++++++++++++
 net/netfilter/xt1_translat.c              |  604 ++++++++++++++++++++++++
 net/netfilter/xt_TCPMSS.c                 |   42 +-
 net/netfilter/xt_TPROXY.c                 |    2 +-
 net/netfilter/xt_quota.c                  |  234 +++++++++-
 net/sched/act_ipt.c                       |    6 +-
 29 files changed, 3291 insertions(+), 658 deletions(-)
 create mode 100644 net/netfilter/xt1_postshared.c
 create mode 100644 net/netfilter/xt1_support.c
 create mode 100644 net/netfilter/xt1_translat.c
