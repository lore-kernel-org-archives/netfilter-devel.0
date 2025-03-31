Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2457212FAB
	for <netfilter-devel@vger.kernel.org>; Mon, 31 Mar 2025 16:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743437645; cv=none; b=KySL7YkXp6qNU0e7VpxqnaF62O4nxwKGDT1WQfpaT6gPaUlZPiOb1gPRrUEwUHV1De4tgzhHhb7MNTiwdbTE2j7FGw9nrbIWnTEpfiLDkbF/dZblHM21C02TXFc08hGq+/71pKcV7qynPeUEim2rspG+oxElyOQ4LSY+aalwf9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743437645; c=relaxed/simple;
	bh=FznHBBODU+uLLn4mDL6mxVbK1oEKrR7013BVTShPsMM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=PvQz077Y8XkFr9B9Qm1dMMLAtUehi8hG0pmp8EacvYkEmgBHGBn4se++nPEW9TroljbCXWn/psKUsZb0MKokim4Kf0RvGYawjOQas2++DFJYyLZGXPCu9TY9F57j6u6PNvku5nvnIGE4tOZ/7VMVXfosnyrYrPe7U0CkJf6iX9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Ne73VvNH; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=lFaKrg7k; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Ne73VvNH";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="lFaKrg7k"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 2DED8603AE; Mon, 31 Mar 2025 18:14:02 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1743437642;
	bh=T5zDILDNHWo2Mv9PWs2YnlCokzizoquDiAxDroUOLtw=;
	h=From:To:Cc:Subject:Date:From;
	b=Ne73VvNHRuXZdmwDKjEP2DFlqKUcrxCb8JmkOyPX7KXYgvXJcL/diArVlEFknquBE
	 NP82bV5P38qAIECsmp95956hiHaoJpoZe0ORnHcck2h5ejJVaNAHVzBbyzYhIsDZw4
	 TZLNuara2BcKdxaQd9AyV9IO7y7xTgNpNPdXLqRzeohnFv+ZU+vzNff7GPHKUILjDj
	 /SlzNqTiROdbp/1SlsrwDq7nYC3oY4pVg+3Vzp2tXUU6LUZI/1SPcsICf9JUyhLWR9
	 /el5Xz84iPJCpzUOHSqgrFTgZYyhhFCDgHqfdkvYJ3pi3vHd1L6fPTYOhfFcnm37Zm
	 MjfNTIVqa2M4g==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 80669603AE;
	Mon, 31 Mar 2025 18:14:01 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1743437641;
	bh=T5zDILDNHWo2Mv9PWs2YnlCokzizoquDiAxDroUOLtw=;
	h=From:To:Cc:Subject:Date:From;
	b=lFaKrg7k7wTQ7+djtvWgUZLK+tYJDIKm5JnvJgRryFKcDqsxRPWxgeNTAC43IMXib
	 bUxvkuS+IexUAYb7wfvhqwXAbiT0NG72knr/mmo+6N11RZzxANQp+741DFjOptOjfU
	 v+7PPzQb1IXv2ONW6UdqANj7HJ+NrKy2Hcp2kLHgZ9R3bG2K9uApEnBG4o9oM7m6GL
	 UAP/ch+i98EwTcHCyyD2+nE9aCnwdVGU/zNj2ayhujUjWOWNxgclfYAo4p7NE+ZLqS
	 NMRIhU7WqxsqGHs94XrOPyAm4ukN9i6vmS3s5tztUfOSMDmETJq7aAiBEjh9kUcQ1G
	 IaeOeLyQdG8nQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de
Subject: [PATCH nft] parser_json: reject empty jump/goto chain
Date: Mon, 31 Mar 2025 18:13:58 +0200
Message-Id: <20250331161358.598022-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When parsing a verdict map json where element jumps to chain represented
as empty string.

internal:0:0-0: Error: Parsing list expression item at index 0 failed.
internal:0:0-0: Error: Invalid set elem at index 0.
internal:0:0-0: Error: Invalid set elem expression.
internal:0:0-0: Error: Parsing command array at index 2 failed.

Fixes: 586ad210368b ("libnftables: Implement JSON parser")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
This is extra, on top of Florian's fix to address this from the evalution
step, not a replacement.

 src/parser_json.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/src/parser_json.c b/src/parser_json.c
index 04d762741e4a..ef7740840710 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -1350,6 +1350,9 @@ static struct expr *json_parse_verdict_expr(struct json_ctx *ctx,
 		    json_unpack_err(ctx, root, "{s:s}", "target", &chain))
 			return NULL;
 
+		if (!chain || chain[0] == '\0')
+			return NULL;
+
 		return verdict_expr_alloc(int_loc, verdict_tbl[i].verdict,
 					  json_alloc_chain_expr(chain));
 	}
-- 
2.30.2

