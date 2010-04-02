From: Jan Engelhardt <jengelh@medozas.de>
Subject: nf-next: xt_condition, xt_SYSRQ
Date: Fri,  2 Apr 2010 15:23:16 +0200
Message-ID: <1270214599-22734-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:57512 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752439Ab0DBNXX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 2 Apr 2010 09:23:23 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Hi,



As reviewed previously in
	http://marc.info/?l=netfilter-devel&m=126883196918488&w=2
	http://marc.info/?t=126883205200011&r=1&w=2

Please merge.



The following changes since commit 02e4eb75912a5c8babccc1acdc9cc913989be04e:
  Eric Dumazet (1):
        netfilter: xt_hashlimit: RCU conversion

are available in the git repository at:

  git://dev.medozas.de/linux master

Jan Engelhardt (2):
      netfilter: xtables: inclusion of xt_condition
      netfilter: xtables: inclusion of xt_SYSRQ

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
