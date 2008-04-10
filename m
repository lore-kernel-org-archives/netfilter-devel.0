From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 08/13] libxt_recent: add missing --rsource,--rdest options to manpage
Date: Thu, 10 Apr 2008 09:38:13 +0200
Message-ID: <9b429754df0c569caf924eb94b4b14069a65fc21.1207813085.git.jengelh@computergmbh.de>
References: <f8e3139e003f45acd60f10a40644de0ad1eefaec.1207813085.git.jengelh@computergmbh.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:50181 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754361AbYDJHiV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 10 Apr 2008 03:38:21 -0400
In-Reply-To: <f8e3139e003f45acd60f10a40644de0ad1eefaec.1207813085.git.jengelh@computergmbh.de>
In-Reply-To: <f8e3139e003f45acd60f10a40644de0ad1eefaec.1207813085.git.jengelh@computergmbh.de>
References: <f8e3139e003f45acd60f10a40644de0ad1eefaec.1207813085.git.jengelh@computergmbh.de>
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

