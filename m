Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19C83C433FE
	for <netfilter-devel@archiver.kernel.org>; Wed, 24 Nov 2021 22:45:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352035AbhKXWtH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 24 Nov 2021 17:49:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351917AbhKXWtH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 Nov 2021 17:49:07 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECFA5C061574
        for <netfilter-devel@vger.kernel.org>; Wed, 24 Nov 2021 14:45:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=CHFK3CZ7POuQ8FdeS1Jn8TEQtydjYrQg3d7bj0/mNc0=; b=Rn1WFS4neN0X10dl0lEwBQTnL/
        Gr2BCY4ItK4gfmljqPdDQj7s5XVxhUEqnJT3QudUlOGmaVwb8EGuHW4ypObiL2TnLBnx4nFPkg9SR
        51WslKSI3JFiVFjwaADvZKlMgsDoqnbZZA6Yf6GoeNXCWMGFinFCVYflRbHH9qTkdSS7acDe0hXj7
        FHCcTQTmm3Vu12BrRwcnlAR5Lkx8AqBNX7QiXvMwmIfabfCC8qYbyuuEkmmf5jGZiNB3eRstNawgu
        BNTVe/NOI8+qT7qteh2rUH8Sr4J7KgKc1PPSAJCoIGyyq0FXDV1NklvLZGP4TTMQLY5w74oTO58te
        IA7TdjCg==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mq0h7-00563U-Ip
        for netfilter-devel@vger.kernel.org; Wed, 24 Nov 2021 22:24:49 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH v3 14/30] output: MYSQL: improve mapping of DB columns to input-keys
Date:   Wed, 24 Nov 2021 22:24:10 +0000
Message-Id: <20211124222444.2597311-16-jeremy@azazel.net>
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

Hitherto, we copied the column-name to a buffer, iterated over it to
replace the underscores with full-stops, using `strchr` from the start
of the buffer on each iteration, then copied the buffer to the
input-key's `name` field.

Apart from the inefficiency, `strncpy` was used to do the copies, which
led gcc to complain:

  ulogd_output_MYSQL.c:149:17: warning: `strncpy` output may be truncated copying 31 bytes from a string of length 31

Furthermore, the buffer was not initialized, which meant that there was
also a possible buffer overrun if the column-name was too long, since
`strncpy` would not append a NUL.

Instead, we now copy the column-name directly to the input-key using
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

