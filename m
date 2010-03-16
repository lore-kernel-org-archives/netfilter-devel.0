From: Jan Engelhardt <jengelh@medozas.de>
Subject: [pull] a bit of tidying
Date: Tue, 16 Mar 2010 02:32:04 +0100
Message-ID: <1268703135-2622-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:49794 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937342Ab0CPBc0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Mar 2010 21:32:26 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Hi,


here's a first round for net-next-2.6.35.
Please review.


The following changes since commit 3a5b27bf6f29574d667230c7e76e4b83fe3014e0
[davenext/master @ v2.6.33-4115-g3a5b27b]:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://gitorious.org/linux-omap-dss2/linux

are available in the git repository at:

  git://dev.medozas.de/linux master

Jan Engelhardt (10):
      netfilter: xt_CT: par->family is an nfproto
      netfilter: xt_NFQUEUE: consolidate v4/v6 targets into one
      netfilter: xtables: add comment markers to Xtables Kconfig
      netfilter: xtables: merge xt_MARK into xt_mark
      netfilter: xtables: merge xt_CONNMARK into xt_connmark
      netfilter: xtables: merge xt_NOTRACK into xt_CT
      netfilter: update my email address
      netfilter: ebt_ip6: add principal maintainer in a MODULE_AUTHOR tag
      netfilter: xt_recent: update description
      netfilter: xt_recent: remove old proc directory

 Documentation/feature-removal-schedule.txt |   10 ---
 include/linux/netfilter/xt_CONNMARK.h      |   22 +-----
 include/linux/netfilter/xt_MARK.h          |    6 +-
 include/linux/netfilter/xt_connmark.h      |   11 +++
 include/linux/netfilter/xt_mark.h          |    4 +
 net/bridge/netfilter/ebt_ip6.c             |    3 +-
 net/netfilter/Kconfig                      |  119 +++++++++++++++-------------
 net/netfilter/Makefile                     |    9 +-
 net/netfilter/xt_CONNMARK.c                |  113 --------------------------
 net/netfilter/xt_CT.c                      |   58 ++++++++++---
 net/netfilter/xt_MARK.c                    |   56 -------------
 net/netfilter/xt_NFQUEUE.c                 |   40 +++-------
 net/netfilter/xt_NOTRACK.c                 |   53 ------------
 net/netfilter/xt_TCPOPTSTRIP.c             |    3 +-
 net/netfilter/xt_connlimit.c               |    1 -
 net/netfilter/xt_connmark.c                |   86 +++++++++++++++++++-
 net/netfilter/xt_hashlimit.c               |    2 +-
 net/netfilter/xt_mark.c                    |   35 ++++++++-
 net/netfilter/xt_recent.c                  |  109 +-------------------------
 net/netfilter/xt_time.c                    |    3 +-
 net/netfilter/xt_u32.c                     |    3 +-
 21 files changed, 263 insertions(+), 483 deletions(-)
 delete mode 100644 net/netfilter/xt_CONNMARK.c
 delete mode 100644 net/netfilter/xt_MARK.c
 delete mode 100644 net/netfilter/xt_NOTRACK.c
