From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 0/4] ipset patches for nf-next
Date: Mon, 11 Sep 2017 21:52:36 +0200
Message-ID: <1505159560-13161-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.25]:34437 "EHLO smtp0.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751617AbdIKTwn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 11 Sep 2017 15:52:43 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

Here follows a few ipset patches for the nf-next tree:

* Merge assignment and simplify return in a fuction by Simran Singhal
* Fix a sparse warning from me
* Deduplicate prefixlen maps by Aaron Conole
* Fix the outdated element counter for sets with timeout by Vishwanath Pai

Please consider applying them.

Best regards,
Jozsef

The following changes since commit 80cee03bf1d626db0278271b505d7f5febb37bba:

  Merge branch 'linus' of git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6 (2017-09-06 15:17:17 -0700)

are available in the git repository at:

  git://blackhole.kfki.hu/nf-next 5c8d7e721c8a1b478bb5f0c9602560e56f466cbe

for you to fetch changes up to 5c8d7e721c8a1b478bb5f0c9602560e56f466cbe:

  netfilter: ipset: ipset list may return wrong member count for set with timeout (2017-09-11 21:38:49 +0200)

----------------------------------------------------------------
Aaron Conole (1):
      netfilter: ipset: deduplicate prefixlen maps

Jozsef Kadlecsik (1):
      netfilter: ipset: Fix sparse warnings

Vishwanath Pai (1):
      netfilter: ipset: ipset list may return wrong member count for set with timeout

simran singhal (1):
      netfilter: ipset: Compress return logic

 net/netfilter/ipset/ip_set_hash_gen.h       |  14 +-
 net/netfilter/ipset/ip_set_hash_ipportnet.c |   2 +-
 net/netfilter/ipset/ip_set_list_set.c       |   5 +-
 net/netfilter/ipset/pfxlen.c                | 395 ++++++++++------------------
 4 files changed, 152 insertions(+), 264 deletions(-)
