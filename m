From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD2 PATCH 2/2] Fix computation of allocated size for query.
Date: Wed,  9 Jul 2008 22:56:45 +0200
Message-ID: <1215637005-3102-3-git-send-email-eric@inl.fr>
References: <>
 <1215637005-3102-1-git-send-email-eric@inl.fr>
 <1215637005-3102-2-git-send-email-eric@inl.fr>
Cc: Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:44151 "EHLO ice-age"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756979AbYGIU4r (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Jul 2008 16:56:47 -0400
In-Reply-To: <1215637005-3102-2-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch fixes the computation of the allocation size for the query.
It was not taking into account the length of the name of the procedure.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 util/db.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/util/db.c b/util/db.c
index 3cfe057..5cf5fe1 100644
--- a/util/db.c
+++ b/util/db.c
@@ -54,7 +54,7 @@ static int disabled_interp_db(struct ulogd_pluginstance *upi)
 	return 0;
 }
 
-#define SQL_INSERTTEMPL   "insert into X (Y) values (Z)"
+#define SQL_INSERTTEMPL   "SELECT P(Y)"
 #define SQL_VALSIZE	100
 
 /* create the static part of our insert statement */
@@ -80,7 +80,8 @@ static int sql_createstmt(struct ulogd_pluginstance *upi)
 		/* we need space for the key and a comma, as well as
 		 * enough space for the values */
 		size += strlen(upi->input.keys[i].name) + 1 + SQL_VALSIZE;
-	}	
+	}
+	size += srtlen(procedure);
 
 	ulogd_log(ULOGD_DEBUG, "allocating %u bytes for statement\n", size);
 
-- 
1.5.5.1

