Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96E91C25AE9
	for <netfilter-devel@archiver.kernel.org>; Sat, 28 Aug 2021 19:40:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 72C6760200
	for <netfilter-devel@archiver.kernel.org>; Sat, 28 Aug 2021 19:40:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231207AbhH1Tlh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 28 Aug 2021 15:41:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231258AbhH1Tle (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 28 Aug 2021 15:41:34 -0400
Received: from kadath.azazel.net (kadath.azazel.net [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE8FCC0617A8
        for <netfilter-devel@vger.kernel.org>; Sat, 28 Aug 2021 12:40:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ZLHdj073IKs2CD6qqtSTiTkwHNeRVduZamF51rCd2BQ=; b=EVRUa/r0zVDZbqsBGGU0rjaSUh
        7A19PO6dR8Q/NwyoxtLG6uRM0xxFOcgSXQAL5MQfZ+TNKAiy6zijL8CTlVev7fJwflM//neLoQbFx
        dT2NHZZRzQGaRwcItrKE+Ev1Ai5ZUwAmtg+jqffdiY2KNlB7BNf2bRHVB3Aku7ty9ULdMRfznWG9r
        +Ej5Itj5jWdVE9MRfk2qOHF5Mn5+dvIGWaBQTp9BcBCUWoF1ySkT5LzSVcRTiXr+ew4QAzsaNc5Fj
        YxY0I1fiCZHNe4CDdogxhpc39/Dca2nt0fxxvWr6Km2fV9p17EwE4QswO4+fHKn7H4eJtjGwbdXk6
        GdZdWesQ==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mK4C1-00FeN7-PV; Sat, 28 Aug 2021 20:40:41 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH libnetfilter_log 4/6] src: use calloc instead of malloc + memset.
Date:   Sat, 28 Aug 2021 20:38:22 +0100
Message-Id: <20210828193824.1288478-5-jeremy@azazel.net>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210828193824.1288478-1-jeremy@azazel.net>
References: <20210828193824.1288478-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 src/libipulog_compat.c | 3 +--
 src/libnetfilter_log.c | 6 ++----
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/src/libipulog_compat.c b/src/libipulog_compat.c
index 2d5b23a25c88..99cd86622d9b 100644
--- a/src/libipulog_compat.c
+++ b/src/libipulog_compat.c
@@ -90,12 +90,11 @@ struct ipulog_handle *ipulog_create_handle(uint32_t gmask,
 	struct ipulog_handle *h;
 	unsigned int group = gmask2group(gmask);
 
-	h = malloc(sizeof(*h)+PAYLOAD_SIZE);
+	h = calloc(1, sizeof(*h)+PAYLOAD_SIZE);
 	if (! h) {
 		ipulog_errno = IPULOG_ERR_HANDLE;
 		return NULL;
 	}
-	memset(h, 0, sizeof(*h));
 	h->nfulh = nflog_open();
 	if (!h->nfulh)
 		goto out_free;
diff --git a/src/libnetfilter_log.c b/src/libnetfilter_log.c
index 339f286f36bc..7d37570e70cb 100644
--- a/src/libnetfilter_log.c
+++ b/src/libnetfilter_log.c
@@ -238,11 +238,10 @@ struct nflog_handle *nflog_open_nfnl(struct nfnl_handle *nfnlh)
 	struct nflog_handle *h;
 	int err;
 
-	h = malloc(sizeof(*h));
+	h = calloc(1, sizeof(*h));
 	if (!h)
 		return NULL;
 
-	memset(h, 0, sizeof(*h));
 	h->nfnlh = nfnlh;
 
 	h->nfnlssh = nfnl_subsys_open(h->nfnlh, NFNL_SUBSYS_ULOG, 
@@ -398,11 +397,10 @@ nflog_bind_group(struct nflog_handle *h, uint16_t num)
 	if (find_gh(h, num))
 		return NULL;
 	
-	gh = malloc(sizeof(*gh));
+	gh = calloc(1, sizeof(*gh));
 	if (!gh)
 		return NULL;
 
-	memset(gh, 0, sizeof(*gh));
 	gh->h = h;
 	gh->id = num;
 
-- 
2.33.0

