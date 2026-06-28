Received: from zg8tmja5ljk3lje4mi4ymjia.icoremail.net (zg8tmja5ljk3lje4mi4ymjia.icoremail.net [209.97.182.222])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 527A6231827
	for <netfilter-devel@vger.kernel.org>; Sun, 28 Jun 2026 08:06:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.97.182.222
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782634017; cv=none; b=AWiKzqGoXLAHBReI4dI080QjC5cgs9GXbJdC/qJx8InCEyLAqtHlrOFnImYIOZ8JdluH2NW3u21e6FG7Vg08Lo/dLkE2MWjZL7lyAPn/rTC5mOqxxhFK7PKrhY+Efr+7cg+lPSBOw0a7ezYLi8Rin384AdlV9U09D3AEqXZlfD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782634017; c=relaxed/simple;
	bh=IshVof78IxV8O0gZ412haYG+l7ouJ6xkqGIMCLTTkq4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ulgmWiAysv5x14FZWN7A6wiEVhY5xBZDg1+8bIJCRwghQS8oYI89/sfOr0wkk8+l3V6/tKtqlaIDW9DBXAVcMl4kL6zPKLd/37F9HMDU67cIcZhWTdmFcCi3ywV7RT9Ie7C9s8P9gpdrQktNjuOvoNgXvWFN6X5QN65+4/zOdOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lzu.edu.cn; spf=pass smtp.mailfrom=lzu.edu.cn; arc=none smtp.client-ip=209.97.182.222
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lzu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lzu.edu.cn
Received: from enjou-Legion-Y7000P-2019 (unknown [172.23.56.36])
	by app3 (Coremail) with SMTP id ywmowADX5vnt1UBquSY0AA--.32471S3;
	Sun, 28 Jun 2026 16:06:08 +0800 (CST)
From: Ren Wei <n05ec@lzu.edu.cn>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com,
	horms@kernel.org,
	kaber@trash.net,
	jengelh@gmx.de,
	yuantan098@gmail.com,
	yifanwucs@gmail.com,
	tomapufckgml@gmail.com,
	zcliangcn@gmail.com,
	bird@lzu.edu.cn,
	bronzed_45_vested@icloud.com,
	n05ec@lzu.edu.cn
Subject: [PATCH nf 1/1] netfilter: xt_u32: reject invalid shift counts
Date: Sun, 28 Jun 2026 16:05:54 +0800
Message-ID: <7c236f82e80fc4c82e90ce4fb32705274b64bb98.1782551654.git.bronzed_45_vested@icloud.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1782551654.git.bronzed_45_vested@icloud.com>
References: <cover.1782551654.git.bronzed_45_vested@icloud.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:ywmowADX5vnt1UBquSY0AA--.32471S3
X-Coremail-Antispam: 1UD129KBjvJXoW7tF13KFW5WFyktw18Jr4ruFg_yoW8Cr4xpa
	y3K3s0grW7XFy3K3WvkryF9Fn8GrsrGrsrursIq34YvwnxJr4UJ3WrtrZavF93ArZ5CF4j
	yFsFvFn7Cwn8A37anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUB01xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AE
	w4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2
	IY67AKxVW8JVW5JwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVWxJVW8Jr1l84ACjcxK6I8E
	87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE3s1le2I262IYc4CY6c
	8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_
	Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwI
	xGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc7CjxVAa
	w2AFwI0_GFv_Wrylc2xSY4AK6svPMxAIw28IcxkI7VAKI48JMxAIw28IcVCjz48v1sIEY2
	0_Gr4l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8G
	jcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r4a6rW5MIIYrxkI7VAKI48JMIIF0xvE2I
	x0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK
	8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I
	0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjTRMXdjDUUUU
X-CM-SenderInfo: zqqvvuo6o23hxhgxhubq/1tbiAQEMCWo-h9QIrAAAsn

From: Wyatt Feng <bronzed_45_vested@icloud.com>

u32_match_it() executes rule-supplied shift operands on a 32-bit
value. A malformed u32 rule can provide a shift count of 32 or more,
triggering an undefined shift out-of-bounds during packet evaluation.

Validate XT_U32_LEFTSH and XT_U32_RIGHTSH operands in
u32_mt_checkentry() and reject malformed rules before they reach the
packet path.

Fixes: 1b50b8a371e9 ("[NETFILTER]: Add u32 match")
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
 net/netfilter/xt_u32.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/xt_u32.c b/net/netfilter/xt_u32.c
index 117d4615d668..ec1a21e3b6e2 100644
--- a/net/netfilter/xt_u32.c
+++ b/net/netfilter/xt_u32.c
@@ -100,7 +100,7 @@ static int u32_mt_checkentry(const struct xt_mtchk_param *par)
 {
 	const struct xt_u32 *data = par->matchinfo;
 	const struct xt_u32_test *ct;
-	unsigned int i;
+	unsigned int i, j;
 
 	if (data->ntests > ARRAY_SIZE(data->tests))
 		return -EINVAL;
@@ -111,6 +111,16 @@ static int u32_mt_checkentry(const struct xt_mtchk_param *par)
 		if (ct->nnums > ARRAY_SIZE(ct->location) ||
 		    ct->nvalues > ARRAY_SIZE(ct->value))
 			return -EINVAL;
+
+		for (j = 1; j < ct->nnums; ++j) {
+			switch (ct->location[j].nextop) {
+			case XT_U32_LEFTSH:
+			case XT_U32_RIGHTSH:
+				if (ct->location[j].number >= 32)
+					return -EINVAL;
+				break;
+			}
+		}
 	}
 
 	return 0;
-- 
2.47.3

