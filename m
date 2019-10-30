Return-Path: <SRS0=SDnU=YX=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B826CA9EC5
	for <netfilter-devel@archiver.kernel.org>; Wed, 30 Oct 2019 17:27:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 25BDC2087E
	for <netfilter-devel@archiver.kernel.org>; Wed, 30 Oct 2019 17:27:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727143AbfJ3R1n (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 30 Oct 2019 13:27:43 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:45144 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726488AbfJ3R1m (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 30 Oct 2019 13:27:42 -0400
Received: from localhost ([::1]:58234 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1iPrkz-0007ny-GM; Wed, 30 Oct 2019 18:27:41 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH v3 03/12] nft: family_ops: Pass nft_handle to 'print_rule' callback
Date:   Wed, 30 Oct 2019 18:26:52 +0100
Message-Id: <20191030172701.5892-4-phil@nwl.cc>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191030172701.5892-1-phil@nwl.cc>
References: <20191030172701.5892-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Prepare for 'rule_to_cs' callback to receive nft_handle pointer so it is
able to access cache for set lookups.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft-arp.c    |  3 ++-
 iptables/nft-bridge.c |  4 ++--
 iptables/nft-ipv4.c   |  4 ++--
 iptables/nft-ipv6.c   |  4 ++--
 iptables/nft-shared.h |  4 ++--
 iptables/nft.c        | 19 ++++++++++---------
 6 files changed, 20 insertions(+), 18 deletions(-)

diff --git a/iptables/nft-arp.c b/iptables/nft-arp.c
index 5ad7556c637b8..da22c12d34a7b 100644
--- a/iptables/nft-arp.c
+++ b/iptables/nft-arp.c
@@ -582,7 +582,8 @@ nft_arp_save_rule(const void *data, unsigned int format)
 }
 
 static void
-nft_arp_print_rule(struct nftnl_rule *r, unsigned int num, unsigned int format)
+nft_arp_print_rule(struct nft_handle *h, struct nftnl_rule *r,
+		   unsigned int num, unsigned int format)
 {
 	struct iptables_command_state cs = {};
 
diff --git a/iptables/nft-bridge.c b/iptables/nft-bridge.c
index 73bca2f38101e..b0c6c5a4db3cd 100644
--- a/iptables/nft-bridge.c
+++ b/iptables/nft-bridge.c
@@ -472,8 +472,8 @@ static void nft_bridge_save_rule(const void *data, unsigned int format)
 		fputc('\n', stdout);
 }
 
-static void nft_bridge_print_rule(struct nftnl_rule *r, unsigned int num,
-				  unsigned int format)
+static void nft_bridge_print_rule(struct nft_handle *h, struct nftnl_rule *r,
+				  unsigned int num, unsigned int format)
 {
 	struct iptables_command_state cs = {};
 
diff --git a/iptables/nft-ipv4.c b/iptables/nft-ipv4.c
index 57d1b3c6d2d0c..98d7f966e3694 100644
--- a/iptables/nft-ipv4.c
+++ b/iptables/nft-ipv4.c
@@ -261,8 +261,8 @@ static void print_fragment(unsigned int flags, unsigned int invflags,
 	fputc(' ', stdout);
 }
 
-static void nft_ipv4_print_rule(struct nftnl_rule *r, unsigned int num,
-				unsigned int format)
+static void nft_ipv4_print_rule(struct nft_handle *h, struct nftnl_rule *r,
+				unsigned int num, unsigned int format)
 {
 	struct iptables_command_state cs = {};
 
diff --git a/iptables/nft-ipv6.c b/iptables/nft-ipv6.c
index 0e2c4a2946e25..56236bff03c2b 100644
--- a/iptables/nft-ipv6.c
+++ b/iptables/nft-ipv6.c
@@ -187,8 +187,8 @@ static void nft_ipv6_parse_immediate(const char *jumpto, bool nft_goto,
 		cs->fw6.ipv6.flags |= IP6T_F_GOTO;
 }
 
-static void nft_ipv6_print_rule(struct nftnl_rule *r, unsigned int num,
-				unsigned int format)
+static void nft_ipv6_print_rule(struct nft_handle *h, struct nftnl_rule *r,
+				unsigned int num, unsigned int format)
 {
 	struct iptables_command_state cs = {};
 
diff --git a/iptables/nft-shared.h b/iptables/nft-shared.h
index e98ce11a4b1a2..65d4997b2539d 100644
--- a/iptables/nft-shared.h
+++ b/iptables/nft-shared.h
@@ -90,8 +90,8 @@ struct nft_family_ops {
 			     const char *pol,
 			     const struct xt_counters *counters, bool basechain,
 			     uint32_t refs, uint32_t entries);
-	void (*print_rule)(struct nftnl_rule *r, unsigned int num,
-			   unsigned int format);
+	void (*print_rule)(struct nft_handle *h, struct nftnl_rule *r,
+			   unsigned int num, unsigned int format);
 	void (*save_rule)(const void *data, unsigned int format);
 	void (*save_counters)(const void *data);
 	void (*save_chain)(const struct nftnl_chain *c, const char *policy);
diff --git a/iptables/nft.c b/iptables/nft.c
index e03ed59c71953..0c6ce12f54582 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -1202,7 +1202,7 @@ nft_rule_append(struct nft_handle *h, const char *chain, const char *table,
 	}
 
 	if (verbose)
-		h->ops->print_rule(r, 0, FMT_PRINT_RULE);
+		h->ops->print_rule(h, r, 0, FMT_PRINT_RULE);
 
 	if (ref) {
 		nftnl_chain_rule_insert_at(r, ref);
@@ -1935,7 +1935,7 @@ int nft_rule_check(struct nft_handle *h, const char *chain,
 		goto fail_enoent;
 
 	if (verbose)
-		h->ops->print_rule(r, 0, FMT_PRINT_RULE);
+		h->ops->print_rule(h, r, 0, FMT_PRINT_RULE);
 
 	return 1;
 fail_enoent:
@@ -1964,7 +1964,7 @@ int nft_rule_delete(struct nft_handle *h, const char *chain,
 		if (ret < 0)
 			errno = ENOMEM;
 		if (verbose)
-			h->ops->print_rule(r, 0, FMT_PRINT_RULE);
+			h->ops->print_rule(h, r, 0, FMT_PRINT_RULE);
 	} else
 		errno = ENOENT;
 
@@ -2005,7 +2005,7 @@ nft_rule_add(struct nft_handle *h, const char *chain,
 	}
 
 	if (verbose)
-		h->ops->print_rule(r, 0, FMT_PRINT_RULE);
+		h->ops->print_rule(h, r, 0, FMT_PRINT_RULE);
 
 	return r;
 }
@@ -2114,8 +2114,8 @@ int nft_rule_replace(struct nft_handle *h, const char *chain,
 static int
 __nft_rule_list(struct nft_handle *h, struct nftnl_chain *c,
 		int rulenum, unsigned int format,
-		void (*cb)(struct nftnl_rule *r, unsigned int num,
-			   unsigned int format))
+		void (*cb)(struct nft_handle *h, struct nftnl_rule *r,
+			   unsigned int num, unsigned int format))
 {
 	struct nftnl_rule_iter *iter;
 	struct nftnl_rule *r;
@@ -2128,7 +2128,7 @@ __nft_rule_list(struct nft_handle *h, struct nftnl_chain *c,
 			 * valid chain but invalid rule number
 			 */
 			return 1;
-		cb(r, rulenum, format);
+		cb(h, r, rulenum, format);
 		return 1;
 	}
 
@@ -2138,7 +2138,7 @@ __nft_rule_list(struct nft_handle *h, struct nftnl_chain *c,
 
 	r = nftnl_rule_iter_next(iter);
 	while (r != NULL) {
-		cb(r, ++rule_ctr, format);
+		cb(h, r, ++rule_ctr, format);
 		r = nftnl_rule_iter_next(iter);
 	}
 
@@ -2242,7 +2242,8 @@ int nft_rule_list(struct nft_handle *h, const char *chain, const char *table,
 }
 
 static void
-list_save(struct nftnl_rule *r, unsigned int num, unsigned int format)
+list_save(struct nft_handle *h, struct nftnl_rule *r,
+	  unsigned int num, unsigned int format)
 {
 	nft_rule_print_save(r, NFT_RULE_APPEND, format);
 }
-- 
2.23.0

