From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD2 PATCH 4/4] Fix typo in function name.
Date: Wed, 23 Jul 2008 13:33:55 +0200
Message-ID: <1216812835-9851-5-git-send-email-eric@inl.fr>
Cc: Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:43429 "EHLO ice-age"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751542AbYGWLd5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 23 Jul 2008 07:33:57 -0400
In-Reply-To: <>
References: <>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch fixes a trivial typo.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 util/db.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/util/db.c b/util/db.c
index 5cf5fe1..946458a 100644
--- a/util/db.c
+++ b/util/db.c
@@ -81,7 +81,7 @@ static int sql_createstmt(struct ulogd_pluginstance *upi)
 		 * enough space for the values */
 		size += strlen(upi->input.keys[i].name) + 1 + SQL_VALSIZE;
 	}
-	size += srtlen(procedure);
+	size += strlen(procedure);
 
 	ulogd_log(ULOGD_DEBUG, "allocating %u bytes for statement\n", size);
 
-- 
1.5.4.3

