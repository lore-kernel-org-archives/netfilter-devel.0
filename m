From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [PATCH 0/4] [nftables] Various compilation error fixes
Date: Thu,  2 Aug 2012 13:31:31 +0300
Message-ID: <1343903495-14486-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:51950 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750822Ab2HBKbi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 2 Aug 2012 06:31:38 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

Here are 4 patches fixing build issues, on gcc-4.7
(though the 2 first issues could be found on earlier version of gcc)

Please review,

Tomasz Bursztyka (4):
  netlink: Use the right datatype for verdict
  evaluate: Remove useless variable in expr_evaluate_bitwise()
  erec: Handle returned value properly in erec_print
  expression: Differentiate expr among anonymous structures in struct
    expr

 include/expression.h      |    4 ++--
 src/erec.c                |    7 ++++---
 src/evaluate.c            |   23 +++++++++++------------
 src/expression.c          |   20 ++++++++++----------
 src/netlink.c             |    2 +-
 src/netlink_delinearize.c |    2 +-
 src/netlink_linearize.c   |    2 +-
 src/segtree.c             |    4 ++--
 8 files changed, 32 insertions(+), 32 deletions(-)

-- 
1.7.8.6

