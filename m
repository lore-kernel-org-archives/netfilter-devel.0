Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EC1939A4CF
	for <netfilter-devel@vger.kernel.org>; Thu,  2 Jul 2026 12:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782995802; cv=none; b=H+cTrsKs8vkCU++qYBwuLByikkg6+tJcrm/lesPHLAu8xyBLPZ4ewE6u53vFGfXru3fhDb7Rl+3VpWpAhYmkJtrgYXXRbMMYIFS2P10BjLRYoxybsfj/EqU6vp41hoK4CZLpaWwDyMJD8HcyFc9/VKIosO2Bh8GqnNoqYKTmB40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782995802; c=relaxed/simple;
	bh=Oc3WlKUETG7EkL+5TVSDOJqeWlTqWMSZ0nbzNdGJTKQ=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=CFGhk5zRopT5ZyofBmDEnWyrcRRDNPJbxV0KNitqZC8+1dBlgZ1qcz+OGIyZg+zQuhfNtI+UTjPQrsTmfmdS9VzmgQEXRh5+pbl1D6dRK4V2uMCM94gg5xqRx3XuciIkQLIEeBzZk6bOK3t7iDHPwFFYVJr8LoqKrp6q/LylrAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=ISfcySSD; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="ISfcySSD"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 7E8446057B
	for <netfilter-devel@vger.kernel.org>; Thu,  2 Jul 2026 14:36:38 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1782995798;
	bh=i2PDZt6teaZp9dEQNn95JG6IdDAFamH0ll+wbfLFiEI=;
	h=From:To:Subject:Date:From;
	b=ISfcySSDffsi+q9Urk9ZER4L3Y1tUErAizHjs7yVcOD4AdGNnsWf/UEcxJ/m04XHz
	 CJBEw+C8/pKoEO2ThPOCSa3yIjCrx/de6UC6CXkpbZAVk/RrPHrVVwOUkamXGaSCb5
	 qXm8n61tzkAKts2N58ApIhbhGjijdRuurwNOCsltic8fkudJ/t5TX03D7DZNGhXul3
	 7rbFAFg5yWG32k8lnnd00zJe5ItjTIsBhkUhMcs9YaKaAXF2DGzMIxnuToVxxB1+Qt
	 zPJdfalQVVvpykHw2YuBaroc8+7DV+XtQYn/F/o7lx/0DINuYdCA4ID+IPEGEyghUx
	 BhqG7UYbfjqVQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft 1/2] segtree: fix get element command with open intervals
Date: Thu,  2 Jul 2026 14:36:33 +0200
Message-ID: <20260702123634.349861-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Skip the closing end element in case this is an open interval.
Otherwise, a bogus end element max(type) + 1 is provided, eg. in
inet_service, this results as a 0x10000 with end interval flag
which is interpreted by the kernel as a matching closing element.

Fixes: a43cc8d53096 ("src: support for get element command")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/segtree.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/src/segtree.c b/src/segtree.c
index a12820bcf1ec..e877814505f4 100644
--- a/src/segtree.c
+++ b/src/segtree.c
@@ -73,12 +73,13 @@ static void set_elem_expr_add(const struct set *set, struct expr *init,
 struct expr *get_set_intervals(const struct set *set, const struct expr *init)
 {
 	enum byteorder byteorder = get_key_byteorder(set->key);
+	mpz_t low, high, mask;
 	struct expr *new_init;
-	mpz_t low, high;
 	struct expr *i;
 
 	mpz_init2(low, set->key->len);
 	mpz_init2(high, set->key->len);
+	mpz_init2(mask, set->key->len);
 
 	new_init = set_expr_alloc(&internal_location, NULL);
 
@@ -105,6 +106,10 @@ struct expr *get_set_intervals(const struct set *set, const struct expr *init)
 			range_expr_value_low(low, i->key);
 			set_elem_expr_add(set, new_init, low, 0, byteorder);
 			range_expr_value_high(high, i->key);
+			mpz_bitmask(mask, i->len);
+			if (!mpz_cmp(mask, high))
+				break;
+
 			mpz_add_ui(high, high, 1);
 			set_elem_expr_add(set, new_init, high,
 					  EXPR_F_INTERVAL_END, byteorder);
@@ -115,6 +120,7 @@ struct expr *get_set_intervals(const struct set *set, const struct expr *init)
 		}
 	}
 
+	mpz_clear(mask);
 	mpz_clear(low);
 	mpz_clear(high);
 
-- 
2.47.3

