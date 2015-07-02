From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft,v3 0/7] cache consolidation
Date: Thu,  2 Jul 2015 20:25:05 +0200
Message-ID: <1435861512-23572-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53394 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753586AbbGBSTo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 2 Jul 2015 14:19:44 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is v3 of the cache consolidation patchset.

In this round, I have patch 2/7 to use the scope so nft knows if this is a
table declaration that contains a full block of further declarations or not.
I have also fixed several problems I found while testing from the previous
round.

More info at:
http://marc.info/?l=netfilter-devel&m=143560012416115&w=2

Pablo Neira Ayuso (7):
  src: consolidate table cache
  src: add table declaration to cache
  src: consolidate set cache
  src: early allocation of the set ID
  segtree: pass element expression as parameter to set_to_intervals()
  rule: use netlink_add_setelems() when creating literal sets
  rule: fix use of intervals in set declarations

 include/expression.h |    3 +-
 include/rule.h       |    6 ++
 src/evaluate.c       |   49 ++++---------
 src/main.c           |   37 +++++++++-
 src/netlink.c        |   16 +----
 src/parser_bison.y   |   10 ++-
 src/rule.c           |  191 ++++++++++++++++++++++++++++++++------------------
 src/segtree.c        |   15 ++--
 8 files changed, 198 insertions(+), 129 deletions(-)

-- 
1.7.10.4

