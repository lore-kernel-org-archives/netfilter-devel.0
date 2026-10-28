Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.216.245.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793199454;
	b=beKxrXwSgW1j+Wc8cfr5Kv+ehgZgH9MmIWFAnrvA9MdazwZ8jfQPkc6As9Y2d+0Pj9Nd
	 e7xduR7goVoGjjxPBRLfspdXL/1pXaMW6WI++8GSKIGJSPqdO0KOeN+mbTL+yKTlUDpiu
	 96zzy0lHvUIJoVfMvKOtDiQdQZaHWAIkjGfhCtjOt9vXvlfQGA8X63uqc5E4xKNTyv4rG
	 Qx8DkhQ3lXuIpI90QYyXbsXxwYANW2OrFiJQdYWT9BkZ0hdQoZlgYoBEOYqIkts2xFrlD
	 ninTaF0YGg7wC5bTHH3rBTiEeiY6ByuJxh4tAwMbRyiG9TN+gWRd0NCmAXWxcCANSYA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793199454;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=mN8oF+BCkugqpRVBISv+1ADUUK8sLtwOwOzCITW48e8=;
	b=qWYPnqTjG+rEVvv4CJZsrdZJlKFphVbSrPFT3A0QV4rnEyUhdirNwan7msBtddNCvCbF
	 /vKWzttPpqwci2HoShczM5FZP9PB9+eLVHEmKi5xfdmRlUhFwpfbIjA34WIezGndOXPQR
	 O0QzmfxwU/spndOx4snMXobiRjJwo8QGXDKRIxN+u2e54mFMj4TcLf6sy0PBxpMKL+Vbk
	 Mm9jDmV5xSeJ/YxqLEBaeuunMC6r2lFt+snETWL7CXca5F/jlrRNJz7hFN744kgWlATxU
	 9N+z7aft6xhKSB3s4u2JFY3IApkyf6oaGErIVZ8N2ve+QDzBLEZR2pcg3ZJVn4e6TMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=strlen.de;
	spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc;
	arc=none smtp.remote-ip=91.216.245.30
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54277606A31A
	for <netfilter-devel@vger.kernel.org>; Wed, 28 Oct 2026 14:57:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 54277606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id A3583609D0; Wed, 28 Oct 2026 15:57:32 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH libftnl 11/12] src: udata: clamp buf->end to actally copied size
Date: Wed, 28 Oct 2026 15:56:31 +0100
Message-ID: <20261028145632.7089-12-fw@strlen.de>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261028145632.7089-1-fw@strlen.de>
References: <20261028145632.7089-1-fw@strlen.de>
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

LLM finding:

nftnl_udata_buf_space() doesn't tolerate buf->end moving
past the size.

Clamp the end pointer in udata_buf_put so that it matches
what was actually copied.  After this, nftnl_udata_buf_space()
will return 0 if the space was exhausted.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/udata.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/src/udata.c b/src/udata.c
index a1956571ef5f..11de73402569 100644
--- a/src/udata.c
+++ b/src/udata.c
@@ -53,7 +53,10 @@ EXPORT_SYMBOL(nftnl_udata_buf_put);
 void nftnl_udata_buf_put(struct nftnl_udata_buf *buf, const void *data,
 			 uint32_t len)
 {
-	memcpy(buf->data, data, len <= buf->size ? len : buf->size);
+	if (len > buf->size)
+		len = buf->size;
+
+	memcpy(buf->data, data, len);
 	buf->end = buf->data + len;
 }
 
-- 
2.55.0

