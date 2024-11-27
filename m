Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1A7E1FCD1B
	for <netfilter-devel@vger.kernel.org>; Wed, 27 Nov 2024 18:01:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732730471; cv=none; b=Puje+4r9EZe0gJkRNnyaDxK8p1X+/pMytltGgRidBGFK6ARSE9yMOyhuc6rnU56Ex5lDqXyo0k+VxITPVfMid5pvGJHqq1xwI9NYjPLfxNVYWklrgQTtH76fVveBfz0wYlRel4YR8OCc4EXnre1JtXF51ztPP8PSD6459gM5skg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732730471; c=relaxed/simple;
	bh=emYYHnjNIanaOLpgyZ53/jBUkXpVFwROharbaC+N1QI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EnnT9XmyRTdPuUhp/hQzN18dr/WEICFNPWtDpGUuHPReI23+PE4sluqP287GFUerYXYsnlpj/8n5yKyyNkPu7PKJyQXjqsKs8UQmwFnMEYbL2yGr2pCimq9GCLuLfVnE0rrIrr74mFT4rf95kbN4I6LAr9epoQ1YBbMsjjbO32U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=DNkb8MQQ; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="DNkb8MQQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=u77V+uvJAcF8sDtIx3i8dZKk6cc8WpspEgg+tiLeQO0=; b=DNkb8MQQzOhqmcGuU4+BFovic7
	gYiUsdwF0CjrHhK+5clPsPbEbubUtKWkCQR4VPTWM0JJsqkt6iBF7Xcj86MyPrfhSvtzKil1hIM/e
	5vf//osu5kh+/Z3RSGEa9bTmF15MfwptDFyCuSSF+Fe1YwIRAB7CSFx0rYXYHDCkbzvR/tZxbbPGS
	Af0xsdv2n1f1ZpgLjmMrsE8BzgSDtNQyanjYOmvskQ4xlNfIDy38LRKXWpCe9LHdb7+G1ro5OShU6
	RynJUFPo2UiSBJ6b3pyDqz7Hi/kd0cJ0L0gHS8QsYL2SGE3P7vKPFwPz9oy6PUMf3eWT746gPo1K8
	Jhq50eiQ==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1tGMLV-000000000F4-1Xfx;
	Wed, 27 Nov 2024 19:01:01 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: [libnftnl PATCH 3/3] tests: Fix for ASAN
Date: Wed, 27 Nov 2024 19:01:03 +0100
Message-ID: <20241127180103.15076-3-phil@nwl.cc>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241127180103.15076-1-phil@nwl.cc>
References: <20241127180103.15076-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The 'data' arrays in match and target expression tests were undersized
as they did not cover for the terminating NUL-char of the string used to
initialize them. When passing such array to strdup(), the latter reads
until after the defined array boundary.

Fixes: 93483364369d8 ("src: get rid of cached copies of x_tables.h and xt_LOG.h")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tests/nft-expr_match-test.c  | 2 +-
 tests/nft-expr_target-test.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tests/nft-expr_match-test.c b/tests/nft-expr_match-test.c
index 53a8b849c4847..bc9f6ac1b9ac8 100644
--- a/tests/nft-expr_match-test.c
+++ b/tests/nft-expr_match-test.c
@@ -54,7 +54,7 @@ int main(int argc, char *argv[])
 	char buf[4096];
 	struct nftnl_expr_iter *iter_a, *iter_b;
 	struct nftnl_expr *rule_a, *rule_b;
-	char data[16] = "0123456789abcdef";
+	char data[] = "0123456789abcdef";
 
 	a = nftnl_rule_alloc();
 	b = nftnl_rule_alloc();
diff --git a/tests/nft-expr_target-test.c b/tests/nft-expr_target-test.c
index 89de945e58348..a483e7ac24dd8 100644
--- a/tests/nft-expr_target-test.c
+++ b/tests/nft-expr_target-test.c
@@ -53,7 +53,7 @@ int main(int argc, char *argv[])
 	char buf[4096];
 	struct nftnl_expr_iter *iter_a, *iter_b;
 	struct nftnl_expr *rule_a, *rule_b;
-	char data[16] = "0123456789abcdef";
+	char data[] = "0123456789abcdef";
 
 	a = nftnl_rule_alloc();
 	b = nftnl_rule_alloc();
-- 
2.47.0

