From: Jan Engelhardt <jengelh@medozas.de>
Subject: ipset: use NFPROTO_ constants
Date: Thu, 25 Aug 2011 11:20:55 +0200
Message-ID: <1314264057-5681-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:45205 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752383Ab1HYJVB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 25 Aug 2011 05:21:01 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>



I have changed the special variant _INET46 to _X_INET46 in
line with the "X-Something"-style headers that HTTP and mail
use, and I hope that copying the constants into nfproto.h
was right (given that nf_inet_addr.h was also copied).

===
The following changes since commit cdb6bb6cf01909e84bae99af0d83946884f24611:

  ipset 6.8 released (2011-07-11 11:10:47 +0200)

are available in the git repository at:
  git://dev.medozas.de/ipset master

Jan Engelhardt (1):
      ipset: use NFPROTO_ constants

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
 lib/data.c                                         |   21 ++++----
 lib/debug.c                                        |    4 +-
 lib/parse.c                                        |   52 ++++++++++----------
 lib/print.c                                        |   20 ++++----
 lib/session.c                                      |   34 ++++++------
 lib/types.c                                        |   26 +++++-----
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
 34 files changed, 189 insertions(+), 165 deletions(-)
 create mode 100644 include/libipset/nfproto.h
