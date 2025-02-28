Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E5961C5F2F
	for <netfilter-devel@vger.kernel.org>; Fri, 28 Feb 2025 21:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740776994; cv=none; b=hBt0Stp6+7X/8nGCFebQe0MZQRGZjPzHGgR9O5vVoPjkgneSAG33NJKvTNBd9UK6aKnCiZ4EWf3Ql1gYz4yg3JGxw3A1Wd1wfTQPV1ejH+iSk9DAGfjy8Rwb3OhlbRDGf6IWRFR5zlSmRbKmPgf3uqtcFTGWN8zCri6SpUhCk2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740776994; c=relaxed/simple;
	bh=0vHjavKs3kq7B73EH/862gBin7ZwDg8UEqyOzEzTL/k=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=W5CW+AhUPdKurnsvV0LpoH/iEMiOp8fNbL9ab5StrP+0Y9cUOtplU5uYCATeFi/q2rZBHRSSbvuwWDlplf+1Jj8/s3HuRnhcAag4Zpeinh90daQbUD+41PCf2CY9gcdYVKQ2Hb4m3f+/rPJzFjytNcbmYn3dZd+jNCCoHscGGvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=RX27rIdY; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=RX27rIdY; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="RX27rIdY";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="RX27rIdY"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id F252960314; Fri, 28 Feb 2025 22:09:44 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1740776984;
	bh=Z8wTT09nQbxBeZx5hTmfwGw1kDBiwK5MGTtMyYbczyk=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=RX27rIdYtlyigNoAK3J+hJbcGxJgE91fojPz7p4O7gIKxeRqhbHjln0A3iE8eBOlu
	 HDRxU21RCxxX3ld1H3VhOqO6nOwqL3EHjiBsG8yYPvcXYGwp+RcjQ5FWFhCW8Oi0nR
	 ncBybeZ3nIpeQ2wE1jZEaUSE+cNgsIWZn5gxFmXQY5iMYMDs3f33BK7svMX026BbW4
	 YUGkpAfzg2cIlDUOM1nGY9BihG21fVEIFJrs/Ga4fGD9uchcVMT+lZ6DQp2dSs6+E1
	 f92QNI6r9ZC5WiSA/IzZpFGBDLY6svD01m8QMXlyMrXRW27p6bVuLFDG9kmkXv4hGn
	 PlO+YkV2Tl7rQ==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 9F2F76030A
	for <netfilter-devel@vger.kernel.org>; Fri, 28 Feb 2025 22:09:44 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1740776984;
	bh=Z8wTT09nQbxBeZx5hTmfwGw1kDBiwK5MGTtMyYbczyk=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=RX27rIdYtlyigNoAK3J+hJbcGxJgE91fojPz7p4O7gIKxeRqhbHjln0A3iE8eBOlu
	 HDRxU21RCxxX3ld1H3VhOqO6nOwqL3EHjiBsG8yYPvcXYGwp+RcjQ5FWFhCW8Oi0nR
	 ncBybeZ3nIpeQ2wE1jZEaUSE+cNgsIWZn5gxFmXQY5iMYMDs3f33BK7svMX026BbW4
	 YUGkpAfzg2cIlDUOM1nGY9BihG21fVEIFJrs/Ga4fGD9uchcVMT+lZ6DQp2dSs6+E1
	 f92QNI6r9ZC5WiSA/IzZpFGBDLY6svD01m8QMXlyMrXRW27p6bVuLFDG9kmkXv4hGn
	 PlO+YkV2Tl7rQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft 2/4] evaluate: reject unsupported expressions in payload statement for bitfields
Date: Fri, 28 Feb 2025 22:09:37 +0100
Message-Id: <20250228210939.3319333-3-pablo@netfilter.org>
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

The payload statement evaluation pretends that it can handle any
expression for bitfields, but the existing evaluation code only knows
how to handle value expression.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index c090aebe2cca..d7915ed19d59 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -3351,7 +3351,8 @@ static int stmt_evaluate_payload(struct eval_ctx *ctx, struct stmt *stmt)
 			mpz_lshift_ui(stmt->payload.val->value, shift_imm);
 		break;
 	default:
-		break;
+		return expr_error(ctx->msgs, stmt->payload.val,
+				  "payload statement for this expression is not supported");
 	}
 
 	masklen = payload_byte_size * BITS_PER_BYTE;
-- 
2.30.2

