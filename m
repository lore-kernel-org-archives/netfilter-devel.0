From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 6/6] nlmsg: remove unused function
Date: Tue, 16 Nov 2010 12:43:33 +0100
Message-ID: <1289907814-32706-7-git-send-email-jengelh@medozas.de>
References: <1289907814-32706-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:47740 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933630Ab0KPLnm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Nov 2010 06:43:42 -0500
In-Reply-To: <1289907814-32706-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

With the new CFLAGS, a notification pops up:

nlmsg.c:64:8: warning: no previous prototype for "mnl_nlmsg_aligned_size"

Marking it thus as static reveals it can be removed.

nlmsg.c:64:15: warning: "mnl_nlmsg_aligned_size" defined but not used

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 src/nlmsg.c |   12 ------------
 1 files changed, 0 insertions(+), 12 deletions(-)

diff --git a/src/nlmsg.c b/src/nlmsg.c
index e09e46a..de2e8e0 100644
--- a/src/nlmsg.c
+++ b/src/nlmsg.c
@@ -56,18 +56,6 @@ EXPORT_SYMBOL size_t mnl_nlmsg_size(size_t len)
 }
 
 /**
- * mnl_nlmsg_aligned_size - calculate the aligned size of Netlink messages
- * \param len length of the Netlink payload
- *
- * This function returns the size of a netlink message (header plus payload)
- * with alignment.
- */
-size_t mnl_nlmsg_aligned_size(size_t len)
-{
-	return MNL_ALIGN(mnl_nlmsg_size(len));
-}
-
-/**
  * mnl_nlmsg_get_payload_len - get the length of the Netlink payload
  * \param nlh pointer to the header of the Netlink message
  *
-- 
1.7.1

