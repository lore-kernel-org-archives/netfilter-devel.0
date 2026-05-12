Received: from zg8tmtyylji0my4xnjeumjiw.icoremail.net (zg8tmtyylji0my4xnjeumjiw.icoremail.net [162.243.161.220])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94FCE397E73
	for <netfilter-devel@vger.kernel.org>; Tue, 12 May 2026 08:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.243.161.220
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778576003; cv=none; b=MRFQUYbtC8BUAYUsnK83lj/w0fbU3xKX9ysxipkG8mpN4DFXbyZEU5y6NZihu6z5u57GMCPDg/Wk57JJnID586u4sCTe5WpwWPfk3daz2YApGvCLKFjjhoMtFLnahYJWKa0d3uJ6VGrKzFG7QAwPyjmX3YFP94e6UIjguJEIZjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778576003; c=relaxed/simple;
	bh=XcR2hzKf3pXNgQII0tx7nKRejW1JdHv8pVQ9QRDoh1g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qKVMbm0OjUj2GKJpe52OMx209H/YnbmPMLk8hI0F4w8EpF13EaCcUdAIwPwEDtY7pK8YrsuHMbYXQ4pl5sJkAiR9Jbap6PQZIsoxol+4kciEf3a2kxTne1REOzrCV66tObWTprI7fzOr0loeyIosMSTEH2g6elnIkHCVWPe0tvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lzu.edu.cn; spf=pass smtp.mailfrom=lzu.edu.cn; arc=none smtp.client-ip=162.243.161.220
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lzu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lzu.edu.cn
Received: from enjou-Legion-Y7000P-2019.coin-barley.ts.net (unknown [172.23.56.36])
	by app1 (Coremail) with SMTP id ygmowACnyMIf6gJqc1YAAA--.547S6;
	Tue, 12 May 2026 16:53:12 +0800 (CST)
From: Ren Wei <n05ec@lzu.edu.cn>
To: netfilter-devel@vger.kernel.org
Cc: kadlec@blackhole.kfki.hu,
	pablo@netfilter.org,
	yuantan098@gmail.com,
	yifanwucs@gmail.com,
	tomapufckgml@gmail.com,
	bird@lzu.edu.cn,
	tonanli66@gmail.com,
	n05ec@lzu.edu.cn
Subject: [PATCH nf 4/4] netfilter: ipset: hash:ip,port,net: stop IPv4 range walk at upper bound
Date: Tue, 12 May 2026 16:50:04 +0800
Message-ID: <bd39fa4962c67bb0d1cfe4dfb9f1abd5ae0c99a7.1778482529.git.tonanli66@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1778482529.git.tonanli66@gmail.com>
References: <cover.1778482529.git.tonanli66@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:ygmowACnyMIf6gJqc1YAAA--.547S6
X-Coremail-Antispam: 1UD129KBjvJXoW7ur13GrWDCF48Gw4DJF4kCrg_yoW8Ww45pF
	W5GrWjq397Xan5Crn7Jr1xAFy3A3Z5ZrnrCwnxAw1kZ3Z8tF45ta4S9rZ2vF1UuFZYkF43
	tw42va1jvwn5ZrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvK1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AE
	w4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2
	IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8Jr0_Cr1UM28EF7xvwVC2
	z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS0I0E0xvYzx
	vE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWU
	JVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7V
	AKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCY1x0262kKe7AKxVWUtVW8ZwCY02Avz4vE
	-syl42xK82IYc2Ij64vIr41l42xK82IY6x8ErcxFaVAv8VW8GwCFx2IqxVCFs4IE7xkEbV
	WUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF
	67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42
	IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF
	0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxh
	VjvjDU0xZFpf9x0JUd-B_UUUUU=
X-CM-SenderInfo: zqqvvuo6o23hxhgxhubq/1tbiAQsFCWoCxO4E8AAAsw

From: Nan Li <tonanli66@gmail.com>

The IPv4 range expansion path in hash:ip,port,net updates the first
dimension iterator in the loop control statement. When the requested
range reaches the last IPv4 address, the iterator can wrap before the
loop terminates.

Handle the increment explicitly at the end of the loop and stop once
the upper bound has been processed. This keeps the range walk bounded
to the requested interval and preserves the existing retry behaviour.

Fixes: 48596a8ddc46 ("netfilter: ipset: Fix adding an IPv4 range containing more than 2^31 addresses")
Cc: stable@kernel.org
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Signed-off-by: Nan Li <tonanli66@gmail.com>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
---
 net/netfilter/ipset/ip_set_hash_ipportnet.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/ipset/ip_set_hash_ipportnet.c b/net/netfilter/ipset/ip_set_hash_ipportnet.c
index 5c6de605a9fb..2d6652d43199 100644
--- a/net/netfilter/ipset/ip_set_hash_ipportnet.c
+++ b/net/netfilter/ipset/ip_set_hash_ipportnet.c
@@ -274,7 +274,7 @@ hash_ipportnet4_uadt(struct ip_set *set, struct nlattr *tb[],
 		p = port;
 		ip2 = ip2_from;
 	}
-	for (; ip <= ip_to; ip++) {
+	for (; ip <= ip_to;) {
 		e.ip = htonl(ip);
 		for (; p <= port_to; p++) {
 			e.port = htons(p);
@@ -298,6 +298,9 @@ hash_ipportnet4_uadt(struct ip_set *set, struct nlattr *tb[],
 			ip2 = ip2_from;
 		}
 		p = port;
+		if (ip == ip_to)
+			break;
+		ip++;
 	}
 	return ret;
 }
-- 
2.43.0

