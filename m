Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795652162;
	b=OKHQJTd0HOLu4wTrxpLHAgDFNN9aRaEGnGc5UWdFaRqd2K5sGDBVNNykP9M90vzTizHV
	 xUL7NcdDrdDa4mKwGz8biTNTpPkHWxv/ZBRo6+KQP/A5vdSCPcz3Uu1KFHBQM6rpF1Lh1
	 GGSCnh9VzNw1RLVKbvDcigj4cZlt0RwWX5k293GJAam5Jqyb8Do7aw0OEevDrSPNXuL86
	 ExctRvLWdb0v50w5SAMcuJ/UhZkamNs+clE/bLiFKr3+DTXCOgJ/J4w1TX4DHU4w2d/jx
	 R0S3QvGHq8y2uZokKTf5EurO4ltWnHl5Qjw13cdqgmBpN+y6r9UmJ8zYpbdyScgtYSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795652162;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=bnDcNGUSqKodEMXSYy83GbqNhBxNVu8NV3IpVzubDGU=;
	b=PhV7UEt61HkUz5HCkUuxNfiCBP8pJikVQ9JB4y3G3fM9XSnjXlO5ucRBGcB+wKAdyLz2
	 yR/8oae4cYNUCEPVHkQVBGY/3/2g1P5ClmoFltbl1dAfOzVs3SfQnCccxQYS/bREczb4b
	 6o7gh59yQgLG4HEFGXU/IIWwmv8ufdjxwDzvaNMh7tQ4ztOz6wqycvib/P7my0AvfHkhU
	 YRwE2ejLVl9ANUPENvbs2WavsnIe64POIWInGvvEuAbgl+3S2IpwmY4MJnncIM8BIM+Xb
	 zCtQOlRQMkYA9tLeKi6ahAY5upmyC+M8sfrn6MHwyAknxra2kpXGFHGOKTVyxZTC/gw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=zml.net;
	spf=pass smtp.mailfrom=zml.net;
	dkim=pass header.d=zml.net header.i=@zml.net header.a=rsa-sha256 header.s=google header.b=L9ELt9Mz;
	arc=none smtp.remote-ip=209.85.216.48
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2F7F606A321
	for <netfilter-devel@vger.kernel.org>; Thu, 26 Nov 2026 00:16:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A2F7F606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=zml.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zml.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=zml.net header.i=@zml.net header.a=rsa-sha256 header.s=google header.b=L9ELt9Mz
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-3b487f44ee0so2477108a91.0
        for <netfilter-devel@vger.kernel.org>; Wed, 25 Nov 2026 16:16:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=zml.net; s=google; t=1795652161; x=1796256961; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=bnDcNGUSqKodEMXSYy83GbqNhBxNVu8NV3IpVzubDGU=;
        b=L9ELt9MzP9RV8EyZKEdGuPdeIH+ICd3o7qbmaQNsHtm5g0hqAerf9yEJi208gnLS+n
         HJuWFTdPQZy9PE34Rc9Q3NZLlbHhhxH1TC3EokVkOfr4BX6aAMwd3uKeT7SfnBskdK2A
         hJovNitTYQhExMGo6puScHNPwGKXIVGjWqXzmHB9bZMdtS5t2lN367MGj2f5QtgkRFMn
         5sKlLzoxfrSmg3AQaCFAmgTn6zPm9CyQP0YkxQvQEqHV4rRfcIczOzjmw8Fe5YFkHDtI
         LQH0/dXzZy8gWc7gCtnV3o46lSrEiZtizMRgT1NDLOrATWFqvlqhloXm4PedfALtmY2v
         Fm+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795652161; x=1796256961;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bnDcNGUSqKodEMXSYy83GbqNhBxNVu8NV3IpVzubDGU=;
        b=WfDCl/Cy5NTtOwiHVOiS9KC3J770mm0HT5ATgII9gYdUB1+h0mPjT9Zbv7b3ee38v4
         O/7m6SGzMUy2TJ1XKsRxZ1PXdtB50G9sOjGKEwCAAKDbnBF/RYPvuxU9mtoS1+jNu+3t
         pk3J27dj5yAkxrofi8sDeVFbWh9YYWPdrkwwiJCbGFHe4AalqFFPQd8YQTtB2uoW2P0Z
         LrPnB4UpiBfhieFUPil5FhTOGNr7van46jzOpVWdxIodsyXg0MK9sqjvPnHGB3g5vxrT
         JpuOh7nvjZqQP9LHhbokNae9KaB/vcJPoPepcruCUmYtnP+wal7FrOff/pH2ykJ0urOX
         gvTw==
X-Gm-Message-State: APuU4Z95lLtZ10ErvMlxDL9mN2QE7OC7t59n+EKC/S2f/IWlt+FwsuHJ
	FAl+66W4V/ZjHIAQ10IsxqBMKt6elIgLAM+hMR02KrTDtZ8kw9BfpJLgVt4Mu0S38ho0Lf6xQ6p
	9TWXA2ao=
X-Gm-Gg: AZFdTZcgGT9+lDQyj0SRfDLhzXfJN5kQ974cwL4jDG9K9b3xqbedG/mkQYWkffMfGQ/
	esYXpOuSbdkY7Abu6SW9qKJ5wCzUobbf5gv5HPqyGd3s303soSHksKDQsrboQZFQCPZwhC1tGVE
	LGrWa6wgs2cbxQW3z4wdGM7COPZmtzfr7xiNKurEJKBitHlsZLxdIPIook1omxypSLPWnniEJ6Z
	nuIZwrQ+UQRvr5hDqyjlX7buPZkiWeMtTJuBXeTI9DX28NZqXEwTNDWYxJG3ugCnavX6BOYbHJk
	j0CpWQlXFTelS7oGP99VY72hA5qe9GO6FCWWNUGFTAxyZg8mGSxME7M5ZUW9CuSJG8EY7H98tdE
	e7aUdcq18/DYdoU74+O4V+PUw8HZOXerenn7rZtZzkl/MRz5mDRsyadBoRzyE+xbaV23aXcyE3i
	LG+a1yIq11O0HTK6Y3T5gKt9eDGxcVPLLrx1VYcmwMYcXAWsPCid77MMk5uwm4uDcQZuIU7mGF7
	VY6EQ6utmao5Ta4puvZ71JUs4bDN78hd6+eAJjCP34/DhhSoffU+YZlMQ0NhJKcw8bkK5YBwmEn
	+9n1QendlfHhjNMDYHf2IzVwpFZyKb8gilu6ThX/oBq07+Z3Gobqr0CQBk1NTuvbBDq95ZI0IWd
	cffPDjfjYhFNktupqM9dmsMnrSyJe6QHS
X-Received: by 2002:a17:90b:2c86:b0:3ac:9c37:9430 with SMTP id 98e67ed59e1d1-3b41c9b2bbfmr18831032a91.21.1795652160935;
        Wed, 25 Nov 2026 16:16:00 -0800 (PST)
Received: from localhost.localdomain (174-21-130-235.tukw.qwest.net. [174.21.130.235])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b40a878d50sm32157818a91.11.2026.11.25.16.15.59
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 25 Nov 2026 16:16:00 -0800 (PST)
From: Zach Loafman <zml@zml.net>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	Zach Loafman <zml@zml.net>
Subject: [PATCH] netfilter: nft_dynset: check extension template errors
Date: Wed, 25 Nov 2026 16:15:56 -0800
Message-ID: <20261126001556.69645-1-zml@zml.net>
X-Mailer: git-send-email 2.56.1
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

nft_dynset_init() currently adds expressions before timeout metadata and
ignores all nft_set_ext_add_length() errors.

For a map with 64-byte keys, 64-byte values and two packet-limit
expressions, the template is 264 bytes long before timeout is added.  The
timeout start therefore cannot be represented in the extension's u8
offset and nft_set_ext_add_length() returns -EINVAL.  Ignoring this error
leaves the timeout offset unset, so packet-created elements do not expire
automatically.

Add timeout before expressions, as the control-plane element constructor
does.  This places timeout at offset 144 and expressions at offset 160; the
resulting 280-byte total remains valid because only individual extension
starts and lengths are u8.  Propagate errors from every template builder so
layouts rejected by those builders fail construction and use the existing
expression unwind.

With a 30-second default set timeout, a raw nfnetlink reproducer creates
the rule and inserts elements on both the unpatched and patched kernels.
The unpatched element dump lacks EXPIRATION; the patched dump includes it.
The missing extension also prevents the element from expiring during
normal set expiration and garbage collection.

This fixes incorrect element lifetime and resource retention.  No
memory-safety primitive has been identified.

Fixes: 48b0ae046ee9 ("netfilter: nftables: netlink support for several set element expressions")
Signed-off-by: Zach Loafman <zml@zml.net>

---
 net/netfilter/nft_dynset.c | 33 +++++++++++++++++++++++----------
 1 file changed, 23 insertions(+), 10 deletions(-)

diff --git a/net/netfilter/nft_dynset.c b/net/netfilter/nft_dynset.c
index fa4da694e92d..8fc2ec2212f4 100644
--- a/net/netfilter/nft_dynset.c
+++ b/net/netfilter/nft_dynset.c
@@ -120,7 +120,7 @@ void nft_dynset_eval(const struct nft_expr *expr,
 		regs->verdict.code = NFT_BREAK;
 }
 
-static void nft_dynset_ext_add_expr(struct nft_dynset *priv)
+static int nft_dynset_ext_add_expr(struct nft_dynset *priv)
 {
 	u8 size = 0;
 	int i;
@@ -128,8 +128,8 @@ static void nft_dynset_ext_add_expr(struct nft_dynset *priv)
 	for (i = 0; i < priv->num_exprs; i++)
 		size += priv->expr_array[i]->ops->size;
 
-	nft_set_ext_add_length(&priv->tmpl, NFT_SET_EXT_EXPRESSIONS,
-			       sizeof(struct nft_set_elem_expr) + size);
+	return nft_set_ext_add_length(&priv->tmpl, NFT_SET_EXT_EXPRESSIONS,
+				      sizeof(struct nft_set_elem_expr) + size);
 }
 
 static struct nft_expr *
@@ -317,16 +317,29 @@ static int nft_dynset_init(const struct nft_ctx *ctx,
 	}
 
 	nft_set_ext_prepare(&priv->tmpl);
-	nft_set_ext_add_length(&priv->tmpl, NFT_SET_EXT_KEY, set->klen);
-	if (set->flags & NFT_SET_MAP)
-		nft_set_ext_add_length(&priv->tmpl, NFT_SET_EXT_DATA, set->dlen);
+	err = nft_set_ext_add_length(&priv->tmpl, NFT_SET_EXT_KEY, set->klen);
+	if (err < 0)
+		goto err_expr_free;
 
-	if (priv->num_exprs)
-		nft_dynset_ext_add_expr(priv);
+	if (set->flags & NFT_SET_MAP) {
+		err = nft_set_ext_add_length(&priv->tmpl, NFT_SET_EXT_DATA,
+					     set->dlen);
+		if (err < 0)
+			goto err_expr_free;
+	}
 
 	if (set->flags & NFT_SET_TIMEOUT &&
-	    (timeout || READ_ONCE(set->timeout)))
-		nft_set_ext_add(&priv->tmpl, NFT_SET_EXT_TIMEOUT);
+	    (timeout || READ_ONCE(set->timeout))) {
+		err = nft_set_ext_add(&priv->tmpl, NFT_SET_EXT_TIMEOUT);
+		if (err < 0)
+			goto err_expr_free;
+	}
+
+	if (priv->num_exprs) {
+		err = nft_dynset_ext_add_expr(priv);
+		if (err < 0)
+			goto err_expr_free;
+	}
 
 	priv->timeout = timeout;
 
-- 
2.52.0
