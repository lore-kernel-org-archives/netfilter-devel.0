From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft,v4 00/16] cache consolidation
Date: Mon,  6 Jul 2015 20:16:52 +0200
Message-ID: <1436206628-23894-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40425 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753248AbbGFSLi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Jul 2015 14:11:38 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

This is another round of the patchset to consolidate the nft cache. The idea
consists of creating a cache of tables that is populated with chains, rules,
sets and elements before parsing/evaluation.

This comes with several advantages:

1) We can now keep the ruleset file in a linear list fashion. We can also apply
   incremental set declaration updates in a file in an atomic fashion, eg.

	-o-FILE:nft-ruleset-o-
	add table filter
	add chain filter input { type filter hook input priority 0; }
	add set filter blacklist { type ipv4_addr; }
	add element filter blacklist { 4.4.4.10 }
	-o-EOF-o-

2) We have a single point to create a consistent cache, thus, we can handle
   EINTR and validate generation counter to make sure we operate with a ruleset
   that is up-to-date.

3) We can provide better error reporting from the evaluation step, eg.

   # nft add element filter blacklist { 1.1.1.1 }
   <cmdline>:1:1-36: Error: Could not process rule: Table 'filter' does not exist
   add element filter blacklist { 1.1.1.1 }
   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

   instead of:

   # nft add element filter blacklist { 1.1.1.1 }
   <cmdline>:1:1-36: Error: Could not process rule: No such file or directory
   add element filter blacklist { 1.1.1.1 }
   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

   In follow up patches, it should be possible to reduce the number of object
   lookups by attaching the corresponding object to struct cmd, so we don't need
   to look it up again from the final command execution step.

4) We can later on use the cache to perform ruleset transformations as Patrick
   already suggested.

I will keep testing this here a bit more, then if no objections, I'll push this
to master.

Thanks.

Pablo Neira Ayuso (16):
  src: consolidate table cache
  src: add cmd_evaluate_list()
  rule: add reference counter to the table object
  src: add table declaration to cache
  src: consolidate set cache
  src: add set declaration to cache
  src: early allocation of the set ID
  segtree: pass element expression as parameter to set_to_intervals()
  rule: use netlink_add_setelems() when creating literal sets
  rule: fix use of intervals in set declarations
  rule: add chain reference counter
  src: consolidate chain cache
  evaluate: add cmd_evaluate_rename()
  src: add chain declarations to cache
  rule: consolidate rule cache
  src: consolidate set element cache

 include/expression.h |    3 +-
 include/rule.h       |    9 ++
 src/evaluate.c       |  142 +++++++++++++++++-------
 src/main.c           |   30 +++++-
 src/netlink.c        |    4 -
 src/rule.c           |  294 ++++++++++++++++++++++++++------------------------
 src/segtree.c        |   15 +--
 7 files changed, 300 insertions(+), 197 deletions(-)

-- 
1.7.10.4

