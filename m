From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [nftables tool PATCH 0/5] Easier base chain declaration
Date: Wed, 28 Aug 2013 11:33:06 +0300
Message-ID: <1377678791-7616-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:15236 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752441Ab3H1IdQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 28 Aug 2013 04:33:16 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

So as proposed, patch 2 and 3 make hook more readable and add priority keyword.
patch 1 is a quick fix on base chain output (we should check the chain's flags, not it's hookunum).
and patch 4 is just to enforce the base chain type checking at input
patch 5 is uptading the tests set according to these syntax changes.

Tomasz Bursztyka (5):
  src: Fix base chain print out
  src: Wrap netfilter hooks around human readable strings
  syntax: Add priority keyword on base chain description
  src: Ensure given base chain type is a valid one
  tests: Update bate chain creation according to latest syntax changes

 include/rule.h      |  23 +++++++++++
 src/netlink.c       | 109 +++++++++++++++++++++++++++++++++++++++++++++++++---
 src/parser.y        |  37 ++++++++++++++----
 src/rule.c          |  51 +++++++++++++++++++-----
 src/scanner.l       |   6 ---
 tests/dictionary    |   2 +-
 tests/expr-ct       |   2 +-
 tests/expr-meta     |   2 +-
 tests/family-bridge |   2 +-
 tests/family-ipv4   |   2 +-
 tests/family-ipv6   |   2 +-
 tests/obj-chain     |   2 +-
 tests/payload-ll    |   2 +-
 tests/set           |   2 +-
 tests/stmt-log      |   2 +-
 tests/verdict-maps  |   2 +-
 16 files changed, 209 insertions(+), 39 deletions(-)

-- 
1.8.3.2

