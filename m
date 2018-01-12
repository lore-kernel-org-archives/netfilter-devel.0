From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 0/1] ipset patch for the nf tree
Date: Fri, 12 Jan 2018 11:16:49 +0100
Message-ID: <1515752210-22053-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp0.kfki.hu ([148.6.0.25]:48083 "EHLO smtp0.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754576AbeALKQx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 12 Jan 2018 05:16:53 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

Here follows a patch for the nf tree, please apply it:

- The patch "Fix adding an IPv4 range containing more than 2^31
  addresses" introduced a wraparound bug, which could lead to
  memory exhaustion, which is fixed here (netfilter bugzilla
  id #1212, reported by Thomas Schwark)

Best regards,
Jozsef

The following changes since commit 889c604fd0b5f6d3b8694ade229ee44124de1127:

  netfilter: x_tables: fix int overflow in xt_alloc_table_info() (2018-01-07 00:17:23 +0100)

are available in the git repository at:

  git://blackhole.kfki.hu/nf ba31d2d88b9

for you to fetch changes up to ba31d2d88b95ce1872fc17ffd0da70b68be0a07f:

  Fix wraparound bug introduced in commit 48596a8ddc46 (2018-01-12 11:07:35 +0100)

----------------------------------------------------------------
Jozsef Kadlecsik (1):
      Fix wraparound bug introduced in commit 48596a8ddc46

 net/netfilter/ipset/ip_set_hash_ipportnet.c  | 26 ++++++++++-----------
 net/netfilter/ipset/ip_set_hash_net.c        |  9 ++++---
 net/netfilter/ipset/ip_set_hash_netiface.c   |  9 ++++---
 net/netfilter/ipset/ip_set_hash_netnet.c     | 28 +++++++++++-----------
 net/netfilter/ipset/ip_set_hash_netport.c    | 19 ++++++++-------
 net/netfilter/ipset/ip_set_hash_netportnet.c | 35 ++++++++++++++--------------
 6 files changed, 63 insertions(+), 63 deletions(-)
