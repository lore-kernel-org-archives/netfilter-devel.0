From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [nftables tool PATCH] INSTALL: Update dependency list and repository URLs
Date: Thu, 29 Aug 2013 09:18:39 +0300
Message-ID: <1377757119-3165-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:13045 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752777Ab3H2GTD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 29 Aug 2013 02:19:03 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 INSTALL | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/INSTALL b/INSTALL
index 1f51ed0..09f6cd4 100644
--- a/INSTALL
+++ b/INSTALL
@@ -6,7 +6,9 @@ Installation instructions for nftables
 
   - standard glibc headers, gcc etc.
 
-  - libnl including support for nftables: git://git.netfilter.org/libnl-nft.git
+  - libmnl: git://git.netfilter.org/libmnl
+
+  - libnftables: git://git.netfilter.org/libnftables
 
   - flex
 
@@ -52,8 +54,8 @@ Installation instructions for nftables
 
  The nftables kernel tree can be found at:
 
- git://git.kernel.org/pub/scm/linux/kernel/git/kaber/nft-2.6.git
+ git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nftables.git
 
  The latest version of this code can be found at:
 
- git://git.netfilter.org/nftables.git
+ git://git.netfilter.org/nftables
-- 
1.8.3.2

