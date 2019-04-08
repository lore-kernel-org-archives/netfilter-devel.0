Return-Path: <SRS0=Xgm7=SK=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7C78C10F14
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Apr 2019 10:42:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 81B2A2148D
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Apr 2019 10:42:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bZcN9RnQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726632AbfDHKm3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 8 Apr 2019 06:42:29 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:38314 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726446AbfDHKm2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 8 Apr 2019 06:42:28 -0400
Received: by mail-pg1-f193.google.com with SMTP id j26so7109200pgl.5
        for <netfilter-devel@vger.kernel.org>; Mon, 08 Apr 2019 03:42:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=3FdTo6WFIe0vvoSFPMRvNbWhnC/rL724J+S31UMNXQE=;
        b=bZcN9RnQ7h9cY+eYJAzJmGtd1JHWhv2uKhly91tFVTP30gPWis6T7m+jvANwUyvn1m
         C0ciZfCFxP9lI8u0B11ASrTMEd59Dw7/eCd48k78Bc3JV+HYHGWSZE3ytgbO7T9cKYsJ
         hSC88ooC2W+GEb3kb53Z0DvvExEysSivYWRKxG46e8SazWMsxpteye0r3KIoxsS0isBR
         4VdkO7ZE5R62ijSnflxuVD8Fo5tokaWzidvEVV/aeAK2Uu6NqCnW0WsPz/VOZPolg3A3
         kgiPXZ6YNDKnDKcwFsC/h6hfJXG81foSG/ZU6AQxm5CK12v6PMrxU25BvVkT7brJQCFl
         DAEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=3FdTo6WFIe0vvoSFPMRvNbWhnC/rL724J+S31UMNXQE=;
        b=Rp8BA3Vp+lxnl5aM2uWhgXFdXZm6SgMk3ydVMe8yv/0xor2sSTmZvKrwKBQpCNeqwK
         D/2kdi02QEc0O7B4TaL1NMU6JrKfENEOFyZdLYb1u88tXNrDWHW9ZnVBDJtZHTwcaUFU
         T1llDXiiwt4NwdkPZpvyrs2luNm7Gr6+ClbE+GD5pW3yJKNV9YvwG08FuNa0zPs8pWDU
         WhkVMsaP3TOIj5uL1dMBQEyfUNXI52NC2MnhdnhPzIUgjkatuRp7eaCtN6TGWNHwvOOf
         nHlNTzNytQw3MZDwrH75GX47HaOULk7DSIhfaSscs6Tzrdc3t+y613IssH3URLKjNrM/
         I//w==
X-Gm-Message-State: APjAAAV/hQy17ZsYmbWsa9CBJsMuUR0Vwtdy+LZPRqNkxdsUBs3VX7Oo
        JSgyTurN5/llV5M5Ho0/5nvD8InR
X-Google-Smtp-Source: APXvYqweUyLeBisTXfw+8Saq4dDib4Otdzpf5Qc0aEtw98272xPVl9fyrMF39gEKT2AN2gdfP3bZFQ==
X-Received: by 2002:a63:41c4:: with SMTP id o187mr27875024pga.73.1554720147728;
        Mon, 08 Apr 2019 03:42:27 -0700 (PDT)
Received: from ap-To-be-filled-by-O-E-M.8.8.8.8 ([14.33.120.60])
        by smtp.gmail.com with ESMTPSA id u5sm28297285pfm.121.2019.04.08.03.42.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Apr 2019 03:42:26 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     pablo@netfilter.org, fw@strlen.de, netfilter-devel@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH nf-next] netfilter: nf_conntrack: restrict conntrack_buckets value
Date:   Mon,  8 Apr 2019 19:42:20 +0900
Message-Id: <20190408104220.3816-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

In order to avoid wastefull memory allocation, conntrack bucket size
should be lower than conntrack_max size.
When a conntrack_max is changed, a conntrack_buckets will be changed to be
under a conntrack_max value.
But, a conntrack_buckets can be over than a conntrack_max only when
a conntrack_max is lower than minimum of a conntrack_buckets.

TEST
   sysctl net.netfilter.nf_conntrack_max=100000 -w
   sysctl net.netfilter.nf_conntrack_buckets=200000 -w
second command will be failed because of this patch.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 include/net/netfilter/nf_conntrack.h    |  4 +--
 net/netfilter/nf_conntrack_core.c       | 34 ++++++++++++++++++++-----
 net/netfilter/nf_conntrack_expect.c     |  2 +-
 net/netfilter/nf_conntrack_helper.c     |  2 +-
 net/netfilter/nf_conntrack_standalone.c | 29 ++++++++++++++++++---
 net/netfilter/nf_nat_core.c             |  2 +-
 6 files changed, 59 insertions(+), 14 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index 5ee7b30b4917..39565339f218 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -179,7 +179,7 @@ void nf_ct_netns_put(struct net *net, u8 nfproto);
  * Allocate a hashtable of hlist_head (if nulls == 0),
  * or hlist_nulls_head (if nulls == 1)
  */
-void *nf_ct_alloc_hashtable(unsigned int *sizep, int nulls);
+void *nf_ct_alloc_hashtable(unsigned int *sizep, int nulls, bool roundup);
 
 int nf_conntrack_hash_check_insert(struct nf_conn *ct);
 bool nf_ct_delete(struct nf_conn *ct, u32 pid, int report);
@@ -287,7 +287,7 @@ static inline bool nf_ct_should_gc(const struct nf_conn *ct)
 struct kernel_param;
 
 int nf_conntrack_set_hashsize(const char *val, const struct kernel_param *kp);
-int nf_conntrack_hash_resize(unsigned int hashsize);
+int nf_conntrack_hash_resize(unsigned int hashsize, bool roundup);
 
 extern struct hlist_nulls_head *nf_conntrack_hash;
 extern unsigned int nf_conntrack_htable_size;
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 82bfbeef46af..7215e535615b 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -2210,7 +2210,12 @@ void nf_conntrack_cleanup_net_list(struct list_head *net_exit_list)
 	}
 }
 
-void *nf_ct_alloc_hashtable(unsigned int *sizep, int nulls)
+static unsigned int nf_ct_hashtable_min(void)
+{
+	return roundup(1, PAGE_SIZE / sizeof(struct hlist_nulls_head));
+}
+
+void *nf_ct_alloc_hashtable(unsigned int *sizep, int nulls, bool roundup)
 {
 	struct hlist_nulls_head *hash;
 	unsigned int nr_slots, i;
@@ -2219,7 +2224,17 @@ void *nf_ct_alloc_hashtable(unsigned int *sizep, int nulls)
 		return NULL;
 
 	BUILD_BUG_ON(sizeof(struct hlist_nulls_head) != sizeof(struct hlist_head));
-	nr_slots = *sizep = roundup(*sizep, PAGE_SIZE / sizeof(struct hlist_nulls_head));
+	if (roundup) {
+		*sizep = roundup(*sizep, PAGE_SIZE /
+					 sizeof(struct hlist_nulls_head));
+	} else {
+		*sizep = rounddown(*sizep, PAGE_SIZE /
+					   sizeof(struct hlist_nulls_head));
+		if (!*sizep)
+			*sizep = nf_ct_hashtable_min();
+	}
+
+	nr_slots = *sizep;
 
 	hash = kvmalloc_array(nr_slots, sizeof(struct hlist_nulls_head),
 			      GFP_KERNEL | __GFP_ZERO);
@@ -2232,7 +2247,7 @@ void *nf_ct_alloc_hashtable(unsigned int *sizep, int nulls)
 }
 EXPORT_SYMBOL_GPL(nf_ct_alloc_hashtable);
 
-int nf_conntrack_hash_resize(unsigned int hashsize)
+int nf_conntrack_hash_resize(unsigned int hashsize, bool roundup)
 {
 	int i, bucket;
 	unsigned int old_size;
@@ -2243,7 +2258,7 @@ int nf_conntrack_hash_resize(unsigned int hashsize)
 	if (!hashsize)
 		return -EINVAL;
 
-	hash = nf_ct_alloc_hashtable(&hashsize, 1);
+	hash = nf_ct_alloc_hashtable(&hashsize, 1, roundup);
 	if (!hash)
 		return -ENOMEM;
 
@@ -2253,6 +2268,12 @@ int nf_conntrack_hash_resize(unsigned int hashsize)
 		return 0;
 	}
 
+	if (hashsize != nf_ct_hashtable_min() &&
+	    hashsize > nf_conntrack_max) {
+		kvfree(hash);
+		return -E2BIG;
+	}
+
 	local_bh_disable();
 	nf_conntrack_all_lock();
 	write_seqcount_begin(&nf_conntrack_generation);
@@ -2305,7 +2326,7 @@ int nf_conntrack_set_hashsize(const char *val, const struct kernel_param *kp)
 	if (rc)
 		return rc;
 
-	return nf_conntrack_hash_resize(hashsize);
+	return nf_conntrack_hash_resize(hashsize, true);
 }
 EXPORT_SYMBOL_GPL(nf_conntrack_set_hashsize);
 
@@ -2377,7 +2398,8 @@ int nf_conntrack_init_start(void)
 		max_factor = 4;
 	}
 
-	nf_conntrack_hash = nf_ct_alloc_hashtable(&nf_conntrack_htable_size, 1);
+	nf_conntrack_hash = nf_ct_alloc_hashtable(&nf_conntrack_htable_size, 1,
+						  true);
 	if (!nf_conntrack_hash)
 		return -ENOMEM;
 
diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index 334d6e5b7762..82fca1480455 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -698,7 +698,7 @@ int nf_conntrack_expect_init(void)
 	if (!nf_ct_expect_cachep)
 		return -ENOMEM;
 
-	nf_ct_expect_hash = nf_ct_alloc_hashtable(&nf_ct_expect_hsize, 0);
+	nf_ct_expect_hash = nf_ct_alloc_hashtable(&nf_ct_expect_hsize, 0, true);
 	if (!nf_ct_expect_hash) {
 		kmem_cache_destroy(nf_ct_expect_cachep);
 		return -ENOMEM;
diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index 274baf1dab87..3d22b80fe9d7 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -483,7 +483,7 @@ int nf_conntrack_helper_init(void)
 	int ret;
 	nf_ct_helper_hsize = 1; /* gets rounded up to use one page */
 	nf_ct_helper_hash =
-		nf_ct_alloc_hashtable(&nf_ct_helper_hsize, 0);
+		nf_ct_alloc_hashtable(&nf_ct_helper_hsize, 0, true);
 	if (!nf_ct_helper_hash)
 		return -ENOMEM;
 
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index c2ae14c720b4..d9a6480178e5 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -515,6 +515,29 @@ static int log_invalid_proto_max __read_mostly = 255;
 /* size the user *wants to set */
 static unsigned int nf_conntrack_htable_size_user __read_mostly;
 
+static int
+nf_conntrack_max_sysctl(struct ctl_table *table, int write,
+			void __user *buffer, size_t *lenp, loff_t *ppos)
+{
+	int ret;
+
+	ret = proc_dointvec(table, write, buffer, lenp, ppos);
+	if (ret < 0 || !write)
+		return ret;
+
+	if (net_eq(&init_net, current->nsproxy->net_ns) &&
+	    nf_conntrack_max < nf_conntrack_htable_size) {
+		ret = nf_conntrack_hash_resize(nf_conntrack_max ?
+					       nf_conntrack_max : 1, false);
+		if (ret < 0)
+			return ret;
+
+		nf_conntrack_htable_size_user = nf_conntrack_htable_size;
+	}
+
+	return ret;
+}
+
 static int
 nf_conntrack_hash_sysctl(struct ctl_table *table, int write,
 			 void __user *buffer, size_t *lenp, loff_t *ppos)
@@ -526,7 +549,7 @@ nf_conntrack_hash_sysctl(struct ctl_table *table, int write,
 		return ret;
 
 	/* update ret, we might not be able to satisfy request */
-	ret = nf_conntrack_hash_resize(nf_conntrack_htable_size_user);
+	ret = nf_conntrack_hash_resize(nf_conntrack_htable_size_user, true);
 
 	/* update it to the actual value used by conntrack */
 	nf_conntrack_htable_size_user = nf_conntrack_htable_size;
@@ -605,7 +628,7 @@ static struct ctl_table nf_ct_sysctl_table[] = {
 		.data		= &nf_conntrack_max,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
+		.proc_handler	= nf_conntrack_max_sysctl,
 	},
 	[NF_SYSCTL_CT_COUNT] = {
 		.procname	= "nf_conntrack_count",
@@ -913,7 +936,7 @@ static struct ctl_table nf_ct_netfilter_table[] = {
 		.data		= &nf_conntrack_max,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
+		.proc_handler	= nf_conntrack_max_sysctl,
 	},
 	{ }
 };
diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index af7dc6537758..d48f43328342 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -1156,7 +1156,7 @@ static int __init nf_nat_init(void)
 	if (nf_nat_htable_size < CONNTRACK_LOCKS)
 		nf_nat_htable_size = CONNTRACK_LOCKS;
 
-	nf_nat_bysource = nf_ct_alloc_hashtable(&nf_nat_htable_size, 0);
+	nf_nat_bysource = nf_ct_alloc_hashtable(&nf_nat_htable_size, 0, true);
 	if (!nf_nat_bysource)
 		return -ENOMEM;
 
-- 
2.17.1

