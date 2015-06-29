From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 0/7 nft] cache consolidation
Date: Mon, 29 Jun 2015 19:53:57 +0200
Message-ID: <1435600444-21529-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57256 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751343AbbF2Rsl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 29 Jun 2015 13:48:41 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Patrick,

This patchset creates two caches, one for tables and another for sets, that
contain the existing objects in the kernel.

Moreover, this also adds the declared objects that don't exists yet in the
kernel to the cache, so they can be referenced from a batch, eg.

-BEGIN of test.ruleset-
add table test
add chain test test
add set test myset { type ipv4_addr; }
add element test myset { 4.4.4.10 }
add element test myset { 4.4.4.11 }
add element test myset { 4.4.4.12 }
add element test myset { 4.4.4.13 }
add rule test test ip saddr @myset
-EOF-

 # nft -f test.ruleset

The idea is to use table_lookup() and set_lookup(), instead of inquiring the
kernel (which would fail since those objects don't exist yet there). The
example above now works and those updates are handled from the same
transaction.

This patch also includes the fix of intervals in set declarations by using
these caches as you suggested, now that we got rid of the get_set() function.

Let me know if you have any concern with these, thanks!

Pablo Neira Ayuso (6):
  src: always allocate table object with no table block
  src: consolidate set cache
  src: early allocation of the set ID
  segtree: pass element expression as parameter to set_to_intervals()
  rule: use netlink_add_setelems() when creating literal sets
  rule: fix use of intervals in set declarations

 include/expression.h |    3 +-
 include/rule.h       |    3 +
 src/evaluate.c       |   60 ++++++++-----------
 src/main.c           |    6 ++
 src/netlink.c        |    4 --
 src/parser_bison.y   |    7 ++-
 src/rule.c           |  156 ++++++++++++++++++++++++++++++++------------------
 src/segtree.c        |   15 ++---
 8 files changed, 147 insertions(+), 107 deletions(-)

--
1.7.10.4

