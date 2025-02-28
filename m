Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 749781C5D4D
	for <netfilter-devel@vger.kernel.org>; Fri, 28 Feb 2025 21:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740776994; cv=none; b=Wb8dMunHT0+rGcRdvBmYMPd4SHV1oyXWBONFPoT7xH77v9b+ZT4NFeO9lvz5B9CIjl6zSo19AL7eRhGl7LjwC4N/hP2dLgj7qJmEeehs2Ofb5dxuo7SaEm3sdoUDd6Pvdx4cZjcOYQbd859VaI+T9ykbSOmsAWEBwnBWcMOZ7qI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740776994; c=relaxed/simple;
	bh=ldwpT/AX5H+eFoI4Xz73tSbsvDbFZJHMumWClf32o70=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=pkuAKU2Z5yvctlf4PYqvslC1DuRw2y66fiQTzyXGkDh7+pEe70bqn30cGxscOva1rF9NNiIaAk8Y8MAD/+37EfGICXO4nTsT+aOR2YMYrNl3/fvaVlxh9vD4krsJDi8JNwvcbCztM55T80GDlfAKzJvp+B46hyVWODOgiYlGu7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Vzctql1f; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Vzctql1f; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Vzctql1f";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Vzctql1f"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 66D1860313; Fri, 28 Feb 2025 22:09:44 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1740776984;
	bh=HlC2KQLqTAYyK4i2eEySWsEblTRy9PqYnIYV1EEflio=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=Vzctql1fAXxk2UG3NSNN2XRA1ASBcIbad+yU3SbpYfl5oUm82Zw51zLCJ3KbFwCBU
	 y0RiyApfydLYMof+AaEfFOJgWB3KxwTEyZgfnAxbSvMgjdITyLsKtFT/6rFj87dzuv
	 XzRoxaWJP+7rhrYTiIuYBFRdFKfMo/VwxIwLuqk3JZCxR9Deve4Vw4HY48gWRMQt6P
	 uMI/ychsIRu5AjfCAMJc6biAY2mMtlP4aLB28ZpFfCjq21RuD1SCb9B/6HQ+LUxO4o
	 FEDt1e3yKYFyGorhXfhwCj7UeCQ8I+IvkdZUS+DUkAEpsnpbWQAu/JRTwpQcmR0QmH
	 YMgt9tYaqgkUg==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 1357A6030A
	for <netfilter-devel@vger.kernel.org>; Fri, 28 Feb 2025 22:09:44 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1740776984;
	bh=HlC2KQLqTAYyK4i2eEySWsEblTRy9PqYnIYV1EEflio=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=Vzctql1fAXxk2UG3NSNN2XRA1ASBcIbad+yU3SbpYfl5oUm82Zw51zLCJ3KbFwCBU
	 y0RiyApfydLYMof+AaEfFOJgWB3KxwTEyZgfnAxbSvMgjdITyLsKtFT/6rFj87dzuv
	 XzRoxaWJP+7rhrYTiIuYBFRdFKfMo/VwxIwLuqk3JZCxR9Deve4Vw4HY48gWRMQt6P
	 uMI/ychsIRu5AjfCAMJc6biAY2mMtlP4aLB28ZpFfCjq21RuD1SCb9B/6HQ+LUxO4o
	 FEDt1e3yKYFyGorhXfhwCj7UeCQ8I+IvkdZUS+DUkAEpsnpbWQAu/JRTwpQcmR0QmH
	 YMgt9tYaqgkUg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft 1/4] evaluate: payload statement evaluation for bitfields
Date: Fri, 28 Feb 2025 22:09:36 +0100
Message-Id: <20250228210939.3319333-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250228210939.3319333-1-pablo@netfilter.org>
References: <20250228210939.3319333-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Instead of allocating a lshift expression and relying on the binary
operation transfer propagate this to the mask value, lshift the mask
value immediately.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c | 21 +++++++--------------
 1 file changed, 7 insertions(+), 14 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index f79667bd41ea..c090aebe2cca 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -3345,20 +3345,13 @@ static int stmt_evaluate_payload(struct eval_ctx *ctx, struct stmt *stmt)
 		}
 	}
 
-	if (shift_imm) {
-		struct expr *off, *lshift;
-
-		off = constant_expr_alloc(&payload->location,
-					  expr_basetype(payload),
-					  BYTEORDER_HOST_ENDIAN,
-					  sizeof(shift_imm), &shift_imm);
-
-		lshift = binop_expr_alloc(&payload->location, OP_LSHIFT,
-					  stmt->payload.val, off);
-		lshift->dtype     = payload->dtype;
-		lshift->byteorder = payload->byteorder;
-
-		stmt->payload.val = lshift;
+	switch (stmt->payload.val->etype) {
+	case EXPR_VALUE:
+		if (shift_imm)
+			mpz_lshift_ui(stmt->payload.val->value, shift_imm);
+		break;
+	default:
+		break;
 	}
 
 	masklen = payload_byte_size * BITS_PER_BYTE;
-- 
2.30.2

