From: Jan Engelhardt <jengelh@medozas.de>
Subject: nf-next: condition
Date: Wed, 21 Apr 2010 15:33:10 +0200
Message-ID: <1271856792-20872-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:51824 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754374Ab0DUNdP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 21 Apr 2010 09:33:15 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>



Git ate my file, or I did not port it to the kernel yet.

I hope this is it, now.


The following changes since commit d97a9e47ba148cfc41e354c5cd241f472273207c:
  Jan Engelhardt (1):
        netfilter: x_tables: move sleeping allocation outside BH-disabled region

are available in the git repository at:

  git://dev.medozas.de/linux condition

Jan Engelhardt (1):
      netfilter: xtables: inclusion of xt_condition

 include/linux/netfilter/Kbuild         |    1 +
 include/linux/netfilter/xt_condition.h |   14 ++
 net/netfilter/Kconfig                  |    8 +
 net/netfilter/Makefile                 |    1 +
 net/netfilter/xt_condition.c           |  229 ++++++++++++++++++++++++++++++++
 5 files changed, 253 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/netfilter/xt_condition.h
 create mode 100644 net/netfilter/xt_condition.c
