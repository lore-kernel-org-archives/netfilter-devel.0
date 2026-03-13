Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F5D23A9626;
	Fri, 13 Mar 2026 15:06:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773414411; cv=none; b=ouqyEg2QJuK2NFmHD11wXJ9zRaHjKT5Km7aJ2yrWu7aZhd93lZYx1Kh2GGVroVFBA5klImFagcCFdTG8XaQjMAFaHypJBCCshm+Mblc7sGLO4d2E+/Q9QYpHIQ362wldeVZzCZZkY5wMVhFQ1rt/5a3HLj9p19aK+Urp+gFk/AM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773414411; c=relaxed/simple;
	bh=5oZ+T1AH6Jd+Z7ABoiFCmOaL+LbqE0lg4sFRT4924AA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KpFaCUJQz9OzL12pEYEd5U1rhXEg8TTjC+24SMrGLawLRI9uMk+ImG081qLREEY6/xepmi9JV5ql4EdYcACcgd9n8MeKtxInhhggp8VFZuyAeVxCgdoFJ81pqkDlHkdGzuNvCQsUFyASdIvLpyEVfy2uKLxDr5z89mi3tY08QIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 9D46460492; Fri, 13 Mar 2026 16:06:47 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net 06/11] netfilter: nf_conntrack_h323: fix OOB read in decode_int() CONS case
Date: Fri, 13 Mar 2026 16:06:09 +0100
Message-ID: <20260313150614.21177-7-fw@strlen.de>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260313150614.21177-1-fw@strlen.de>
References: <20260313150614.21177-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jenny Guanni Qu <qguanni@gmail.com>

In decode_int(), the CONS case calls get_bits(bs, 2) to read a length
value, then calls get_uint(bs, len) without checking that len bytes
remain in the buffer. The existing boundary check only validates the
2 bits for get_bits(), not the subsequent 1-4 bytes that get_uint()
reads. This allows a malformed H.323/RAS packet to cause a 1-4 byte
slab-out-of-bounds read.

Add a boundary check for len bytes after get_bits() and before
get_uint().

Fixes: 5e35941d9901 ("[NETFILTER]: Add H.323 conntrack/NAT helper")
Reported-by: Klaudia Kloc <klaudia@vidocsecurity.com>
Reported-by: Dawid Moczadło <dawid@vidocsecurity.com>
Signed-off-by: Jenny Guanni Qu <qguanni@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_conntrack_h323_asn1.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/nf_conntrack_h323_asn1.c b/net/netfilter/nf_conntrack_h323_asn1.c
index 62aa22a07876..c972e9488e16 100644
--- a/net/netfilter/nf_conntrack_h323_asn1.c
+++ b/net/netfilter/nf_conntrack_h323_asn1.c
@@ -331,6 +331,8 @@ static int decode_int(struct bitstr *bs, const struct field_t *f,
 		if (nf_h323_error_boundary(bs, 0, 2))
 			return H323_ERROR_BOUND;
 		len = get_bits(bs, 2) + 1;
+		if (nf_h323_error_boundary(bs, len, 0))
+			return H323_ERROR_BOUND;
 		BYTE_ALIGN(bs);
 		if (base && (f->attr & DECODE)) {	/* timeToLive */
 			unsigned int v = get_uint(bs, len) + f->lb;
-- 
2.52.0

