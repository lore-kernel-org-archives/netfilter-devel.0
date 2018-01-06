From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 0/3] ipset patches for nf-next
Date: Sat,  6 Jan 2018 16:36:06 +0100
Message-ID: <1515252969-26094-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.25]:38549 "EHLO smtp0.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753279AbeAFPmO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 6 Jan 2018 10:42:14 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

Please consider to apply the next patches:

- A patch to use the swap() macro instead of the manual coding
  from Gustavo A. R. Silva
- A fix to take into account the possible counter value matching
  for the "don't update counters" mode. It required a reorganizing
  in handling the extensions which resulted a simpler and cleaner code.
- The patch "netfilter: ipset: use nfnl_mutex_is_locked" revealed
  a missing mutex locking in ip_set_net_exit(), fixed.

Best regards,
Jozsef

The following changes since commit e0ca2b8c1e3c299da6baca30b528a37c485e3d69:

  netfilter: add nf_queue_entry forward declaration (2018-01-02 12:23:32 +0100)

are available in the git repository at:

  git://blackhole.kfki.hu/nf-next 83d7fe936e

for you to fetch changes up to 83d7fe936e79136275fa2ed3feea95267e0a9fe3:

  netfilter: ipset: Missing nfnl_lock()/nfnl_unlock() is added to ip_set_net_exit() (2018-01-06 15:24:18 +0100)

----------------------------------------------------------------
Gustavo A. R. Silva (1):
      netfilter: ipset: use swap macro instead of _manually_ swapping values

Jozsef Kadlecsik (2):
      netfilter: ipset: Fix "don't update counters" mode when counters used at the matching
      netfilter: ipset: Missing nfnl_lock()/nfnl_unlock() is added to ip_set_net_exit()

 include/linux/netfilter/ipset/ip_set.h         |   6 ++
 include/linux/netfilter/ipset/ip_set_counter.h |  25 ++++--
 net/netfilter/ipset/ip_set_bitmap_gen.h        |   9 +-
 net/netfilter/ipset/ip_set_bitmap_ip.c         |   8 +-
 net/netfilter/ipset/ip_set_bitmap_ipmac.c      |   8 +-
 net/netfilter/ipset/ip_set_bitmap_port.c       |   8 +-
 net/netfilter/ipset/ip_set_core.c              |  27 ++++++
 net/netfilter/ipset/ip_set_hash_gen.h          |  37 +++-----
 net/netfilter/ipset/ip_set_list_set.c          |  21 ++---
 net/netfilter/xt_set.c                         | 119 +++++++++----------------
 10 files changed, 122 insertions(+), 146 deletions(-)
