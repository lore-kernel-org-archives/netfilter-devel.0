Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D91B01CA81
	for <netfilter-devel@vger.kernel.org>; Fri, 31 Jan 2025 10:47:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738320449; cv=none; b=YJnFRXnXAVnZzoOsM+OipF7utgzuDibq7UhWwwxKP2zDOHBUgrovAaJAqf7BSQfsg+0Exn5nkFR6tyNe6LSIj9FyO2fY2iQ++jl8UqZYWZtsXNKizJTZRydfwbHS47VENQWQq04Co4gYMsf0gLZzqfeKSAxU78qG5ibbMUrhcDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738320449; c=relaxed/simple;
	bh=HMkSYM1xZbM36dpFDLFNkwn/GAAcrrN1k2q+dN0pFvw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=dYz0H9UwZeX6Ozm0GhuVYHQ3JYGKdAXDOVeEhKqe8eR3dSCB7LvEAD7ZGvBGBDYfZjRb/09jJToAqFMqWI8QInXvwaKagECAUfkuuIhn2tdtzMqvSc0p38dgF6+am2YZ96wXQc/fAFADAHeAVWBwAMCpN4fsdqRWBxje/04Za+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=KA/YM6U6; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=KA/YM6U6; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="KA/YM6U6";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="KA/YM6U6"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id A02126028F; Fri, 31 Jan 2025 11:47:23 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1738320443;
	bh=nUJAyYEZXz93/xPnWk7HhGN9xyp/QkczgBliARiiCkM=;
	h=From:To:Cc:Subject:Date:From;
	b=KA/YM6U6g6DhLrvy2fb0tfCzaENSpC+fZj4H4IzdbotgwZCg/ilFLy62cYBwiOvLW
	 9tHYdD6qGwg/URFUghV4/0qtiI/WbIgxDBpeXYjdA6uXsbgN+jDP6tYNjXgsKSkuIw
	 cwGBvf2qKR9dHWb4+hRe8Y2HbNECxESztdAEu0CIByAskw55HDf2WE6j9LWR4gWd8z
	 H5gak0nSL/fvfn2uSlJfNbiE7TJYfH0G4biUiJtXCVfPBaXBP9ExaPDTzUNhI/rvgT
	 cmVqLvmdkm5B0ZQn93+dm0TjEYqTbvndnTtir2O6dzW/w0XXh3hHxR8s2EwVT4i6JL
	 Mq9VE2Cv6VCWg==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 1131160287;
	Fri, 31 Jan 2025 11:47:23 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1738320443;
	bh=nUJAyYEZXz93/xPnWk7HhGN9xyp/QkczgBliARiiCkM=;
	h=From:To:Cc:Subject:Date:From;
	b=KA/YM6U6g6DhLrvy2fb0tfCzaENSpC+fZj4H4IzdbotgwZCg/ilFLy62cYBwiOvLW
	 9tHYdD6qGwg/URFUghV4/0qtiI/WbIgxDBpeXYjdA6uXsbgN+jDP6tYNjXgsKSkuIw
	 cwGBvf2qKR9dHWb4+hRe8Y2HbNECxESztdAEu0CIByAskw55HDf2WE6j9LWR4gWd8z
	 H5gak0nSL/fvfn2uSlJfNbiE7TJYfH0G4biUiJtXCVfPBaXBP9ExaPDTzUNhI/rvgT
	 cmVqLvmdkm5B0ZQn93+dm0TjEYqTbvndnTtir2O6dzW/w0XXh3hHxR8s2EwVT4i6JL
	 Mq9VE2Cv6VCWg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: akashavkin@gmail.com
Subject: [PATCH nft 1/2] ipopt: use ipv4 address datatype for address field in ip options
Date: Fri, 31 Jan 2025 11:47:15 +0100
Message-Id: <20250131104716.492246-1-pablo@netfilter.org>
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

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/ipopt.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/src/ipopt.c b/src/ipopt.c
index 37f779d468ab..ddb42f5712d4 100644
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
 
@@ -56,7 +56,7 @@ static const struct exthdr_desc ipopt_ra = {
 	.templates	= {
 		[IPOPT_FIELD_TYPE]		= PHT("type",   0,   8),
 		[IPOPT_FIELD_LENGTH]		= PHT("length", 8,   8),
-		[IPOPT_FIELD_VALUE]		= PHT("value",  16, 16),
+		[IPOPT_FIELD_ADDR_0]		= PROTO_HDR_TEMPLATE("addr", &ipaddr_type, BYTEORDER_BIG_ENDIAN, 24, 32),
 	},
 };
 
-- 
2.30.2

