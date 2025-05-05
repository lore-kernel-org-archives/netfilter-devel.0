Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 219A730C1F7;
	Mon,  5 May 2025 23:42:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746488532; cv=none; b=gqTMr4tKR/XESmn0zXeN2W4vCoDLyOgQD7yWdTHHE0GvtbmE4L6yqiige+tP/Zk/4HtBi9J0QBN4oPYzcMfrMW9WrhsjIZknq+zoDJAbnLNc4+b9nWc+JkL0PnBJ6EjzIEQjWvXLg19/Eo0ojaNCGTNZ53sd4RAOISvxFl0RC6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746488532; c=relaxed/simple;
	bh=rHkIcYpd8IVf/yuDq1tl9uYYDKLeL1IrOA5/oplKYic=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nt70Po/lwejcqjWqXChqEnrTLEkgg0le3bvzAiqPRRczoc6kR84HmEGkf2ONWfpY7969Z6Kdbk9coZ90rwUIeTECli+mUm4/SAdLPbJbDhoTWJ9srQY2nCZ6nDKCLeJrrfWquHSmhrlst2O5FgA+Y4HyCJp9j0Coj3PAeCigQwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=V6Tplmlg; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=gXF7aWd0; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="V6Tplmlg";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="gXF7aWd0"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 8033560655; Tue,  6 May 2025 01:42:09 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1746488529;
	bh=r5HCCgoT0G3V8yuYwiKnaIC/5iF9MPectUiKQD7HoWw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V6TplmlgxIrlpkAqNR49BmZCCbe5MtTDR1nYFJ/S3mkiEh4/3aLTEw01meXK1enWD
	 g2U6Vep09BYO7ZhmevURLt2IuYBhcE2k5bgq7Erc8ONPGUDV50TZqfugONEIPfYeAd
	 PbArxmobWUygSOl2ljDxXsn6XLc4xG4zUw5PzJDcSBtLfKogXjI3TWjtbwSgdiFqTZ
	 Zs5MHTrZBFPBUR3ceMITtnmetVUZpS8e42F0ZjxnRv+VmEcjytEar5UX7mpqQRoTsR
	 NGLyirrmTJIOSx4FIa2uiIZ9d/Rxx2m6yRvBCetfw1sBu2+eAICN7XQ6fh4ouBAp4A
	 2+c9DQPZ0B7Og==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 78A0A60656;
	Tue,  6 May 2025 01:42:00 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1746488520;
	bh=r5HCCgoT0G3V8yuYwiKnaIC/5iF9MPectUiKQD7HoWw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gXF7aWd0jpXVvdCjpesX5BVdWMNyMChlCXr6TJe0XInurTz2pC1HOUDVT1XY3UD/I
	 XI6llja51AuCNJ/UP5TqeJsnLlQSG0ybaGqJ7W8i2M2iF7wyPJWhKiLpi6dfy9eZ0e
	 jMsVd2ziGpgOjSMuQLqEoqVyvqqRwV5Oy+f8CeZXSQJ3HkqJ8NV9FkMBA+LRrkr6/e
	 gCbN92TN+J/UPTsRxtBNqNdzT/4hvShRRIExJ+k60EVjPaCDgiIyQj7UZ8fAIderub
	 x1KGqtHhuZ1n3A8kdU8LLk08Z1qwA6JFggpj9l5GSza9X0/6kiHO/n8eB8s7o/5ZD4
	 pvmgUtENfP89Q==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH nf-next 6/7] netfilter: nft_set_pipapo: clamp maximum map bucket size to INT_MAX
Date: Tue,  6 May 2025 01:41:50 +0200
Message-Id: <20250505234151.228057-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250505234151.228057-1-pablo@netfilter.org>
References: <20250505234151.228057-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Otherwise, it is possible to hit WARN_ON_ONCE in __kvmalloc_node_noprof()
when resizing hashtable because __GFP_NOWARN is unset.

Similar to:

  b541ba7d1f5a ("netfilter: conntrack: clamp maximum hashtable size to INT_MAX")

Reviewed-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_set_pipapo.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index 0529e4ef7520..c5855069bdab 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -663,6 +663,9 @@ static int pipapo_realloc_mt(struct nft_pipapo_field *f,
 	    check_add_overflow(rules, extra, &rules_alloc))
 		return -EOVERFLOW;
 
+	if (rules_alloc > (INT_MAX / sizeof(*new_mt)))
+		return -ENOMEM;
+
 	new_mt = kvmalloc_array(rules_alloc, sizeof(*new_mt), GFP_KERNEL_ACCOUNT);
 	if (!new_mt)
 		return -ENOMEM;
@@ -1499,6 +1502,9 @@ static struct nft_pipapo_match *pipapo_clone(struct nft_pipapo_match *old)
 		       src->groups * NFT_PIPAPO_BUCKETS(src->bb));
 
 		if (src->rules > 0) {
+			if (src->rules_alloc > (INT_MAX / sizeof(*src->mt)))
+				goto out_mt;
+
 			dst->mt = kvmalloc_array(src->rules_alloc,
 						 sizeof(*src->mt),
 						 GFP_KERNEL_ACCOUNT);
-- 
2.30.2

