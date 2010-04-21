From: Jan Engelhardt <jengelh@medozas.de>
Subject: nf-next: sysrq and condition 20100421
Date: Wed, 21 Apr 2010 12:26:55 +0200
Message-ID: <1271845618-28569-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:46617 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753941Ab0DUK1D (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 21 Apr 2010 06:27:03 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The following changes since commit 6c79bf0f2440fd250c8fce8d9b82fcf03d4e8350:
  Bart De Schuymer (1):
        netfilter: bridge-netfilter: fix refragmenting IP traffic encapsulated in PPPoE traffic

are available in the git repository at:

  git://dev.medozas.de/linux sysrq_cond

Jan Engelhardt (2):
      netfilter: xtables: inclusion of xt_SYSRQ
      netfilter: xtables: inclusion of xt_condition

 include/linux/netfilter/Kbuild         |    1 +
 include/linux/netfilter/xt_condition.h |   14 ++
 net/netfilter/Kconfig                  |   20 ++
 net/netfilter/Makefile                 |    2 +
 net/netfilter/xt_SYSRQ.c               |  354 ++++++++++++++++++++++++++++++++
 net/netfilter/xt_condition.c           |  243 ++++++++++++++++++++++
 6 files changed, 634 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/netfilter/xt_condition.h
 create mode 100644 net/netfilter/xt_SYSRQ.c
 create mode 100644 net/netfilter/xt_condition.c
