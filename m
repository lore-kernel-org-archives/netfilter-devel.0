From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 6/7] extensions/libxt_recent.t: add test case for 3.19 regression
Date: Thu, 19 Feb 2015 14:11:22 +0100
Message-ID: <1424351483-27617-7-git-send-email-fw@strlen.de>
References: <1424351483-27617-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:58482 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753266AbbBSNLs (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Feb 2015 08:11:48 -0500
In-Reply-To: <1424351483-27617-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

fail with vanilla 3.19.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 extensions/libxt_recent.t | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/extensions/libxt_recent.t b/extensions/libxt_recent.t
index cb4049f..8165c02 100644
--- a/extensions/libxt_recent.t
+++ b/extensions/libxt_recent.t
@@ -5,3 +5,7 @@
 -m recent --update --rttl;=;OK
 -m recent --set --rttl;=;FAIL
 -m recent --rcheck --hitcount 999 --name foo --mask 255.255.255.255 --rsource;=;FAIL
+# nonsensical, but all should load successfully:
+-m recent --rcheck --hitcount 3 --name foo --mask 255.255.255.255 --rsource -m recent --rcheck --hitcount 4 --name foo --mask 255.255.255.255 --rsource;=;OK
+-m recent --rcheck --hitcount 4 --name foo --mask 255.255.255.255 --rsource -m recent --rcheck --hitcount 4 --name foo --mask 255.255.255.255 --rsource;=;OK
+-m recent --rcheck --hitcount 8 --name foo --mask 255.255.255.255 --rsource -m recent --rcheck --hitcount 12 --name foo --mask 255.255.255.255 --rsource;=;OK
-- 
2.0.5

