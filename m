From: Eric Leblond <eric@regit.org>
Subject: [PATCH 05/11] sqlite3: add sanity checking
Date: Fri, 10 May 2013 08:48:52 +0200
Message-ID: <1368168538-29780-6-git-send-email-eric@regit.org>
References: <1368168538-29780-1-git-send-email-eric@regit.org>
Cc: Eric Leblond <eric@regit.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:51459 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241Ab3EJGtZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 10 May 2013 02:49:25 -0400
In-Reply-To: <1368168538-29780-1-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Nullify sqlite3 handler at deinit.

Signed-off-by: Eric Leblond <eric@regit.org>
---
 output/sqlite3/ulogd_output_SQLITE3.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/output/sqlite3/ulogd_output_SQLITE3.c b/output/sqlite3/ulogd_output_SQLITE3.c
index f9f2462..5c49055 100644
--- a/output/sqlite3/ulogd_output_SQLITE3.c
+++ b/output/sqlite3/ulogd_output_SQLITE3.c
@@ -431,6 +431,8 @@ sqlite3_stop(struct ulogd_pluginstance *pi)
 
 	sqlite3_close(priv->dbh);
 
+	priv->dbh = NULL;
+
 	return 0;
 }
 
-- 
1.7.10.4

