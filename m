From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 0/2] ipset patches for nf
Date: Sun, 19 Feb 2017 19:24:14 +0100
Message-ID: <1487528656-21961-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp2.kfki.hu ([148.6.0.28]:56476 "EHLO smtp2.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750914AbdBSSY6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 19 Feb 2017 13:24:58 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

Please apply the next patches for ipset in your nf branch.
Both patches should go into the stable kernel branches as well,
because these are important bugfixes:

* Sometimes valid entries in hash:* types of sets were evicted
  due to a typo in an index. The wrong evictions happen when
  entries are deleted from the set and the bucket is shrinked.
  Bug was reported by Eric Ewanco and the patch fixes
  netfilter bugzilla id #1119.
* Fixing of a null pointer exception when someone wants to add an
  entry to an empty list type of set and specifies an add before/after
  option. The fix is from Vishwanath Pai.

Best regards,
Jozsef

The following changes since commit f95d7a46bc5722767c30ee223c8b67dd0f2e8793:

  netfilter: ctnetlink: Fix regression in CTA_HELP processing (2017-02-06 12:49:05 +0100)

are available in the git repository at:

  git://blackhole.kfki.hu/nf master

for you to fetch changes up to 40b446a1d8af17274746ff7079aa0a618dffbac3:

  netfilter: ipset: Null pointer exception in ipset list:set (2017-02-19 19:08:47 +0100)

----------------------------------------------------------------
Jozsef Kadlecsik (1):
      Fix bug: sometimes valid entries in hash:* types of sets were evicted

Vishwanath Pai (1):
      netfilter: ipset: Null pointer exception in ipset list:set

 net/netfilter/ipset/ip_set_hash_gen.h | 2 +-
 net/netfilter/ipset/ip_set_list_set.c | 9 ++++++---
 2 files changed, 7 insertions(+), 4 deletions(-)
