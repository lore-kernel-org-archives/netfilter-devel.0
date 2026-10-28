Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.216.245.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793199425;
	b=MrH+n+HmBG2knREixGc2d177VyswhmJaMPF0bfDecY/M7GypwxFkIa80kYd71A13EcFT
	 1HZeRRewvgFjoqYf9yFpxPd2l+OJf5j1+sVY9iNXv78YhC4G3sq97MUUvPHUHZ208SW4N
	 tGx1oHgFQ+Af5rxXN3W3coUvRWwnXhxhzvWFTwemk+g5OrnsVq2NRPNNMtC6BdU+yjT74
	 9LImZqvwf4OjOmr/ZWtf1CWC/yv+S3rL/1wzGjIdGoalZVS8HXHJvEbqByndC48ksmdFU
	 r+/Cws4s9TZxp8sahNy8OpP/LStPfMnKosuthay/R5GqcCadETT6iWqDpVCV9nhnbmg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793199425;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=nxGunLs+sPO7TtYqXK1Viv2YMUb6TKD7u0R6LF5YLgs=;
	b=3jstqc+naOBw4DEx4hFW8hNkM+r8PfN7nXN4AtsiUrap7LlWxhAem4owwZxIdxzMVNRN
	 WdtidvV3WchUqJOhG8KXNPvHqpVUiKkVdqIZz0rZdh/YfMuxWdxpC0hOgWu95ttI/lgoG
	 xc9ot2Du2rn1bYRE7CQqxB+hdiA3iAeHG66Fvf1UfBYkVjlR6JkPqXcgP7Ki9weDrSWxM
	 uMo7WosrqKKUJKZK5SsPHC0P4yMj98KFZUYSTVaBtiKbFRBU4kB8g4oIqsN5K264JWmNb
	 vQy8fK/MaEFLNY7/j8CUEuixpc/fypiXDRfngvdaeryWrxdYlvZNbKXRHXSqTjs1iLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=strlen.de;
	spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc;
	arc=none smtp.remote-ip=91.216.245.30
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71108606A31A
	for <netfilter-devel@vger.kernel.org>; Wed, 28 Oct 2026 14:57:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 71108606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id BBF4460A79; Wed, 28 Oct 2026 15:57:02 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH libftnl 04/12] src: expr: make sure NFTA_EXPR_NAME was parsed successfuly
Date: Wed, 28 Oct 2026 15:56:24 +0100
Message-ID: <20261028145632.7089-5-fw@strlen.de>
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

LLM finding. Not a bug atm, the kernel always includes this.
While at it, upgrade to NUL_STRING.  Kernel always sets a trailing
NUL even for NLA_STRING, so we can enforce this.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/expr.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/src/expr.c b/src/expr.c
index 6462119e3eb2..980b317ff6db 100644
--- a/src/expr.c
+++ b/src/expr.c
@@ -251,7 +251,7 @@ static int nftnl_rule_parse_expr_cb(const struct nlattr *attr, void *data)
 
 	switch (type) {
 	case NFTA_EXPR_NAME:
-		if (mnl_attr_validate(attr, MNL_TYPE_STRING) < 0)
+		if (mnl_attr_validate(attr, MNL_TYPE_NUL_STRING) < 0)
 			abi_breakage();
 		break;
 	case NFTA_EXPR_DATA:
@@ -272,6 +272,9 @@ struct nftnl_expr *nftnl_expr_parse(struct nlattr *attr)
 	if (mnl_attr_parse_nested(attr, nftnl_rule_parse_expr_cb, tb) < 0)
 		goto err1;
 
+	if (!tb[NFTA_EXPR_NAME])
+		goto err1;
+
 	expr = nftnl_expr_alloc(mnl_attr_get_str(tb[NFTA_EXPR_NAME]));
 	if (expr == NULL)
 		goto err1;
-- 
2.55.0

