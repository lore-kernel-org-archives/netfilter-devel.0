Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E675C433EF
	for <netfilter-devel@archiver.kernel.org>; Wed, 24 Nov 2021 22:45:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351992AbhKXWtF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 24 Nov 2021 17:49:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245389AbhKXWtF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 Nov 2021 17:49:05 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B994C061574
        for <netfilter-devel@vger.kernel.org>; Wed, 24 Nov 2021 14:45:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=2qK+ffRPvq26gTo++xByhrlqYcxtgV3fhnF1uQDG+wQ=; b=Fq2CcAsNvn8JTNXHeJwHmzp3f0
        xChFDvCqRu4IGLFy6ntxElTk+nUnhtlYvh4JfE7Ko28Zz9cbxrGQCKR/VErkLlYS21GMbOdqE/e+L
        RWMgz8sNL5Z6hVhACbHnjnZNI/9rKg1sHdfrqMCI9Ugr+HaK6n3fplEFEe3CQc9MkbY4DAz+qHswH
        9VHV2rOaXtqddw8EEvLX7oDONWK6QBu1Ux5nG/xOHr6VYt/LaQyRZfRKCA+9IuCavKervxKUWboc6
        0YI710easM/nQ6zql4rOL/qQs986VHVqFbzmJF7G3ywrEsRb2/PwUPZCQnU5Cg/6Ct+28nfocOd1A
        hG5Pu+Dg==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mq0hA-00563U-3R
        for netfilter-devel@vger.kernel.org; Wed, 24 Nov 2021 22:24:52 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH v3 24/30] db: replace `strncpy` with `strcpy`
Date:   Wed, 24 Nov 2021 22:24:30 +0000
Message-Id: <20211124222444.2597311-36-jeremy@azazel.net>
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

We used strncpy to copy the SQL statement to the ring buffer, passing
the length of the source string, which led the compiler to complain:

  ../../util/db.c:231:25: warning: `strncpy` specified bound depends on the length of the source argument

In fact, the ring buffer is sized to be a multiple of the size of the
SQL buffer, and we are just copying the SQL multiple times at various
offsets, so we can just use `strcpy` instead.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 util/db.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/util/db.c b/util/db.c
index 339e39ef4797..c1d24365239f 100644
--- a/util/db.c
+++ b/util/db.c
@@ -228,9 +228,8 @@ int ulogd_db_start(struct ulogd_pluginstance *upi)
 			  di->ring.size, di->ring.length);
 		/* init start of query for each element */
 		for(i = 0; i < di->ring.size; i++) {
-			strncpy(di->ring.ring + di->ring.length * i + 1,
-				di->stmt,
-				strlen(di->stmt));
+			strcpy(di->ring.ring + di->ring.length * i + 1,
+			       di->stmt);
 		}
 		/* init cond & mutex */
 		ret = pthread_cond_init(&di->ring.cond, NULL);
-- 
2.33.0

