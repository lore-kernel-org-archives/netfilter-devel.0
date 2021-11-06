Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 999EEC433EF
	for <netfilter-devel@archiver.kernel.org>; Sat,  6 Nov 2021 17:15:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8077F61361
	for <netfilter-devel@archiver.kernel.org>; Sat,  6 Nov 2021 17:15:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234669AbhKFRRx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 6 Nov 2021 13:17:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234665AbhKFRRw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 6 Nov 2021 13:17:52 -0400
Received: from kadath.azazel.net (kadath.azazel.net [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E6B5C061570
        for <netfilter-devel@vger.kernel.org>; Sat,  6 Nov 2021 10:15:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=An35OZztWQ8E5cfOE34E9MFys0c7CYVIuG4W353XS6E=; b=uDfjE5Uxzi81pZGDjeHRJ/fTD9
        AR4VUyMDbpMtxMyT1FChl4Fi0zjIzCxvrr+q4dZ1JwymMghXNu2LhKRztsDRc1Gbq/zEC8LUtHNHF
        rZVBLb57f+ebFQPTo7DOPpZCZXgSUFEycl82+paSL0EL+JnfOKeMvzmhbEoffkkybRRhL9w0kISKr
        zBtdHpmNmJzuiYZ299Wj9F1FZkVgSzZgPe/jcVXq5gVUtUD5WgNdLI8EKvInCDd3hzwpfSeqcjdU6
        3qWbhhaYLOdLjMDESTM7dZrnLIVXKAaHnQ8n6cTUKuM//QwihGDTJTrGmY2jYx4gBO4f3XSlFB+G4
        Nl8cf3nw==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mjOtK-004m1E-Mg
        for netfilter-devel@vger.kernel.org; Sat, 06 Nov 2021 16:50:06 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH v2 18/27] output: MYSQL: Fix string truncation warning
Date:   Sat,  6 Nov 2021 16:49:44 +0000
Message-Id: <20211106164953.130024-19-jeremy@azazel.net>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211106164953.130024-1-jeremy@azazel.net>
References: <20211106164953.130024-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Replace `strncpy` with `snprintf`.

Remove superfluous intermediate buffer.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 output/mysql/ulogd_output_MYSQL.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/output/mysql/ulogd_output_MYSQL.c b/output/mysql/ulogd_output_MYSQL.c
index 66151feb4939..946498d4d2fe 100644
--- a/output/mysql/ulogd_output_MYSQL.c
+++ b/output/mysql/ulogd_output_MYSQL.c
@@ -135,18 +135,17 @@ static int get_columns_mysql(struct ulogd_pluginstance *upi)
 	}
 
 	for (i = 0; (field = mysql_fetch_field(result)); i++) {
-		char buf[ULOGD_MAX_KEYLEN+1];
 		char *underscore;
 
+		snprintf(upi->input.keys[i].name,
+			 sizeof(upi->input.keys[i].name),
+			 "%s", field->name);
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

