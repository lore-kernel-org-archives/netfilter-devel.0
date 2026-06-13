Received: from zg8tmtyylji0my4xnjqumte4.icoremail.net (zg8tmtyylji0my4xnjqumte4.icoremail.net [162.243.164.118])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB10E39C00F
	for <netfilter-devel@vger.kernel.org>; Sat, 13 Jun 2026 10:27:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.243.164.118
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781346479; cv=none; b=amNBgrnx81pa9Zs4c9kqjDUnnJyx+HLxKGPc2S4XxwYGZnkZeGQ0mlS4lcoSUSQTdSsQ8qdwe8GWhAj8DeASfksaoEiHd0CniIUNnzEI+I1i/F1vOM1x1e7MJUQUn/k9+g1kSaJwFxX+afZr4F64pnA7N9KEa8GvGCNW6RzT0bU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781346479; c=relaxed/simple;
	bh=Qu1yX2vVMiHNu8yxCH/BhEy9YGa2rIfOkivUYM+V1Po=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XAe4IdRVfTqkW6bnNWGMocgeYxYXCq7k+wIM3iPTxp0e+dP2fhNjs+n29+hIQuKdiio+8E+pj/CxLsjU7S+Uk45FI8vKybGbF8kLnMTkr1r0AuCBQnSxHaHOPyrAMbos7jtq0EHFueCXTVBfhFZebVhFHeE2QklgszeNnVEvKz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lzu.edu.cn; spf=pass smtp.mailfrom=lzu.edu.cn; arc=none smtp.client-ip=162.243.164.118
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lzu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lzu.edu.cn
Received: from enjou-Legion-Y7000P-2019 (unknown [172.23.56.36])
	by app1 (Coremail) with SMTP id ygmowAAHKMKKMC1qHPuBAA--.19853S3;
	Sat, 13 Jun 2026 18:27:27 +0800 (CST)
From: Ren Wei <n05ec@lzu.edu.cn>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	kaber@trash.net,
	yuantan098@gmail.com,
	yifanwucs@gmail.com,
	tomapufckgml@gmail.com,
	zcliangcn@gmail.com,
	bird@lzu.edu.cn,
	bronzed_45_vested@icloud.com,
	n05ec@lzu.edu.cn
Subject: [PATCH nf 1/1] netfilter: xt_nat: reject unsupported target families
Date: Sat, 13 Jun 2026 18:27:15 +0800
Message-ID: <5722ce33544cc22da3f811de77ab57847eb58366.1781144570.git.bronzed_45_vested@icloud.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1781144570.git.bronzed_45_vested@icloud.com>
References: <cover.1781144570.git.bronzed_45_vested@icloud.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:ygmowAAHKMKKMC1qHPuBAA--.19853S3
X-Coremail-Antispam: 1UD129KBjvJXoW7tF1xWryxKrWxCF4rGFy7trb_yoW8WFy8pa
	y3Gr1DGr93XryavFn7tryxCF45ArZxGF1I9r98KFykZ3WDWFyUKw1SqFZIvFn8AFZ0kFW5
	AFsFvFsrA34ay37anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUB01xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AE
	w4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2
	IY67AKxVW5JVW7JwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVWxJVW8Jr1l84ACjcxK6I8E
	87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE3s1le2I262IYc4CY6c
	8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_
	Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwI
	xGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc7CjxVAa
	w2AFwI0_Jw0_GFylc2xSY4AK6svPMxAIw28IcxkI7VAKI48JMxAIw28IcVCjz48v1sIEY2
	0_Gr4l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8G
	jcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2I
	x0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK
	8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I
	0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUonmRUUUUU
X-CM-SenderInfo: zqqvvuo6o23hxhgxhubq/1tbiAQERCWotEtIA1wAAsI

From: Wyatt Feng <bronzed_45_vested@icloud.com>

xt_nat SNAT and DNAT target handlers assume IP-family conntrack state
is present and can dereference a NULL pointer when instantiated from an
unsupported family through nft_compat. A bridge-family compat rule can
therefore trigger a NULL-dereference in nf_nat_setup_info().

Reject non-IP families in xt_nat_checkentry() so unsupported targets
cannot be installed. Keep NFPROTO_INET allowed for valid inet NAT
compat users and leave the runtime fast path unchanged.

Fixes: c7232c9979cb ("netfilter: add protocol independent NAT core")
Cc: stable@vger.kernel.org
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Reported-by: Zhengchuan Liang <zcliangcn@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Assisted-by: Codex:GPT-5.4
Signed-off-by: Wyatt Feng <bronzed_45_vested@icloud.com>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
---
 net/netfilter/xt_nat.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/net/netfilter/xt_nat.c b/net/netfilter/xt_nat.c
index b4f7bbc3f3ca..51c7f7ce88d9 100644
--- a/net/netfilter/xt_nat.c
+++ b/net/netfilter/xt_nat.c
@@ -26,6 +26,15 @@ static int xt_nat_checkentry_v0(const struct xt_tgchk_param *par)
 
 static int xt_nat_checkentry(const struct xt_tgchk_param *par)
 {
+	switch (par->family) {
+	case NFPROTO_IPV4:
+	case NFPROTO_IPV6:
+	case NFPROTO_INET:
+		break;
+	default:
+		return -EINVAL;
+	}
+
 	return nf_ct_netns_get(par->net, par->family);
 }
 
-- 
2.47.3

