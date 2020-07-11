Return-Path: <SRS0=5odi=AW=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2C6DC433E2
	for <netfilter-devel@archiver.kernel.org>; Sat, 11 Jul 2020 10:20:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9D230206F4
	for <netfilter-devel@archiver.kernel.org>; Sat, 11 Jul 2020 10:20:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727782AbgGKKUD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 11 Jul 2020 06:20:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726208AbgGKKUD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 11 Jul 2020 06:20:03 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD93EC08C5DD
        for <netfilter-devel@vger.kernel.org>; Sat, 11 Jul 2020 03:20:02 -0700 (PDT)
Received: from localhost ([::1]:59502 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.94)
        (envelope-from <phil@nwl.cc>)
        id 1juCbx-0007Jz-Bu; Sat, 11 Jul 2020 12:20:01 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 16/18] nft: cache: Sort custom chains by name
Date:   Sat, 11 Jul 2020 12:18:29 +0200
Message-Id: <20200711101831.29506-17-phil@nwl.cc>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200711101831.29506-1-phil@nwl.cc>
References: <20200711101831.29506-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Update nft_cache_add_chain() to make use of libnftnl's new
nftnl_chain_list_add_sorted() function and sort custom chains by name.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft-cache.c                                     | 9 ++++++++-
 .../testcases/ebtables/0002-ebtables-save-restore_0      | 2 +-
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/iptables/nft-cache.c b/iptables/nft-cache.c
index 5853bdce82f88..7949bc57b0e1b 100644
--- a/iptables/nft-cache.c
+++ b/iptables/nft-cache.c
@@ -181,6 +181,12 @@ static int fetch_table_cache(struct nft_handle *h)
 	return ret;
 }
 
+static int nftnl_chain_name_cmp(struct nftnl_chain *a, struct nftnl_chain *b)
+{
+	return strcmp(nftnl_chain_get_str(a, NFTNL_CHAIN_NAME),
+		      nftnl_chain_get_str(b, NFTNL_CHAIN_NAME));
+}
+
 int nft_cache_add_chain(struct nft_handle *h, const struct builtin_table *t,
 			struct nftnl_chain *c)
 {
@@ -197,7 +203,8 @@ int nft_cache_add_chain(struct nft_handle *h, const struct builtin_table *t,
 		return 0;
 	}
 
-	nftnl_chain_list_add_tail(c, h->cache->table[t->type].chains);
+	nftnl_chain_list_add_sorted(c, h->cache->table[t->type].chains,
+				    nftnl_chain_name_cmp);
 	return 0;
 }
 
diff --git a/iptables/tests/shell/testcases/ebtables/0002-ebtables-save-restore_0 b/iptables/tests/shell/testcases/ebtables/0002-ebtables-save-restore_0
index b84f63a7c3672..ccdef19cfb215 100755
--- a/iptables/tests/shell/testcases/ebtables/0002-ebtables-save-restore_0
+++ b/iptables/tests/shell/testcases/ebtables/0002-ebtables-save-restore_0
@@ -70,8 +70,8 @@ DUMP='*filter
 :INPUT ACCEPT
 :FORWARD DROP
 :OUTPUT ACCEPT
-:foo ACCEPT
 :bar RETURN
+:foo ACCEPT
 -A INPUT -p IPv4 -i lo -j ACCEPT
 -A FORWARD -j foo
 -A OUTPUT -s Broadcast -j DROP
-- 
2.27.0

