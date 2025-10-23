Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D3C82882D3
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Oct 2025 16:14:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761236100; cv=none; b=FBtKW8o6rssWYExMVaZmkAVEK97Jy1HKcfcarqyrMDqMWJuJno0GkDtegSaGDmfKJ250wrqyNSWGUBiD7M5J7I832XMSMu3EtwT3/rw3invVTiYUXM5iEfkZG5+V2hRSr5X/LfUtlPkvIf/M1sDjsjpotq4uLaeiw3+MWZo30yQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761236100; c=relaxed/simple;
	bh=kEUkJhbXuFBR1sAmy2rAcOzvGEOz7go/SSNpso9RdQY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DNCmm7gAZJm7vqltxFu6ITW4bwyaNW3QZS+NCRFh9cQhs22S+8ZgJyp01YMjXCvLub2boqkI7w3LYPUSt4T8UMvIKq5K5XawNeH9nVu6XKbQu5lkmzoQoPG84l0sr8tIbeRz74/z8RH1jwRXxx7zqE7Q57n5kFGw+Xtj4G8jmVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=LhjIwQgg; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="LhjIwQgg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=GmAiqFTV+6pqQu+ZATnxjomdjUB2c8M9+WreyJQueRI=; b=LhjIwQggKFLIfygv0wpXMhmhDL
	QKpKlwbdV7mCwWL/nuwNDQnYPEA2xTX31MMYvxiMLLUhhhuczdp7mdH7L2wjp/7y4KGYeHTvUNMSN
	QAz7F0HhMro7ZINz7RXpCDM8Ul54XuMHE/xLI8Hnsjhw5bfSfYhcQT2zMHUv1xPvdFJhkIsjRsQpw
	buOBq0mWvOwJwlw+qMZPo3M2a9Dw18a/VMmIfLsPKI+JrwX9ciZ4EcklUHi8TIj/ov99oduUFORW1
	qASb9nCHqc3gBaVOcrz9utTqTo9uOZmLXr0f0HY2ZSjCnvoLnYPPZXRlFBqh3ZSX93YT/c8WuWyle
	DcWLFBPQ==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1vBxxp-0000000008L-2dMg;
	Thu, 23 Oct 2025 18:14:57 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH 15/28] Fix byteorder conversion of concatenated value expressions and ranges
Date: Thu, 23 Oct 2025 18:14:04 +0200
Message-ID: <20251023161417.13228-16-phil@nwl.cc>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251023161417.13228-1-phil@nwl.cc>
References: <20251023161417.13228-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A problem with the existing code was that struct expr::byteorder was not
updated despite the call to mpz_switch_byteorder(). Doing so leads to an
extra byteorder swap during data linearization though, so in order to
have byteorder swapped *and* the field value set correctly, simply
update the latter and rely upon the implicitly happening conversion.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/intervals.c | 10 +++-------
 src/netlink.c   |  5 ++---
 2 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/src/intervals.c b/src/intervals.c
index 438957c52d391..6a917b7b79c3f 100644
--- a/src/intervals.c
+++ b/src/intervals.c
@@ -793,11 +793,8 @@ int setelem_to_interval(const struct set *set, struct expr *elem,
 	}
 
 	low = constant_expr_alloc(&key->location, set->key->dtype,
-				  set->key->byteorder, set->key->len, NULL);
-
+				  BYTEORDER_BIG_ENDIAN, set->key->len, NULL);
 	mpz_set(low->value, key->range.low);
-	if (set->key->byteorder == BYTEORDER_HOST_ENDIAN)
-		mpz_switch_byteorder(low->value, set->key->len / BITS_PER_BYTE);
 
 	low = set_elem_expr_alloc(&key->location, low);
 	set_elem_expr_copy(low, interval_expr_key(elem));
@@ -819,12 +816,11 @@ int setelem_to_interval(const struct set *set, struct expr *elem,
 	}
 
 	high = constant_expr_alloc(&key->location, set->key->dtype,
-				   set->key->byteorder, set->key->len,
+				   BYTEORDER_BIG_ENDIAN, set->key->len,
 				   NULL);
 	mpz_set(high->value, key->range.high);
 	mpz_add_ui(high->value, high->value, 1);
-	if (set->key->byteorder == BYTEORDER_HOST_ENDIAN)
-		mpz_switch_byteorder(high->value, set->key->len / BITS_PER_BYTE);
+	high->byteorder = BYTEORDER_BIG_ENDIAN;
 
 	high = set_elem_expr_alloc(&key->location, high);
 
diff --git a/src/netlink.c b/src/netlink.c
index 2a6caa9c76565..3228747a74af8 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -323,9 +323,8 @@ static int __netlink_gen_concat_key(uint32_t flags, const struct expr *i,
 			break;
 
 		expr = (struct expr *)i;
-		if (expr_basetype(expr)->type == TYPE_INTEGER &&
-		    expr->byteorder == BYTEORDER_HOST_ENDIAN)
-			byteorder_switch_expr_value(value, expr);
+		if (expr_basetype(expr)->type == TYPE_INTEGER)
+			expr->byteorder = BYTEORDER_BIG_ENDIAN;
 		break;
 	default:
 		BUG("invalid expression type '%s' in set", expr_ops(i)->name);
-- 
2.51.0

