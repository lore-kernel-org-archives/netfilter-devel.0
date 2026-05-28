Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFF243DEAE4
	for <netfilter-devel@vger.kernel.org>; Thu, 28 May 2026 11:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779966639; cv=none; b=JPpE5AvSMSz/KbkX90Cnwxk5oGkm7NFb9NstPU6E6ZP1eUcd2VRhHHX2Asf8lvYxfD/9BzGBJK1gvh8uFcjASE82zNgZqSyL+KyhU0Zp1yWt15npp034+H7Yx0QH8BJ1IqNa9GYyFSoNmuAwcEaoumjKXgaOmu+anj4ees4j1bA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779966639; c=relaxed/simple;
	bh=XPSTbIkDBUGzKWNlU8J2VTz2QiFw8sDMnEq+q8lxl+4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Vh1dKJRTOyCdiGZMIURKdxH/8q6XrmmGWjzv9478f+HTMFgY9pTWSfgCgTfGtCgcGOVDq3w95GBWk8gTriSwAKmg/MT5SENkFmoYo3XZEnnj7ubGQMfLIFqmjDYzPJiaK++oRKGZMxZdxf2nAKSZIBMLXR9T+NI7AmvZE/ThQ2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=E5HBueXP; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="E5HBueXP"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779966634;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=lIyMxMe34ti5OGqYHU2XYLd1o4czF6IJRVjnBmLGfX8=;
	b=E5HBueXP3Y2hugKe9rbkc61PZ+5ywT2pHbQRXXy6rLxukDe5Z/R09YRBK8lPheONkXW83o
	ZrEkHeTEYNsONV7TfJDlHuVB3JSeOKEq1tDnZ8NiZRtloRf7B5MFnKekjx/YP+dESs9mev
	7Rl8Co7qE0yw5rWnMncahJL5Ef+LEXE=
From: Jiayuan Chen <jiayuan.chen@linux.dev>
To: fw@strlen.de,
	pablo@netfilter.org,
	netfilter-devel@vger.kernel.org
Cc: Jiayuan Chen <jiayuan.chen@linux.dev>
Subject: [PATCH nf v2] netfilter: nft_ct: bail out on template ct in get eval
Date: Thu, 28 May 2026 19:09:19 +0800
Message-ID: <20260528110919.28952-1-jiayuan.chen@linux.dev>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

I noticed this issue while looking at a historic syzbot report [1].

A rule like the one below is enough to trigger the bug:

    table ip t {
        chain pre {
            type filter hook prerouting priority raw;
            ct zone set 1
            ct original saddr 1.2.3.4 accept
        }
    }

The first expression attaches a per-cpu template ct via
nft_ct_set_zone_eval() (nf_ct_tmpl_alloc -> kzalloc, tuple is all
zero, nf_ct_l3num(ct) == 0). The next expression then calls
nft_ct_get_eval() on the same skb, treats the template as a real ct
and hits the 16-byte memcpy path. With dreg at NFT_REG32_15 this
overflows past struct nft_regs on the kernel stack; with smaller
dreg values it silently clobbers adjacent registers.

Reject template ct at the eval entry and in nft_ct_get_fast_eval(),
mirroring the check nft_ct_set_eval() already has. Additionally,
bound the address copy in NFT_CT_SRC / NFT_CT_DST by priv->len
instead of by nf_ct_l3num(ct): nf_ct_get_tuple() zeroes the tuple
before pkt_to_tuple() fills in only the protocol-relevant leading
bytes, so the trailing bytes of tuple->{src,dst}.u3.all are
well-defined zero. priv->len is validated at rule load, so the
copy size is now bounded by the destination register rather than
by an untrusted field on the conntrack.

[1]: https://syzkaller.appspot.com/bug?id=389cf09cb72926114fce90dc85a2c3231dcb647c

Fixes: 45d9bcda21f4 ("netfilter: nf_tables: validate len in nft_validate_data_load()")
Suggested-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
---
v2: - reject template ct before reading ct fields/tuple.
    - bound NFT_CT_SRC / NFT_CT_DST address copy by priv->len instead of
      by nf_ct_l3num(ct).
v1: https://lore.kernel.org/netfilter-devel/20260528042620.263828-1-jiayuan.chen@linux.dev/
---
 net/netfilter/nft_ct.c      | 8 +++-----
 net/netfilter/nft_ct_fast.c | 2 +-
 2 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index fa2cc556331c..357513c6dcea 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -78,7 +78,7 @@ static void nft_ct_get_eval(const struct nft_expr *expr,
 		break;
 	}
 
-	if (ct == NULL)
+	if (!ct || nf_ct_is_template(ct))
 		goto err;
 
 	switch (priv->key) {
@@ -180,12 +180,10 @@ static void nft_ct_get_eval(const struct nft_expr *expr,
 	tuple = &ct->tuplehash[priv->dir].tuple;
 	switch (priv->key) {
 	case NFT_CT_SRC:
-		memcpy(dest, tuple->src.u3.all,
-		       nf_ct_l3num(ct) == NFPROTO_IPV4 ? 4 : 16);
+		memcpy(dest, tuple->src.u3.all, priv->len);
 		return;
 	case NFT_CT_DST:
-		memcpy(dest, tuple->dst.u3.all,
-		       nf_ct_l3num(ct) == NFPROTO_IPV4 ? 4 : 16);
+		memcpy(dest, tuple->dst.u3.all, priv->len);
 		return;
 	case NFT_CT_PROTO_SRC:
 		nft_reg_store16(dest, (__force u16)tuple->src.u.all);
diff --git a/net/netfilter/nft_ct_fast.c b/net/netfilter/nft_ct_fast.c
index e684c8a91848..ecf7b3a404be 100644
--- a/net/netfilter/nft_ct_fast.c
+++ b/net/netfilter/nft_ct_fast.c
@@ -30,7 +30,7 @@ void nft_ct_get_fast_eval(const struct nft_expr *expr,
 		break;
 	}
 
-	if (!ct) {
+	if (!ct || nf_ct_is_template(ct)) {
 		regs->verdict.code = NFT_BREAK;
 		return;
 	}
-- 
2.43.0

