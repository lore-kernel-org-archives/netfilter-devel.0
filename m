Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.72.192.73
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792942426;
	b=bY9ZECwoELL4YdUdtxjeRPp3i2srue6sVvw/1pch88OmoDaCRgxB3KC083G7ZqF9cIn7
	 QAyt9B/5+fkJSdJ51o0dm33Hc1jRixUnkLv3cZ7pwxhNxSQAJmVkbAbcUOqewfJkyJomw
	 CxZqJFZw0hpTHlTQLD7tt74H2R5XkIdnj/3XdjIubfTfldEWRmC6PHg5YEDhNf5xttNUQ
	 5j/OvnPt/o81h75oLj0ypTyfiKH66alOivPjuvJiS1RvGF1pU6ytYqD+dwvBCvx5+fjPc
	 ls3EYSNOskqH5DvBhC+vSxSYJ4wZyp6HOi2gc5CiPqS0IFVDqcRru9Z0ds3UEGBJrSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792942426;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:
	 X-Provags-ID:X-Spam-Flag:UI-OutboundReport;
	bh=cehBNXVPFwP8lu60EZ3dTh8llabfw1q+edQaO8Vh+5Y=;
	b=KqfJ4P/ern69BIE0UameyiAGFE9koXGOY36oRzJ5zoPrI4hUDBrKTNL2OIXID5Dv5W4u
	 w1ZjIpB8P3JCzNw0WClTO61pAgY67640lqMgJNyo8BGJCWPhcQc9wyUfJxehGgIgQdzo2
	 nmk1K/IleG4FBXtfmmv2Bw8QM/aF4IBE7UzwYnFrlFVuWClbXgbz5JrjXKDvV0+mVx+v2
	 XfBSBWZJb5rWhJTs7DIIlWlLQI7NEvZYLW7EnlxT8nRzVK5TT7djxFZTtsURw7dwuSsBp
	 +iiLF1d3YcwahtQKscSExtjKwsuyHdUBwGwrsaYbwjvI8/AKaZ0pAwnSC7WairMWTpA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=kernelscan.io;
	spf=pass smtp.mailfrom=kernelscan.io;
	arc=none smtp.remote-ip=217.72.192.73
Received: from mout.kundenserver.de (mout.kundenserver.de [217.72.192.73])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2E9F606A31A;
	Sun, 25 Oct 2026 15:33:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E2E9F606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kernelscan.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernelscan.io
Received: from client.hidden.invalid by mrelayeu.kundenserver.de (mreue107
 [213.165.67.113]) with ESMTPSA (Nemesis) id 1MZk1p-1x6U9Q2dGB-00Il1s; Sun, 25
 Oct 2026 16:33:43 +0100
From: Steffen Pfendtner <steffen.pfendtner@kernelscan.io>
To: stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org
Subject: [PATCH v2 5.10.y 1/2] netfilter: nf_tables: always increment set element count
Date: Sun, 25 Oct 2026 16:32:23 +0100
Message-ID: <20261025153224.42044-2-steffen.pfendtner@kernelscan.io>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20261025153224.42044-1-steffen.pfendtner@kernelscan.io>
References: <2026-10-24-1-daily-reply-0010-nft-set-nelems-5-10-bounce@kernel.org>
 <20261025153224.42044-1-steffen.pfendtner@kernelscan.io>
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
X-Provags-ID: V03:K1:eONRPlqyAlOsNCBbMMPKZ53NbchN1VvymnXbWTEXd2Xuktm4n4c
 32IVamK0/9BZScCk6TJer3tn8f+E0qQ9rvxNrCNgJPi1IjMqzH+In/YuHkfjFVQaVEeOOSG
 v1c3HUTRKdrA9qUcBM0V1GaRBeFvWmPHm4hRycU2xoXby5VvJRBCV14zcIXcRwVXqYWl0J8
 mnA9mIlmKFHQbJlKWvheg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:U7sWPHENIb8=;sAnoI30GAXVJoUYdWlfcDjgV4oN
 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

From: Florian Westphal <fw@strlen.de>

[ Upstream commit d4b7f29eb85c93893bc27388b37709efbc3c9a0e ]

At this time, set->nelems counter only increments when the set has
a maximum size.

All set elements decrement the counter unconditionally, this is
confusing.

Increment the counter unconditionally to make this symmetrical.
This would also allow changing the set maximum size after set creation
in a later patch.

Signed-off-by: Florian Westphal <fw@strlen.de>
[ Backport to 5.10.y: 5.10 has no NFT_SET_ELEM_CATCHALL element class,
  so the catch-all exclusion from the upstream commit is dropped and
  every element is counted. ]
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Steffen Pfendtner <steffen.pfendtner@kernelscan.io>
---
 net/netfilter/nf_tables_api.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 63592c73a7a1..9a0b5a574d9a 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5841,8 +5841,8 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 		goto err_element_clash;
 	}
 
-	if (set->size &&
-	    !atomic_add_unless(&set->nelems, 1, set->size + set->ndeact)) {
+	if (!atomic_add_unless(&set->nelems, 1,
+			       set->size ? set->size + set->ndeact : UINT_MAX)) {
 		err = -ENFILE;
 		goto err_set_full;
 	}
-- 
2.39.5

