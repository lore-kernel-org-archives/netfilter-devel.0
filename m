From: Jan Engelhardt <jengelh@medozas.de>
Subject: iptables: headers, chain length
Date: Thu, 24 Jun 2010 10:14:01 +0200
Message-ID: <1277367245-14961-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:37887 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752918Ab0FXIOM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 24 Jun 2010 04:14:12 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The following changes since commit d40f1628c3717daebc437a398a285e371b5b6f7f:

  libxt_set: new revision added (2010-06-16 12:45:33 +0200)

are available in the git repository at:
  git://dev.medozas.de/iptables master

Jan Engelhardt (3):
      includes: sync header files from Linux 2.6.35-rc1
      xtables: another try at chain name length checking
      xtables: remove xtables_set_revision function

 configure.ac                          |    2 +-
 include/linux/kernel.h                |   62 +++++++++++++++++++++++++++++++++
 include/linux/netfilter/x_tables.h    |   30 +++++++++++-----
 include/linux/netfilter/xt_CONNMARK.h |   22 +-----------
 include/linux/netfilter/xt_MARK.h     |    6 +---
 include/linux/netfilter/xt_TEE.h      |    3 ++
 include/linux/netfilter/xt_connmark.h |   11 ++++++
 include/linux/netfilter/xt_mark.h     |    4 ++
 include/linux/netfilter/xt_recent.h   |    7 ++++
 include/linux/netfilter_ipv6.h        |    1 +
 include/xtables.h.in                  |    1 -
 ip6tables-restore.c                   |    4 +-
 ip6tables.c                           |   12 +++----
 iptables-restore.c                    |    4 +-
 iptables.c                            |   15 +++-----
 xtables.c                             |   18 ++-------
 16 files changed, 131 insertions(+), 71 deletions(-)
 create mode 100644 include/linux/kernel.h
