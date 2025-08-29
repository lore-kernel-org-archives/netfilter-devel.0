Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38F213218A1
	for <netfilter-devel@vger.kernel.org>; Fri, 29 Aug 2025 14:25:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756477526; cv=none; b=gwpg/2a2uKH+rRw/LgiVLTZDYaiBGd6kgpr1srRndmZrkW7tp0c7wQPVtfmeTSIThLnprI7BlesiCrZrqgS6gsDJAG+NNIwj80Yyht2mFaq/OkTgY7kaWjDf/VnGrwrvXhSAWFSWXIe5eMNobX+vOeZY953//bz89aUygwq5hJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756477526; c=relaxed/simple;
	bh=9VIyt/DbP+afJeqEA5vU5VxIZvNNG4KFn4yjdzjO9uY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kGmVFv+iZ7oVu57AzbgnLaVg7aUZWJ6sve/dKxzic5smXIRie+UnkCmQ6cyZ8ebR1fGzPWbYBTH5mEGBSsrNAK0xoxY3BFPwJm34nbqRLDDP65wa/qsWLPUGBBBcsHz4Ef/qEL+/Nree04KjHTtqoZswMU9AYI5b46CQJkNm8vA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=YCUd7VEg; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="YCUd7VEg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=+izKacyARpBt2TBwrGxJY7TTrV0CUeIhRxxiwqaVzEk=; b=YCUd7VEgPbmpGhlEYw+XVIEUN2
	5g0QvuRV+hAb6Pf5NxlZE4jG0bZDzXoVXgq01Wr5iFWs7V8UYYTE3Qlllhf9ugVNZUV0fuhs/7HXB
	i66b7Ivlzj/dqaPY8B/bWk506WZVRvpXqWL153ucQHXWIfc4bhF7Ol65nQrngquecoAoVC9zHmKOj
	jw5wjLmTK16cv/Cuq6w0c1AI9xlgvt8vcKjWH9w/yf7gt7WjjM7XwM5ZZMTN253lYb1TuYumRsc9d
	iR7tvhvEE54i4TcKvhcZwoWKHuR3TVpCALmUFe9up0dO6AeAPAs7VhIHEINUOLCPnRH8vU1MfU4DK
	8zeecuFg==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1us02c-0000000073J-1ygo;
	Fri, 29 Aug 2025 16:25:22 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [nft PATCH 2/5] monitor: Quote device names in chain declarations, too
Date: Fri, 29 Aug 2025 16:25:10 +0200
Message-ID: <20250829142513.4608-3-phil@nwl.cc>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250829142513.4608-1-phil@nwl.cc>
References: <20250829142513.4608-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fixed commit missed the fact that there are two routines printing chain
declarations.

Fixes: eb30f236d91a8 ("rule: print chain and flowtable devices in quotes")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/rule.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/rule.c b/src/rule.c
index ceb56488d37f6..d0a62a3ee002d 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -1131,7 +1131,7 @@ void chain_print_plain(const struct chain *chain, struct output_ctx *octx)
 
 			nft_print(octx, "devices = { ");
 			for (i = 0; i < chain->dev_array_len; i++) {
-				nft_print(octx, "%s", chain->dev_array[i]);
+				nft_print(octx, "\"%s\"", chain->dev_array[i]);
 				if (i + 1 != chain->dev_array_len)
 					nft_print(octx, ", ");
 			}
-- 
2.51.0

