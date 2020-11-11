Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E425DC61DD8
	for <netfilter-devel@archiver.kernel.org>; Wed, 11 Nov 2020 19:38:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 95124208B8
	for <netfilter-devel@archiver.kernel.org>; Wed, 11 Nov 2020 19:38:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726960AbgKKTiE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 11 Nov 2020 14:38:04 -0500
Received: from correo.us.es ([193.147.175.20]:45092 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725984AbgKKTiD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 11 Nov 2020 14:38:03 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 513641878A6
        for <netfilter-devel@vger.kernel.org>; Wed, 11 Nov 2020 20:38:01 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 44C0FDA858
        for <netfilter-devel@vger.kernel.org>; Wed, 11 Nov 2020 20:38:01 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 413E6DA852; Wed, 11 Nov 2020 20:38:01 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0228BDA84A;
        Wed, 11 Nov 2020 20:37:59 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 11 Nov 2020 20:37:59 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id BC05B42EF9E1;
        Wed, 11 Nov 2020 20:37:58 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        razor@blackwall.org, jeremy@azazel.net
Subject: [PATCH net-next,v3 1/9] netfilter: flowtable: add hash offset field to tuple
Date:   Wed, 11 Nov 2020 20:37:29 +0100
Message-Id: <20201111193737.1793-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201111193737.1793-1-pablo@netfilter.org>
References: <20201111193737.1793-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add a placeholder field to calculate hash tuple offset. Similar to
2c407aca6497 ("netfilter: conntrack: avoid gcc-10 zero-length-bounds
warning").

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_flow_table.h | 4 ++++
 net/netfilter/nf_flow_table_core.c    | 6 +++---
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index 16e8b2f8d006..54c4d5c908a5 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -107,6 +107,10 @@ struct flow_offload_tuple {
 
 	u8				l3proto;
 	u8				l4proto;
+
+	/* All members above are keys for lookups, see flow_offload_hash(). */
+	struct { }			__hash;
+
 	u8				dir;
 
 	u16				mtu;
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 513f78db3cb2..55fca71ace26 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -191,14 +191,14 @@ static u32 flow_offload_hash(const void *data, u32 len, u32 seed)
 {
 	const struct flow_offload_tuple *tuple = data;
 
-	return jhash(tuple, offsetof(struct flow_offload_tuple, dir), seed);
+	return jhash(tuple, offsetof(struct flow_offload_tuple, __hash), seed);
 }
 
 static u32 flow_offload_hash_obj(const void *data, u32 len, u32 seed)
 {
 	const struct flow_offload_tuple_rhash *tuplehash = data;
 
-	return jhash(&tuplehash->tuple, offsetof(struct flow_offload_tuple, dir), seed);
+	return jhash(&tuplehash->tuple, offsetof(struct flow_offload_tuple, __hash), seed);
 }
 
 static int flow_offload_hash_cmp(struct rhashtable_compare_arg *arg,
@@ -207,7 +207,7 @@ static int flow_offload_hash_cmp(struct rhashtable_compare_arg *arg,
 	const struct flow_offload_tuple *tuple = arg->key;
 	const struct flow_offload_tuple_rhash *x = ptr;
 
-	if (memcmp(&x->tuple, tuple, offsetof(struct flow_offload_tuple, dir)))
+	if (memcmp(&x->tuple, tuple, offsetof(struct flow_offload_tuple, __hash)))
 		return 1;
 
 	return 0;
-- 
2.20.1

