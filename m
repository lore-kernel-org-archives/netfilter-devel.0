Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E733C433FE
	for <netfilter-devel@archiver.kernel.org>; Tue, 30 Nov 2021 11:15:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236839AbhK3LS3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 30 Nov 2021 06:18:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235176AbhK3LS3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 30 Nov 2021 06:18:29 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 729EDC061574
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Nov 2021 03:15:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=1VpApnz9g4f87qFdjIovcLRoOamQFNZJt9o/E64jh7k=; b=LKcN4YeAYJ/4jiDYFljE8wvp8j
        Y6+6LZLcd6V06zMg2u+3Qj4jASWtdoGAgCEqFAahjtwpKt76xlb3cnxeOYxzxiwrJbVP/TpLeXz5R
        XsDTYvdOy/1M9QhxXNPUpNbm8x1Wr97d8qtVXtoWht9iEBZnxPyK/KzsR9aLkoTYc2hZGDeYEXG6O
        dUqCGQx68z9fkh4BI2V9g/GU8PF21qT4KdmJZD0A1q95OTdjgPFQ7yOHN+633GjikRWKc06DA9+Yn
        6/vDMnILBRAM8A6pYb7UJVI4M7qn7HONu7c4/ua2TqxyOiR/pXaULkNSZ6kLNRMFDIkC/YLT6rrd3
        J/Kg8S3g==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1ms0ns-00Awwr-2V
        for netfilter-devel@vger.kernel.org; Tue, 30 Nov 2021 10:56:04 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH v4 12/32] output: DBI: improve mapping of DB columns to input-keys
Date:   Tue, 30 Nov 2021 10:55:40 +0000
Message-Id: <20211130105600.3103609-13-jeremy@azazel.net>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211130105600.3103609-1-jeremy@azazel.net>
References: <20211130105600.3103609-1-jeremy@azazel.net>
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
of the buffer on each iteration, iterate over it a second time to
lower-case all letters, and finally copy the buffer to the input-key's
`name` member.

In addition to being inefficient, `strncpy` is used to do the copies,
which leads gcc to complain:

  ulogd_output_DBI.c:160:17: warning: `strncpy` output may be truncated copying 31 bytes from a string of length 31

Furthermore, the buffer is not initialized, which means that there is
also a possible buffer overrun if the column-name is too long, since
`strncpy` will not append a NUL.

Instead, copy the column-name directly to the input-key using
`snprintf`, and then iterate over it once to replace underscores and
lower-case letters.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 output/dbi/ulogd_output_DBI.c | 34 +++++++++++++---------------------
 1 file changed, 13 insertions(+), 21 deletions(-)

diff --git a/output/dbi/ulogd_output_DBI.c b/output/dbi/ulogd_output_DBI.c
index b4a5bacd156f..fff9abc57ff6 100644
--- a/output/dbi/ulogd_output_DBI.c
+++ b/output/dbi/ulogd_output_DBI.c
@@ -91,15 +91,6 @@ static struct config_keyset dbi_kset = {
 #define dbtype_ce(x)	(x->ces[DB_CE_NUM+6])
 
 
-/* lower-cases s in place */
-static void str_tolower(char *s)
-{
-	while(*s) {
-		*s = tolower(*s);
-		s++;
-	}
-}
-
 /* find out which columns the table has */
 static int get_columns_dbi(struct ulogd_pluginstance *upi)
 {
@@ -140,24 +131,25 @@ static int get_columns_dbi(struct ulogd_pluginstance *upi)
 	}
 
 	for (ui=1; ui<=upi->input.num_keys; ui++) {
-		char buf[ULOGD_MAX_KEYLEN+1];
-		char *underscore;
-		const char* field_name = dbi_result_get_field_name(pi->result, ui);
+		const char *field_name = dbi_result_get_field_name(pi->result, ui);
+		char *cp;
 
 		if (!field_name)
 			break;
 
-		/* replace all underscores with dots */
-		strncpy(buf, field_name, ULOGD_MAX_KEYLEN);
-		while ((underscore = strchr(buf, '_')))
-			*underscore = '.';
-
-		str_tolower(buf);
+		snprintf(upi->input.keys[ui - 1].name,
+			 sizeof(upi->input.keys[ui - 1].name),
+			 "%s", field_name);
 
-		DEBUGP("field '%s' found: ", buf);
+		/* down-case and replace all underscores with dots */
+		for (cp = upi->input.keys[ui - 1].name; *cp; cp++) {
+			if (*cp == '_')
+				*cp = '.';
+			else
+				*cp = tolower(*cp);
+		}
 
-		/* add it to list of input keys */
-		strncpy(upi->input.keys[ui-1].name, buf, ULOGD_MAX_KEYLEN);
+		DEBUGP("field '%s' found: ", upi->input.keys[ui - 1].name);
 	}
 
 	/* ID is a sequence */
-- 
2.33.0

