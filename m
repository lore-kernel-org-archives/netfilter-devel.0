Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F090377F36;
	Wed, 24 Jan 2024 19:12:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706123578; cv=none; b=Edpg/h0CXOZsN8af8IU/FhJi0qwF2PVroigZVZa8y+l29OPjXL1bJpKWidMCe7uqxwuT9GsuFYgJYTUptqSaRuaKsoDsW8u9uiiY0wtfwFc8akGFWho2XCUjbm+OBL/wdO1U0ZDXeCyi0h8On6EfkFQrO3MP4kHMroDCbVYybf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706123578; c=relaxed/simple;
	bh=h8SBTN0jD3O+Ny/D0+C4hV6nCQFkgNpSBX22nFjQW2c=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=be0B+NZtawBWWLbjfshdDhAP2F9yH3db87+elssD2GkFVgHrbaqh0C9TGFAwx2Oxxa60SoXxj8ZeK88B/mCRKlKB5AH/40QQl6oHgqKd46Unoml95AlY3RXy6jVzFkf3GiaGOf2qxN6C+yLcthkHj5YVwtbprrhAjbKasVjmzos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de
Subject: [PATCH net 4/6] netfilter: nf_tables: restrict anonymous set and map names to 16 bytes
Date: Wed, 24 Jan 2024 20:12:46 +0100
Message-Id: <20240124191248.75463-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240124191248.75463-1-pablo@netfilter.org>
References: <20240124191248.75463-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

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

Fixes: 387454901bd6 ("netfilter: nf_tables: Allow set names of up to 255 chars")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
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
2.30.2

