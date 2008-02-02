From: Eric Leblond <eric@inl.fr>
Subject: [PATCH 27/34]  Free insertion function result (mysql)
Date: Sat,  2 Feb 2008 22:24:22 +0100
Message-ID: <12019874711816-git-send-email-eric@inl.fr>
References: <1201987469575-git-send-email-eric@inl.fr>
 <1201987469368-git-send-email-eric@inl.fr>
 <12019874692227-git-send-email-eric@inl.fr>
 <12019874701613-git-send-email-eric@inl.fr>
 <12019874702005-git-send-email-eric@inl.fr>
 <12019874703998-git-send-email-eric@inl.fr>
 <12019874701589-git-send-email-eric@inl.fr>
 <12019874701366-git-send-email-eric@inl.fr>
 <12019874704144-git-send-email-eric@inl.fr>
 <12019874703136-git-send-email-eric@inl.fr>
 <12019874701552-git-send-email-eric@inl.fr>
 <12019874701370-git-send-email-eric@inl.fr>
 <12019874702349-git-send-email-eric@inl.fr>
 <12019874703504-git-send-email-eric@inl.fr>
 <12019874704067-git-send-email-eric@inl.fr>
 <12019874703897-git-send-email-eric@inl.fr>
 <12019874712066-git-send-email-eric@inl.fr>
 <1201987471474-git-send-email-eric@inl.fr>
 <1201987471346-git-send-email-eric@inl.fr>
 <12019874712309-git-send-email-eric@inl.fr>
 <12019874714080-git-send-email-eric@inl.fr>
 <12019874712041-git-send-email-eric@inl.fr>
 <12019874711938-git-send-email-eric@inl.fr>
 <1201987471531-git-send-email-eric@inl.fr>
 <12019874713790-git-send-email-eric@inl.fr>
 <12019874712753-git-send-email-eric@inl.fr>
 <12019874713782-git-send-email-eric@inl.fr>
Cc: Pierre Chifflier <chifflier@inl.fr>, Eric leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:46009 "EHLO localhost"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761901AbYBBWOz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 2 Feb 2008 17:14:55 -0500
In-Reply-To: <12019874713782-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pierre Chifflier <chifflier@inl.fr>

Change from procedure to function in mysql schema adds the need to free MySQL
result after request.

Signed-off-by: Pierre Chifflier <chifflier@inl.fr>
Signed-off-by: Eric leblond <eric@inl.fr>
---
:100644 100644 800d79d... fd650bf... M	output/mysql/ulogd_output_MYSQL.c
 output/mysql/ulogd_output_MYSQL.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/output/mysql/ulogd_output_MYSQL.c b/output/mysql/ulogd_output_MYSQL.c
index 800d79d..fd650bf 100644
--- a/output/mysql/ulogd_output_MYSQL.c
+++ b/output/mysql/ulogd_output_MYSQL.c
@@ -231,6 +231,7 @@ static int execute_mysql(struct ulogd_pluginstance *upi,
 {
 	struct mysql_instance *mi = (struct mysql_instance *) upi->private;
 	int ret;
+	MYSQL_RES * result;
 
 	ret = mysql_real_query(mi->dbh, stmt, len);
 	if (ret) {
@@ -238,6 +239,10 @@ static int execute_mysql(struct ulogd_pluginstance *upi,
 			  mysql_error(mi->dbh));
 		return -1;
 	}
+	result = mysql_use_result(mi->dbh);
+	if (result) {
+		mysql_free_result(result);
+	}
 
 	return 0;
 }
-- 
1.5.2.5

