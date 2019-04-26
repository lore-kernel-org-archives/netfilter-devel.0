Return-Path: <SRS0=OoQ/=S4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F485C43219
	for <netfilter-devel@archiver.kernel.org>; Fri, 26 Apr 2019 16:55:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6C2AA206E0
	for <netfilter-devel@archiver.kernel.org>; Fri, 26 Apr 2019 16:55:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DKcgIQ3g"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726154AbfDZQzC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 26 Apr 2019 12:55:02 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:43622 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725944AbfDZQzC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 26 Apr 2019 12:55:02 -0400
Received: by mail-pg1-f195.google.com with SMTP id z9so1888743pgu.10
        for <netfilter-devel@vger.kernel.org>; Fri, 26 Apr 2019 09:55:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=+6nu+8uFCOaoEB5+uwrvfiqZuNzWaOfnsjIQBHwXoyw=;
        b=DKcgIQ3gVSiI5x5h4IvtNicGEKTrO8RF7KOZM2Mw9MopP+8DFQzBUi4txEkyDFk2Tk
         4UzqxauLcMFNW70CaJ5QN72LF0onlRLWOkzx9NFcXUjfHKTHibRNZrfaaqxQOlkyXn0C
         4DNF3GHVmYcVSu7j0wzPTeGZN7csSa2zmbX3c0d0KO+pHpGx5wuxWtH0YQFLeOY2ARGP
         65aNyDIn/w7P1PrOqKoZKdgCIGXZQ3f9XntkPAff30mo1j4WiDpM3tE1xPnf62EeaxJQ
         H0gAvXmlJ9Bv7woR6EizcU7GTsxblH9+svd/aWOz1yH8trsDuBywngzCuHXyiaEyDUJl
         OUKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=+6nu+8uFCOaoEB5+uwrvfiqZuNzWaOfnsjIQBHwXoyw=;
        b=fvQ9tJOkoUK4iVu+8MDSTwaY2Y7L3FUjLyMObA4tnrASpQyGvpm1uFUtKupKLsMR99
         DG5YKDHBUYiFbZb4y7UBFnOBcPg/ENkuiN9WPBbxlEceZI9UnkPHmwnbc1Gqvd4QTSIF
         L2U7bVVg3Y6fSmZRRrV90uzpf8ygezP0XleMNdHdWpm/seXJvn5BSv/CDg9yklPFLUO2
         5VQe2oWlguhQBtMNWNdARqPh6HimrI7eeDB4XN5FcRKrDGmgMCj4yGjPfi72LDU3Nx+N
         k/73IzRTF7dus6g/G8+QuxlKfYzPeatyrQHp4yJdFfbI06Cvf9HItlQxDtfeXmtepYR9
         G55A==
X-Gm-Message-State: APjAAAVORdROgeKT4L5NV7SfAcQH5hzovspeXt9zqM2Fg2PlaEOPcoHg
        nUCjgDLo+hjFRXDN1GgSi4w=
X-Google-Smtp-Source: APXvYqzqY7ab/F8R8Fc5C27AjNvvU+Ol7NnOsdHJGCaGfirIImnKcvEDXuBW9AfuNAcRV1P8kvlC5Q==
X-Received: by 2002:a63:ed4f:: with SMTP id m15mr45618992pgk.387.1556297701348;
        Fri, 26 Apr 2019 09:55:01 -0700 (PDT)
Received: from ap-To-be-filled-by-O-E-M.8.8.8.8 ([14.33.120.60])
        by smtp.gmail.com with ESMTPSA id h127sm37753207pgc.31.2019.04.26.09.54.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 26 Apr 2019 09:55:00 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     pablo@netfilter.org, fw@strlen.de, netfilter-devel@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH nf 4/4] netfilter: nf_flow_table: do not use deleted CT's flow offload
Date:   Sat, 27 Apr 2019 01:54:54 +0900
Message-Id: <20190426165454.3943-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

flow offload of CT can be deleted by the masquerade module. then,
flow offload should be deleted too. but GC and data-path of flow offload
do not check CT's status. hence they will be removed only by the timeout.

GC and data-path routine will check ct_general.use value.
If that value is 1, it means that CT is removed from the list.
So, GC will delete this and data-path do not use this.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 net/netfilter/nf_flow_table_core.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 7aabfd4b1e50..334eb561ae48 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -232,6 +232,7 @@ flow_offload_lookup(struct nf_flowtable *flow_table,
 {
 	struct flow_offload_tuple_rhash *tuplehash;
 	struct flow_offload *flow;
+	struct flow_offload_entry *e;
 	int dir;
 
 	tuplehash = rhashtable_lookup(&flow_table->rhashtable, tuple,
@@ -244,6 +245,10 @@ flow_offload_lookup(struct nf_flowtable *flow_table,
 	if (flow->flags & (FLOW_OFFLOAD_DYING | FLOW_OFFLOAD_TEARDOWN))
 		return NULL;
 
+	e = container_of(flow, struct flow_offload_entry, flow);
+	if (unlikely(atomic_read(&e->ct->ct_general.use) == 1))
+		return NULL;
+
 	return tuplehash;
 }
 EXPORT_SYMBOL_GPL(flow_offload_lookup);
@@ -290,9 +295,12 @@ static inline bool nf_flow_has_expired(const struct flow_offload *flow)
 static void nf_flow_offload_gc_step(struct flow_offload *flow, void *data)
 {
 	struct nf_flowtable *flow_table = data;
+	struct flow_offload_entry *e;
 
+	e = container_of(flow, struct flow_offload_entry, flow);
 	if (nf_flow_has_expired(flow) ||
-	    (flow->flags & (FLOW_OFFLOAD_DYING | FLOW_OFFLOAD_TEARDOWN)))
+	    (flow->flags & (FLOW_OFFLOAD_DYING | FLOW_OFFLOAD_TEARDOWN)) ||
+	    (atomic_read(&e->ct->ct_general.use) == 1))
 		flow_offload_del(flow_table, flow);
 }
 
-- 
2.17.1

