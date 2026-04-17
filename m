Received: from azure-sdnproxy.icoremail.net (azure-sdnproxy.icoremail.net [4.193.249.245])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C6263859EB
	for <netfilter-devel@vger.kernel.org>; Fri, 17 Apr 2026 12:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=4.193.249.245
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776428957; cv=none; b=Y+02KVwfqaA8rnbpwcXQcdJ5l2jNaXMFuCkiqopjoQRFpK4JgjqTMXHKs2/5PVjUGlJy/xbtR/YZKyZkbXxqnrG62FBoZYUEwSbbUXr7I2uE/Sjjwczl/+cjxFd5lNF3dJpN8qOcQbXdH2DYGd6norgxVLyGjydHeuqpy6cjif0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776428957; c=relaxed/simple;
	bh=AU7vos6dF+irj8p6nzJ2xeKoza49aDZZtbTNmr0J/pI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mtZ09Y10TzuLcF1rWGMYUTwm+1CmNHBXdUIXOlv/RFGg2Bc8IgHYMbGZtXhR9NEbkRzkU9vLNpttYgZ0mo7++r2frXUdGNi4yy6L4VMlbbdPJ30TyAMQEb7ii+O6QvtLHmdioE5Th5/XaFKSUxLKfoioP+3nthC5aEcrNT020A4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lzu.edu.cn; spf=pass smtp.mailfrom=lzu.edu.cn; arc=none smtp.client-ip=4.193.249.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lzu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lzu.edu.cn
Received: from enjou-Legion-Y7000P-2019.coin-barley.ts.net (unknown [172.23.56.36])
	by app1 (Coremail) with SMTP id ygmowACH+_tyJ+Jp5CbQAA--.13061S3;
	Fri, 17 Apr 2026 20:28:36 +0800 (CST)
From: Ren Wei <n05ec@lzu.edu.cn>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	ebiederm@xmission.com,
	yuantan098@gmail.com,
	yifanwucs@gmail.com,
	tomapufckgml@gmail.com,
	bird@lzu.edu.cn,
	wangjiexun2025@gmail.com,
	n05ec@lzu.edu.cn
Subject: [PATCH nf 1/1] netfilter: xt_policy: fix strict mode inbound policy matching
Date: Fri, 17 Apr 2026 20:25:06 +0800
Message-ID: <85a95e0ef783ed8f5f4a787138cca22f995d8056.1776141503.git.wangjiexun2025@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1776141503.git.wangjiexun2025@gmail.com>
References: <cover.1776141503.git.wangjiexun2025@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:ygmowACH+_tyJ+Jp5CbQAA--.13061S3
X-Coremail-Antispam: 1UD129KBjvJXoW7uw1DZF4DWry3CFW3GFy8Xwb_yoW8GrWrpF
	ZxK34DCryDXry5JwnrGryxuFWUAFykCw4xArZ8K3s7Z3s7Jr1UGa1rKrW2vFn8AF1qgr4Y
	vF4q93sYk3Z8ArJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUB01xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AE
	w4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2
	IY67AKxVW5JVW7JwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVWxJVW8Jr1l84ACjcxK6I8E
	87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE3s1le2I262IYc4CY6c
	8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_
	Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwI
	xGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc7CjxVAa
	w2AFwI0_Jw0_GFylc2xSY4AK6svPMxAIw28IcxkI7VAKI48JMxAIw28IcVCjz48v1sIEY2
	0_Gr4l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8G
	jcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r4a6rW5MIIYrxkI7VAKI48JMIIF0xvE2I
	x0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK
	8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I
	0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUonmRUUUUU
X-CM-SenderInfo: zqqvvuo6o23hxhgxhubq/1tbiAQEACWnh8+AE7gAAs4

From: Jiexun Wang <wangjiexun2025@gmail.com>

match_policy_in() walks sec_path entries from the last transform to the
first one, but strict policy matching needs to consume info->pol[] in
the same forward order as the rule layout.

Derive the strict-match policy position from the number of transforms
already consumed so that multi-element inbound rules are matched
consistently.

Fixes: df008c91f835 ("net: Allow userns root to control llc, netfilter, netlink, packet, and xfrm")
Cc: stable@kernel.org
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Signed-off-by: Jiexun Wang <wangjiexun2025@gmail.com>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
---
 net/netfilter/xt_policy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/xt_policy.c b/net/netfilter/xt_policy.c
index cb6e8279010a..b5fa65558318 100644
--- a/net/netfilter/xt_policy.c
+++ b/net/netfilter/xt_policy.c
@@ -63,7 +63,7 @@ match_policy_in(const struct sk_buff *skb, const struct xt_policy_info *info,
 		return 0;
 
 	for (i = sp->len - 1; i >= 0; i--) {
-		pos = strict ? i - sp->len + 1 : 0;
+		pos = strict ? sp->len - i - 1 : 0;
 		if (pos >= info->len)
 			return 0;
 		e = &info->pol[pos];
-- 
2.34.1

