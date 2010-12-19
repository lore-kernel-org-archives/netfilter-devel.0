From: Jan Engelhardt <jengelh@medozas.de>
Subject: ipset-5: buncha patches
Date: Sun, 19 Dec 2010 06:18:02 +0100
Message-ID: <1292735894-17534-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:42654 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750735Ab0LSFSQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 19 Dec 2010 00:18:16 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The following changes since commit 06366c172c487b3038b52e8fe640747b4092a544:

  Prevent calling Makefile directly in the kernel/ subdirectory (2010-12-19 00:56:03 +0100)

are available in the git repository at:
  git://dev.medozas.de/ipset master

Jan Engelhardt (11):
      build: enable parallel building
      xt_set: avoid user types in exported kernel headers
      kernel: do not mix const and __read_mostly
      kernel: use __read_mostly for registration-type structures
      kernel: const annotations
      kernel: use EXPORT_SYMBOL_GPL  (suggesting)
      libipset: ipset_strncpy is really a strlcpy-type operation
      libipset: remove redundant indirection via union name
      libipset: remove redundant casts
      libipset: const annotations
      libipset: static annotations

 Makefile.am                                        |    6 +-
 include/libipset/data.h                            |    2 +-
 kernel/include/linux/netfilter/ipset/ip_set.h      |    5 +-
 .../include/linux/netfilter/ipset/ip_set_ahash.h   |    8 +-
 .../include/linux/netfilter/ipset/ip_set_chash.h   |    4 +-
 kernel/include/linux/netfilter/xt_set.h            |   12 ++--
 kernel/ip_set.c                                    |   56 ++++++-------
 kernel/ip_set_bitmap_ip.c                          |   25 +++---
 kernel/ip_set_bitmap_ipmac.c                       |   18 ++--
 kernel/ip_set_bitmap_port.c                        |   31 +++----
 kernel/ip_set_hash_ip.c                            |   22 ++---
 kernel/ip_set_hash_ipport.c                        |   18 ++--
 kernel/ip_set_hash_ipportip.c                      |   18 ++--
 kernel/ip_set_hash_ipportnet.c                     |   18 ++--
 kernel/ip_set_hash_net.c                           |   19 ++--
 kernel/ip_set_hash_netport.c                       |   18 ++--
 kernel/ip_set_list_set.c                           |   19 ++--
 lib/data.c                                         |   92 ++++++++++----------
 lib/mnl.c                                          |    2 +-
 lib/parse.c                                        |   10 +-
 lib/print.c                                        |    2 +-
 lib/session.c                                      |   24 +++---
 lib/types.c                                        |   10 +-
 23 files changed, 214 insertions(+), 225 deletions(-)
