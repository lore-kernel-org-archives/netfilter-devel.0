From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD2 PATCH 10/11] Make gcc happy.
Date: Sun, 27 Jul 2008 15:51:25 +0200
Message-ID: <1217166686-28508-11-git-send-email-eric@inl.fr>
References: <20080723162746.GB31572@bayen.regit.org>
Cc: Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:43807 "EHLO ice-age"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751949AbYG0Nv3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 27 Jul 2008 09:51:29 -0400
In-Reply-To: <20080723162746.GB31572@bayen.regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Fix gcc warning related to the lack of parenthesis.

Signed-off-by: Eric Leblond <eric@inl.fr>
---
 output/mysql/ulogd_output_MYSQL.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/output/mysql/ulogd_output_MYSQL.c b/output/mysql/ulogd_output_MYSQL.c
index 562424b..94c8c9a 100644
--- a/output/mysql/ulogd_output_MYSQL.c
+++ b/output/mysql/ulogd_output_MYSQL.c
@@ -140,7 +140,7 @@ static int get_columns_mysql(struct ulogd_pluginstance *upi)
 	memset(upi->input.keys, 0, sizeof(struct ulogd_key) *
 						upi->input.num_keys);
 
-	for (i = 0; field = mysql_fetch_field(result); i++) {
+	for (i = 0; (field = mysql_fetch_field(result)); i++) {
 		char buf[ULOGD_MAX_KEYLEN+1];
 		char *underscore;
 
-- 
1.5.4.3

