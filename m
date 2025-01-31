Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B064238DC0
	for <netfilter-devel@vger.kernel.org>; Fri, 31 Jan 2025 13:20:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738329603; cv=none; b=ObG3AYajTkP8TibMB/6T+m9HEe0UeM6jIWTOEsmYelK2pcG42ywghKJebuZtVjd9xLeFSABi/KcBkxgI1fs8LcvekHxdb9t9eSEbPo8A6K6T/VMW5m64WzoeDDbmnnF/vp0XcU1xm+ENlbbSmYC38nq6QdKAVAtgQL5DlCnmAwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738329603; c=relaxed/simple;
	bh=d1Cdin38e47vgxOMCl+ru8CKwWWFDYE31XXHdnOXTjM=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=q2Df0NmQDymeOs+ymdMiDHBbWaoOLBkqk91vTf2Wzj1uIYylO1+s91IJpvqWXS+aIaqKn3tUUsAaiRBcEOz94tNgeDli29sX5FQmPhRp0j7U50+YHKTJdRzr8yJes76ckoM+gX4wuDpJGeOFPTl10TSYWOhApvVNxGEPVePB+WM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=RfroyxMY; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=RfroyxMY; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="RfroyxMY";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="RfroyxMY"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id C676160285; Fri, 31 Jan 2025 14:19:58 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1738329598;
	bh=N//V7GDE2V5A9km46FVi5vd1lB2KhRA2LIPjaMSGgKk=;
	h=From:To:Subject:Date:From;
	b=RfroyxMYJw3py72+7/lLaZAHVVjtuK1V+IzLH7WNp3JDCylkqkZ89uEOxlXdAjxYw
	 sZwPka8k33AGDAb+32fFPcs06u48UgZE4TqekTnq06Ltv/+/onc1T0EZgZ89M4ONxB
	 B9uKZdPfpnzlVMlvCVhHqv96bs4Mff9Bqzc77WuEhxNBVhwGe79ikXe1RtTk87qFfz
	 MBzjWPlsqlVQPfDYU3DCjLnHnjSRTyfSVepURFVaTxPx4y687ywUoiFAZIpry1y3J2
	 4aSwJ6kYeXIPsILrx3cPU8OnPI0ZqhmHat/c0yOX3knslN7F7ZNA5ltTebAIT0hnBw
	 BEnqPCsD6shTg==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 5B8C460283
	for <netfilter-devel@vger.kernel.org>; Fri, 31 Jan 2025 14:19:58 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1738329598;
	bh=N//V7GDE2V5A9km46FVi5vd1lB2KhRA2LIPjaMSGgKk=;
	h=From:To:Subject:Date:From;
	b=RfroyxMYJw3py72+7/lLaZAHVVjtuK1V+IzLH7WNp3JDCylkqkZ89uEOxlXdAjxYw
	 sZwPka8k33AGDAb+32fFPcs06u48UgZE4TqekTnq06Ltv/+/onc1T0EZgZ89M4ONxB
	 B9uKZdPfpnzlVMlvCVhHqv96bs4Mff9Bqzc77WuEhxNBVhwGe79ikXe1RtTk87qFfz
	 MBzjWPlsqlVQPfDYU3DCjLnHnjSRTyfSVepURFVaTxPx4y687ywUoiFAZIpry1y3J2
	 4aSwJ6kYeXIPsILrx3cPU8OnPI0ZqhmHat/c0yOX3knslN7F7ZNA5ltTebAIT0hnBw
	 BEnqPCsD6shTg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft,v2] ipopt: use ipv4 address datatype for address field in ip options
Date: Fri, 31 Jan 2025 14:19:41 +0100
Message-Id: <20250131131941.986200-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

So user does not have to play integer arithmetics to match on IPv4
address.

Before:

 # nft describe ip option lsrr addr
 exthdr expression, datatype integer (integer), 32 bits

After:

 # nft describe ip option lsrr addr
 exthdr expression, datatype ipv4_addr (IPv4 address) (basetype integer), 32 bits

Fixes: 226a0e072d5c ("exthdr: add support for matching IPv4 options")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: incorrect mangling of ip option ra.

 src/ipopt.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/src/ipopt.c b/src/ipopt.c
index 37f779d468ab..c03a80415fe2 100644
--- a/src/ipopt.c
+++ b/src/ipopt.c
@@ -24,7 +24,7 @@ static const struct exthdr_desc ipopt_lsrr = {
 		[IPOPT_FIELD_TYPE]		= PHT("type",    0,  8),
 		[IPOPT_FIELD_LENGTH]		= PHT("length",  8,  8),
 		[IPOPT_FIELD_PTR]		= PHT("ptr",    16,  8),
-		[IPOPT_FIELD_ADDR_0]		= PHT("addr",   24, 32),
+		[IPOPT_FIELD_ADDR_0]		= PROTO_HDR_TEMPLATE("addr", &ipaddr_type, BYTEORDER_BIG_ENDIAN, 24, 32),
 	},
 };
 
@@ -35,7 +35,7 @@ static const struct exthdr_desc ipopt_rr = {
 		[IPOPT_FIELD_TYPE]		= PHT("type",   0,   8),
 		[IPOPT_FIELD_LENGTH]		= PHT("length",  8,  8),
 		[IPOPT_FIELD_PTR]		= PHT("ptr",    16,  8),
-		[IPOPT_FIELD_ADDR_0]		= PHT("addr",   24, 32),
+		[IPOPT_FIELD_ADDR_0]		= PROTO_HDR_TEMPLATE("addr", &ipaddr_type, BYTEORDER_BIG_ENDIAN, 24, 32),
 	},
 };
 
@@ -46,7 +46,7 @@ static const struct exthdr_desc ipopt_ssrr = {
 		[IPOPT_FIELD_TYPE]		= PHT("type",   0,   8),
 		[IPOPT_FIELD_LENGTH]		= PHT("length",  8,  8),
 		[IPOPT_FIELD_PTR]		= PHT("ptr",    16,  8),
-		[IPOPT_FIELD_ADDR_0]		= PHT("addr",   24, 32),
+		[IPOPT_FIELD_ADDR_0]		= PROTO_HDR_TEMPLATE("addr", &ipaddr_type, BYTEORDER_BIG_ENDIAN, 24, 32),
 	},
 };
 
-- 
2.30.2

