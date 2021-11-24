Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53573C433EF
	for <netfilter-devel@archiver.kernel.org>; Wed, 24 Nov 2021 22:45:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243822AbhKXWs5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 24 Nov 2021 17:48:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245389AbhKXWs5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 Nov 2021 17:48:57 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 211E5C061574
        for <netfilter-devel@vger.kernel.org>; Wed, 24 Nov 2021 14:45:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=1VpApnz9g4f87qFdjIovcLRoOamQFNZJt9o/E64jh7k=; b=eKD9UlDeLMuCU3qNL8GljXUq0S
        V0zRA+AEntDLMcNV8BYqxgSf46vjBeVzjSROtPZDidO2ENbFZxYMULC+XVtCZ8zCiTxIrZo/h+WON
        MtDayoZExtYIrNYp7KFHPcxGLW/bNcYJpVGQqG/a4NuOVagOrge/P29fMRQPfd2Fa3Q69DgUSYMRB
        rao+Zmu2tXCPmRCHtXFkbpdMQtU7/YjgZWz7GFlmeoPxd8BHVkWf3T+owH/1UA9ZsVOwKTVg8A3W6
        My0jgnrdCT2NNMGFmV9L+VOSBZtDTZqkEgiKJt5sM5uGXiReTEiJcGUqEcLbpz4XvSVX7cmgvQLUn
        BicyVDeQ==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mq0h7-00563U-Aj
        for netfilter-devel@vger.kernel.org; Wed, 24 Nov 2021 22:24:49 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH v3 12/32] output: DBI: improve mapping of DB columns to input-keys
Date:   Wed, 24 Nov 2021 22:24:07 +0000
Message-Id: <20211124222444.2597311-13-jeremy@azazel.net>
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

