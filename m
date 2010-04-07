From: Jan Engelhardt <jengelh@medozas.de>
Subject: nf-next: TEE/reentrancy 20100407
Date: Wed,  7 Apr 2010 20:50:10 +0200
Message-ID: <1270666217-27670-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org,
	YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:50577 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755678Ab0DGSu1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 7 Apr 2010 14:50:27 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The following changes since commit 02e4eb75912a5c8babccc1acdc9cc913989be04e:
  Eric Dumazet (1):
        netfilter: xt_hashlimit: RCU conversion

are available in the git repository at:

  git://dev.medozas.de/linux master

Jan Engelhardt (6):
      netfilter: ipv6: move POSTROUTING invocation before fragmentation
      netfilter: ipv6: add IPSKB_REROUTED exclusion to NF_HOOK/POSTROUTING invocation
      netfilter: xtables: inclusion of xt_TEE
      netfilter: xtables2: make ip_tables reentrant
      netfilter: xt_TEE: have cloned packet travel through Xtables too
      netfilter: xtables: remove old comments about reentrancy

 include/linux/netfilter/Kbuild     |    1 +
 include/linux/netfilter/x_tables.h |    7 +
 include/linux/netfilter/xt_TEE.h   |    8 ++
 net/ipv4/netfilter/arp_tables.c    |    6 +-
 net/ipv4/netfilter/ip_tables.c     |   67 ++++++-----
 net/ipv4/netfilter/ipt_REJECT.c    |    3 -
 net/ipv6/ip6_output.c              |   50 ++++----
 net/ipv6/netfilter/ip6_tables.c    |   58 ++++------
 net/ipv6/netfilter/ip6t_REJECT.c   |    3 -
 net/netfilter/Kconfig              |    7 +
 net/netfilter/Makefile             |    1 +
 net/netfilter/x_tables.c           |   79 ++++++++++++
 net/netfilter/xt_TEE.c             |  229 ++++++++++++++++++++++++++++++++++++
 13 files changed, 417 insertions(+), 102 deletions(-)
 create mode 100644 include/linux/netfilter/xt_TEE.h
 create mode 100644 net/netfilter/xt_TEE.c
