From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 01/21] doc: clarify libxt_connlimit defaults
Date: Sun, 21 Aug 2011 13:09:16 +0200
Message-ID: <1313924977-8623-2-git-send-email-jengelh@medozas.de>
References: <1313924977-8623-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:38719 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754083Ab1HULJl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 21 Aug 2011 07:09:41 -0400
In-Reply-To: <1313924977-8623-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_connlimit.man |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/extensions/libxt_connlimit.man b/extensions/libxt_connlimit.man
index bd369a6..ad9f40f 100644
--- a/extensions/libxt_connlimit.man
+++ b/extensions/libxt_connlimit.man
@@ -13,7 +13,8 @@ Group hosts using the prefix length. For IPv4, this must be a number between
 maximum prefix length for the applicable protocol is used.
 .TP
 \fB\-\-connlimit\-saddr\fP
-Apply the limit onto the source group.
+Apply the limit onto the source group. This is the default if
+\-\-connlimit\-daddr is not specified.
 .TP
 \fB\-\-connlimit\-daddr\fP
 Apply the limit onto the destination group.
-- 
1.7.3.4

