Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.216.245.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793199450;
	b=hjqQmi3DMazWcNj0igiRsIbCmW2WskbWZa7kMEaHqe5TC5PH44/+pa1G2IT7aEPG43D2
	 jzRdA+K5mdCb0FFHjdbeOSYZPcs0DHKRxKaXZG4m8I8VyyALqg3ymVjQ0h7z88sshe/4m
	 DXlEW2AheHoQj0EU/s9e9/UHXsoKtqac3Zi+1oBQYn8DURBzGWbWkRefa3KeNnBHC9VID
	 /hgNgOLmTFmIY3vi0NoAwxcfQqGUSiO5VvwtD0ntfAYtJN19K+giS+fju9ERZYLCpfHRW
	 KmskNeY3+hbMdSJu0iwaLpvZBv5pe9hw24nlz7VPE2kDGH/p09TveMVOqdGcdIPvGJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793199450;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=F67JmIjCUTUbq2UeYUGoENmrWM1p0mhpp71IhxLgVEc=;
	b=2gmVEE2P4LJG73lBKH0ztM1OjlSUUSSIZVZOgJ/+82WnFkDZtSvwbRYp2rvbxkN2ncKm
	 lV8ft8FPWVaLXVDShDmfosqV640vVFRIpnsy3+kQrKv1/unYNDU5fm0vEp5tTILhoDmBz
	 dLelG0M1pXyCOBoAzEThqqNEEO34wKqb56I7SPMiJzK3GSyWzKa8s1OLx40ruHVlj4Puu
	 W7F66WmMzJcFwdMMBjCGZcQS6li6kvHUnGWCr3H/Hglhw2tzloyfrZhsZ6UWJo6f0JMX5
	 WoZRDR8+vl/Nj7rKeUsl7yd2V2IXUkayUbCbqgC7p2YP+Z2W34TMCanZDeZy5F48Wrw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=strlen.de;
	spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc;
	arc=none smtp.remote-ip=91.216.245.30
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 181A8606A31D
	for <netfilter-devel@vger.kernel.org>; Wed, 28 Oct 2026 14:57:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 181A8606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 64F6B609D0; Wed, 28 Oct 2026 15:57:28 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH libftnl 10/12] src: set_elem: list_del before freeing
Date: Wed, 28 Oct 2026 15:56:30 +0100
Message-ID: <20261028145632.7089-11-fw@strlen.de>
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
nftnl_expr_free() calls xfree(expr).
It never calls list_del(&expr->head).

After the loop, expr_list.next/.prev point into freed heap memory.
Next list_add results in UaF.

Looks like noone does such re-use, but as the API allows it, make
this safe.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/set_elem.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/src/set_elem.c b/src/set_elem.c
index 3504a2306e47..0170d0ccefd1 100644
--- a/src/set_elem.c
+++ b/src/set_elem.c
@@ -88,8 +88,10 @@ void nftnl_set_elem_unset(struct nftnl_set_elem *s, uint16_t attr)
 		break;
 	case NFTNL_SET_ELEM_EXPR:
 	case NFTNL_SET_ELEM_EXPRESSIONS:
-		list_for_each_entry_safe(expr, tmp, &s->expr_list, head)
+		list_for_each_entry_safe(expr, tmp, &s->expr_list, head) {
+			list_del(&expr->head);
 			nftnl_expr_free(expr);
+		}
 		break;
 	case NFTNL_SET_ELEM_OBJREF:
 		xfree(s->objref);
@@ -167,8 +169,10 @@ __nftnl_set_elem_set(struct nftnl_set_elem *s, uint16_t attr, const void *data,
 			return -1;
 		break;
 	case NFTNL_SET_ELEM_EXPR:
-		list_for_each_entry_safe(expr, tmp, &s->expr_list, head)
+		list_for_each_entry_safe(expr, tmp, &s->expr_list, head) {
+			list_del(&expr->head);
 			nftnl_expr_free(expr);
+		}
 
 		expr = (void *)data;
 		list_add(&expr->head, &s->expr_list);
-- 
2.55.0

