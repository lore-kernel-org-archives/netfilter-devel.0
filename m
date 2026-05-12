Received: from azure-sdnproxy.icoremail.net (azure-sdnproxy.icoremail.net [13.75.44.102])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63392396565
	for <netfilter-devel@vger.kernel.org>; Tue, 12 May 2026 08:52:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.75.44.102
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778575965; cv=none; b=cnq74BE+bAn+CrjZTapXBOddbM9jVjzovIriioPfBNJ0C23J1/e95HSPMarEo83e+1wbEo6LyeluTesqTvyQSr7Bye+4koUk1wKU7Z2YV1zUGm3H/vbf9aEHRB9iZO093WztHQg6Hepv6ULZAF/gpAINbyLdwKVcCqCluEitFEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778575965; c=relaxed/simple;
	bh=7L6qj631WLz82wxQNv9OTL2Sc6b6BfdJSRoqL6eFaCE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eTXKhsQ2DdonMvH2h8kg8cK9ad05OEo3AFPIRsNMy+tg6wBBpHNRFUyFHKKZTHJ2aXpwHRMrsAgchGJTTAjDs+xC1RtAh0jnDUgR1hUxQ2Nb81MW+XeMXpvZdRL3CuotGS7QVMIdghnDAvsTWvNeI9UhTeSKcZ1jSDTxyh0OUYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lzu.edu.cn; spf=pass smtp.mailfrom=lzu.edu.cn; arc=none smtp.client-ip=13.75.44.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lzu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lzu.edu.cn
Received: from enjou-Legion-Y7000P-2019.coin-barley.ts.net (unknown [172.23.56.36])
	by app1 (Coremail) with SMTP id ygmowACnyMIf6gJqc1YAAA--.547S4;
	Tue, 12 May 2026 16:52:23 +0800 (CST)
From: Ren Wei <n05ec@lzu.edu.cn>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org,
	kadlec@blackhole.kfki.hu,
	yuantan098@gmail.com,
	yifanwucs@gmail.com,
	tomapufckgml@gmail.com,
	bird@lzu.edu.cn,
	tonanli66@gmail.com,
	n05ec@lzu.edu.cn
Subject: [PATCH nf 2/4] netfilter: ipset: stop hash:ip,port,ip range iteration at end
Date: Tue, 12 May 2026 16:50:02 +0800
Message-ID: <c8131d7432dfc9eaa7ea4cf8a7a54331c787e473.1778482529.git.tonanli66@gmail.com>
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
X-CM-TRANSID:ygmowACnyMIf6gJqc1YAAA--.547S4
X-Coremail-Antispam: 1UD129KBjvJXoWxJF18CF48ZFy5uw4ruF1DAwb_yoW8AFyxpa
	y5WrZ8A397Wa1UC3W8JF4xZFy3Aws5uFy7J3sxJ3sYy3Z8tF4rJa4fKrW2v3WDZFZYkayY
	yanIya1jvw1UXw7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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
X-CM-SenderInfo: zqqvvuo6o23hxhgxhubq/1tbiAQEFCWoCxO4E5QAAsv

From: Nan Li <tonanli66@gmail.com>

hash:ip,port,ip iterates IPv4 ranges with a 32-bit iterator.

The iterator must stop once the last address in the requested range has
been processed. Advancing it once more can move the traversal state past
the end of the request, so a later retry may continue from an unintended
position.

Stop the outer IPv4 loop after the end of the requested range is
handled. This keeps the existing retry behavior intact for valid ranges
while preventing traversal from continuing past the original boundary.

Fixes: 48596a8ddc46 ("netfilter: ipset: Fix adding an IPv4 range containing more than 2^31 addresses")
Cc: stable@kernel.org
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Signed-off-by: Nan Li <tonanli66@gmail.com>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
---
 net/netfilter/ipset/ip_set_hash_ipportip.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/ipset/ip_set_hash_ipportip.c b/net/netfilter/ipset/ip_set_hash_ipportip.c
index 39a01934b153..b9ac2efaa15c 100644
--- a/net/netfilter/ipset/ip_set_hash_ipportip.c
+++ b/net/netfilter/ipset/ip_set_hash_ipportip.c
@@ -182,7 +182,7 @@ hash_ipportip4_uadt(struct ip_set *set, struct nlattr *tb[],
 
 	if (retried)
 		ip = ntohl(h->next.ip);
-	for (; ip <= ip_to; ip++) {
+	for (; ip <= ip_to;) {
 		p = retried && ip == ntohl(h->next.ip) ? ntohs(h->next.port)
 						       : port;
 		for (; p <= port_to; p++, i++) {
@@ -199,6 +199,9 @@ hash_ipportip4_uadt(struct ip_set *set, struct nlattr *tb[],
 
 			ret = 0;
 		}
+		if (ip == ip_to)
+			break;
+		ip++;
 	}
 	return ret;
 }
-- 
2.43.0

