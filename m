Return-Path: <SRS0=YpbV=TC=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19A19C43219
	for <netfilter-devel@archiver.kernel.org>; Thu,  2 May 2019 16:56:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E010520C01
	for <netfilter-devel@archiver.kernel.org>; Thu,  2 May 2019 16:56:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hwdjEkQ3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726667AbfEBQ4t (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 2 May 2019 12:56:49 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:40272 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726120AbfEBQ4t (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 2 May 2019 12:56:49 -0400
Received: by mail-pg1-f193.google.com with SMTP id d31so1327172pgl.7
        for <netfilter-devel@vger.kernel.org>; Thu, 02 May 2019 09:56:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=vjIghLEsCF0q4zPn2E6xDKpYUOgpjja76JJ8Ipip6R0=;
        b=hwdjEkQ3y0hVYVJHIDwMaLI04AOHOqU+ePQMcUXkSe6vIHM4Ct2LTWnVwKVN9meoff
         UCvCfaVX2CrIXjSs3Tjb2sb1C2GriSDYK4wMnhIZMb/x6eiu8CnzFpGuBEUAEUisF2St
         zZDA5u9zUduweuGhQB2XljFzF6nuIJqThKgOzQx2/wKVw3C9jA1wugAOsUOGvZq+u90y
         yDGUihsJVw3ThSkGmGsik2u8oJ9yRPcGIGrpxN6FE2PgSxJ0Y8jYkQVzDQ4gzjer5XqJ
         3O/3SYvDVhyAHQXZXLzPjPMnPKPX0BXXjVk3auVnhYGkjBvAs3UiQj6F+Zwd+MaL4l1j
         TySQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=vjIghLEsCF0q4zPn2E6xDKpYUOgpjja76JJ8Ipip6R0=;
        b=r3lMtNC2htqWnrsHTXXMFR/ecfslL4rpduGqN8ZHsQjbJtZjg5dvYOTLNxdG1LA7Z/
         tiJdPYIrymG18UL00y8ckD9ZZVbAgfg7yI65WOC+NENFt5sVWCH897T5qzurOrUXxaKJ
         6LiIeWB55xMChH337xDCJ/D8aYZzgjxo+V3wsd7mdDNFPOObizbxeWN7auMVF2mV/6Nk
         4zXeMVs5+ZlfTW6JqGPrUu9iMYP019oyQiSba4gKsIXn13QOcAfpvun+H0UDUcieIbOX
         +ol5oMuCut0EAVo1IzjWXMLmPK5eZ2blcOz8TkX9LgWEQVl9AvdaU2i9wJD30gJrNLNn
         Ge2g==
X-Gm-Message-State: APjAAAV+1gR0BOR0nXIDITcLqDYeMHQfKznZmqURLhwH3pYQ2ngMs1lW
        eYze4s8vS9i6/UzU2oTsf6Y=
X-Google-Smtp-Source: APXvYqzoeDeFhkNmOtybCxkBH8aY0d6PpBLQQUVLvciEF880BME9kwQ0Ubq0fEC80maRguW68onBFg==
X-Received: by 2002:aa7:83c6:: with SMTP id j6mr2184004pfn.117.1556816207967;
        Thu, 02 May 2019 09:56:47 -0700 (PDT)
Received: from ap-To-be-filled-by-O-E-M.8.8.8.8 ([14.33.120.60])
        by smtp.gmail.com with ESMTPSA id b13sm57290919pfd.12.2019.05.02.09.56.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 02 May 2019 09:56:47 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     pablo@netfilter.org, netfilter-devel@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH nf] netfilter: nf_flow_table: fix missing err check for rhashtable_insert_fast
Date:   Fri,  3 May 2019 01:56:38 +0900
Message-Id: <20190502165638.23509-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

rhashtable_insert_fast() could return err value when memory allocation
is failed. but flow_offload_add() do not check values and this always
returns success value.
This patch just adds error check code.

Fixes: ac2a66665e23 ("netfilter: add generic flow table infrastructure")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 net/netfilter/nf_flow_table_core.c | 25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 7aabfd4b1e50..a9e4f74b1ff6 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -185,14 +185,25 @@ static const struct rhashtable_params nf_flow_offload_rhash_params = {
 
 int flow_offload_add(struct nf_flowtable *flow_table, struct flow_offload *flow)
 {
-	flow->timeout = (u32)jiffies;
+	int err;
 
-	rhashtable_insert_fast(&flow_table->rhashtable,
-			       &flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].node,
-			       nf_flow_offload_rhash_params);
-	rhashtable_insert_fast(&flow_table->rhashtable,
-			       &flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].node,
-			       nf_flow_offload_rhash_params);
+	err = rhashtable_insert_fast(&flow_table->rhashtable,
+				     &flow->tuplehash[0].node,
+				     nf_flow_offload_rhash_params);
+	if (err < 0)
+		return err;
+
+	err = rhashtable_insert_fast(&flow_table->rhashtable,
+				     &flow->tuplehash[1].node,
+				     nf_flow_offload_rhash_params);
+	if (err < 0) {
+		rhashtable_remove_fast(&flow_table->rhashtable,
+				       &flow->tuplehash[0].node,
+				       nf_flow_offload_rhash_params);
+		return err;
+	}
+
+	flow->timeout = (u32)jiffies;
 	return 0;
 }
 EXPORT_SYMBOL_GPL(flow_offload_add);
-- 
2.17.1

