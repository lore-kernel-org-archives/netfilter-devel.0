From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [iptables (nft-compat) PATCH 0/5] Various fixes version 2
Date: Tue, 11 Feb 2014 18:36:41 +0200
Message-ID: <1392136606-10339-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:62651 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752153AbaBKQg5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 11 Feb 2014 11:36:57 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patch 1 and 2 are a resent of previous patchset.
(patch 1 is quite useful actually, at leats it was for testing patch 3)
(patch 2 is a bug fix)

Patch 3 is the full rewrite of patch 8 it previous patchset.
Much smaller, and works in all case with xtables-restore with or without --table option.

Patch 4 is applying the idea to get rid of useless error message (which clearly did not help at all).

Patch 5 is a debug message fix.

Tomasz Bursztyka (5):
  nft: Add useful debug output when a builtin table is created
  nft: A builtin chain might be created when restoring
  nft: Initialize a table only once
  nft: Remove useless error message
  nft: Pass a line after printing out a debug message

 iptables/nft.c             | 66 ++++++++++++++++++----------------------------
 iptables/nft.h             |  2 ++
 iptables/xtables-restore.c |  1 +
 3 files changed, 28 insertions(+), 41 deletions(-)

-- 
1.8.3.2

