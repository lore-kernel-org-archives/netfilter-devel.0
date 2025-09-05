Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 077A62F7AC6
	for <netfilter-devel@vger.kernel.org>; Fri,  5 Sep 2025 15:36:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757086607; cv=none; b=RoPbyajDJWE44bEySj3cpNFKj+SMHzCVrctfq7AiYAMu6cLn7KT2qNp5a4m+0fbuFjg0v9Fp9+5w68UxtS0MGJewYuPcttjNK/WKzUQ2LWAdaI8KV/E/OC6yl9QWecoJolf30EjScois78v4qdA39Hg7qZrpyWQaL1YJySfYfwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757086607; c=relaxed/simple;
	bh=8VNV010fMA1ARqWqz5y/dFLrhvb7XuMgtaBFX7XzPTo=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=b0b4xc2jUmUZkoGvxS9LWNWLrsMN8ikT8dN+N7QRrL/EKeX1ClmaDe7omAhoAd0L8Vg4P6Ou3v/ODHiT7I+7ySxcFowg4V2ZQrRDaQMBvzeS3mFvupjJlVVfJf2D4IkfJBjJ//Ls8OjwGO4ajqANcP1elhEQ2r5cz2mOXJ53v5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=o8AYt/Tw; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Vkf0siJ6; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="o8AYt/Tw";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Vkf0siJ6"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 39FBF608B8; Fri,  5 Sep 2025 17:36:40 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1757086600;
	bh=PDIObA/9MB+tlm2XMOPPadw8P/Ph17uXz6GxsGCeiLg=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=o8AYt/TwohpmVUlNGYVGXzh5YxvmwD5t9mDokJSXQZyyWtBAbtz/NmY0fw1scm8Fy
	 2x7mijuwcNAqw+2VtDuUzJJh0xFbmytQjzyoOZEYOw9a/ONFwZpGolhsXJrQYLVdEZ
	 L8oasnI5risacOQOultO+w+x9O1o2GhrwDvOaE2KqdBHDyLu3AHG3g0AU8fpMofCPG
	 kecPvnKyO0OOkuMfq3TVgonCueco3LivtgB5Vj8W0qMSYwv+MBpHU/9/kBgQ0rtLXK
	 C1vQIyfhoUG0ecz1EqbCeAIYlEe1Krq7SybKEnc3eUYFNQUt7NlvmFHvDPWVue3vjE
	 4Jp9uciq6FGVA==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 4C8F7608D5
	for <netfilter-devel@vger.kernel.org>; Fri,  5 Sep 2025 17:36:38 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1757086598;
	bh=PDIObA/9MB+tlm2XMOPPadw8P/Ph17uXz6GxsGCeiLg=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=Vkf0siJ6nIm2ltksud5CgWe0Ou06GbVNdB2JvtpbEbbcTUqMS0jHLY588hK2GkjwB
	 tyHZpD0HubUUrKoaQ9Y1LugaiQMOD85zgMGMEwPMBRk6QPNRoiW2EKXlIY8DIUe86P
	 w+FrDl7R38+woD8X31WNCTnMA7zZeddDtCExXQgGfLyTQGWZCZbsHbOartd/pzTz8S
	 9jTKM99TSkGAZd2poyVbH4q+EIMXti0JustFbva6zhH8eQsYWSMcBQQ5EqVad2H3Bw
	 neCaXQr0Wf0DlWpjC5C9HEDfENEyQ7lsEy6spQeOoA3r/Cd//8t/pEBAI3QGR0Q0pq
	 Esb5PoMOVsidQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft 6/7] segtree: rename set_elem_add() to set_elem_expr_add()
Date: Fri,  5 Sep 2025 17:36:26 +0200
Message-Id: <20250905153627.1315405-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250905153627.1315405-1-pablo@netfilter.org>
References: <20250905153627.1315405-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

---
 src/segtree.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/src/segtree.c b/src/segtree.c
index f95a7ce1c8a8..f9dddaa99176 100644
--- a/src/segtree.c
+++ b/src/segtree.c
@@ -53,8 +53,8 @@ static void interval_expr_copy(struct expr *dst, struct expr *src)
 	list_splice_init(&src->stmt_list, &dst->stmt_list);
 }
 
-static void set_elem_add(const struct set *set, struct expr *init, mpz_t value,
-			 uint32_t flags, enum byteorder byteorder)
+static void set_elem_expr_add(const struct set *set, struct expr *init,
+			      mpz_t value, uint32_t flags, enum byteorder byteorder)
 {
 	struct expr *expr;
 
@@ -84,8 +84,8 @@ struct expr *get_set_intervals(const struct set *set, const struct expr *init)
 
 		switch (i->key->etype) {
 		case EXPR_VALUE:
-			set_elem_add(set, new_init, i->key->value,
-				     i->flags, byteorder);
+			set_elem_expr_add(set, new_init, i->key->value,
+					  i->flags, byteorder);
 			break;
 		case EXPR_CONCAT:
 			set_expr_add(new_init, expr_clone(i));
@@ -97,11 +97,11 @@ struct expr *get_set_intervals(const struct set *set, const struct expr *init)
 			break;
 		default:
 			range_expr_value_low(low, i);
-			set_elem_add(set, new_init, low, 0, i->byteorder);
+			set_elem_expr_add(set, new_init, low, 0, i->byteorder);
 			range_expr_value_high(high, i);
 			mpz_add_ui(high, high, 1);
-			set_elem_add(set, new_init, high,
-				     EXPR_F_INTERVAL_END, i->byteorder);
+			set_elem_expr_add(set, new_init, high,
+					  EXPR_F_INTERVAL_END, i->byteorder);
 			break;
 		}
 	}
-- 
2.30.2

