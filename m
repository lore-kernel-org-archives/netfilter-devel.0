From: Jan Engelhardt <jengelh@medozas.de>
Subject: nf-next: TEE and nesting
Date: Wed, 31 Mar 2010 12:31:21 +0200
Message-ID: <1270031487-15094-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:52717 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757593Ab0CaKbc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 31 Mar 2010 06:31:32 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Hi,


next on the calendar is the xt_TEE submission.


The following changes since commit b44672889c11e13e4f4dc0a8ee23f0e64f1e57c6:
  Jan Engelhardt (1):
        netfilter: xtables: merge registration structure to NFPROTO_UNSPEC

are available in the git repository at:

  git://dev.medozas.de/linux master

Jan Engelhardt (5):
      netfilter: ipv6: move POSTROUTING invocation before fragmentation
      net: ipv6: add IPSKB_REROUTED exclusion to NF_HOOK/POSTROUTING invocation
      netfilter: xtables: inclusion of xt_TEE
      netfilter: xtables2: make ip_tables reentrant
      netfilter: xt_TEE: have cloned packet travel through Xtables too

 include/linux/netfilter/Kbuild     |    1 +
 include/linux/netfilter/x_tables.h |    7 +
 include/linux/netfilter/xt_TEE.h   |    8 +
 net/ipv4/netfilter/arp_tables.c    |    6 +-
 net/ipv4/netfilter/ip_tables.c     |   65 +++++----
 net/ipv6/ip6_output.c              |   50 ++++----
 net/ipv6/netfilter/ip6_tables.c    |   56 +++-----
 net/netfilter/Kconfig              |    7 +
 net/netfilter/Makefile             |    1 +
 net/netfilter/x_tables.c           |   79 +++++++++++
 net/netfilter/xt_TEE.c             |  258 ++++++++++++++++++++++++++++++++++++
 11 files changed, 446 insertions(+), 92 deletions(-)
 create mode 100644 include/linux/netfilter/xt_TEE.h
 create mode 100644 net/netfilter/xt_TEE.c
