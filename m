From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH] netfilter: xtables: remove duplicate member
Date: Thu, 20 Jan 2011 14:14:04 +0100
Message-ID: <1295529245-21127-2-git-send-email-jengelh@medozas.de>
References: <1295529245-21127-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org, jan.rovner@diadema.cz
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:58181 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755565Ab1ATNOK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 20 Jan 2011 08:14:10 -0500
In-Reply-To: <1295529245-21127-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Accidentally missed removing the old out-of-union "inverse" member,
which caused the struct size to change which then gives size mismatch
warnings when using an old iptables.

It is interesting to see that gcc did not warn about this before.
(Filed http://gcc.gnu.org/bugzilla/show_bug.cgi?id=47376 )

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/linux/netfilter/xt_connlimit.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/netfilter/xt_connlimit.h b/include/linux/netfilter/xt_connlimit.h
index 8884efc..ab1d3b5 100644
--- a/include/linux/netfilter/xt_connlimit.h
+++ b/include/linux/netfilter/xt_connlimit.h
@@ -18,7 +18,7 @@ struct xt_connlimit_info {
 		};
 #endif
 	};
-	unsigned int limit, inverse;
+	unsigned int limit;
 	union {
 		/* revision 0 */
 		unsigned int inverse;
-- 
1.7.1

