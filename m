Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C306C433EF
	for <netfilter-devel@archiver.kernel.org>; Tue, 30 Nov 2021 11:15:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235176AbhK3LSd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 30 Nov 2021 06:18:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236718AbhK3LSd (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 30 Nov 2021 06:18:33 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47112C061574
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Nov 2021 03:15:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=vaLguVRxJTc08lNsJRSlC4sMIOzi+9EVq/gzHRZgH/I=; b=i/XU0+zK9+RQydUspgWzYg8fP/
        BZZbx6LP4uxdhK2UhrHz4HDIf2hCE1ZB93lartzc39bhy2Y7Q/5BMn03tebCI9fYDssk8sUgON5+G
        Bp29AhsjmQ6WW9Eo49scpghyh8I1yMIC5Bltxg1eIHnjZXcqfdWRMofcvcn70rMzafLVnhGmxltps
        mAN3W4tJLdG+h1N6YWAIXNKM+Q7jPPyDqTWohFJmkz7AerhwUqBQB0QPYYz3ZHqEpRciqF8gOf6Kk
        HZ49I4rxCSKODGFscT38d04EL7By9AVf35BaO18j3h9JYC0Fc5CKCaJuhAjkF2HLMUno9iyCxOX4A
        MucJSn8A==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1ms0nt-00Awwr-E3
        for netfilter-devel@vger.kernel.org; Tue, 30 Nov 2021 10:56:05 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH v4 26/32] db: simplify initialization of ring-buffer
Date:   Tue, 30 Nov 2021 10:55:54 +0000
Message-Id: <20211130105600.3103609-27-jeremy@azazel.net>
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

Currently, `strncpy` is used to copy the SQL statement to the ring
buffer, passing the length of the source string, which leads gcc to
complain:

  ../../util/db.c:231:25: warning: `strncpy` specified bound depends on the length of the source argument

In fact, the ring buffer is sized to be a multiple of the size of the
SQL buffer, and the SQL is simply copied multiple times at increasing
offsets, so use `strcpy` instead.

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

