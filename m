Return-Path: <SRS0=lxoE=WR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01D5FC3A59E
	for <netfilter-devel@archiver.kernel.org>; Wed, 21 Aug 2019 07:56:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CCAC022D6D
	for <netfilter-devel@archiver.kernel.org>; Wed, 21 Aug 2019 07:56:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726735AbfHUH4W (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 21 Aug 2019 03:56:22 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42790 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726354AbfHUH4W (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 21 Aug 2019 03:56:22 -0400
Received: from 2.general.paelzer.uk.vpn ([10.172.196.173] helo=localhost.localdomain)
        by youngberry.canonical.com with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
        (Exim 4.76)
        (envelope-from <christian.ehrhardt@canonical.com>)
        id 1i0LTg-0001fr-NG; Wed, 21 Aug 2019 07:56:20 +0000
From:   Christian Ehrhardt <christian.ehrhardt@canonical.com>
To:     netfilter-devel@vger.kernel.org
Cc:     Christian Ehrhardt <christian.ehrhardt@canonical.com>
Subject: [RFC 1/1] nft: abort cache creation if mnl_genid_get fails
Date:   Wed, 21 Aug 2019 09:56:11 +0200
Message-Id: <20190821075611.30918-2-christian.ehrhardt@canonical.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190821075611.30918-1-christian.ehrhardt@canonical.com>
References: <20190821075611.30918-1-christian.ehrhardt@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

mnl_genid_get can fail and in this case not update the genid which leads
to a busy loop that never recovers.

To avoid that check the return value and abort __nft_build_cache
if mnl_genid_get fails.

Signed-off-by: Christian Ehrhardt <christian.ehrhardt@canonical.com>
---
 iptables/nft.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index ae3740be..c9b7edbb 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -1597,11 +1597,13 @@ static void __nft_build_cache(struct nft_handle *h)
 	uint32_t genid_start, genid_stop;
 
 retry:
-	mnl_genid_get(h, &genid_start);
+	if (mnl_genid_get(h, &genid_start) == -1)
+		goto fatal;
 	fetch_chain_cache(h);
 	fetch_rule_cache(h);
 	h->have_cache = true;
-	mnl_genid_get(h, &genid_stop);
+	if (mnl_genid_get(h, &genid_stop) == -1)
+		goto fatal;
 
 	if (genid_start != genid_stop) {
 		flush_chain_cache(h, NULL);
@@ -1609,6 +1611,10 @@ retry:
 	}
 
 	h->nft_genid = genid_start;
+
+fatal:
+	flush_chain_cache(h, NULL);
+	h->have_cache = false;
 }
 
 void nft_build_cache(struct nft_handle *h)
@@ -1651,6 +1657,8 @@ struct nftnl_chain_list *nft_chain_list_get(struct nft_handle *h,
 		return NULL;
 
 	nft_build_cache(h);
+	if (!h->have_cache)
+		return NULL;
 
 	return h->cache->table[t->type].chains;
 }
@@ -2047,6 +2055,8 @@ int nft_chain_user_rename(struct nft_handle *h,const char *chain,
 static struct nftnl_table_list *nftnl_table_list_get(struct nft_handle *h)
 {
 	nft_build_cache(h);
+	if (!h->have_cache)
+		return NULL;
 
 	return h->cache->tables;
 }
-- 
2.22.0

