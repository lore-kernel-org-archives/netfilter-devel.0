From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH libnftnl 0/3] use nftnl_ prefix
Date: Wed,  2 Sep 2015 16:44:23 +0200
Message-ID: <1441205064-9240-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58509 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752464AbbIBOiE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Sep 2015 10:38:04 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patchset renames the existing functions and definitions to use the nftnl_
prefix to prepare the introduction of the higher level library, which will use
the nft_ prefix.

The patchset does not break backward compatibility: Neither compilation not
existing binaries.

The patchset keeps the nft_ symbols around as aliases for the nftnl_ symbols.
Moreover, the header files contain the old nft_ definitions so clients of this
library don't break all of a sudden.

Please, let me know if you observe any problem with this. I would like that
this changes are pushed to master before the next release.

Thanks.

Pablo Neira Ayuso (3):
  src: introduce nftnl_* aliases for all existing functions
  src: rename existing functions to use the nftnl_ prefix
  src: add compat header file definitions

 examples/nft-chain-add.c          |   28 +-
 examples/nft-chain-del.c          |   24 +-
 examples/nft-chain-get.c          |   28 +-
 examples/nft-chain-parse-add.c    |   38 +-
 examples/nft-events.c             |   72 ++--
 examples/nft-rule-add.c           |   68 +--
 examples/nft-rule-del.c           |   22 +-
 examples/nft-rule-get.c           |   18 +-
 examples/nft-rule-parse-add.c     |   40 +-
 examples/nft-ruleset-get.c        |  146 +++----
 examples/nft-ruleset-parse-file.c |  186 ++++----
 examples/nft-set-add.c            |   32 +-
 examples/nft-set-del.c            |   14 +-
 examples/nft-set-elem-add.c       |   28 +-
 examples/nft-set-elem-del.c       |   28 +-
 examples/nft-set-elem-get.c       |   26 +-
 examples/nft-set-get.c            |   24 +-
 examples/nft-set-parse-add.c      |   38 +-
 examples/nft-table-add.c          |   26 +-
 examples/nft-table-del.c          |   26 +-
 examples/nft-table-get.c          |   26 +-
 examples/nft-table-parse-add.c    |   36 +-
 examples/nft-table-upd.c          |   14 +-
 include/buffer.h                  |   34 +-
 include/common.h                  |   18 +-
 include/data_reg.h                |    8 +-
 include/expr.h                    |    6 +-
 include/expr_ops.h                |   26 +-
 include/json.h                    |   86 ++--
 include/libnftnl/batch.h          |   16 +
 include/libnftnl/chain.h          |   77 ++++
 include/libnftnl/common.h         |   53 +++
 include/libnftnl/expr.h           |  168 ++++++++
 include/libnftnl/gen.h            |   36 ++
 include/libnftnl/rule.h           |   83 ++++
 include/libnftnl/ruleset.h        |   61 +++
 include/libnftnl/set.h            |  136 ++++++
 include/libnftnl/table.h          |   65 +++
 include/set.h                     |    8 +-
 include/set_elem.h                |    8 +-
 include/utils.h                   |   54 +--
 include/xml.h                     |   74 ++--
 src/batch.c                       |   69 +--
 src/buffer.c                      |  114 ++---
 src/chain.c                       |  663 ++++++++++++++---------------
 src/common.c                      |  108 +++--
 src/expr.c                        |  108 ++---
 src/expr/bitwise.c                |  202 ++++-----
 src/expr/byteorder.c              |  192 ++++-----
 src/expr/cmp.c                    |  152 +++----
 src/expr/counter.c                |  120 +++---
 src/expr/ct.c                     |  174 ++++----
 src/expr/data_reg.c               |  150 +++----
 src/expr/dynset.c                 |  218 +++++-----
 src/expr/exthdr.c                 |  168 ++++----
 src/expr/immediate.c              |  196 ++++-----
 src/expr/limit.c                  |  120 +++---
 src/expr/log.c                    |  222 +++++-----
 src/expr/lookup.c                 |  148 +++----
 src/expr/masq.c                   |  100 ++---
 src/expr/match.c                  |  114 ++---
 src/expr/meta.c                   |  150 +++----
 src/expr/nat.c                    |  250 +++++------
 src/expr/payload.c                |  168 ++++----
 src/expr/queue.c                  |  150 +++----
 src/expr/redir.c                  |  148 +++----
 src/expr/reject.c                 |  120 +++---
 src/expr/target.c                 |  114 ++---
 src/expr_ops.c                    |    2 +-
 src/gen.c                         |  106 ++---
 src/jansson.c                     |  114 ++---
 src/libnftnl.map                  |  260 ++++++++++++
 src/mxml.c                        |   86 ++--
 src/rule.c                        |  612 +++++++++++++-------------
 src/ruleset.c                     |  848 ++++++++++++++++++-------------------
 src/set.c                         |  712 +++++++++++++++----------------
 src/set_elem.c                    |  462 ++++++++++----------
 src/table.c                       |  376 ++++++++--------
 src/utils.c                       |  125 +++---
 tests/nft-chain-test.c            |   92 ++--
 tests/nft-expr_bitwise-test.c     |   78 ++--
 tests/nft-expr_byteorder-test.c   |   78 ++--
 tests/nft-expr_cmp-test.c         |   66 +--
 tests/nft-expr_counter-test.c     |   60 +--
 tests/nft-expr_ct-test.c          |   66 +--
 tests/nft-expr_exthdr-test.c      |   72 ++--
 tests/nft-expr_immediate-test.c   |   72 ++--
 tests/nft-expr_limit-test.c       |   60 +--
 tests/nft-expr_log-test.c         |   72 ++--
 tests/nft-expr_lookup-test.c      |   66 +--
 tests/nft-expr_masq-test.c        |   54 +--
 tests/nft-expr_match-test.c       |   66 +--
 tests/nft-expr_meta-test.c        |   60 +--
 tests/nft-expr_nat-test.c         |   90 ++--
 tests/nft-expr_payload-test.c     |   72 ++--
 tests/nft-expr_queue-test.c       |   62 +--
 tests/nft-expr_redir-test.c       |   66 +--
 tests/nft-expr_reject-test.c      |   60 +--
 tests/nft-expr_target-test.c      |   66 +--
 tests/nft-parsing-test.c          |   50 +--
 tests/nft-rule-test.c             |   62 +--
 tests/nft-set-test.c              |   62 +--
 tests/nft-table-test.c            |   40 +-
 103 files changed, 6346 insertions(+), 5392 deletions(-)

-- 
1.7.10.4

