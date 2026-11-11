Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=94.136.29.106
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794395606;
	b=p6rEMcne6Bgd2jW/Ao4uc2EEKAyzORhEMKui3TLtcTXQC9YxWEOqQeSXu9+WyMJ5YmWL
	 ScCbIQdinLeMEZQfSIby2ux31H8oRiJGu8N6T1PQynUThuefJhwzK9P9nwwDsAhRrdgcX
	 KOecV+fWlUhfd/LYIMzkqGrHtMBsSCr4/JUvS+oGTcWYnD63VWkR/1JF9cGCYodXvcc/I
	 wU1kiapxj0ycqEPvVxmW5TLAKbfN/0f/nc1dsCFMwiimg5zzpuN4ePOiz+RlmO2fa/gMg
	 DgRFEPGNg5hkPADusJnATlQsIsQchpIHKp9gBe65S1bBE7uPmKEvT3+SPCzjSsmL4ng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794395606;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:
	 X-Bm-Milter-Handled:X-Bm-Transport-Timestamp;
	bh=Y0ME94W3ayVjJi/Q8oGCWWvasHa8KRmGNVoPpEDqrAg=;
	b=e68IChfNY/jZUYIoIKx5x20VQ9QE4drtTz5GVhHyHTfpA6oTSDosJFgBrtJKbga96BWD
	 +m3Nj/2qm37uGPXepmQr9mwtwHS9VykPH3fc9M/3Uk6cDPJROoXNiLZIz8ersdymCDxqC
	 HoJmZD+XC7qAUkatOrRWkQHj4EqAQV8pi+Wv8e7nPKzSL5oFjvGuQp4Ps8d9g6I6Q3qXY
	 /C1D8o+KwyJVkwJy4izqh2JwSVvXEJGldC9VhKRaNc4L5Ah1dEGFthhhhfEQ6JbuTGsOO
	 zGGAS8U7oHgLFrmevWcLaFdC5kd/Q5CeUh/9zcuZKhQfBSWOKnPlccn2UseQac3tLzw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=proxmox.com;
	spf=pass smtp.mailfrom=proxmox.com;
	arc=none smtp.remote-ip=94.136.29.106
Received: from proxmox-new.maurer-it.com (proxmox-new.maurer-it.com [94.136.29.106])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1C5D606A32A
	for <netfilter-devel@vger.kernel.org>; Wed, 11 Nov 2026 11:13:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A1C5D606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=proxmox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proxmox.com
Received: from proxmox-new.maurer-it.com (localhost.localdomain [127.0.0.1])
	by proxmox-new.maurer-it.com (Proxmox) with ESMTP id 30E1B41DFC;
	Wed, 11 Nov 2026 12:13:17 +0100 (CET)
From: Stefan Hanreich <s.hanreich@proxmox.com>
To: netfilter-devel@vger.kernel.org
Cc: Stefan Hanreich <s.hanreich@proxmox.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>
Subject: [PATCH nf-next 3/3] netfilter: nf_tables: use a counter for anonymous set names
Date: Wed, 11 Nov 2026 12:12:46 +0100
Message-ID: <20261111111250.226432-4-s.hanreich@proxmox.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261111111250.226432-1-s.hanreich@proxmox.com>
References: <20261111111250.226432-1-s.hanreich@proxmox.com>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Bm-Milter-Handled: 55990f41-d878-4baa-be0a-ee34c49e34d2
X-Bm-Transport-Timestamp: 1794395595979

To allocate a name for an anonymous set, nf_tables_set_alloc_name()
parses the name of every set in the table with sscanf() to find the
smallest number not in use for the given format. Loading a ruleset
with many anonymous sets therefore takes time quadratic in the number
of sets.

Take the number from a per-table counter instead and probe the
candidate name with a set lookup, skipping names that are still in
use. This is similar to anonymous chains, which are named after a
counter as well. The counter wraps around at INT_MAX, since the name
is formatted with %d. If all numbers are in use, -ENFILE is returned.

Numbers are no longer reused, and different formats share the same
counter. Userspace does not depend on the actual number: nft refers to
a new anonymous set by its set ID within the batch and never parses the
number from the name.

Signed-off-by: Stefan Hanreich <s.hanreich@proxmox.com>
---
 include/net/netfilter/nf_tables.h |  2 ++
 net/netfilter/nf_tables_api.c     | 52 ++++++++++++++-----------------
 2 files changed, 26 insertions(+), 28 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index d09959eea8ba..be129db1b82d 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1303,6 +1303,7 @@ static inline void nft_use_inc_restore(u32 *use)
  *	@flags: table flag (see enum nft_table_flags)
  *	@genmask: generation mask
  *	@nlpid: netlink port ID
+ *	@anon_set_num: next number for anonymous set names
  *	@name: name of the table
  *	@udlen: length of the user data
  *	@udata: user data
@@ -1324,6 +1325,7 @@ struct nft_table {
 					flags:8,
 					genmask:2;
 	u32				nlpid;
+	u32				anon_set_num;
 	char				*name;
 	u16				udlen;
 	u8				*udata;
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index c9b0070846b7..b46e32192f41 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4950,13 +4950,30 @@ struct nft_set *nft_set_lookup_global(const struct net *net,
 	return set;
 }
 
+static int nft_set_alloc_anon_num(struct nft_ctx *ctx, const char *name)
+{
+	struct nft_table *table = ctx->table;
+	char buf[NFT_SET_MAXNAMELEN];
+	u32 i, n;
+
+	for (i = 0; i <= INT_MAX; i++) {
+		n = table->anon_set_num;
+		table->anon_set_num = n < INT_MAX ? n + 1 : 0;
+
+		snprintf(buf, sizeof(buf), name, n);
+		if (IS_ERR(__nft_set_lookup(ctx->net, table, buf,
+					    nft_genmask_next(ctx->net))))
+			return n;
+	}
+
+	return -ENFILE;
+}
+
 static int nf_tables_set_alloc_name(struct nft_ctx *ctx, struct nft_set *set,
 				    const char *name)
 {
-	const struct nft_set *i;
 	const char *p;
-	unsigned long *inuse;
-	unsigned int n = 0, min = 0;
+	int n = 0;
 
 	p = strchr(name, '%');
 	if (p != NULL) {
@@ -4966,33 +4983,12 @@ static int nf_tables_set_alloc_name(struct nft_ctx *ctx, struct nft_set *set,
 		if (strnlen(name, NFT_SET_MAX_ANONLEN) >= NFT_SET_MAX_ANONLEN)
 			return -EINVAL;
 
-		inuse = (unsigned long *)get_zeroed_page(GFP_KERNEL);
-		if (inuse == NULL)
-			return -ENOMEM;
-cont:
-		list_for_each_entry(i, &ctx->table->sets, list) {
-			int tmp;
-
-			if (!nft_is_active_next(ctx->net, i))
-				continue;
-			if (!sscanf(i->name, name, &tmp))
-				continue;
-			if (tmp < min || tmp >= min + BITS_PER_BYTE * PAGE_SIZE)
-				continue;
-
-			set_bit(tmp - min, inuse);
-		}
-
-		n = find_first_zero_bit(inuse, BITS_PER_BYTE * PAGE_SIZE);
-		if (n >= BITS_PER_BYTE * PAGE_SIZE) {
-			min += BITS_PER_BYTE * PAGE_SIZE;
-			memset(inuse, 0, PAGE_SIZE);
-			goto cont;
-		}
-		free_page((unsigned long)inuse);
+		n = nft_set_alloc_anon_num(ctx, name);
+		if (n < 0)
+			return n;
 	}
 
-	set->name = kasprintf(GFP_KERNEL_ACCOUNT, name, min + n);
+	set->name = kasprintf(GFP_KERNEL_ACCOUNT, name, n);
 	if (!set->name)
 		return -ENOMEM;
 
-- 
2.47.3


