Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.216.245.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793199442;
	b=W7wrllWXylnJ3eSee9fdgib3TnIDLtjj2/AHRRUSTgsuJwi4QVrMP1c+/dw6XWseuq7s
	 IGYmzV/O/kjcKJsQU6ZgrEemR7bcLPFoxJ7HrVZOAFP5X6rB7WkiodVD+EyouT4CQMne5
	 zrVnT3MuRCUrzFnnKrQ2UMRXdjHvmGQA5n+gJkohzFDUrq5FsiE697wCIIJap1rLIuiCA
	 iI5bAI42iXZGXco4NMhuchNsXUBKQmk6LJaqND5P3hf9gN5DfATtWNMWtn5rg1f4EPbhi
	 i8cfFeQxEsva5CZaReLee8MKYVMiGo904RFowqraEqNZYxH7vwg1lzuYQ+SZ9TbbM3A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793199442;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=RzrZL6yynDauFLaeQgRfbQQCGc23/DzsgjlFchI0AbA=;
	b=kZVUMvQMWuRWj1CfFbYzuEy4fnfBSe6rQJeubt6ZeiPkPdic+xhnn4gRBcfH2FwdOsRj
	 49/tbkoK3U6dP6v9sWG01NIJXyUnuxMECXaudjAbZU+gSPvkmmn2mYgXHsPx796TTcXtW
	 ou9VpLWAx2MysozdhhcL3BpsZYT1j0zgjJXGaRVTr/vERiT8k14S2uPPrLCmrsTDhqDs1
	 cE7w+rPvjcAL2+VD/iBk4ru5UPy+9zJX2HkS+/psRPEJaisWpJ2iGWpS1Pq61NQN13sCs
	 AAv8B8cImS1/ijr8h6YJ7Zr2g+BUYLtMRieC/A4eb138liPes4eFEvxHZJIFBas0E8Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=strlen.de;
	spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc;
	arc=none smtp.remote-ip=91.216.245.30
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FF15606A320
	for <netfilter-devel@vger.kernel.org>; Wed, 28 Oct 2026 14:57:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7FF15606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id D6AEA609D0; Wed, 28 Oct 2026 15:57:19 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH libftnl 08/12] src: set: clear field_len array before copying
Date: Wed, 28 Oct 2026 15:56:28 +0100
Message-ID: <20261028145632.7089-9-fw@strlen.de>
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

LLM flagged:
      if (data_len > sizeof(s->desc.field_len))
          return -1;

      memcpy(&s->desc.field_len, data, data_len);
      for (s->desc.field_count = 0;
           s->desc.field_count < NFT_REG32_COUNT;
           s->desc.field_count++) {
          if (!s->desc.field_len[s->desc.field_count]) // here

i.e. it relies on the inital zero state.

If for any reason a 2nd call is made that shinks field_len
array, the loop would read stale count from previous
incarnation.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/set.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/src/set.c b/src/set.c
index 22fd4a839f80..fc50f3f28055 100644
--- a/src/set.c
+++ b/src/set.c
@@ -188,6 +188,7 @@ int nftnl_set_set_data(struct nftnl_set *s, uint16_t attr, const void *data,
 		if (data_len > sizeof(s->desc.field_len))
 			return -1;
 
+		memset(&s->desc.field_len, 0, sizeof(s->desc.field_len));
 		memcpy(&s->desc.field_len, data, data_len);
 		for (s->desc.field_count = 0;
 		     s->desc.field_count < NFT_REG32_COUNT;
-- 
2.55.0

