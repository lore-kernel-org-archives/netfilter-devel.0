Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51D7DC433EF
	for <netfilter-devel@archiver.kernel.org>; Tue, 30 Nov 2021 11:14:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231690AbhK3LSJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 30 Nov 2021 06:18:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234329AbhK3LSI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 30 Nov 2021 06:18:08 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 078DBC061574
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Nov 2021 03:14:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Fi1VGtKOWMHxLn0ZCrS2o9p9rHnh9GOI7NIN+chDxhs=; b=AhPGPA14R9nY89YPKyRX1t+sKg
        lR+4nI3fxxZpr1lQlSZNmi5pVoNZI+P1+CGTri7tyxbN2vyyh800I596fM6jjnJITGeC0khw1W+I3
        ehre9to5i8lcbbO4gqp3tIIBNApYeoh75IESYYAMeyz1FeH7bbspBArjfEoD+serE1grdV7chqwPH
        11L9mgjFl9C+w/w4RVsS1tf1YXsIX4Pvrtx6Z/3JGikFxWOTNZ5mOaTi3BvbH9Ldgf7qajLce/kOh
        qvAo6iilQLst6dJXuSaQI6PqRQVXg+5dqeLZFb+PrIOdCwZdHuC+Dm6JkunK0ZeT4BBY7rcjB4Qop
        nTpDZ9+A==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1ms0ns-00Awwr-5T
        for netfilter-devel@vger.kernel.org; Tue, 30 Nov 2021 10:56:04 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH v4 13/32] output: DBI: fix NUL-termination of escaped SQL string
Date:   Tue, 30 Nov 2021 10:55:41 +0000
Message-Id: <20211130105600.3103609-14-jeremy@azazel.net>
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

On error, `dbi_conn_quote_string_copy` returns zero.  In this case, we
need to set `*dst` to NUL.  Handle a return-value of `2` as normal
below.  `1` is never returned.

Replace `strncpy` with `memcpy`: using `strncpy` is nearly always a
mistake, and we don't need its special behaviour here.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 output/dbi/ulogd_output_DBI.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/output/dbi/ulogd_output_DBI.c b/output/dbi/ulogd_output_DBI.c
index fff9abc57ff6..57e3058036d9 100644
--- a/output/dbi/ulogd_output_DBI.c
+++ b/output/dbi/ulogd_output_DBI.c
@@ -236,18 +236,20 @@ static int escape_string_dbi(struct ulogd_pluginstance *upi,
 	}
 
 	ret = dbi_conn_quote_string_copy(pi->dbh, src, &newstr);
-	if (ret <= 2)
+	if (ret == 0) {
+		*dst = '\0';
 		return 0;
+	}
 
 	/* dbi_conn_quote_string_copy returns a quoted string,
 	 * but __interp_db already quotes the string
 	 * So we return a string without the quotes
 	 */
-	strncpy(dst,newstr+1,ret-2);
-	dst[ret-2] = '\0';
+	memcpy(dst, newstr + 1, ret - 2);
+	dst[ret - 2] = '\0';
 	free(newstr);
 
-	return (ret-2);
+	return ret - 2;
 }
 
 static int execute_dbi(struct ulogd_pluginstance *upi,
-- 
2.33.0

