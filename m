From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 1/5] libxt_tcp: fix a manpage syntax typo
Date: Thu, 11 Jun 2009 13:11:18 +0200
Message-ID: <1244718682-2497-2-git-send-email-jengelh@medozas.de>
References: <1244718682-2497-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:38294 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762897AbZFKLLX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Jun 2009 07:11:23 -0400
In-Reply-To: <1244718682-2497-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Frank Tobin <ftobin+netfilter@neverending.org>

Reference: http://bugzilla.netfilter.org/show_bug.cgi?id=596
Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_tcp.man |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/extensions/libxt_tcp.man b/extensions/libxt_tcp.man
index 8f39cdb..0a99cdf 100644
--- a/extensions/libxt_tcp.man
+++ b/extensions/libxt_tcp.man
@@ -12,7 +12,7 @@ The flag
 \fB\-\-sport\fP
 is a convenient alias for this option.
 .TP
-[\fB!\fP] \fB\-\-destination\-port\fP,\fB\-\-dport\fP \fIport\fP[\fB,\fP\fIport\fP]
+[\fB!\fP] \fB\-\-destination\-port\fP,\fB\-\-dport\fP \fIport\fP[\fB:\fP\fIport\fP]
 Destination port or port range specification.  The flag
 \fB\-\-dport\fP
 is a convenient alias for this option.
-- 
1.6.3.1

