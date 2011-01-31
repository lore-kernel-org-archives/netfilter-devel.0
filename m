From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 1/7] libxt_quota: clarifications on matching
Date: Mon, 31 Jan 2011 03:12:46 +0100
Message-ID: <1296439973-16089-2-git-send-email-jengelh@medozas.de>
References: <1296439973-16089-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:45265 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752122Ab1AaCM5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 30 Jan 2011 21:12:57 -0500
In-Reply-To: <1296439973-16089-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_quota.man |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/extensions/libxt_quota.man b/extensions/libxt_quota.man
index 8d9e18b..fbecf37 100644
--- a/extensions/libxt_quota.man
+++ b/extensions/libxt_quota.man
@@ -1,5 +1,7 @@
 Implements network quotas by decrementing a byte counter with each
-packet.
+packet. The condition matches until the byte counter reaches zero. Behavior
+is reversed with negation (i.e. the condition does not match until the
+byte counter reaches zero).
 .TP
 [\fB!\fP] \fB\-\-quota\fP \fIbytes\fP
 The quota in bytes.
-- 
1.7.1

