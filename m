From: Jan Engelhardt <jengelh@medozas.de>
Subject: xtables2 a8, netlink interface
Date: Thu, 19 Jan 2012 17:26:14 +0100
Message-ID: <1326990381-14534-1-git-send-email-jengelh@medozas.de>
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:57966 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932325Ab2ASQ0Y (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Jan 2012 11:26:24 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


So here is the first set of patches implementing part of the xt2 core
and nfnl interface. Please review, I am sure you will have something
to say :)

The userspace part is at git://dev.medozas.de/libnetfilter_xtables,
the xtnl-test program compiled as part of the default make target
gives access to the kernel functions implemented by the patches.

===
The following changes since commit c3b92c8787367a8bb53d57d9789b558f1295cc96:

  Linux 3.1 (2011-10-24 09:10:05 +0200)

are available in the git repository at:
  git://dev.medozas.de/linux xtables2_a8

Jan Engelhardt (7):
      netfilter: xtables2: initial table skeletal functions
      netfilter: xtables2: initial Netlink interface
      netfilter: xtables2: chain creation and deletion
      netfilter: xtables2: chain renaming support
      netfilter: xtables2: initial table replace support
      netfilter: xtables2: transaction abort support
      netfilter: xtables2: redirect writes into transaction buffer

 include/linux/netfilter/Kbuild              |    1 +
 include/linux/netfilter/nfnetlink.h         |    3 +-
 include/linux/netfilter/nfnetlink_xtables.h |   48 +++
 include/net/netfilter/x_tables2.h           |   50 +++
 net/netfilter/Kconfig                       |   16 +-
 net/netfilter/Makefile                      |    2 +
 net/netfilter/xt2_core.c                    |  199 +++++++++
 net/netfilter/xt2_nfnetlink.c               |  584 +++++++++++++++++++++++++++
 8 files changed, 901 insertions(+), 2 deletions(-)
 create mode 100644 include/linux/netfilter/nfnetlink_xtables.h
 create mode 100644 include/net/netfilter/x_tables2.h
 create mode 100644 net/netfilter/xt2_core.c
 create mode 100644 net/netfilter/xt2_nfnetlink.c
