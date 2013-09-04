From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [nftables tool v2 PATCH 0/4] Easier base chain declaration
Date: Wed,  4 Sep 2013 12:50:18 +0300
Message-ID: <1378288222-13182-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:57218 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934469Ab3IDJui (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 4 Sep 2013 05:50:38 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Same patchset as before (minus bug fix which got applied already) applying comments.
Now chain's hook names are validated at parsing stage, and their scope is checked at
evaluation thus the error can be reported on the command line properly.

Rest is same as before, just refactored a bit the type checking.

Tomasz Bursztyka (4):
  src: Wrap netfilter hooks around human readable strings
  src: Ensure given base chain type is a valid one
  src: Add priority keyword on base chain description
  tests: Update bate chain creation according to latest syntax changes

 include/rule.h      |  4 +++
 src/evaluate.c      | 44 +++++++++++++++++++++++++
 src/parser.y        | 39 +++++++++++++++++-----
 src/rule.c          | 95 ++++++++++++++++++++++++++++++++++++++++++++---------
 src/scanner.l       |  6 ----
 tests/dictionary    |  2 +-
 tests/expr-ct       |  2 +-
 tests/expr-meta     |  2 +-
 tests/family-bridge |  2 +-
 tests/family-ipv4   |  2 +-
 tests/family-ipv6   |  2 +-
 tests/obj-chain     |  2 +-
 tests/payload-ll    |  2 +-
 tests/set           |  2 +-
 tests/stmt-log      |  2 +-
 tests/verdict-maps  |  2 +-
 16 files changed, 169 insertions(+), 41 deletions(-)

-- 
1.8.3.2

