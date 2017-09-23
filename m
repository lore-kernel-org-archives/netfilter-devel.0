From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 0/1] ipset patch for nf
Date: Sat, 23 Sep 2017 23:37:39 +0200
Message-ID: <1506202660-12553-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.28]:35257 "EHLO smtp2.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750839AbdIWVhm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 23 Sep 2017 17:37:42 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

Please apply the next patch for the nf tree. It fixes the issue
when an IP range with more than 2^31 addresses was specified to
add (bugzilla id #1005)

- Fix adding an IPv4 range containing more than 2^31 addresses,
  which failed silently due to wrong comparison (bugzilla id #1005).

Thanks,
Jozsef
-

The following changes since commit 7f4f7dd4417d9efd038b14d39c70170db2e0baa0:

  netfilter: ipset: ipset list may return wrong member count for set with timeout (2017-09-18 17:35:32 +0200)

are available in the git repository at:

  git://blackhole.kfki.hu/nf 

for you to fetch changes up to 625a0411a81ae51c12bde4452171f08174b656cd:

  Fix adding an IPv4 range containing more than 2^31 addresses (2017-09-23 23:28:13 +0200)

----------------------------------------------------------------
Jozsef Kadlecsik (1):
      Fix adding an IPv4 range containing more than 2^31 addresses

 net/netfilter/ipset/ip_set_hash_ip.c         | 22 ++++++++++++----------
 net/netfilter/ipset/ip_set_hash_ipmark.c     |  2 +-
 net/netfilter/ipset/ip_set_hash_ipport.c     |  2 +-
 net/netfilter/ipset/ip_set_hash_ipportip.c   |  2 +-
 net/netfilter/ipset/ip_set_hash_ipportnet.c  |  4 ++--
 net/netfilter/ipset/ip_set_hash_net.c        |  2 +-
 net/netfilter/ipset/ip_set_hash_netiface.c   |  2 +-
 net/netfilter/ipset/ip_set_hash_netnet.c     |  4 ++--
 net/netfilter/ipset/ip_set_hash_netport.c    |  2 +-
 net/netfilter/ipset/ip_set_hash_netportnet.c |  4 ++--
 10 files changed, 24 insertions(+), 22 deletions(-)
