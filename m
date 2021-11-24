Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 342D1C433EF
	for <netfilter-devel@archiver.kernel.org>; Wed, 24 Nov 2021 22:46:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352051AbhKXWtS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 24 Nov 2021 17:49:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352121AbhKXWtR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 Nov 2021 17:49:17 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3C7BC061574
        for <netfilter-devel@vger.kernel.org>; Wed, 24 Nov 2021 14:46:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=uN5cwDuVwhDH8mtj9OGQ5nsS1wkDnpUOigqeSVCswgA=; b=ox0QuRCIF+sve/IGes2r4THxgm
        7d5W0iIb4+8w8dP4ZiD2KmJrfK7otCjUB0DZLDyKxbZO0ojgo/efLlZREtcgC720wUBpK6WR5+c2y
        T0kNTqi1BEmueVtR3zdGOTPNblHiyWYsmWw4HHAUw1oMDcXQkuNA4jXV9N7mlqWLfBU/xJLmnRvs1
        muY4AqhxLSvVJj7Y/FB03ZwdKFEIFFmFiaZSU9piMtPsIdmoRMgNFYpNfyg6frsWUztBQh7a1hBHJ
        nW6827NmtWODm6W1TJ36At1uJDCvPAA9gcyfOy7UmbXsgyJKNt59tgCqFyz1C9M8iHKGrNlNnE7WA
        JoUVa60Q==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mq0hA-00563U-8K
        for netfilter-devel@vger.kernel.org; Wed, 24 Nov 2021 22:24:52 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH v3 25/30] output: JSON: fix output of GMT offset
Date:   Wed, 24 Nov 2021 22:24:32 +0000
Message-Id: <20211124222444.2597311-38-jeremy@azazel.net>
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

The compiler has two sets of complaints.  Firstly, `t->tm_gmtoffset` is
a `long int`, but it is being passed to `abs`, which leads to warnings
such as:

  ulogd_output_JSON.c:308:34: warning: absolute value function `abs` given an argument of type `long int` but has parameter of type `int` which may cause truncation of value

Secondly, it can't verify that the hour value derived from the offset
will in fact fit into `%02d`, thus:

  ulogd_output_JSON.c:306:37: warning: `%02d` directive output may be truncated writing between 2 and 6 bytes into a region of size 5

To remedy these, we now mod the offset by 86,400 and assign it to an `int`
before deriving the hour and minute values.

We also change the format-specifier for the hour value to `%+03d` which
causes a sign to be printed even if the value is positive, thus allowing
us not to specify the sign explicitly and to drop the `abs` call for the
hour value.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 output/ulogd_output_JSON.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/output/ulogd_output_JSON.c b/output/ulogd_output_JSON.c
index 6edfa902efaf..f5c065dd062a 100644
--- a/output/ulogd_output_JSON.c
+++ b/output/ulogd_output_JSON.c
@@ -302,11 +302,12 @@ static int json_interp(struct ulogd_pluginstance *upi)
 			now = time(NULL);
 		t = localtime_r(&now, &result);
 		if (unlikely(*opi->cached_tz = '\0' || t->tm_gmtoff != opi->cached_gmtoff)) {
+			int gmtoff   = t->tm_gmtoff % 86400;
+			int gmtoff_h = gmtoff / 3600;
+			int gmtoff_m = abs(gmtoff) / 60 % 60;
+
 			snprintf(opi->cached_tz, sizeof(opi->cached_tz),
-				 "%c%02d%02d",
-				 t->tm_gmtoff > 0 ? '+' : '-',
-				 abs(t->tm_gmtoff) / 60 / 60,
-				 abs(t->tm_gmtoff) / 60 % 60);
+				 "%+03d%02d", gmtoff_h, gmtoff_m);
 		}
 
 		if (pp_is_valid(inp, opi->usec_idx)) {
-- 
2.33.0

