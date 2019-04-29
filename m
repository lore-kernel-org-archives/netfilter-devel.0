Return-Path: <SRS0=bgPs=S7=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99D9AC43219
	for <netfilter-devel@archiver.kernel.org>; Mon, 29 Apr 2019 16:56:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 678692087B
	for <netfilter-devel@archiver.kernel.org>; Mon, 29 Apr 2019 16:56:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cKHiJA7f"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728752AbfD2Q4W (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 29 Apr 2019 12:56:22 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:45761 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728520AbfD2Q4W (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 29 Apr 2019 12:56:22 -0400
Received: by mail-pf1-f194.google.com with SMTP id e24so5594077pfi.12
        for <netfilter-devel@vger.kernel.org>; Mon, 29 Apr 2019 09:56:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=RK+lm+KnQqAG7Z7lK8VmQ3QoP1mfZXV+RwWrycpDIBc=;
        b=cKHiJA7fsxmPYiKXDV+4Af6GUqWAFaphtyqGVDCkzmHP/r/GRWdxOUqRgHT4f1M88F
         t/4r7VwmKaIE774zBgWm8V3YnOgBT8b8+CmAABKWQCJsyWEUHvCf0WukljI/qM9M7pGW
         hsU/ZyGAJePtpZQv0XzgppVJX/oUsyNVf7KOgnz7w+MG5j74UgBnJFSEK6ppVKRXZNhA
         e1Lp4JaG/DnFSuzelRmeBYNIZvrnZVkTIHA60gQLFn5PdJA/TLj8EuOYsl5EW5LWzQ6F
         A/hkkPnMufExo8or/pyneidV9d4DrCXWR6pCSEyTSehRcabNcCI+qmrZ7Mjum5K6EQLv
         MjrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=RK+lm+KnQqAG7Z7lK8VmQ3QoP1mfZXV+RwWrycpDIBc=;
        b=nAIxmpnFeQ694MnAt3gFb+uIN1dRGoUGKfg7v6ff+JQZZk5TZTwhNrVW4pFfzJEob6
         oOBkUr5VezjngJAd6xg6Z8yT9HpZCWvqMUW2nfNxGNi4/omXUrhoBOxvbyfof1hjl68D
         oWNmYlxi0B5DfDCst2zWEkZE6ne7bmRZOF/UT3fCP8iFC+ofzkLKqKgcH+MRbn2MDWue
         Z3vL0BiS+HN6FptMmf7FSULC7pzzcnrm91rasOc76jtl+jp82SKBPoqdwjKoZ/1rBu7C
         EFOl6G6hBUyvlwlD1kcz4kpHsLsFpoiBCRYJpnKNjgKJHUOMcg270oiLn2FFoHFTwT5C
         Wqzg==
X-Gm-Message-State: APjAAAWuNMCYQU5kskJtZ9Jv4WLgohcymzfDx37TCKUEKDKy5uUpOVK8
        O2Ac0bkVMo2F1EvX5AS48ZsSLERn
X-Google-Smtp-Source: APXvYqyzoQXb5uKnYX2WxsXzjK0ScQgQbO9ie47TWDtGkNdsBetq+avsEUK4/eHkjx2hDhELhYN0eA==
X-Received: by 2002:a65:4247:: with SMTP id d7mr15469074pgq.114.1556556981355;
        Mon, 29 Apr 2019 09:56:21 -0700 (PDT)
Received: from ap-To-be-filled-by-O-E-M.8.8.8.8 ([14.33.120.60])
        by smtp.gmail.com with ESMTPSA id h127sm48980466pgc.31.2019.04.29.09.56.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Apr 2019 09:56:20 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     pablo@netfilter.org, fw@strlen.de, netfilter-devel@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH nf v2 3/3] netfilter: nf_flow_table: do not use deleted CT's flow offload
Date:   Tue, 30 Apr 2019 01:56:14 +0900
Message-Id: <20190429165614.1506-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

flow offload of CT can be deleted by the masquerade module. then,
flow offload should be deleted too. but GC and data-path of flow offload
do not check CT's status. hence they will be removed only by the timeout.

GC and data-path routine will check ct->status.
If IPS_DYING_BIT is set, GC will delete CT and data-path routine
do not use it.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---

v1 -> v2 : use IPS_DYING_BIT instead of ct->ct_general.use refcnt.

 net/netfilter/nf_flow_table_core.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 7aabfd4b1e50..50d04a718b41 100644
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
+	if (unlikely(test_bit(IPS_DYING_BIT, &e->ct->status)))
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
+	    (test_bit(IPS_DYING_BIT, &e->ct->status)))
 		flow_offload_del(flow_table, flow);
 }
 
-- 
2.17.1

