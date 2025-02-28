Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BC3523F370
	for <netfilter-devel@vger.kernel.org>; Fri, 28 Feb 2025 21:19:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740777594; cv=none; b=kYf/eDfhHUy/lT2kqtFmXc5aUeaRaqd9auHEOnh468k2hycEQylQhhDUTHLgQl48q4WQDBM1hfCuEWWlKecDciSzj6vtbwsUTQv5D/qHlEyPzrCCsOqOCAwYIUAjiN6MDfognKdm6QfWwEAe2SjyoBGi0BR/xT63eTtnNQECBms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740777594; c=relaxed/simple;
	bh=OYWmWqF29kLgA16SSRdV/9l0228A7ooUilCg0LpCEJM=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=plFOlPNtWbAwdLrP35FVUSZ2dvOJRiGzOpp0mlelsE5HA5g2nfdUzZWn4tGtqhEyyPDXIDfTWbFzhP/y5UlRxdxn86xrj7YlJu/eNatsX6CAeUMHwX73YCvkF6lcS3J/NfDT90v96DqkYyveGDXdduurG7zAHhtdXz0gCGLyT1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=ovzJCGEm; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=ovzJCGEm; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="ovzJCGEm";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="ovzJCGEm"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 48142602A4; Fri, 28 Feb 2025 22:19:51 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1740777591;
	bh=HKAjEh/0ydY/EgXxpPCVXFLYHg1I2BpiQUtRFOCVkk8=;
	h=From:To:Subject:Date:From;
	b=ovzJCGEmrEpqbTZPgY6miFPdUnDaHTXLU9QrGOn0D1gVPGF34kvs3Kk5ZZXsJs47k
	 5BK8swxsAjMKUhLi5QXpgKlbtpikq/IXm34lgD4RKM2bREBpKedxldQWUw3fHgYJRL
	 T57ZPFFoGePexReGRu5q877RTKEytCZ8k0FV2kGmB+NpnU/X97rjfbmOIUl0WC6FNL
	 3noFBWTy/zrPFfJ1KXE/8ChiWS0XvXfpEpeLP6vI9eEpxaryCR3yah9eCCJMV8qEks
	 Y0S1ICQgBQgjoNBtMdmzC6KmGy4lQy5wKTmDDST24jZTECXuwbXptL+eBzCIeN21XG
	 M2l4T6XKtmdZw==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id E37C1602A1
	for <netfilter-devel@vger.kernel.org>; Fri, 28 Feb 2025 22:19:50 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1740777591;
	bh=HKAjEh/0ydY/EgXxpPCVXFLYHg1I2BpiQUtRFOCVkk8=;
	h=From:To:Subject:Date:From;
	b=ovzJCGEmrEpqbTZPgY6miFPdUnDaHTXLU9QrGOn0D1gVPGF34kvs3Kk5ZZXsJs47k
	 5BK8swxsAjMKUhLi5QXpgKlbtpikq/IXm34lgD4RKM2bREBpKedxldQWUw3fHgYJRL
	 T57ZPFFoGePexReGRu5q877RTKEytCZ8k0FV2kGmB+NpnU/X97rjfbmOIUl0WC6FNL
	 3noFBWTy/zrPFfJ1KXE/8ChiWS0XvXfpEpeLP6vI9eEpxaryCR3yah9eCCJMV8qEks
	 Y0S1ICQgBQgjoNBtMdmzC6KmGy4lQy5wKTmDDST24jZTECXuwbXptL+eBzCIeN21XG
	 M2l4T6XKtmdZw==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft] evaluate: release existing datatype when evaluating unary expression
Date: Fri, 28 Feb 2025 22:19:47 +0100
Message-Id: <20250228211947.3320239-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use __datatype_set() to release the existing datatype before assigning
the new one, otherwise ASAN reports the following memleak:

Direct leak of 104 byte(s) in 1 object(s) allocated from:
    #0 0x7fbc8a2b89cf in __interceptor_malloc ../../../../src/libsa
    #1 0x7fbc898c96c2 in xmalloc src/utils.c:31
    #2 0x7fbc8971a182 in datatype_clone src/datatype.c:1406
    #3 0x7fbc89737c35 in expr_evaluate_unary src/evaluate.c:1366
    #4 0x7fbc89758ae9 in expr_evaluate src/evaluate.c:3057
    #5 0x7fbc89726bd9 in byteorder_conversion src/evaluate.c:243
    #6 0x7fbc89739ff0 in expr_evaluate_bitwise src/evaluate.c:1491
    #7 0x7fbc8973b4f8 in expr_evaluate_binop src/evaluate.c:1600
    #8 0x7fbc89758b01 in expr_evaluate src/evaluate.c:3059
    #9 0x7fbc8975ae0e in stmt_evaluate_arg src/evaluate.c:3198
    #10 0x7fbc8975c51d in stmt_evaluate_payload src/evaluate.c:330

Fixes: faa6908fad60 ("evaluate: clone unary expression datatype to deal with dynamic datatype")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index 25c07d90695b..f79667bd41ea 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1359,7 +1359,7 @@ static int expr_evaluate_unary(struct eval_ctx *ctx, struct expr **expr)
 		BUG("invalid unary operation %u\n", unary->op);
 	}
 
-	unary->dtype	 = datatype_clone(arg->dtype);
+	__datatype_set(unary, datatype_clone(arg->dtype));
 	unary->byteorder = byteorder;
 	unary->len	 = arg->len;
 	return 0;
-- 
2.30.2

