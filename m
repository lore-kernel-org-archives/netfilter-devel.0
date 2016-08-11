From: Phil Sutter <phil@nwl.cc>
Subject: [libnftnl PATCH 0/7] A bunch of covscan detected fixes
Date: Fri, 12 Aug 2016 01:33:32 +0200
Message-ID: <1470958419-32602-1-git-send-email-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:53359 "EHLO mail.nwl.cc"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751570AbcHKXef (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Aug 2016 19:34:35 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The following series aims at fixing a number of issues identified by
Coverity tool. Due to limited familiarity with the whole code layout, I
am not sure all of them are really valid, but I tried my best to verify
the concerns are legitimate and worth fixing.

Phil Sutter (7):
  set: prevent memleak in nftnl_jansson_parse_set_info()
  ruleset: Prevent memleak in nftnl_ruleset_snprintf_*() functions
  expr/ct: prevent array index overrun in ctkey2str()
  expr/limit: Drop unreachable code in limit_to_type()
  common: Avoid integer overflow in nftnl_batch_is_supported()
  Avoid returning uninitialized data
  ruleset: Initialize ctx.flags before calling nftnl_ruleset_ctx_set()

 src/chain.c      |  2 +-
 src/common.c     |  3 +++
 src/expr/ct.c    |  2 +-
 src/expr/limit.c |  1 -
 src/rule.c       |  2 +-
 src/ruleset.c    | 18 ++++++++++++++++++
 src/set.c        | 12 ++++++------
 src/table.c      |  2 +-
 8 files changed, 31 insertions(+), 11 deletions(-)

-- 
2.8.2

