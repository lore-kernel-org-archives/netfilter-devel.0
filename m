Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDDCD2C027C
	for <netfilter-devel@vger.kernel.org>; Thu,  5 Feb 2026 02:41:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770259316; cv=none; b=DFEWtA4juTXds5VufUjI9CQ5SSAQpjVwMM/TWGYKLPLaKAsq7wWF4xxZJUdyUzRw80Yb79VplukV5GBimAWKjc9yNXyluvnsDUrqlfNKOzxc9n+SxBJUpFOCYWR+sR2frEaufOnU4Rh7l4lIjrVUduDNUIu+4v7Y+tZF3z78N6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770259316; c=relaxed/simple;
	bh=3OEYPYOZf9vXmdNjn9LUoaZ9qSzqUvftFYbMGLBYx80=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sc8RnUugMQ/X3rXUtY9/fDgt+sJHsEb5UyBuPGXPOdwc4Lwv1YBe+pvhaZHJffbMAjzhG32iFjj8yLyMbd+QkK8JMfyJKxyAPjpjgplN+/k8f+REOEFlTG2NlWJX50X7R3exvcB2fQtxzhA9qJFeDwB7gEJRRRSW4hvWZbYeQvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=vf0B1G8z; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="vf0B1G8z"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 6B38D60871
	for <netfilter-devel@vger.kernel.org>; Thu,  5 Feb 2026 03:41:54 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1770259314;
	bh=D5KulUR0gOWNRcFUocnsHdvDTOKaYlOVGsrLB8kBeKA=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=vf0B1G8zkAlRuo2IXq0UngcHODb0JyTcrIxxXvbRFILGGMMZMYGwrzbWPROkEprYF
	 hLd+kP7fPeLVMg6eNnVR9MuqkslbqKokz3XYbCFEGz/1Zy1IPPJKS/PXpVkDNP5k2K
	 KsIjC6CnZ8YjN5vht1hT3nfmPUBUum/69/1dJU5lwR3rVVyOF10UXCBlJXVByYp53A
	 0anvltAUeD9Q7M/pUCVKtzbMQ8l71hR7LeSOd7u81OHrNYjT8uR3hkkN1bR35woexv
	 RfAiABNHhGpM2oTU6eDxHki6Yvdy4u1XFSor2CQO8vxGVuvCCkH/UeEArHdYSGeWn2
	 5WxMWfvS5SKrA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft 18/20] segtree: use set->key->byteorder instead of expr->byteorder
Date: Thu,  5 Feb 2026 03:41:27 +0100
Message-ID: <20260205024130.1470284-19-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260205024130.1470284-1-pablo@netfilter.org>
References: <20260205024130.1470284-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For consistency, use the set key byteorder in get_set_intervals().

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/segtree.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/segtree.c b/src/segtree.c
index fde9473dd366..bfea2f64ed81 100644
--- a/src/segtree.c
+++ b/src/segtree.c
@@ -103,11 +103,11 @@ struct expr *get_set_intervals(const struct set *set, const struct expr *init)
 		case EXPR_RANGE_VALUE:
 		case EXPR_MAPPING:
 			range_expr_value_low(low, i->key);
-			set_elem_expr_add(set, new_init, low, 0, i->byteorder);
+			set_elem_expr_add(set, new_init, low, 0, byteorder);
 			range_expr_value_high(high, i->key);
 			mpz_add_ui(high, high, 1);
 			set_elem_expr_add(set, new_init, high,
-					  EXPR_F_INTERVAL_END, i->byteorder);
+					  EXPR_F_INTERVAL_END, byteorder);
 			break;
 		default:
 			BUG("unexpected expression %s", expr_name(i->key));
-- 
2.47.3

