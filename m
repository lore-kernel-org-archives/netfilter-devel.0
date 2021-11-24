Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EE1AC433EF
	for <netfilter-devel@archiver.kernel.org>; Wed, 24 Nov 2021 22:46:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351917AbhKXWtL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 24 Nov 2021 17:49:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245389AbhKXWtL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 Nov 2021 17:49:11 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37E91C061574
        for <netfilter-devel@vger.kernel.org>; Wed, 24 Nov 2021 14:46:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=i/7eo0aC604KhEgy+LmHmNmH1o92E1dkJzzhteUSgT4=; b=FhuJzPsk21/m26gjW0kXAdR/cD
        trEKVgTz2cqmy1r4+OAg+IJOA8x382aSQC0WnvF60d7AWeEDgY8qAz/pagjRnOsX3JbnTA7KDtdR0
        D+zfvEhoQKiS/20EYG1lKRKs1IVYboUaO7IY0lBLErGrx8hhqnQQokbXkQDVn6sY14b2/vAxxGcLx
        In8QrFsaoPRVTW/kn+49QrZTUyLrYiL9UVRvtBXN583XOC50rvNSWO+hHPXmn8HWJRE7VhiggzdpN
        vgEf3F7qmnfNw/WfeHDsrGQHaGm2De3ELHi14Y49sBAYSGC4wA/9lkbtyhCBJWEdStQK/MgqZHJxz
        zQmBKuvQ==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mq0h8-00563U-Ds
        for netfilter-devel@vger.kernel.org; Wed, 24 Nov 2021 22:24:50 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH v3 18/30] output: SQLITE3: improve formatting of insert statement
Date:   Wed, 24 Nov 2021 22:24:18 +0000
Message-Id: <20211124222444.2597311-24-jeremy@azazel.net>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211124222444.2597311-1-jeremy@azazel.net>
References: <20211124222444.2597311-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

`sqlite3_createstmt` contains a variable `stmt_pos` which points to the
end of the SQL already written, at which the next chunk should be
appended.  Hitherto, this was assigned after every write:

  sprintf(stmt_pos, ...);
  stmt_pos = priv->stmt + strlen(priv->stmt);

However, since `sprintf` returns the number of bytes written, we can avoid the
repeated `strlen` calls by incrementing `stmt_pos` by the return-value of
`sprintf`.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 output/sqlite3/ulogd_output_SQLITE3.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/output/sqlite3/ulogd_output_SQLITE3.c b/output/sqlite3/ulogd_output_SQLITE3.c
index 41aeeec27854..da1c09f08047 100644
--- a/output/sqlite3/ulogd_output_SQLITE3.c
+++ b/output/sqlite3/ulogd_output_SQLITE3.c
@@ -226,9 +226,9 @@ sqlite3_createstmt(struct ulogd_pluginstance *pi)
 		ulogd_log(ULOGD_ERROR, "SQLITE3: out of memory\n");
 		return -1;
 	}
+	stmt_pos = priv->stmt;
 
-	sprintf(priv->stmt, "insert into %s (", table_ce(pi));
-	stmt_pos = priv->stmt + strlen(priv->stmt);
+	stmt_pos += sprintf(stmt_pos, "insert into %s (", table_ce(pi));
 
 	tailq_for_each(f, priv->fields, link) {
 		strncpy(buf, f->name, ULOGD_MAX_KEYLEN);
@@ -236,19 +236,17 @@ sqlite3_createstmt(struct ulogd_pluginstance *pi)
 		while ((underscore = strchr(buf, '.')))
 			*underscore = '_';
 
-		sprintf(stmt_pos, "%s,", buf);
-		stmt_pos = priv->stmt + strlen(priv->stmt);
+		stmt_pos += sprintf(stmt_pos, "%s,", buf);
 
 		cols++;
 	}
 
 	*(stmt_pos - 1) = ')';
 
-	sprintf(stmt_pos, " values (");
-	stmt_pos = priv->stmt + strlen(priv->stmt);
+	stmt_pos += sprintf(stmt_pos, " values (");
 
 	for (i = 0; i < cols - 1; i++) {
-		sprintf(stmt_pos,"?,");
+		strcpy(stmt_pos, "?,");
 		stmt_pos += 2;
 	}
 
-- 
2.33.0

