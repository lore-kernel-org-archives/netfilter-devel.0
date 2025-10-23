Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF35E286881
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Oct 2025 16:14:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761236068; cv=none; b=sDR2sWQkVyvKyLt0AFCE6IMCFJwcpvs1GOyb3GXLA+hP4OwHNhL43INBkl7vwMHQOMI7yF2Hiz89z1LNTQKr5LiUZd+DxekIZ7JXsQi6iWFmiz5Dt3SoZoEXJ1HEiGEXnIHRS3yq9A3HMngYtg2t3kpjzzgKlwprZx9v4nHn5rg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761236068; c=relaxed/simple;
	bh=6O+NNyiWxZ5KdouexBSOVSmtXPL3leZjSGkH7MtAlI8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bKpWF48ndspYhc42YyMtlpe5i8IUE8Qrw3qagAXz7e/ApccMyzgw/UiI71ge76WAcz1iy8A+gh4huRu9DygqN7pnInzyYdxkezSar4lUD65Wcw8i2eNnmcSqc/VwzkMtg3mMJ98TibqbwJdqlSLp9rmPx1PqSiXb5GDclYpcohE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=l9u26Nzb; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="l9u26Nzb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=J2hjyC89bVvhSlr9qKgvH9aLrxFxTQTAxnQLVYWvKPk=; b=l9u26NzbhICOPkRogQEyNGBpOm
	54ZAU44s9YDKeskGnSvywigbpoh8MAxa4F6o6OVlLT3Yh+2T4eO1FFU9W6gVB/1iSEJ7afUzrewRN
	Ugz0M3nQTn9K76meI3ZWhOxywtu8d1x/fAqCepKtbqFDoA9ok2VKHkjbx0eX5ONtgv65lj4L5cQnU
	kp9Zd/hKvR6atdU1rosDpWFAIrN8VoyHgVJ5eY7YYGLzdbb4AxNbpkmKQ6Dv3K5Ce38PeZV5V+5Z+
	NQCLHugAIXi3cjbv69iNF7a5Vn6ig41SMVh3Yz/lYGGW4YHX4PHMDkOALUZmabwJWE1+ZQMEc5b/k
	/WaWPpaw==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1vBxxJ-0000000004z-0YnN;
	Thu, 23 Oct 2025 18:14:25 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH 14/28] segtree: No byteorder conversion for string prefix len calculation
Date: Thu, 23 Oct 2025 18:14:03 +0200
Message-ID: <20251023161417.13228-15-phil@nwl.cc>
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

Not needed anymore since strings are defined as Big Endian.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/segtree.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/src/segtree.c b/src/segtree.c
index b9c35dcb297ce..5a334efc8bebb 100644
--- a/src/segtree.c
+++ b/src/segtree.c
@@ -387,8 +387,6 @@ void concat_range_aggregate(struct expr *set)
 			if (expr_basetype(r1)->type == TYPE_STRING &&
 			    expr_basetype(r2)->type == TYPE_STRING) {
 				string_type = true;
-				mpz_switch_byteorder(r1->value, r1->len / BITS_PER_BYTE);
-				mpz_switch_byteorder(r2->value, r2->len / BITS_PER_BYTE);
 			}
 
 			mpz_sub(range, r2->value, r1->value);
@@ -401,10 +399,6 @@ void concat_range_aggregate(struct expr *set)
 			 */
 			prefix_len = range_mask_len(r1->value, r2->value,
 						    r1->len);
-			if (string_type) {
-				mpz_switch_byteorder(r1->value, r1->len / BITS_PER_BYTE);
-				mpz_switch_byteorder(r2->value, r2->len / BITS_PER_BYTE);
-			}
 
 			if (prefix_len >= 0 &&
 			    (prefix_len % BITS_PER_BYTE) == 0 &&
@@ -535,9 +529,6 @@ add_interval(struct expr *set, struct expr *low, struct expr *i)
 	mpz_and(p, expr_value(low)->value, range);
 
 	if (!mpz_cmp_ui(range, 0)) {
-		if (expr_basetype(low)->type == TYPE_STRING)
-			mpz_switch_byteorder(expr_value(low)->value,
-					     expr_value(low)->len / BITS_PER_BYTE);
 		low->flags |= EXPR_F_KERNEL;
 		expr = expr_get(low);
 	} else if (range_is_prefix(range) && !mpz_cmp_ui(p, 0)) {
-- 
2.51.0

