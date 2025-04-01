Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D68D2156677
	for <netfilter-devel@vger.kernel.org>; Tue,  1 Apr 2025 14:36:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743518220; cv=none; b=qyFjNk/NMb5XpuRaBY+8Ciy7LrFo547g7QHS1Q67zWFobM22XSP/Y1L2imf7SWOLnjuYPEL5Jk2VGcH4uMROpXvUTa2Fr5u+CvHqN2Unh4nKsBgzUJFSyA2YtNdPC153LxdDtyw43cudkJF8+XIiaMtoGosb6bUXCM5otq304nA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743518220; c=relaxed/simple;
	bh=G2TI8JLUUVg+6a0hVroN+pJxHLpsFYOB02bLypRkN5s=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=nP/TETTbYLc1yMha+y9HPL5NgsVieSpV/s+NJoAWsUoIVYiGi7b6miBjz5AU0VlGgnGKbbjbKwMDRcFEaE9a8NrknFdlwgMGi8f0zIcUx6NKhwavggQsviLE/DyNs7HYrwA+agyTuFKzZM+UbR2P8j+itxyRrF64wmy66icllmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=cYeVj/4W; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=cYeVj/4W; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="cYeVj/4W";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="cYeVj/4W"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id C29D76054C; Tue,  1 Apr 2025 16:36:55 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1743518215;
	bh=nHbQOHyLSSh7sxUoTx84b4ZqwiA4yNlLb1L7lrmTqwQ=;
	h=From:To:Subject:Date:From;
	b=cYeVj/4W5VYFKXU2CkhQNX+nEDmXL1pG1i/MRPgahMvhELPah0KC68C1EpPPJ9jfT
	 Rlhf6PPkHR5YEt+sL5mi1m5hhWhEKez4DnFmIbKHsLjDzf11R+pzf+AOK8cdx2bGa2
	 SPii+pjqWi9U7SKxzlKfXkXRQ2zppJ4VQ6jfYUlTo/N8fetMZZjHMc/1QMwaLJjmYH
	 GcEz2y4b1IKhHhRXL8x1KC0LMkDOMZpGpO0oi0NvoU8HJ1FZNeIMP8SeANrGLdXBtU
	 P2UKisGMW+k64h6wOrg/haXm22se8D44fI+eP6JDBXetiV9NNd5BdZPJxn7M1uH+WH
	 cL/akts14BbuQ==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 6A87E603B8
	for <netfilter-devel@vger.kernel.org>; Tue,  1 Apr 2025 16:36:55 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1743518215;
	bh=nHbQOHyLSSh7sxUoTx84b4ZqwiA4yNlLb1L7lrmTqwQ=;
	h=From:To:Subject:Date:From;
	b=cYeVj/4W5VYFKXU2CkhQNX+nEDmXL1pG1i/MRPgahMvhELPah0KC68C1EpPPJ9jfT
	 Rlhf6PPkHR5YEt+sL5mi1m5hhWhEKez4DnFmIbKHsLjDzf11R+pzf+AOK8cdx2bGa2
	 SPii+pjqWi9U7SKxzlKfXkXRQ2zppJ4VQ6jfYUlTo/N8fetMZZjHMc/1QMwaLJjmYH
	 GcEz2y4b1IKhHhRXL8x1KC0LMkDOMZpGpO0oi0NvoU8HJ1FZNeIMP8SeANrGLdXBtU
	 P2UKisGMW+k64h6wOrg/haXm22se8D44fI+eP6JDBXetiV9NNd5BdZPJxn7M1uH+WH
	 cL/akts14BbuQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft 1/2] parser_json: allow statement stateful statement only in set elements
Date: Tue,  1 Apr 2025 16:36:50 +0200
Message-Id: <20250401143651.1313098-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Upfront reject of non stateful statements in set elements.

Fixes: 07958ec53830 ("json: add set statement list support")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/parser_json.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/src/parser_json.c b/src/parser_json.c
index 053dd81a076f..4c9dc5415445 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -2433,6 +2433,11 @@ static void json_parse_set_stmt_list(struct json_ctx *ctx,
 			stmt_list_free(stmt_list);
 			return;
 		}
+		if (!(stmt->flags & STMT_F_STATEFUL)) {
+			stmt_free(stmt);
+			json_error(ctx, "Unsupported set statements array at index %zd failed.", index);
+			stmt_list_free(stmt_list);
+		}
 		list_add(&stmt->list, head);
 		head = &stmt->list;
 	}
-- 
2.30.2

