From: Jan Engelhardt <jengelh@medozas.de>
Subject: iptables: options, tproxy
Date: Fri,  3 Dec 2010 22:58:38 +0100
Message-ID: <1291413524-15016-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:44577 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752901Ab0LCV6q (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 3 Dec 2010 16:58:46 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The following changes since commit 2f09f1b39ced2ae7109382dcf066785bab4a966a:

  libxt_conntrack: fix --ctdir save/dump output format (2010-11-17 15:54:18 +0100)

are available in the git repository at:
  git://dev.medozas.de/iptables master

Jan Engelhardt (5):
      iptables: reset options at the start of each command
      iptables: do not emit orig_opts twice
      include: update files with headers from Linux 2.6.37-rc1
      TPROXY: add support for revision 1
      socket: add support for revision 1

 extensions/libxt_SECMARK.c               |    8 +-
 extensions/libxt_TPROXY.c                |  193 +++++++++++++++++++++++++-----
 extensions/libxt_socket.c                |   76 +++++++++++-
 extensions/libxt_socket.man              |    3 +
 extensions/libxt_time.c                  |    1 +
 include/linux/netfilter/xt_CHECKSUM.h    |    8 +-
 include/linux/netfilter/xt_CT.h          |   10 +-
 include/linux/netfilter/xt_IDLETIMER.h   |    2 +-
 include/linux/netfilter/xt_SECMARK.h     |   12 +--
 include/linux/netfilter/xt_TCPOPTSTRIP.h |    2 +-
 include/linux/netfilter/xt_TPROXY.h      |   17 ++-
 include/linux/netfilter/xt_cluster.h     |    8 +-
 include/linux/netfilter/xt_connlimit.h   |    2 +
 include/linux/netfilter/xt_ipvs.h        |    2 +
 include/linux/netfilter/xt_physdev.h     |    3 +
 include/linux/netfilter/xt_policy.h      |   11 ++
 include/linux/netfilter/xt_quota.h       |    6 +-
 include/linux/netfilter/xt_sctp.h        |    4 +-
 include/linux/netfilter/xt_socket.h      |   12 ++
 include/linux/netfilter/xt_time.h        |   14 +-
 include/linux/netfilter/xt_u32.h         |   16 ++--
 ip6tables.c                              |    2 +-
 iptables.c                               |    2 +-
 xtables.c                                |    4 +
 24 files changed, 329 insertions(+), 89 deletions(-)
 create mode 100644 include/linux/netfilter/xt_socket.h
