Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 336CDC4332F
	for <netfilter-devel@archiver.kernel.org>; Fri,  4 Mar 2022 13:19:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232523AbiCDNUl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 4 Mar 2022 08:20:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230372AbiCDNUk (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 4 Mar 2022 08:20:40 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 653004EA2E
        for <netfilter-devel@vger.kernel.org>; Fri,  4 Mar 2022 05:19:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=wvKY0FBcjFJIclvXJzMzgEzbuoMIFQCfdi+EOjuESAM=; b=iIaO5Da4/nMEhQiri9j3nq3gKb
        4TVy166/wdma4aBwbFEHlSkOkO1HRImOJbTtSpGwWxLRgPDsaMwKURAwkcm017c6PstLjCiEobkSC
        CAXl5JIltiCn9Hq9aTTKUkQU7/AkBkuHPw4udF2demolQDqxsvpm9HitAzsGFZWvRbbY4y6aNbQuH
        XA2KhRTooPL6WyQirYokqK857mpK/0+5aLM3YxZUpydSL7YC3gFApDw4fSiat4kFxsccs8iveZAA8
        2i31P3pRuwfVPDoLOcaqiGcP26cMPhGvrX2h2g3Sqq4BQ+O2Lzeexuz30SGyxqWnRwpzbAQjQLHI8
        RoQ5wWHw==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1nQ7qY-0004Vg-RQ; Fri, 04 Mar 2022 14:19:50 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables RFC 1/2] libxtables: Implement notargets hash table
Date:   Fri,  4 Mar 2022 14:19:43 +0100
Message-Id: <20220304131944.30801-2-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220304131944.30801-1-phil@nwl.cc>
References: <20220304131944.30801-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Target lookup is relatively costly due to the filesystem access. Avoid
this overhead in huge rulesets which contain many chain jumps by caching
the failed lookups into a hashtable for later.

A sample ruleset involving 50k user-defined chains and 130k rules of
which 90k contain a chain jump restores significantly faster on my
testing VM:

variant		old	new
---------------------------
legacy		1m12s	37s
nft		1m35s	53s

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 libxtables/xtables.c | 78 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 78 insertions(+)

diff --git a/libxtables/xtables.c b/libxtables/xtables.c
index 094cbd87ec1ed..3cb9a87c9406d 100644
--- a/libxtables/xtables.c
+++ b/libxtables/xtables.c
@@ -49,6 +49,7 @@
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv6/ip6_tables.h>
 #include <libiptc/libxtc.h>
+#include <libiptc/linux_list.h>
 
 #ifndef NO_SHARED_LIBS
 #include <dlfcn.h>
@@ -255,6 +256,72 @@ static void dlreg_free(void)
 }
 #endif
 
+struct notarget {
+	struct hlist_node node;
+	char name[];
+};
+
+#define NOTARGET_HSIZE	512
+static struct hlist_head notargets[NOTARGET_HSIZE];
+
+static void notargets_hlist_init(void)
+{
+	int i;
+
+	for (i = 0; i < NOTARGET_HSIZE; i++)
+		INIT_HLIST_HEAD(&notargets[i]);
+}
+
+static void notargets_hlist_free(void)
+{
+	struct hlist_node *pos, *n;
+	struct notarget *cur;
+	int i;
+
+	for (i = 0; i < NOTARGET_HSIZE; i++) {
+		hlist_for_each_entry_safe(cur, pos, n, &notargets[i], node) {
+			hlist_del(&cur->node);
+			free(cur);
+		}
+	}
+}
+
+static uint32_t djb_hash(const char *key)
+{
+	uint32_t i, hash = 5381;
+
+	for (i = 0; i < strlen(key); i++)
+		hash = ((hash << 5) + hash) + key[i];
+
+	return hash;
+}
+
+static struct notarget *notargets_hlist_lookup(const char *name)
+{
+	uint32_t key = djb_hash(name) % NOTARGET_HSIZE;
+	struct hlist_node *node;
+	struct notarget *cur;
+
+	hlist_for_each_entry(cur, node, &notargets[key], node) {
+		if (!strcmp(name, cur->name))
+			return cur;
+	}
+	return NULL;
+}
+
+static void notargets_hlist_insert(const char *name)
+{
+	struct notarget *cur;
+
+	if (!name)
+		return;
+
+	cur = xtables_malloc(sizeof(*cur) + strlen(name) + 1);
+	cur->name[0] = '\0';
+	strcat(cur->name, name);
+	hlist_add_head(&cur->node, &notargets[djb_hash(name) % NOTARGET_HSIZE]);
+}
+
 void xtables_init(void)
 {
 	/* xtables cannot be used with setuid in a safe way. */
@@ -284,6 +351,8 @@ void xtables_init(void)
 		return;
 	}
 	xtables_libdir = XTABLES_LIBDIR;
+
+	notargets_hlist_init();
 }
 
 void xtables_fini(void)
@@ -291,6 +360,7 @@ void xtables_fini(void)
 #ifndef NO_SHARED_LIBS
 	dlreg_free();
 #endif
+	notargets_hlist_free();
 }
 
 void xtables_set_nfproto(uint8_t nfproto)
@@ -820,8 +890,14 @@ xtables_find_target(const char *name, enum xtables_tryload tryload)
 	struct xtables_target *prev = NULL;
 	struct xtables_target **dptr;
 	struct xtables_target *ptr;
+	struct notarget *notgt;
 	bool found = false;
 
+	/* known non-target? */
+	notgt = notargets_hlist_lookup(name);
+	if (notgt && tryload != XTF_LOAD_MUST_SUCCEED)
+		return NULL;
+
 	/* Standard target? */
 	if (strcmp(name, "") == 0
 	    || strcmp(name, XTC_LABEL_ACCEPT) == 0
@@ -894,6 +970,8 @@ xtables_find_target(const char *name, enum xtables_tryload tryload)
 
 	if (ptr)
 		ptr->used = 1;
+	else
+		notargets_hlist_insert(name);
 
 	return ptr;
 }
-- 
2.34.1

