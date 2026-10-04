Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 722B0450402
	for <netfilter-devel@vger.kernel.org>; Sun,  4 Oct 2026 19:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791143998; cv=none; b=oVnXzbAMjMrSpall6hC9B2yEK7jFtuDhctHzT39qCWfXs8mS/rahZSv53V7JWFLXJ7QgoYT7kLBZ89mRO1BXjAjhPrQGLgIlruzN1aGJksXkGW1eyqffh3rObm66o9HAKfPCmhSkmmpVm2OUpP1Z1cmk43jr58ISEbRQIxNCSLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791143998; c=relaxed/simple;
	bh=AaXFQDGVnS61VeRbZY2j4eY1toZNsIZXmIM8BMoSdBc=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=M4hqy5KS5L1bDC7fsREWRdAeXyflNwpyMEIeoMH2q3e9psJjjUWpEkuYpxYG/BEXQB9aXBMKsR9BsObJdAtlXJL2ghzih7tMjRSfBvOJuVy/PZ83nXujs8pjSt6FKhGb/SMHeScOzgpaKS7YL1y9LOsJlZ62bvxhnNYWfBeJS/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=sxTIw0Bf; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="sxTIw0Bf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1791143993;
	bh=XHEWkjJ8zC6lhZUqf4giqhcDkOXpd2hM6HJhLNIvZEs=;
	h=From:To:Subject:Date:From;
	b=sxTIw0BfRFB3hBdus282qR7JHRvNqTwM/fqmGaQqJ64gDOVBpj1prRpT8f3S0gmXh
	 L4Aiu7pit9ciNg3aoj9G9w6V8bJe3BwTk8ZR6Z5qkDW8VAFMIcZMJDDzpaUQiRe1lW
	 btG9p+5kY5LRZdEksBp1BQDV/ewiLkb6m6zdwz7QYughuB9nGWwZLTXLwuKIh9b6xq
	 bUff+7Zt207COJvG63otKWr4+aomXgg8VII+EbVnzdY3wFrEPab7V3H+wCr6DOJy5W
	 zPscgshX+QagTASLbAu/3hourUbxbTAyl+T1M46AYyA63KJWCPLpCx79VSh00zvAJX
	 FlafN+EUguz1w==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 8C2A660235
	for <netfilter-devel@vger.kernel.org>; Sun,  4 Oct 2026 21:59:53 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH libnftnl] set: Check array boundary when parsing NFTA_SET_DESC_CONCAT
Date: Sun,  4 Oct 2026 21:59:50 +0200
Message-ID: <20261004195950.355927-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When parsing NFTA_SET_DESC_CONCAT coming from the kernel, make sure
provided list does not go over the boundary, resulting in an array
overrun. This is hardening for correctness, kernel should not be sending
a list larger than NFT_REG32_COUNT.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/set.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/src/set.c b/src/set.c
index a017017e1fb6..6444de0affba 100644
--- a/src/set.c
+++ b/src/set.c
@@ -548,6 +548,9 @@ nftnl_set_desc_concat_field_parse_attr_cb(const struct nlattr *attr, void *data)
 	if (mnl_attr_validate(attr, MNL_TYPE_U32))
 		return MNL_CB_ERROR;
 
+	if (s->desc.field_count >= NFT_REG32_COUNT)
+		return -1;
+
 	s->desc.field_len[s->desc.field_count] = ntohl(mnl_attr_get_u32(attr));
 	s->desc.field_count++;
 
-- 
2.47.3

