Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EAA0C433EF
	for <netfilter-devel@archiver.kernel.org>; Sat, 30 Oct 2021 17:10:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0FD3060F38
	for <netfilter-devel@archiver.kernel.org>; Sat, 30 Oct 2021 17:10:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229793AbhJ3RND (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 30 Oct 2021 13:13:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229788AbhJ3RND (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 30 Oct 2021 13:13:03 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:fb7d:d6d6:e0:4cff:fe83:e514])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C79C7C061570
        for <netfilter-devel@vger.kernel.org>; Sat, 30 Oct 2021 10:10:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=8hvgyFjNe3fI2zhBYXFuQbvNeCpzqJoLHeFqlSuNMqM=; b=UjHzCB/9BmteefYAaYCGKrTaf8
        X7jBlV8WVP5TB/D/k5Q1v2qMFn0WwaXoiODvopcc4zEpN/ts9rIlSvSKVlXfZQO13M23EXft3Usnk
        jWesgsYV2yPnun+EA7oNGIpZ47rntgbLdgL8Q6j4GRCsdba4z7JQzRyDH346lx54gZjwwiv2p9Cd2
        aVEvj0B6c7TbQVZx4nlV95xNeLFI6eHe3t9mNXKCYoBv24zo4V3+tyjGIkxsJ7dvRM4s7P+kx2uoi
        qQiq0NApZf976u9PuzvZFqZAsvKz3BvGncC2xcera6OzAIoBmW/VQSVoVFNc9V9/HrtS0DnvlhAl6
        x2tECy8A==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] helo=ulthar.scientificgames.com)
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mgrTA-00AFgT-Fp
        for netfilter-devel@vger.kernel.org; Sat, 30 Oct 2021 17:44:36 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH 19/26] output: PGSQL: Fix string truncation warning
Date:   Sat, 30 Oct 2021 17:44:25 +0100
Message-Id: <20211030164432.1140896-20-jeremy@azazel.net>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211030164432.1140896-1-jeremy@azazel.net>
References: <20211030164432.1140896-1-jeremy@azazel.net>
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
 output/pgsql/ulogd_output_PGSQL.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/output/pgsql/ulogd_output_PGSQL.c b/output/pgsql/ulogd_output_PGSQL.c
index f5a2823a7e1d..c20ca605fb52 100644
--- a/output/pgsql/ulogd_output_PGSQL.c
+++ b/output/pgsql/ulogd_output_PGSQL.c
@@ -190,18 +190,17 @@ static int get_columns_pgsql(struct ulogd_pluginstance *upi)
 	}
 
 	for (i = 0; i < PQntuples(pi->pgres); i++) {
-		char buf[ULOGD_MAX_KEYLEN+1];
 		char *underscore;
 
+		snprintf(upi->input.keys[i].name,
+			 sizeof(upi->input.keys[i].name),
+			 "%s", PQgetvalue(pi->pgres, i, 0));
 		/* replace all underscores with dots */
-		strncpy(buf, PQgetvalue(pi->pgres, i, 0), ULOGD_MAX_KEYLEN);
-		while ((underscore = strchr(buf, '_')))
+		for (underscore = upi->input.keys[i].name;
+		     (underscore = strchr(underscore, '_')); )
 			*underscore = '.';
 
-		DEBUGP("field '%s' found: ", buf);
-
-		/* add it to list of input keys */
-		strncpy(upi->input.keys[i].name, buf, ULOGD_MAX_KEYLEN);
+		DEBUGP("field '%s' found\n", upi->input.keys[i].name);
 	}
 
 	/* ID (starting by '.') is a sequence */
-- 
2.33.0

