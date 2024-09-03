Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6BECB1CA6A9
	for <netfilter-devel@vger.kernel.org>; Tue,  3 Sep 2024 13:55:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725371742; cv=none; b=H/jceNGE/igprKylnK04HwE7twF7GfAylibq6TqCh8ZLJptV08V/985hO1dIuPRo2NjD/nlWyV9bI4qu6IZ76SoEQlD/P9WKxCLL9pim57qJpugV6xWXwVWUdmLSnVs+KSjrLNN+FNGzmIpxqkCuN69r9U3HBCj37G5KGSMJ0b0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725371742; c=relaxed/simple;
	bh=NrMPPhNJrDspVCxI4G/DtRy/rDAAmzMwjxZcZtoRDLk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=WwYeW8umZkoZOwT86BH5dLw7PeXjXHvFymB/DbXeYxTKhz7qHf31cEXuVd80dgqBu6O3I3zT4HukGDQoplOHLal9R9n1ba4pyy70Oct2jioyj0+WZhlTFt2KZXHmdRPFeAbZMCcFgS3+vuLtOGamU4LKjD9a1EXG/Dw9Q3IIpuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de
Subject: [PATCH nf-next,v3 3/9] netfilter: nf_tables: reject expiration higher than timeout
Date: Tue,  3 Sep 2024 15:55:27 +0200
Message-Id: <20240903135533.2021-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240903135533.2021-1-pablo@netfilter.org>
References: <20240903135533.2021-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Report ERANGE to userspace if user specifies an expiration larger than
the timeout.

Fixes: 8e1102d5a159 ("netfilter: nf_tables: support timeouts larger than 23 days")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v3: no changes

 net/netfilter/nf_tables_api.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 1884125ebb28..684dff68b2c3 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6924,6 +6924,9 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 					    &expiration);
 		if (err)
 			return err;
+
+		if (expiration > timeout)
+			return -ERANGE;
 	}
 
 	if (nla[NFTA_SET_ELEM_EXPR]) {
-- 
2.30.2

