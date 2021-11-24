Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D051FC433FE
	for <netfilter-devel@archiver.kernel.org>; Wed, 24 Nov 2021 22:45:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348982AbhKXWsv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 24 Nov 2021 17:48:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243822AbhKXWsv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 Nov 2021 17:48:51 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8384C061574
        for <netfilter-devel@vger.kernel.org>; Wed, 24 Nov 2021 14:45:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=2/d6kpBXtZYTowDxvc+tgm14/7VVksAz7H7+Titifd4=; b=DfY5YW9g93CalUjYSN9rXzST95
        CM9CcPIg1WF0eWqrCh4uxtsss6PsrqtkEmKkqnC/vhAcKf7jxLVKBUVjqQ++PeaowYIQiiHm3v0HF
        f2sNpHJCkeRnoRquF8Aq2C7cFupLffva22+eTatTie7gqcRfp75NsDt4iFb5jikWTXkdUnufjBBje
        qQnW+sms2b1Ipukq76ve0td81jq9ADNWriaNw0c6xKOewc2pW4W0u6EwAaoYTO2pZFC1HGRfMpFfZ
        SXiSQ0XcufrqLbopuLo0j8ZIcIGxYufUWwwxdngN14q2LT5sR7Oz8WgbA12t8gALoECqeyVns32JR
        knFfWgDg==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mq0h7-00563U-Nb
        for netfilter-devel@vger.kernel.org; Wed, 24 Nov 2021 22:24:49 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH v3 15/32] output: MYSQL: improve mapping of DB columns to input-keys
Date:   Wed, 24 Nov 2021 22:24:11 +0000
Message-Id: <20211124222444.2597311-17-jeremy@azazel.net>
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

Currently, we copy the column-name to a buffer, iterate over it to
replace the underscores with full-stops, using `strchr` from the start
of the buffer on each iteration, then copy the buffer to the input-key's
`name` member.

Apart from the inefficiency, `strncpy` is used to do the copies, which
leads gcc to complain:

  ulogd_output_MYSQL.c:149:17: warning: `strncpy` output may be truncated copying 31 bytes from a string of length 31

Furthermore, the buffer is not initialized, which means that there is
also a possible buffer overrun if the column-name is too long, since
`strncpy` will not append a NUL.

Instead, copy the column-name directly to the input-key using
`snprintf`, and run `strchr` from the last underscore on each iteration.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 output/mysql/ulogd_output_MYSQL.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/output/mysql/ulogd_output_MYSQL.c b/output/mysql/ulogd_output_MYSQL.c
index 66151feb4939..9727e303f2c5 100644
--- a/output/mysql/ulogd_output_MYSQL.c
+++ b/output/mysql/ulogd_output_MYSQL.c
@@ -135,18 +135,18 @@ static int get_columns_mysql(struct ulogd_pluginstance *upi)
 	}
 
 	for (i = 0; (field = mysql_fetch_field(result)); i++) {
-		char buf[ULOGD_MAX_KEYLEN+1];
 		char *underscore;
 
+		snprintf(upi->input.keys[i].name,
+			 sizeof(upi->input.keys[i].name),
+			 "%s", field->name);
+
 		/* replace all underscores with dots */
-		strncpy(buf, field->name, ULOGD_MAX_KEYLEN);
-		while ((underscore = strchr(buf, '_')))
+		for (underscore = upi->input.keys[i].name;
+		     (underscore = strchr(underscore, '_')); )
 			*underscore = '.';
 
-		DEBUGP("field '%s' found\n", buf);
-
-		/* add it to list of input keys */
-		strncpy(upi->input.keys[i].name, buf, ULOGD_MAX_KEYLEN);
+		DEBUGP("field '%s' found\n", upi->input.keys[i].name);
 	}
 	/* MySQL Auto increment ... ID :) */
 	upi->input.keys[0].flags |= ULOGD_KEYF_INACTIVE;
-- 
2.33.0

