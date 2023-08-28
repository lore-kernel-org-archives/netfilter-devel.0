Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30120C83F12
	for <netfilter-devel@archiver.kernel.org>; Mon, 28 Aug 2023 13:23:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229718AbjH1NWf (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 28 Aug 2023 09:22:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231666AbjH1NWQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 28 Aug 2023 09:22:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC99A122
        for <netfilter-devel@vger.kernel.org>; Mon, 28 Aug 2023 06:21:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1693228891;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=XObW/irKrFMvdZD/5mdweJdM7rYD71QsYjFo9kkuf18=;
        b=NtMM6185yNW6lUGRCjt0RMjVQekDDiFedzuMQegAes2n0Cp6ASH+FeEdducMmg7VJApQBJ
        aneEuHxAKzx/xApVBy+6jIafg9pexAnblz1U5vVRiuC9sUItp1abgp7poZvOF5aVZ51frU
        TVZjqezmH96eNFL49yRvvlVyGekIfGk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-580-yZB3xwcoMQipTDtpjyk_HQ-1; Mon, 28 Aug 2023 09:21:27 -0400
X-MC-Unique: yZB3xwcoMQipTDtpjyk_HQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 953538D40A5;
        Mon, 28 Aug 2023 13:21:26 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.22.16.86])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A26E940C6F4E;
        Mon, 28 Aug 2023 13:21:23 +0000 (UTC)
From:   Wander Lairson Costa <wander@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Patrick McHardy <kaber@trash.net>,
        Jan Engelhardt <jengelh@gmx.de>,
        netfilter-devel@vger.kernel.org (open list:NETFILTER),
        coreteam@netfilter.org (open list:NETFILTER),
        netdev@vger.kernel.org (open list:NETWORKING [GENERAL]),
        linux-kernel@vger.kernel.org (open list)
Cc:     Wander Lairson Costa <wander@redhat.com>
Subject: [PATCH nf] netfilter/xt_u32: validate user space input
Date:   Mon, 28 Aug 2023 10:21:07 -0300
Message-ID: <20230828132107.18376-1-wander@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The xt_u32 module doesn't validate the fields in the xt_u32 structure.
An attacker may take advantage of this to trigger an OOB read by setting
the size fields with a value beyond the arrays boundaries.

Add a checkentry function to validate the structure.

This was originally reported by the ZDI project (ZDI-CAN-18408).

Fixes: 1b50b8a371e9 ("[NETFILTER]: Add u32 match")
Signed-off-by: Wander Lairson Costa <wander@redhat.com>
---
 net/netfilter/xt_u32.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/net/netfilter/xt_u32.c b/net/netfilter/xt_u32.c
index 177b40d08098..117d4615d668 100644
--- a/net/netfilter/xt_u32.c
+++ b/net/netfilter/xt_u32.c
@@ -96,11 +96,32 @@ static bool u32_mt(const struct sk_buff *skb, struct xt_action_param *par)
 	return ret ^ data->invert;
 }
 
+static int u32_mt_checkentry(const struct xt_mtchk_param *par)
+{
+	const struct xt_u32 *data = par->matchinfo;
+	const struct xt_u32_test *ct;
+	unsigned int i;
+
+	if (data->ntests > ARRAY_SIZE(data->tests))
+		return -EINVAL;
+
+	for (i = 0; i < data->ntests; ++i) {
+		ct = &data->tests[i];
+
+		if (ct->nnums > ARRAY_SIZE(ct->location) ||
+		    ct->nvalues > ARRAY_SIZE(ct->value))
+			return -EINVAL;
+	}
+
+	return 0;
+}
+
 static struct xt_match xt_u32_mt_reg __read_mostly = {
 	.name       = "u32",
 	.revision   = 0,
 	.family     = NFPROTO_UNSPEC,
 	.match      = u32_mt,
+	.checkentry = u32_mt_checkentry,
 	.matchsize  = sizeof(struct xt_u32),
 	.me         = THIS_MODULE,
 };
-- 
2.41.0

