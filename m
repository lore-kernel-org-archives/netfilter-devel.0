Return-Path: <SRS0=Ro/3=TA=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED7D9C43219
	for <netfilter-devel@archiver.kernel.org>; Tue, 30 Apr 2019 13:56:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BA06A20675
	for <netfilter-devel@archiver.kernel.org>; Tue, 30 Apr 2019 13:56:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QBINvlOw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727470AbfD3N40 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 30 Apr 2019 09:56:26 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:39794 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725938AbfD3N40 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 30 Apr 2019 09:56:26 -0400
Received: by mail-pf1-f194.google.com with SMTP id z26so3211310pfg.6
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Apr 2019 06:56:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=ainpOKjAZ4Tkmt/4r3rIComk7o2gPcd7qj8Z0LJjuwQ=;
        b=QBINvlOw1P/cuCPi2iyD6TAwj4IHPmh8LYNNVhpzVwhegI0yI1zEckFlGn+fM5HYJy
         84OHQSVWIkFzecIJo3Q6yFtsZUyk2q4RaVqiQS5fh2PqkPOSh+NLSlyZC8SOPgImyrjM
         VWrNdGzhlg11LeyDeoe5q3SI1vd/vCzwNN+IhxcVn6YLSOZC43gvGDowuZzsjFpjDseV
         y1tRMTiHWJYR+5YME8K1e8Mri/pGA/9LbysEiVh3yOhXxlTz1gy4bbQpTWF2vdOnE6PG
         2jhn3KWj9XmEoydO8KQDnNbJ0u7YRpS1qdzC1omqHofXsN6ku/tCmOfyePl8XYlf33hP
         KkCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=ainpOKjAZ4Tkmt/4r3rIComk7o2gPcd7qj8Z0LJjuwQ=;
        b=CChHJ/jE5yiGC/lJwzx0QHGPNQveTgSdnQ39+7lYqV/ISLa/Rp2AHSuSWZ/OMusUEl
         5puolaIv9TPOfG7h+wPF44CbbZYgNely6R5quJchxLSdaqVzUQS9Ad6l2++4vb6SmOCC
         lk0TtXcyATiV2CwNwBnYKaiz+SXA/5yUr4AFUZDu1xqVQmXFD6K7XLFZvnAxYTeI4sQ8
         mP+5bBvZaxkDWxI1YjOvW/b20DAO5QMgv+bc5yi6uuXFHba9vfPpyzsuYS7fp7fWp7IO
         Hs/qXFR2E05xu3ZKK63lUxoOS0Mn5zGuMfmi9HieuVndtHLS6iY7m/X2cOdWydCDqXDm
         FRIQ==
X-Gm-Message-State: APjAAAU57bLYTUENMBIQH+pc+PbdyRjmpKMPZzDCHVs8GNJdbCW3zWB2
        rBzFbXfwTAgiMI9oLQyHbwY=
X-Google-Smtp-Source: APXvYqxSEO6J7VWsQAmp8FzULv/7Td5Ug1TWQq6VkUOzDbh4rpymqW14yircNfqABjMz9+YMjCmMBA==
X-Received: by 2002:a62:3501:: with SMTP id c1mr47140864pfa.184.1556632585305;
        Tue, 30 Apr 2019 06:56:25 -0700 (PDT)
Received: from ap-To-be-filled-by-O-E-M.8.8.8.8 ([14.33.120.60])
        by smtp.gmail.com with ESMTPSA id t127sm7208536pfb.106.2019.04.30.06.56.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Apr 2019 06:56:24 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     pablo@netfilter.org, fw@strlen.de, netfilter-devel@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH v3 nf] netfilter: nf_flow_table: do not use deleted CT's flow offload
Date:   Tue, 30 Apr 2019 22:56:14 +0900
Message-Id: <20190430135614.8773-1-ap420073@gmail.com>
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

v2 -> v3 : use nf_ct_is_dying().
v1 -> v2 : use IPS_DYING_BIT instead of ct->ct_general.use refcnt.

 net/netfilter/nf_flow_table_core.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 7aabfd4b1e50..6477a5cbaaa5 100644
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
+	if (unlikely(nf_ct_is_dying(e->ct)))
+		return NULL;
+
 	return tuplehash;
 }
 EXPORT_SYMBOL_GPL(flow_offload_lookup);
@@ -290,8 +295,10 @@ static inline bool nf_flow_has_expired(const struct flow_offload *flow)
 static void nf_flow_offload_gc_step(struct flow_offload *flow, void *data)
 {
 	struct nf_flowtable *flow_table = data;
+	struct flow_offload_entry *e;
 
-	if (nf_flow_has_expired(flow) ||
+	e = container_of(flow, struct flow_offload_entry, flow);
+	if (nf_flow_has_expired(flow) || nf_ct_is_dying(e->ct) ||
 	    (flow->flags & (FLOW_OFFLOAD_DYING | FLOW_OFFLOAD_TEARDOWN)))
 		flow_offload_del(flow_table, flow);
 }
-- 
2.17.1

