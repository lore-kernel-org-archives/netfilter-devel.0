Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B1967602C
	for <netfilter-devel@vger.kernel.org>; Thu,  8 Feb 2024 12:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707396902; cv=none; b=CqOxfDr7ZfWKSxgd2vOGa3aC43vxVtL/JBIn0eOu6NPpMYY567qjlcG/rkKcuD1VfVXoy7ZN3feEK2Ht9HuJ4PmP2sxuWAD5Vk6jffp+6eaGh2FdWwzHe3BC96IEeDVw7v3DzL5iPEfJiGbRsBPyCukn8l69R4M8AdZK09/99y8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707396902; c=relaxed/simple;
	bh=B58ZdtDXkAEUvfO5XCjzvTF5kjHYMh73EkC8DHX3RE8=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=J50no8ZpxAzerzhW4vBZTFx81xNoFlZxmKU93f1ZzY6Z8rPnrLEUbjStmelUevIful6vBYCSPKGNg2o4baH/YLgtMjbx1WLzMMf4hqZoeyJJuAn2Qe9tM7V/HPQcCcGzcSTYNP9JEgM4yCBy9bzwPZwdEKG/h5STF3ezskDA3jo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nft 2/2] netlink_linearize: add assertion to catch for buggy byteorder
Date: Thu,  8 Feb 2024 13:54:47 +0100
Message-Id: <20240208125447.272965-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240208125447.272965-1-pablo@netfilter.org>
References: <20240208125447.272965-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add assertion to catch buggy bytecode where unary expression is present
with 1-byte, where no byteorder conversion is required.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/netlink_linearize.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index 50dbd36c1b8e..6204d8fd2668 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -797,6 +797,8 @@ static void netlink_gen_unary(struct netlink_linearize_ctx *ctx,
 	struct nftnl_expr *nle;
 	int byte_size;
 
+	assert(div_round_up(expr->arg->len, BITS_PER_BYTE) != 1);
+
 	if ((expr->arg->len % 64) == 0)
 		byte_size = 8;
 	else if ((expr->arg->len % 32) == 0)
-- 
2.30.2

