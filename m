From: Varsha Rao <rvarsha016@gmail.com>
Subject: [PATCH nft] man: Fix typo.
Date: Sun,  6 Aug 2017 16:44:21 +0530
Message-ID: <20170806111421.5754-1-rvarsha016@gmail.com>
Cc: Varsha Rao <rvarsha016@gmail.com>
To: pablo@netfilter.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:38247 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751263AbdHFLOi (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 6 Aug 2017 07:14:38 -0400
Received: by mail-pg0-f67.google.com with SMTP id 123so6107905pga.5
        for <netfilter-devel@vger.kernel.org>; Sun, 06 Aug 2017 04:14:38 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The word 'occur' is misspelled as 'ocurr'. This patch fixes it.

Signed-off-by: Varsha Rao <rvarsha016@gmail.com>
---
 doc/nft.xml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/doc/nft.xml b/doc/nft.xml
index 4d03a3d..8ffa5b3 100644
--- a/doc/nft.xml
+++ b/doc/nft.xml
@@ -4381,7 +4381,7 @@ add rule nat prerouting tcp dport 22 redirect to :2222
 			<para>
 				The monitor command allows you to listen to Netlink events produced
 				by the nf_tables subsystem, related to creation and deletion of objects.
-				When they ocurr, nft will print to stdout the monitored events in either
+				When they occur, nft will print to stdout the monitored events in either
 				XML, JSON or native nft format.
 			</para>
 			<para>
-- 
2.13.3

