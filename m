Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D9B4C433F5
	for <netfilter-devel@archiver.kernel.org>; Wed, 16 Mar 2022 17:45:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344405AbiCPRqT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 16 Mar 2022 13:46:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237760AbiCPRqS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 16 Mar 2022 13:46:18 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84D1F43EEC
        for <netfilter-devel@vger.kernel.org>; Wed, 16 Mar 2022 10:45:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=RJkl32HwgTJxMFH92/IjtRlj9H/TKM/+aQI/CkctzYk=; b=XPQtw8mGVN/cjM3TZ3zElRAs/L
        LHgryZkI4RQ3PEcc0JNFPLG/WRlljIS5nrfD/9pF77Qpk+kKt4mnjYdh6APX3L6Zp0qox1rOyeZGb
        PURH2dv3q8AVOreDYr+7RmfOcUMHqIaRxnglau1iIQbnDpEIZMhPJN4QrNdQpQ4AB3FO8SGG84F9N
        C7oZKFl8KphGKvGz52e15AOZpY9BB3Kc/4lAigpL5mGMEW99++3Tkc6nmcBEqVwB5pIC5JcMc6+HQ
        76UN5qe2pvyOWLxwuXRgcaT8R1prg79PfUViFyAQBQNs9IeVq6C/gXoCymZu4HsO8Nvu8pDj7FAIE
        6Z3PKI3g==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1nUXhl-0000QD-VQ; Wed, 16 Mar 2022 18:45:02 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 2/3] libxtables: Implement notargets hash table
Date:   Wed, 16 Mar 2022 18:44:42 +0100
Message-Id: <20220316174443.1930-3-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220316174443.1930-1-phil@nwl.cc>
References: <20220316174443.1930-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Target lookup is relatively costly due to the filesystem access. Avoid
this overhead in huge rulesets which contain many chain jumps by caching
the failed lookups into a hashtable for later.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 libxtables/xtables.c | 75 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 75 insertions(+)

diff --git a/libxtables/xtables.c b/libxtables/xtables.c
index 094cbd87ec1ed..49790046a79d8 100644
--- a/libxtables/xtables.c
+++ b/libxtables/xtables.c
@@ -49,6 +49,7 @@
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv6/ip6_tables.h>
 #include <libiptc/libxtc.h>
+#include <libiptc/linux_list.h>
 
 #ifndef NO_SHARED_LIBS
 #include <dlfcn.h>
@@ -255,6 +256,71 @@ static void dlreg_free(void)
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
+	strcpy(cur->name, name);
+	hlist_add_head(&cur->node, &notargets[djb_hash(name) % NOTARGET_HSIZE]);
+}
+
 void xtables_init(void)
 {
 	/* xtables cannot be used with setuid in a safe way. */
@@ -284,6 +350,8 @@ void xtables_init(void)
 		return;
 	}
 	xtables_libdir = XTABLES_LIBDIR;
+
+	notargets_hlist_init();
 }
 
 void xtables_fini(void)
@@ -291,6 +359,7 @@ void xtables_fini(void)
 #ifndef NO_SHARED_LIBS
 	dlreg_free();
 #endif
+	notargets_hlist_free();
 }
 
 void xtables_set_nfproto(uint8_t nfproto)
@@ -829,6 +898,10 @@ xtables_find_target(const char *name, enum xtables_tryload tryload)
 	    || strcmp(name, XTC_LABEL_QUEUE) == 0
 	    || strcmp(name, XTC_LABEL_RETURN) == 0)
 		name = "standard";
+	/* known non-target? */
+	else if (notargets_hlist_lookup(name) &&
+		 tryload != XTF_LOAD_MUST_SUCCEED)
+		return NULL;
 
 	/* Trigger delayed initialization */
 	for (dptr = &xtables_pending_targets; *dptr; ) {
@@ -894,6 +967,8 @@ xtables_find_target(const char *name, enum xtables_tryload tryload)
 
 	if (ptr)
 		ptr->used = 1;
+	else
+		notargets_hlist_insert(name);
 
 	return ptr;
 }
-- 
2.34.1

