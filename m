Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0E3919D8A8
	for <netfilter-devel@vger.kernel.org>; Mon,  8 Sep 2025 14:09:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757340568; cv=none; b=n/mFsMhn+kECw0yAFywjalTt2ytLkPvYz5nNZv1ChY+293eWDKvI9OFfkDDWFrk31XME25fRNvX8ofJIFXQLuhQJV/t53ig05uMw7bNNyXzJOMJ5pUY1whXGSGjKZxpUHpnxai/lJhCspNFd8e/tIzxb5KmolTNQ9vOs1A625eE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757340568; c=relaxed/simple;
	bh=BN2YeYIkkKLE8mrSfRQwT7PH6JFxUqWXibOqgxEPVxY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=UywmT1ahJZNfb5OvJ15Z+2aMW2rvBQV/ulQhUNPYHhSmC3lruHQICmpLdsbWd+Pa8QlxggRREa//3PsD4SeWWReMYr48wpPvL/zKLW4hSZZoqBqi57MzAGno6FkqWVUX5EyyJOcXihYrQtkOARPhId8Cr8MZsXItdEISMr9Ialw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iie.ac.cn; spf=pass smtp.mailfrom=iie.ac.cn; arc=none smtp.client-ip=159.226.251.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iie.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iie.ac.cn
Received: from localhost.localdomain (unknown [159.226.95.28])
	by APP-01 (Coremail) with SMTP id qwCowACH4aN4475oXXesAQ--.24801S2;
	Mon, 08 Sep 2025 22:08:57 +0800 (CST)
From: Chen Yufeng <chenyufeng@iie.ac.cn>
To: pablo@netfilter.org
Cc: kadlec@netfilter.org,
	fw@strlen.de,
	netfilter-devel@vger.kernel.org,
	Chen Yufeng <chenyufeng@iie.ac.cn>
Subject: [PATCH] netfilter: Set expressions out of range in nft_add_set_elem()
Date: Mon,  8 Sep 2025 22:08:44 +0800
Message-ID: <20250908140844.1197-1-chenyufeng@iie.ac.cn>
X-Mailer: git-send-email 2.43.0.windows.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qwCowACH4aN4475oXXesAQ--.24801S2
X-Coremail-Antispam: 1UD129KBjvdXoWrZryrZw47KryDur18Gw17Jrb_yoWktwb_Ca
	s3t3ykGFWrJF92kayDGr4Fyr1fW3y8ur1rWF92gr4fXFyUGr4jkFWkuF13A3WUW3yDJwn5
	Xw1q9w13GrZIkjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbsxFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Jr0_
	Gr1l84ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s
	0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xII
	jxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr
	1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxkF7I0En4kS14v26r12
	6r1DMxkIecxEwVAFwVW5XwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8Jw
	C20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAF
	wI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjx
	v20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2
	jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0x
	ZFpf9x0JU-6p9UUUUU=
X-CM-SenderInfo: xfkh05xxih0wo6llvhldfou0/1tbiBgwTEmi+sgWVmwAAsk

The number of `expr` expressions provided by userspace may exceed the 
declared set expressions, potentially leading to errors or undefined behavior. 
This patch addresses the issue by validating whether i exceeds 
set->num_exprs.

This patch is inspired by commit 3701cd390fd7("netfilter: nf_tables: 
 bail out on mismatching dynset and set expressions").

Signed-off-by: Chen Yufeng <chenyufeng@iie.ac.cn>
---
 net/netfilter/nf_tables_api.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 58c5425d61c2..958a7c8b0b4c 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -7338,9 +7338,15 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 			expr_array[i] = expr;
 			num_exprs++;
 
-			if (set->num_exprs && expr->ops != set->exprs[i]->ops) {
-				err = -EOPNOTSUPP;
-				goto err_set_elem_expr;
+			if (set->num_exprs) {
+				if (i >= set->num_exprs) {
+					err = -EINVAL;
+					goto err_set_elem_expr;
+				}
+				if (expr->ops != set->exprs[i]->ops) {
+					err = -EOPNOTSUPP;
+					goto err_set_elem_expr;
+				}
 			}
 			i++;
 		}
-- 
2.34.1

