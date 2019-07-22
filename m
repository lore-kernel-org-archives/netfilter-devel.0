Return-Path: <SRS0=3WFO=VT=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69334C76190
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Jul 2019 10:17:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4A4AF218A0
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Jul 2019 10:17:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729519AbfGVKRh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 22 Jul 2019 06:17:37 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:45510 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728569AbfGVKRg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 22 Jul 2019 06:17:36 -0400
Received: from localhost ([::1]:58600 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1hpVNv-0000ga-L0; Mon, 22 Jul 2019 12:17:35 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH v2 05/11] nft: Make nft_for_each_table() more versatile
Date:   Mon, 22 Jul 2019 12:16:22 +0200
Message-Id: <20190722101628.21195-6-phil@nwl.cc>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190722101628.21195-1-phil@nwl.cc>
References: <20190722101628.21195-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Support passing arbitrary data (via void pointer) to the callback.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft.c          |  6 +++---
 iptables/nft.h          |  2 +-
 iptables/xtables-save.c | 27 +++++++++++++++++----------
 3 files changed, 21 insertions(+), 14 deletions(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index 8f0d5e664eca6..cd42af70b54ef 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -2092,8 +2092,8 @@ err:
 }
 
 int nft_for_each_table(struct nft_handle *h,
-		       int (*func)(struct nft_handle *h, const char *tablename, bool counters),
-		       bool counters)
+		       int (*func)(struct nft_handle *h, const char *tablename, void *data),
+		       void *data)
 {
 	struct nftnl_table_list *list;
 	struct nftnl_table_list_iter *iter;
@@ -2112,7 +2112,7 @@ int nft_for_each_table(struct nft_handle *h,
 		const char *tablename =
 			nftnl_table_get(t, NFTNL_TABLE_NAME);
 
-		func(h, tablename, counters);
+		func(h, tablename, data);
 
 		t = nftnl_table_list_iter_next(iter);
 	}
diff --git a/iptables/nft.h b/iptables/nft.h
index dc1161840a38c..da078a44bab7b 100644
--- a/iptables/nft.h
+++ b/iptables/nft.h
@@ -81,7 +81,7 @@ void nft_build_cache(struct nft_handle *h);
 struct nftnl_table;
 struct nftnl_chain_list;
 
-int nft_for_each_table(struct nft_handle *h, int (*func)(struct nft_handle *h, const char *tablename, bool counters), bool counters);
+int nft_for_each_table(struct nft_handle *h, int (*func)(struct nft_handle *h, const char *tablename, void *data), void *data);
 bool nft_table_find(struct nft_handle *h, const char *tablename);
 int nft_table_purge_chains(struct nft_handle *h, const char *table, struct nftnl_chain_list *list);
 int nft_table_flush(struct nft_handle *h, const char *table);
diff --git a/iptables/xtables-save.c b/iptables/xtables-save.c
index 811ec6330a4cb..484450f03354f 100644
--- a/iptables/xtables-save.c
+++ b/iptables/xtables-save.c
@@ -62,10 +62,15 @@ static const struct option ebt_save_options[] = {
 
 static bool ebt_legacy_counter_format;
 
+struct do_output_data {
+	bool counters;
+};
+
 static int
-__do_output(struct nft_handle *h, const char *tablename, bool counters)
+__do_output(struct nft_handle *h, const char *tablename, void *data)
 {
 	struct nftnl_chain_list *chain_list;
+	struct do_output_data *d = data;
 
 	if (!nft_table_builtin_find(h, tablename))
 		return 0;
@@ -89,7 +94,7 @@ __do_output(struct nft_handle *h, const char *tablename, bool counters)
 	/* Dump out chain names first,
 	 * thereby preventing dependency conflicts */
 	nft_chain_save(h, chain_list);
-	nft_rule_save(h, tablename, counters ? 0 : FMT_NOCOUNTS);
+	nft_rule_save(h, tablename, d->counters ? 0 : FMT_NOCOUNTS);
 
 	now = time(NULL);
 	printf("COMMIT\n");
@@ -98,12 +103,12 @@ __do_output(struct nft_handle *h, const char *tablename, bool counters)
 }
 
 static int
-do_output(struct nft_handle *h, const char *tablename, bool counters)
+do_output(struct nft_handle *h, const char *tablename, struct do_output_data *d)
 {
 	int ret;
 
 	if (!tablename) {
-		ret = nft_for_each_table(h, __do_output, counters);
+		ret = nft_for_each_table(h, __do_output, d);
 		nft_check_xt_legacy(h->family, true);
 		return !!ret;
 	}
@@ -114,7 +119,7 @@ do_output(struct nft_handle *h, const char *tablename, bool counters)
 		return 1;
 	}
 
-	ret = __do_output(h, tablename, counters);
+	ret = __do_output(h, tablename, d);
 	nft_check_xt_legacy(h->family, true);
 	return ret;
 }
@@ -128,6 +133,7 @@ xtables_save_main(int family, int argc, char *argv[])
 {
 	const struct builtin_table *tables;
 	const char *tablename = NULL;
+	struct do_output_data d = {};
 	bool dump = false;
 	struct nft_handle h = {
 		.family	= family,
@@ -150,7 +156,7 @@ xtables_save_main(int family, int argc, char *argv[])
 			fprintf(stderr, "-b/--binary option is not implemented\n");
 			break;
 		case 'c':
-			show_counters = true;
+			d.counters = true;
 			break;
 
 		case 't':
@@ -229,7 +235,7 @@ xtables_save_main(int family, int argc, char *argv[])
 		exit(EXIT_FAILURE);
 	}
 
-	ret = do_output(&h, tablename, show_counters);
+	ret = do_output(&h, tablename, &d);
 	nft_fini(&h);
 	if (dump)
 		exit(0);
@@ -247,10 +253,11 @@ int xtables_ip6_save_main(int argc, char *argv[])
 	return xtables_save_main(NFPROTO_IPV6, argc, argv);
 }
 
-static int __ebt_save(struct nft_handle *h, const char *tablename, bool counters)
+static int __ebt_save(struct nft_handle *h, const char *tablename, void *data)
 {
 	struct nftnl_chain_list *chain_list;
 	unsigned int format = FMT_NOCOUNTS;
+	bool *counters = data;
 	time_t now;
 
 	if (!nft_table_find(h, tablename)) {
@@ -286,9 +293,9 @@ static int __ebt_save(struct nft_handle *h, const char *tablename, bool counters
 static int ebt_save(struct nft_handle *h, const char *tablename, bool counters)
 {
 	if (!tablename)
-		return nft_for_each_table(h, __ebt_save, counters);
+		return nft_for_each_table(h, __ebt_save, &counters);
 
-	return __ebt_save(h, tablename, counters);
+	return __ebt_save(h, tablename, &counters);
 }
 
 int xtables_eb_save_main(int argc_, char *argv_[])
-- 
2.22.0

