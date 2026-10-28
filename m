Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.216.245.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793199437;
	b=v0LVLz5D5zFYrhUcFsAEe12nMJIES5yHir4sILO4EJymB0mrmtvf3AZ1pgzARlf14GYK
	 ARwN/Psk5X6r6gvYOOzbU7p+JW8cnLZ7WK5eJL2mlYQ0whRe8rtqqSL9c39DEAWA27Hi+
	 FuQqiM7QmXjGSb4JWKMi/wJn+lYIWWzOww6+qXrIegr0df80OXQbkP+7uoo0jh+xQsx6W
	 LyNu8HIYG2MKtUj87f/HKAGkhtw0CzbA8VPZR6qndl2VGVcug9QmlABkusdPnKaKE5OmD
	 qdFS419YMOK4Y9J5JUV2LJD+hOsWFJHbrKH7KMHQPEQgZybfSW4Lb/+5eXyrCe9E1Aw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793199437;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=BWK3TawAgEvQYlVcbsy82HDy0rrWrlCoClgnyhrJ2a8=;
	b=ScMXxoC3YZzc2lyrYJ0yYCCwutZvT6jTsnyVGu4bi767UdfeRHzu+tq39Lb5enRK3vpO
	 6AJAWeaLrk30/3ZJVrRSFvILw6wwJrpUYTZYpMZ/ZfiPoYnXPQx3JTdJnwdV0Ovrs6xbC
	 Fnr8QUkAVC1UyJBYY1AjHXI92E+e7STXE/ueSEjBrr8bDVGG4sYq5Ixj+M1et8nKPrCZJ
	 r6henRByHZgOS8DpsohGr2NFkCHlZMMiTG8CD/2wd2j4s8S+B9FFuQ4ZjKYAAL8VzeCPt
	 2wCtXV4zkPQOSc64nGVahhWQ8ppU5RKcuBvNVyjn9BxAfO7ETKwwoD+jIa7lEt6YxEw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=strlen.de;
	spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc;
	arc=none smtp.remote-ip=91.216.245.30
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 171B6606A325
	for <netfilter-devel@vger.kernel.org>; Wed, 28 Oct 2026 14:57:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 171B6606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 88A16609D0; Wed, 28 Oct 2026 15:57:15 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH libftnl 07/12] src: ruleset: remove set_elem member from union
Date: Wed, 28 Oct 2026 15:56:27 +0100
Message-ID: <20261028145632.7089-8-fw@strlen.de>
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

LLM flags this bug:
case NFTNL_RULESET_SET:
case NFTNL_RULESET_SET_ELEMS:
     nftnl_set_free(ctx->set);
     break;

... because it hints at type confusion, SET_ELEMS
should call nftnl_set_elem_free(ctx->set_elem).

However, this entire API is obsolete, nftables doesn't
use this anymore.  The last user of NFTNL_RULESET_SET_ELEMS
went away when the json interface was removed from libnftnl.

Drop the member from the union.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/ruleset.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/src/ruleset.c b/src/ruleset.c
index ac50aa604f98..e0f46dd1b20d 100644
--- a/src/ruleset.c
+++ b/src/ruleset.c
@@ -36,7 +36,6 @@ struct nftnl_parse_ctx {
 		struct nftnl_chain	*chain;
 		struct nftnl_rule		*rule;
 		struct nftnl_set		*set;
-		struct nftnl_set_elem	*set_elem;
 	};
 	void *data;
 
@@ -158,9 +157,9 @@ void nftnl_ruleset_ctx_free(const struct nftnl_parse_ctx *ctx)
 		nftnl_rule_free(ctx->rule);
 		break;
 	case NFTNL_RULESET_SET:
-	case NFTNL_RULESET_SET_ELEMS:
 		nftnl_set_free(ctx->set);
 		break;
+	case NFTNL_RULESET_SET_ELEMS:
 	case NFTNL_RULESET_RULESET:
 	case NFTNL_RULESET_UNSPEC:
 		break;
-- 
2.55.0

