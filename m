From: Patrick McHardy <kaber@trash.net>
Subject: linux/types.h: Use __u64 for aligned_u64
Date: Wed, 30 Jan 2008 21:16:57 +0100 (MET)
Message-ID: <20080130201654.29874.47799.sendpatchset@localhost.localdomain>
References: <20080130201650.29874.7456.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:60635 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932238AbYA3UQ6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jan 2008 15:16:58 -0500
In-Reply-To: <20080130201650.29874.7456.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

linux/types.h: Use __u64 for aligned_u64

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 6276f9ebe13419b94f58dd9ef713c1c56c74e4ca
tree 359d6748c8f98414b144ba3cac969c7bccc0f311
parent a2a8ddee99386b740ec6242b2a185617ba59edac
author Jan Engelhardt <jengelh@computergmbh.de> Tue, 29 Jan 2008 16:21:49 +0100
committer Patrick McHardy <kaber@trash.net> Wed, 30 Jan 2008 15:04:12 +0100

 include/linux/types.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/types.h b/include/linux/types.h
index f4f8d19..b94c0e4 100644
--- a/include/linux/types.h
+++ b/include/linux/types.h
@@ -126,7 +126,7 @@ typedef		__s64		int64_t;
 #endif
 
 /* this is a special 64bit data type that is 8-byte aligned */
-#define aligned_u64 unsigned long long __attribute__((aligned(8)))
+#define aligned_u64 __u64 __attribute__((aligned(8)))
 #define aligned_be64 __be64 __attribute__((aligned(8)))
 #define aligned_le64 __le64 __attribute__((aligned(8)))
 
