From: Jan Engelhardt <jengelh@medozas.de>
Subject: Quick intermediate cleanup
Date: Wed, 13 Oct 2010 20:03:17 +0200
Message-ID: <1286993003-3444-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:43221 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751298Ab0JMSDZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 13 Oct 2010 14:03:25 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The following changes since commit eecc545856c8a0f27783a440d25f4ceaa1f95ce8:

  netfilter: add missing xt_log.h file (2010-10-04 23:24:21 +0200)

are available in the git repository at:
  git://dev.medozas.de/linux master

Jan Engelhardt (5):
      netfilter: xtables: resolve indirect macros 1/3
      netfilter: xtables: resolve indirect macros 2/3
      netfilter: xtables: resolve indirect macros 3/3
      netfilter: xtables: unify {ip,ip6,arp}t_error_target
      netfilter: xtables: remove unused defines

 include/linux/netfilter/x_tables.h        |    5 ++
 include/linux/netfilter_arp/arp_tables.h  |   68 ++++++------------
 include/linux/netfilter_ipv4/ip_tables.h  |  107 ++++++++++++----------------
 include/linux/netfilter_ipv6/ip6_tables.h |  110 +++++++++++------------------
 net/ipv4/netfilter/arp_tables.c           |   62 ++++++++--------
 net/ipv4/netfilter/arpt_mangle.c          |    2 +-
 net/ipv4/netfilter/ip_tables.c            |   84 +++++++++++-----------
 net/ipv6/netfilter/ip6_tables.c           |   84 +++++++++++-----------
 net/sched/act_ipt.c                       |   14 ++--
 9 files changed, 240 insertions(+), 296 deletions(-)
