From: Eric Leblond <eric@regit.org>
Subject: [Ulogd PATCH 3/4] sqlite3: add sanity checking
Date: Mon, 18 Mar 2013 01:01:23 +0100
Message-ID: <1363564884-5957-4-git-send-email-eric@regit.org>
References: <1363564884-5957-1-git-send-email-eric@regit.org>
Cc: eric@regit.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:44634 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932645Ab3CRABu (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 17 Mar 2013 20:01:50 -0400
In-Reply-To: <1363564884-5957-1-git-send-email-eric@regit.org>
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

