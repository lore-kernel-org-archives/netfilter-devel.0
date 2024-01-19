Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B09BD31A61
	for <netfilter-devel@vger.kernel.org>; Fri, 19 Jan 2024 12:34:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705667691; cv=none; b=hLt+PavtHfGIvfjxOerb7agYZGkFxnxKNvRXkufUGwcLueD2ybk65GC5OlvzbR99DaZ9ZyRw5xovwIth6A/8eI7hH+BJFB7j5AsYP220oxbPbCZXe6mVYTXhBBRmbbDh4S7MCjAa7fU8kbbdb1rd2P0RyiWIGd18QpOMszWMeOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705667691; c=relaxed/simple;
	bh=dCRdB2XG05EaEhUtDKM7V3CSknc7Ky9QIYmfhEaV190=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=sB0RjlxtkWV/TIB1QSqxzOK2qhRlD0MpOnKh4y9slNt4vvUvoMKh8gJKECONqErfTGwMI0+0j0FTP7HFbiPOH8PAHsajSuOH4X+eA6vJZ44Pr4gY2nGmzctvSNR8Yi+pjd0f/331ft5a0EcEA73XJ+NGvpxbnxy9o0tyBXPKJto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rQo54-0007yf-9V; Fri, 19 Jan 2024 13:34:42 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf] netfilter: nf_tables: restrict anonymous set and map names to 16 bytes
Date: Fri, 19 Jan 2024 13:34:32 +0100
Message-ID: <20240119123437.5745-1-fw@strlen.de>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

nftables has two types of sets/maps, one where userspace defines the
name, and anonymous sets/maps, where userspace defines a template name.

For the latter, kernel requires presence of exactly one "%d".
nftables uses "__set%d" and "__map%d" for this.  The kernel will
expand the format specifier and replaces it with the smallest unused
number.

As-is, userspace could define a template name that allows to move
the set name past the 256 bytes upperlimit (post-expansion).

I don't see how this could be a problem, but I would prefer if userspace
cannot do this, so add a limit of 16 bytes for the '%d' template name.

16 bytes is the old total upper limit for set names that existed when
nf_tables was merged initially.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_tables_api.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 4b55533ce5ca..02f45424644b 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -24,6 +24,7 @@
 #include <net/sock.h>
 
 #define NFT_MODULE_AUTOLOAD_LIMIT (MODULE_NAME_LEN - sizeof("nft-expr-255-"))
+#define NFT_SET_MAX_ANONLEN 16
 
 unsigned int nf_tables_net_id __read_mostly;
 
@@ -4413,6 +4414,9 @@ static int nf_tables_set_alloc_name(struct nft_ctx *ctx, struct nft_set *set,
 		if (p[1] != 'd' || strchr(p + 2, '%'))
 			return -EINVAL;
 
+		if (strnlen(name, NFT_SET_MAX_ANONLEN) >= NFT_SET_MAX_ANONLEN)
+			return -EINVAL;
+
 		inuse = (unsigned long *)get_zeroed_page(GFP_KERNEL);
 		if (inuse == NULL)
 			return -ENOMEM;
-- 
2.43.0

