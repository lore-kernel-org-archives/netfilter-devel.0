Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43B94248F73
	for <netfilter-devel@vger.kernel.org>; Wed,  5 Nov 2025 16:48:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762361319; cv=none; b=hXI8WNzyy8UTkgwNY+0B/bpczw4quhaJ2iDMIR7kehym06M6dSHpPoQODqvwdhQKKINVYxSzxFADpidC+261fHCkCnMH/fa6liseJ5JvdXi+SZ87PDJVIgZgS2wf+oJF1wJWXtcEXw95hmO4AMVjhubXqL8yIftrXr4b4JSON/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762361319; c=relaxed/simple;
	bh=fPUN4V2FHwPfDkYvH+53zvNCywJtIst7jd5TkXPINSY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H1iNes1CBNUUuRFpo69ug6hb50UT3DHHY3sXJmmc/UgRe12NoMkjVaXWraBLO+YzXkf69V96iZqi5ocqyAX6HbYsoXJ+rM+KqXfHK/7zLm7i7LnMpSVoRTGSkItEtIUaYgcxaMo7tO99z0M2nLCR9HHwHmMvrq4UbLzdFHmQQKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id BF0386020C; Wed,  5 Nov 2025 17:48:36 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: pablo@netfilter.org
Subject: [RFC nf-next 05/11] netfilter: conntrack: split hashtable auto-size to helper function
Date: Wed,  5 Nov 2025 17:47:59 +0100
Message-ID: <20251105164805.3992-6-fw@strlen.de>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251105164805.3992-1-fw@strlen.de>
References: <20251105164805.3992-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Split the 'figure out a good default hash table size' into a
new function.  We will later no longer do the allocation right away,
but will still do the initial size computation.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_conntrack_core.c | 33 ++++++++++++++++++++-----------
 1 file changed, 21 insertions(+), 12 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index fc9312bfa616..1f938ef8e59a 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -2636,9 +2636,27 @@ int nf_conntrack_set_hashsize(const char *val, const struct kernel_param *kp)
 	return nf_conntrack_hash_resize(hashsize);
 }
 
-int nf_conntrack_init_start(void)
+static unsigned int nf_conntrack_htable_autosize(void)
 {
 	unsigned long nr_pages = totalram_pages();
+	unsigned int ht_size;
+
+	ht_size = (((nr_pages << PAGE_SHIFT) / 16384)
+			   / sizeof(struct hlist_head));
+	if (BITS_PER_LONG >= 64 &&
+	    nr_pages > (4 * (1024 * 1024 * 1024 / PAGE_SIZE)))
+		ht_size = 262144;
+	else if (nr_pages > (1024 * 1024 * 1024 / PAGE_SIZE))
+		ht_size = 65536;
+
+	if (nf_conntrack_htable_size < 1024)
+		ht_size = 1024;
+
+	return ht_size;
+}
+
+int nf_conntrack_init_start(void)
+{
 	int max_factor = 8;
 	int ret = -ENOMEM;
 	int i;
@@ -2650,17 +2668,8 @@ int nf_conntrack_init_start(void)
 		spin_lock_init(&nf_conntrack_locks[i]);
 
 	if (!nf_conntrack_htable_size) {
-		nf_conntrack_htable_size
-			= (((nr_pages << PAGE_SHIFT) / 16384)
-			   / sizeof(struct hlist_head));
-		if (BITS_PER_LONG >= 64 &&
-		    nr_pages > (4 * (1024 * 1024 * 1024 / PAGE_SIZE)))
-			nf_conntrack_htable_size = 262144;
-		else if (nr_pages > (1024 * 1024 * 1024 / PAGE_SIZE))
-			nf_conntrack_htable_size = 65536;
-
-		if (nf_conntrack_htable_size < 1024)
-			nf_conntrack_htable_size = 1024;
+		nf_conntrack_htable_size = nf_conntrack_htable_autosize();
+
 		/* Use a max. factor of one by default to keep the average
 		 * hash chain length at 2 entries.  Each entry has to be added
 		 * twice (once for original direction, once for reply).
-- 
2.51.0

