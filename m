From: Sergey Popovich <popovich_sergei@mail.ua>
Subject: ipset: small series of fixes
Date: Mon, 16 Mar 2015 15:40:10 +0200
Message-ID: <cover.1426509747.git.popovich_sergei@mail.ua>
To: netfilter-devel@vger.kernel.org, popovich_sergei@mail.ru
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fallback1.mail.ru ([94.100.181.184]:54684 "EHLO
	fallback1.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755984AbbCPONE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Mar 2015 10:13:04 -0400
Received: from smtp32.i.mail.ru (smtp32.i.mail.ru [94.100.177.92])
	by fallback1.mail.ru (mPOP.Fallback_MX) with ESMTP id E061752E2459
	for <netfilter-devel@vger.kernel.org>; Mon, 16 Mar 2015 16:40:20 +0300 (MSK)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This series of patches contains fixes to the current kernel
upstream version of ipset.

Sergey Popovich (6):
  netfilter: ipset: Properly calculate extensions offsets and total
    length
  netfilter: ipset: Use first timed out entry when no matching entry
    exists
  netfilter: ipset: Destroy extensions before moving non-last entry
  netfilter: ipset: Reset flags on private copy on set resize
  netfilter: ipset: Fix double free of comment string when adding
    element
  netfilter: ipset: Remove expired entries on set resize

 net/netfilter/ipset/ip_set_core.c     |   18 ++++++++++++------
 net/netfilter/ipset/ip_set_hash_gen.h |   32 +++++++++++++++-----------------
 2 files changed, 27 insertions(+), 23 deletions(-)

-- 
1.7.10.4

