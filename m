Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 165EF2356BC
	for <netfilter-devel@vger.kernel.org>; Tue,  8 Jul 2025 23:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752017045; cv=none; b=Enbv2t7Fc4oDO0bpc0VIgnQBmK0NLvgFPBqQM9SzKdtI0ZtczgjfFXD722WlH6xRE6+R2pQNGPrzJClTAz07Vec4XU3f1Q95tNlStvt8sdaC8lben4hCLTkhZQK34yyeC9OeYs5kUro9PaAoSyeU2nnCxgjoURbykAjTHFc0NZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752017045; c=relaxed/simple;
	bh=ep375/xnklv6rk404c6ylFQ7lOSGFiM63ohOdfdhOAQ=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=YBygXL1NN72T7uTqyvxMILX99nfv+vcQkg6cVsghYZ3NcJjeGrcT947C7SlzKjEDw2eesVgn/a3vd0jKAuRnUFDmlxDLPw4Az8dT4C5d3jGGd3ZzFCZJPSpMyBHyg0Y5luIr2V/JMqrnluQt0c5UuJ6ulnptMA/wifbOTQyF0yw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=NFlsoUuq; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=H8qOySXT; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="NFlsoUuq";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="H8qOySXT"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 0BD0860278; Wed,  9 Jul 2025 01:23:59 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1752017040;
	bh=hKNdVT0Ac6gYwExVW3bvIQ0wywFjGwLBbAbCJbaDXnI=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=NFlsoUuqGzjj1kHykGPUjwDKZmtAQ1gOCEND4sUhIu4tBAtna5m3mjUdoYlRdkstz
	 SMUI6S8Vel3VmKCPJStUi7UV/5Sfv+NOwna2SrBX3tybShnaBNF+zPHS2XsL1Xd9vk
	 LZqwMbvgjII4XIjrUMSQsImiS4JRrpTsunPCWPgbdBlzMGJHOSQtX3U31wWwM0ziKI
	 MI/pWHPAtJcowNkxZ1ZXnGJolEL7ldmG3vs/C5a19PsX8Lze2QQezd+rhtdHgHLUGS
	 cBolg2YqzW4oggk0XYhi62r6PKufBQB+afz1yzOf+BrKJ4n3r0jbLuZZYrK/zqE7lw
	 Qv5YrWBN3ySmQ==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id A6DEB60273
	for <netfilter-devel@vger.kernel.org>; Wed,  9 Jul 2025 01:23:59 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1752017039;
	bh=hKNdVT0Ac6gYwExVW3bvIQ0wywFjGwLBbAbCJbaDXnI=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=H8qOySXTKQXrDI4brlIPEolA0DZs1rhVVIDD49G4/CzIpv4W1XTN3tqqL0vaN+YMg
	 DTlxL35HJLyhFkhSJtA4avO4L59uzF7xIlYl09Ds1k+0MS7VP5q9hNY2siwDhWw8SJ
	 +zFxQ5eZ1EkrqgZ669QsY5meh1bNOPoSC8CLo75pNQh/aeXxDchWCIPeRWzwNM997e
	 zHXdMD68xJDN3YiD0RHFeHRm2pZBt2Pp4NtLtBlVnBUHwVfBJu6aMWXfBKpgDy6y+z
	 92ojr3iD5PEV/KINPUGmHX3lZQagFhxA3GpkYtRa21sNzXL9Fk+J50DeBEgk0ppJjV
	 mBQie8HV4nABQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft 1/4] evaluate: mappings require set expression
Date: Wed,  9 Jul 2025 01:23:51 +0200
Message-Id: <20250708232354.2189045-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250708232354.2189045-1-pablo@netfilter.org>
References: <20250708232354.2189045-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

While EXPR_CONCAT and EXPR_LIST share the same layout in struct expr,
these expressions are not possible at this stage.

Fall back to error out with "invalid mapping expression".

Fixes: 02d44b4f9917 ("evaluate: fix expression data corruption")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index a2d5d7c29514..83381b4ef3d0 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -2211,8 +2211,6 @@ static int expr_evaluate_map(struct eval_ctx *ctx, struct expr **expr)
 	mappings = map->mappings;
 
 	switch (map->mappings->etype) {
-	case EXPR_CONCAT:
-	case EXPR_LIST:
 	case EXPR_SET:
 		set_flags |= mappings->set_flags;
 		/* fallthrough */
-- 
2.30.2

