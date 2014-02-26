From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 0/7] libnftnl updates
Date: Wed, 26 Feb 2014 02:51:52 +0100
Message-ID: <1393379519-16189-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40458 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750968AbaBZBwI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Feb 2014 20:52:08 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This batch contains updates for libnftnl:

* add implicit bugtrap for undefined set operations. Gcc will spot a
  compilation warning if attribute is not defined in the switch in
  nft_*_attr_set.

* add assertion infrastructure to validate attribute size.

* Add nft_*_attr_{set|get}_data to allow setting data of variable length.
  This includes validation of the attribute size. This new interface
  supersedes nft_*_attr_{set|get}. It is required by the per-rule
  userdata infrastructure.

* Fix wrong family attribute type uncovered by the validation added +
  existing test infrastructure.

* Get in sync with current linux kernel header (as of 3.14-rc).

* Simplify the overly complicated nft-rule-add example. This should help
  to merge the nft-rule-insert example into nft-rule-add.

* add support for NFT_RULE_ATTR_USERDATA, which allows nft to attach
  human-readable comments.

Pablo Neira Ayuso (7):
  src: early attribute type validation in nft_*_attr_set
  src: add assertion infrastructure to validate attribute types
  src: add nft_*_attr_{set|get}_data interface
  src: fix wrong type in NFT_ATTR_*_FAMILY
  include: get linux/netfilter/nf_tables.h in sync with kernel header
  example: nft-rule-add: simplify example
  rule: add NFT_RULE_ATTR_USERDATA support

 Make_global.am			     |	  2 +-
 examples/nft-rule-add.c	     |	 86 ++++++++----------------
 include/libnftnl/chain.h	     |	  6 ++
 include/libnftnl/expr.h	     |	  2 +
 include/libnftnl/rule.h	     |	  7 ++
 include/libnftnl/set.h		     |	  6 ++
 include/libnftnl/table.h	     |	  6 ++
 include/linux/netfilter/nf_tables.h |	  8 ++-
 src/chain.c			     |	 83 ++++++++++++++++++-----
 src/internal.h			     |	 13 ++++
 src/libnftnl.map		     |	 11 +++
 src/rule.c			     |	125 +++++++++++++++++++++++++++++++----
 src/set.c			     |	 47 +++++++++++--
 src/table.c			     |	 50 ++++++++++----
 src/utils.c			     |	  7 ++
 tests/nft-chain-test.c		     |	  6 +-
 tests/nft-expr_ct-test.c	     |	  6 +-
 tests/nft-expr_exthdr-test.c	     |	  6 +-
 tests/nft-expr_meta-test.c	     |	  4 +-
 tests/nft-table-test.c		     |	  6 +-
 20 files changed, 368 insertions(+), 119 deletions(-)

--
1.7.10.4

