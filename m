From: Jan Engelhardt <jengelh@medozas.de>
Subject: Guided option parser
Date: Wed,  6 Apr 2011 13:31:07 +0200
Message-ID: <1302089478-15022-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:46478 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750807Ab1DFLbU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 6 Apr 2011 07:31:20 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


This is a staggered submit, with 10 patches in the first submission.
See 01/10 for a description.

Currently, the entire set of 64 has a diffstat of

 74 files changed, 2845 insertions(+), 4062 deletions(-)

this is roughly a third of the entire work, and it is expected this
to linearly continue until ~200 patches. But I felt I needed to flush
the queue now.

===
The following changes since commit a239728ec064666025de2723997d87b176d57fd6:

  mark newly opened fds as FD_CLOEXEC (close on exec) (2011-04-04 15:30:32 +0200)

are available in the git repository at:
  git://dev.medozas.de/iptables opts

Jan Engelhardt (10):
      extensions: add missing checks for specific flags (2)
      libxtables: guided option parser
      libxt_CHECKSUM: use guided option parser
      libxt_socket: use guided option parser
      libxtables: provide better final_check
      libxt_CONNSECMARK: use guided option parser
      libxtables: XTTYPE_UINT32 support
      libxt_cpu: use guided option parser
      libxtables: min-max option support
      libxt_cluster: use guided option parser

 Makefile.am                     |    2 +-
 extensions/libip6t_ipv6header.c |    4 +-
 extensions/libxt_CHECKSUM.c     |   46 ++----
 extensions/libxt_CONNSECMARK.c  |   59 +++----
 extensions/libxt_cluster.c      |  187 +++++---------------
 extensions/libxt_cpu.c          |   65 ++-----
 extensions/libxt_socket.c       |   29 ++--
 include/xtables.h.in            |  111 ++++++++++++
 ip6tables.c                     |   56 ++++--
 iptables.c                      |   58 ++++---
 xshared.h                       |   20 ++
 xtables.c                       |   25 +--
 xtoptions.c                     |  366 +++++++++++++++++++++++++++++++++++++++
 13 files changed, 695 insertions(+), 333 deletions(-)
 create mode 100644 xtoptions.c
