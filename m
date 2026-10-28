Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.216.245.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793199446;
	b=Ft3PxUHqtxLXX6f/kvMduyYZgblN1UPwPRsUlfDQD09jopw0qqW7NOlLcbz0WlkQEya7
	 QDdLsoamMr/ZGAKkrpCCyScnBprk9BSdL5k0t0ef0uBh0eXozu3VVJqDQq9w+NHuZFoDo
	 KY2rCP2IsJo21NdCB4xcNwFUvSVXbWbi0+WXQ/JQHpt13vSliB6fEcF9mWr1Kk5Efvov/
	 BHkjEvV3FFoqawuxA1g0sIgiiimhCXUPPuOFczIgO/FLlVrnpelQ9deyZuZcMb3BgGmLX
	 lLYaWDfLYS46Wwp0BoVTbq400N3LJtULmMaNEy6hjng4WU4ERZJF4cQ39TxXevqAv5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793199446;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=/+LhhO/3h9ac48SwxL2RtVMYqA41WzI+Egle+DK29rE=;
	b=ackOnR2VylnZv2XUswVAae0D9bpuBwwMNoOaJIlByXhT/wyaHLdp8b0ij8zA1dLfNuGn
	 ZiBqjF6EkenXVhyv76Vlwb24T8iaF2/m9RSCaGNSPZaSWjG+VlI1dZrrO7Jj/gL6MzFuN
	 jtU+Pq3ukBV0S3C/tPSXGGoqQavlTXC+nxXhevRaqkVKWmNYDW8Sa29yCI4mYbPW/1AiF
	 lFaX2gX3IXa5sQrB7nn2V+yKq9UllS9jpwJyCkrkJmFkCJ+uy0pYPCPwv26pqEGy2F5dG
	 QynfdEx1vwGskpX1pxxFsA0zUI4HeF9deakm2+yul+NhlD+ENTdLiAB5IanEVty4Rjg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=strlen.de;
	spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc;
	arc=none smtp.remote-ip=91.216.245.30
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A81DB606A322
	for <netfilter-devel@vger.kernel.org>; Wed, 28 Oct 2026 14:57:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A81DB606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 23855609D0; Wed, 28 Oct 2026 15:57:24 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH libftnl 09/12] src: set: check for empty list explicitly
Date: Wed, 28 Oct 2026 15:56:29 +0100
Message-ID: <20261028145632.7089-10-fw@strlen.de>
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
When s->expr_list is empty the for-init assigns
expr = container_of(&s->expr_list, nftnl_expr, head).

Since `head` is at offset 0 in nftnl_expr, this yields
expr == (nftnl_expr*)&s->expr_list: a pointer into the middle of the
nftnl_set struct.

The function returns this bogus pointer.
Also set data_len to 0; normally users would use the _str getter
which ignores the data_len anyway, but its better to initialise it
to a known value.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/set.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/src/set.c b/src/set.c
index fc50f3f28055..f06223eaed86 100644
--- a/src/set.c
+++ b/src/set.c
@@ -253,8 +253,6 @@ EXPORT_SYMBOL(nftnl_set_get_data);
 const void *nftnl_set_get_data(const struct nftnl_set *s, uint16_t attr,
 			       uint32_t *data_len)
 {
-	struct nftnl_expr *expr;
-
 	if (!(s->flags & (1 << attr)))
 		return NULL;
 
@@ -313,9 +311,11 @@ const void *nftnl_set_get_data(const struct nftnl_set *s, uint16_t attr,
 	case NFTNL_SET_USERDATA:
 		return nftnl_mem_blob_get(&s->user_data, data_len);
 	case NFTNL_SET_EXPR:
-		list_for_each_entry(expr, &s->expr_list, head)
-			break;
-		return expr;
+		*data_len = 0;
+		if (list_empty(&s->expr_list))
+			return NULL;
+
+		return list_entry(s->expr_list.next, struct nftnl_expr, head);
 	}
 	return NULL;
 }
-- 
2.55.0

