From: Jan Engelhardt <jengelh@medozas.de>
Subject: nf-next: reentrancy, new modules
Date: Tue, 13 Apr 2010 14:37:39 +0200
Message-ID: <1271162268-28131-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:44332 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751201Ab0DMMhy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 13 Apr 2010 08:37:54 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Hi,


per request, the series reposted with fixes applied. I also tacked
sysrq and condition on.


The following changes since commit 9f93ff5be54108066372d1c4100c515d9d9acc1b:
  Alexey Dobriyan (1):
        Restore __ALIGN_MASK()

are available in the git repository at:

  git://dev.medozas.de/linux master

Jan Engelhardt (8):
      netfilter: ipv6: move POSTROUTING invocation before fragmentation
      netfilter: ipv6: add IPSKB_REROUTED exclusion to NF_HOOK/POSTROUTING invocation
      netfilter: xtables: inclusion of xt_TEE
      netfilter: xtables2: make ip_tables reentrant
      netfilter: xt_TEE: have cloned packet travel through Xtables too
      netfilter: xtables: remove old comments about reentrancy
      netfilter: xtables: inclusion of xt_SYSRQ
      netfilter: xtables: inclusion of xt_condition

 include/linux/netfilter/Kbuild         |    2 +
 include/linux/netfilter/x_tables.h     |    7 +
 include/linux/netfilter/xt_TEE.h       |    8 +
 include/linux/netfilter/xt_condition.h |   14 ++
 net/ipv4/netfilter/arp_tables.c        |    6 +-
 net/ipv4/netfilter/ip_tables.c         |   67 +++---
 net/ipv4/netfilter/ipt_REJECT.c        |    3 -
 net/ipv6/ip6_output.c                  |   50 +++---
 net/ipv6/netfilter/ip6_tables.c        |   58 ++----
 net/ipv6/netfilter/ip6t_REJECT.c       |    3 -
 net/netfilter/Kconfig                  |   27 +++
 net/netfilter/Makefile                 |    3 +
 net/netfilter/x_tables.c               |   77 +++++++
 net/netfilter/xt_SYSRQ.c               |  354 ++++++++++++++++++++++++++++++++
 net/netfilter/xt_TEE.c                 |  228 ++++++++++++++++++++
 net/netfilter/xt_condition.c           |  243 ++++++++++++++++++++++
 16 files changed, 1048 insertions(+), 102 deletions(-)
 create mode 100644 include/linux/netfilter/xt_TEE.h
 create mode 100644 include/linux/netfilter/xt_condition.h
 create mode 100644 net/netfilter/xt_SYSRQ.c
 create mode 100644 net/netfilter/xt_TEE.c
 create mode 100644 net/netfilter/xt_condition.c
