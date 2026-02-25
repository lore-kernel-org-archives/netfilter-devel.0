Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1AB13451BB;
	Wed, 25 Feb 2026 13:06:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772024791; cv=none; b=PPqnPqBiG0GLWPioaMjvt1eUuttqt0ONh94MDAvHXfdOHd0vTgzUhFucTBjuhfKWC1aeUZItVYLguGPMBZW+Dxy/71SSzfARYVhRDvY5Q6K2qN/4tXWrCYZwTzVVqleWo1EgFgtPuMe/mmOcXnUqQtjhTOgcvCAmUqSKeTycXwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772024791; c=relaxed/simple;
	bh=WtJrOkNhHDh2hiZPhbIe7xf/AHKVEH86hLgG4hXQBPA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uXRM8cgrZfICIipQFZmPujNAasNAggyGhPh8qZQozc3bE8JrphCk8nh0+ZtR4LS8cveZYwYDgR+vK6UDyBu+vkmFSfgBqjdCwWhG9KaXdQdd802ERHrffuedOa3shtIqtvcv+yElwmrHVmOMNT8BMeC3N9F2obPkOtZB1lSJdzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id D473160516; Wed, 25 Feb 2026 14:06:27 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net 1/2] netfilter: nf_conntrack_h323: fix OOB read in decode_choice()
Date: Wed, 25 Feb 2026 14:06:18 +0100
Message-ID: <20260225130619.1248-2-fw@strlen.de>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260225130619.1248-1-fw@strlen.de>
References: <20260225130619.1248-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Vahagn Vardanian <vahagn@redrays.io>

In decode_choice(), the boundary check before get_len() uses the
variable `len`, which is still 0 from its initialization at the top of
the function:

    unsigned int type, ext, len = 0;
    ...
    if (ext || (son->attr & OPEN)) {
        BYTE_ALIGN(bs);
        if (nf_h323_error_boundary(bs, len, 0))  /* len is 0 here */
            return H323_ERROR_BOUND;
        len = get_len(bs);                        /* OOB read */

When the bitstream is exactly consumed (bs->cur == bs->end), the check
nf_h323_error_boundary(bs, 0, 0) evaluates to (bs->cur + 0 > bs->end),
which is false.  The subsequent get_len() call then dereferences
*bs->cur++, reading 1 byte past the end of the buffer.  If that byte
has bit 7 set, get_len() reads a second byte as well.

This can be triggered remotely by sending a crafted Q.931 SETUP message
with a User-User Information Element containing exactly 2 bytes of
PER-encoded data ({0x08, 0x00}) to port 1720 through a firewall with
the nf_conntrack_h323 helper active.  The decoder fully consumes the
PER buffer before reaching this code path, resulting in a 1-2 byte
heap-buffer-overflow read confirmed by AddressSanitizer.

Fix this by checking for 2 bytes (the maximum that get_len() may read)
instead of the uninitialized `len`.  This matches the pattern used at
every other get_len() call site in the same file, where the caller
checks for 2 bytes of available data before calling get_len().

Fixes: ec8a8f3c31dd ("netfilter: nf_ct_h323: Extend nf_h323_error_boundary to work on bits as well")
Signed-off-by: Vahagn Vardanian <vahagn@redrays.io>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_conntrack_h323_asn1.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_h323_asn1.c b/net/netfilter/nf_conntrack_h323_asn1.c
index 540d97715bd2..62aa22a07876 100644
--- a/net/netfilter/nf_conntrack_h323_asn1.c
+++ b/net/netfilter/nf_conntrack_h323_asn1.c
@@ -796,7 +796,7 @@ static int decode_choice(struct bitstr *bs, const struct field_t *f,
 
 	if (ext || (son->attr & OPEN)) {
 		BYTE_ALIGN(bs);
-		if (nf_h323_error_boundary(bs, len, 0))
+		if (nf_h323_error_boundary(bs, 2, 0))
 			return H323_ERROR_BOUND;
 		len = get_len(bs);
 		if (nf_h323_error_boundary(bs, len, 0))
-- 
2.52.0

