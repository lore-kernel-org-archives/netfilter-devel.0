From: Jan Engelhardt <jengelh@medozas.de>
Subject: ipset: use NFPROTO_ (v2)
Date: Wed, 31 Aug 2011 14:43:53 +0200
Message-ID: <1314794637-30141-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:53328 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755169Ab1HaMn7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 31 Aug 2011 08:43:59 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The following changes since commit cdb6bb6cf01909e84bae99af0d83946884f24611:

  ipset 6.8 released (2011-07-11 11:10:47 +0200)

are available in the git repository at:
  git://dev.medozas.de/ipset master

Jan Engelhardt (3):
      ipset: use NFPROTO_ constants
      build: abort autogen on subcommand failure
      build: move ipset_errcode into library

 autogen.sh                                         |    2 +-
 include/libipset/nfproto.h                         |   19 +++++++
 include/libipset/types.h                           |   15 +++--
 kernel/include/linux/netfilter/ipset/ip_set.h      |    5 ++-
 kernel/net/netfilter/ipset/ip_set_bitmap_ip.c      |    4 +-
 kernel/net/netfilter/ipset/ip_set_bitmap_ipmac.c   |    4 +-
 kernel/net/netfilter/ipset/ip_set_bitmap_port.c    |    4 +-
 kernel/net/netfilter/ipset/ip_set_core.c           |   16 +++---
 kernel/net/netfilter/ipset/ip_set_getport.c        |    4 +-
 kernel/net/netfilter/ipset/ip_set_hash_ip.c        |   18 +++---
 kernel/net/netfilter/ipset/ip_set_hash_ipport.c    |   10 ++--
 kernel/net/netfilter/ipset/ip_set_hash_ipportip.c  |   10 ++--
 kernel/net/netfilter/ipset/ip_set_hash_ipportnet.c |   12 ++--
 kernel/net/netfilter/ipset/ip_set_hash_net.c       |   12 ++--
 kernel/net/netfilter/ipset/ip_set_hash_netiface.c  |   12 ++--
 kernel/net/netfilter/ipset/ip_set_hash_netport.c   |   12 ++--
 kernel/net/netfilter/ipset/ip_set_list_set.c       |    2 +-
 lib/Makefile.am                                    |    1 +
 lib/data.c                                         |   21 ++++----
 lib/debug.c                                        |    4 +-
 {src => lib}/errcode.c                             |    0
 lib/parse.c                                        |   52 ++++++++++----------
 lib/print.c                                        |   20 ++++----
 lib/session.c                                      |   34 ++++++------
 lib/types.c                                        |   29 ++++++-----
 src/Makefile.am                                    |    1 -
 src/ipset.c                                        |   10 ++--
 src/ipset_bitmap_ip.c                              |    2 +-
 src/ipset_bitmap_ipmac.c                           |    2 +-
 src/ipset_bitmap_port.c                            |    2 +-
 src/ipset_hash_ip.c                                |    2 +-
 src/ipset_hash_ipport.c                            |    2 +-
 src/ipset_hash_ipportip.c                          |    2 +-
 src/ipset_hash_ipportnet.c                         |    4 +-
 src/ipset_hash_net.c                               |    4 +-
 src/ipset_hash_netiface.c                          |    2 +-
 src/ipset_hash_netport.c                           |    4 +-
 src/ipset_list_set.c                               |    2 +-
 38 files changed, 194 insertions(+), 167 deletions(-)
 create mode 100644 include/libipset/nfproto.h
 rename {src => lib}/errcode.c (100%)
