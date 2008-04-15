From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 10/10] libxt_recent: add missing --rsource,--rdest options to manpage
Date: Tue, 15 Apr 2008 12:33:28 +0200
Message-ID: <a9299b704dc86cfc2cf98c141a8a92f101e5d5d4.1208255176.git.jengelh@computergmbh.de>
References: <1208255608-8044-1-git-send-email-jengelh@computergmbh.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:34605 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755575AbYDOKda (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Apr 2008 06:33:30 -0400
In-Reply-To: <1208255608-8044-1-git-send-email-jengelh@computergmbh.de>
In-Reply-To: <0e1521015bea15f495f191fa5534eb65ad9bd43f.1208255176.git.jengelh@computergmbh.de>
References: <0e1521015bea15f495f191fa5534eb65ad9bd43f.1208255176.git.jengelh@computergmbh.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

---
 extensions/libxt_recent.man |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/extensions/libxt_recent.man b/extensions/libxt_recent.man
index 25be677..f752577 100644
--- a/extensions/libxt_recent.man
+++ b/extensions/libxt_recent.man
@@ -15,6 +15,13 @@ source address is already in the list, this will update the existing
 entry. This will always return success (or failure if `!' is passed
 in).
 .TP
+\fB--rsource\fP
+Match/save the source address of each packet in the recent list table. This
+is the default.
+.TP
+\fB--rdest\fP
+Match/save the destination address of each packet in the recent list table.
+.TP
 [\fB!\fR] \fB--rcheck\fR
 Check if the source address of the packet is currently in
 the list.
-- 
1.5.5.rc3

