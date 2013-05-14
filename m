From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [libnftables PATCH 0/7] Fixes and features
Date: Tue, 14 May 2013 13:51:15 +0300
Message-ID: <1368528682-10041-1-git-send-email-tomasz.bursztyka@linux.intel.com>
References: <519216B6.7060701@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:2739 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753284Ab3ENKvb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 14 May 2013 06:51:31 -0400
In-Reply-To: <519216B6.7060701@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

patch 1, 2, 3, 4, 5 and 7 are various trivial fixes.
patch 6 is meant for expression list handling in iptables-nftables tool

Tomasz Bursztyka (7):
  git: add a .gitignore file
  build: add an autogen.sh script
  rule: declare nft_rule_list structure at a proper place
  expr: remove inconsistent and non implemented function
  map: fix nft_rule_expr_build_payload export
  expr: add support for expr list and capability to add it into a rule
  chain: handle attribute is relevant if only there is no name to use

 .gitignore                 | 30 ++++++++++++++++++++++++++++++
 autogen.sh                 |  4 ++++
 include/libnftables/expr.h |  7 ++++++-
 include/libnftables/rule.h |  5 +++++
 src/chain.c                |  3 ++-
 src/expr.c                 | 45 +++++++++++++++++++++++++++++++++++++++++++++
 src/internal.h             |  4 ++++
 src/libnftables.map        |  6 ++++++
 src/rule.c                 | 12 ++++++++++++
 9 files changed, 114 insertions(+), 2 deletions(-)
 create mode 100644 .gitignore
 create mode 100755 autogen.sh

-- 
1.8.2.1

