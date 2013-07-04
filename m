From: Alexey Perevalov <a.perevalov@samsung.com>
Subject: [PATCH 1/2] Clarify DEBUG usage macro
Date: Thu, 04 Jul 2013 11:26:17 +0400
Message-ID: <1372922778-12997-2-git-send-email-a.perevalov@samsung.com>
References: <1372922778-12997-1-git-send-email-a.perevalov@samsung.com>
Cc: Alexey Perevalov <a.perevalov@samsung.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:63510 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755041Ab3GDH0g (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 4 Jul 2013 03:26:36 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MPE00108HZHBJB0@mailout3.w1.samsung.com> for
 netfilter-devel@vger.kernel.org; Thu, 04 Jul 2013 08:26:35 +0100 (BST)
In-reply-to: <1372922778-12997-1-git-send-email-a.perevalov@samsung.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Alexey Perevalov <a.perevalov@samsung.com>
---
 INSTALL |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/INSTALL b/INSTALL
index e17e844..d62b428 100644
--- a/INSTALL
+++ b/INSTALL
@@ -70,6 +70,8 @@ If you want to enable debugging, use
 (-O0 is used to turn off instruction reordering, which makes debugging
 much easier.)
 
+To show debug traces you can add -DDEBUG to CFLAGS option
+
 
 Other notes
 ===========
-- 
1.7.9.5

