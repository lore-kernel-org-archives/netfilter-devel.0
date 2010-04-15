From: Jan Engelhardt <jengelh@medozas.de>
Subject: nf-next: TEE 20100215
Date: Fri, 16 Apr 2010 01:25:04 +0200
Message-ID: <1271373909-6959-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:43241 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752059Ab0DOXZN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 Apr 2010 19:25:13 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Hi,


xt_TEE now has routing by oif. Please review. Does it look right to you?


The following changes since commit 9c6eb28aca52d562f3ffbaebaa56385df9972a43:
  Jan Engelhardt (1):
        netfilter: ipv6: add IPSKB_REROUTED exclusion to NF_HOOK/POSTROUTING invocation

are available in the git repository at:

  git://dev.medozas.de/linux master

Jan Engelhardt (4):
      netfilter: xtables: inclusion of xt_TEE
      netfilter: xtables2: make ip_tables reentrant
      netfilter: xt_TEE: have cloned packet travel through Xtables too
      netfilter: xtables: remove old comments about reentrancy

 include/linux/netfilter/Kbuild     |    1 +
 include/linux/netfilter/x_tables.h |    7 +
 include/linux/netfilter/xt_TEE.h   |    9 ++
 net/ipv4/netfilter/arp_tables.c    |    6 +-
 net/ipv4/netfilter/ip_tables.c     |   67 +++++-----
 net/ipv4/netfilter/ipt_REJECT.c    |    3 -
 net/ipv6/netfilter/ip6_tables.c    |   58 +++-----
 net/ipv6/netfilter/ip6t_REJECT.c   |    3 -
 net/netfilter/Kconfig              |    7 +
 net/netfilter/Makefile             |    1 +
 net/netfilter/x_tables.c           |   77 +++++++++++
 net/netfilter/xt_TEE.c             |  252 ++++++++++++++++++++++++++++++++++++
 12 files changed, 415 insertions(+), 76 deletions(-)
 create mode 100644 include/linux/netfilter/xt_TEE.h
 create mode 100644 net/netfilter/xt_TEE.c
