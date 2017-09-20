From: Phil Sutter <phil@nwl.cc>
Subject: [iptables PATCH 0/2] ip{,6}tables-restore: Fix wait-interval parsing
Date: Wed, 20 Sep 2017 19:34:34 +0200
Message-ID: <20170920173436.20221-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:41522 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751436AbdITRer (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 Sep 2017 13:34:47 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This series fixes two problems with parsing of --wait-interval (-W) option.

Phil Sutter (2):
  ip{,6}tables-restore: Don't ignore missing wait-interval value
  ip{,6}tables-restore: Don't accept wait-interval without wait

 iptables/ip6tables-restore.c | 5 +++++
 iptables/iptables-restore.c  | 5 +++++
 iptables/xshared.c           | 2 +-
 3 files changed, 11 insertions(+), 1 deletion(-)

-- 
2.13.1

