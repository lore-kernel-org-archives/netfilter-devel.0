From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 21/24] libxt_recent: add missing --rsource,--rdest options to manpage
Date: Sun,  6 Apr 2008 17:27:18 +0200
Message-ID: <0d000f3de119b9d4586f885d1a8a6bbc71c93cbf.1207495183.git.jengelh@computergmbh.de>
References: <1207495642-21055-1-git-send-email-jengelh@computergmbh.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:56481 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752647AbYDFP11 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 6 Apr 2008 11:27:27 -0400
In-Reply-To: <1207495642-21055-1-git-send-email-jengelh@computergmbh.de>
In-Reply-To: <bd573e5e48763aa655cdb6e3f70a6f647c3868c7.1207495183.git.jengelh@computergmbh.de>
References: <bd573e5e48763aa655cdb6e3f70a6f647c3868c7.1207495183.git.jengelh@computergmbh.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

---
 extensions/libxt_recent.man |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/extensions/libxt_recent.man b/extensions/libxt_recent.man
index f0dc3f4..6b7fc86 100644
--- a/extensions/libxt_recent.man
+++ b/extensions/libxt_recent.man
@@ -14,6 +14,13 @@ This will add the source address of the packet to the list. If the source
 address is already in the list, this will update the existing entry. This will
 always return success (or failure if \fB!\fR is passed in).
 .TP
+\fB--rsource\fP
+Match/save the source address of each packet in the recent list table. This
+is the default.
+.TP
+\fB--rdest\fP
+Match/save the destination address of each packet in the recent list table.
+.TP
 [\fB!\fR] \fB--rcheck\fR
 Check if the source address of the packet is currently in the list.
 .TP
-- 
1.5.5.rc3

