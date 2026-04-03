Received: from azure-sdnproxy.icoremail.net (azure-sdnproxy.icoremail.net [13.75.44.102])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6BD6F230BDB;
	Fri,  3 Apr 2026 15:53:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.75.44.102
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775231626; cv=none; b=VfwJ6j4TOdnG8ebaeYxfxVjF0azebyE6mC5DOajVdjFyS+Kw2WRQSNPGV/fh1vBKBbawvAiKu+Za7s1bQpZ2vCo5IpOhryjPtPKUoxlUVyOm/xufYBk+bRqefGbwBmOP9pIZ9uhEW9P3KV04lKWMFmlPm2xFz8tibS20OCWBpwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775231626; c=relaxed/simple;
	bh=D1e2olgVJeIYMvsd6OjKX99SYPIpmzcquojkKTFR1tI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m0tTAtTtSGkQPqZhgTAM5od6eTrL1CfqEypvCW2Jfi3uLV42p5w93UZ0nwbuzgEcNm5xDBHiWYj1BXvDXOd71a3HOCZweZCGgQzSSkL+eoU4P7Md6Ng5LtvTnTCKZFaz3XISGGwyuIkFfXTMcFQ/+9fC74kZLyGmZm57vhCwRjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lzu.edu.cn; spf=pass smtp.mailfrom=lzu.edu.cn; arc=none smtp.client-ip=13.75.44.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lzu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lzu.edu.cn
Received: from enjou-Legion-Y7000P-2019.coin-barley.ts.net (unknown [172.23.56.36])
	by app1 (Coremail) with SMTP id ygmowABXz_9U4s9p5d2jAA--.37129S2;
	Fri, 03 Apr 2026 23:52:52 +0800 (CST)
From: Ren Wei <n05ec@lzu.edu.cn>
To: netfilter-devel@vger.kernel.org,
	netdev@vger.kernel.org
Cc: pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	yasuyuki.kozakai@toshiba.co.jp,
	kaber@trash.net,
	yifanwucs@gmail.com,
	tomapufckgml@gmail.com,
	yuantan098@gmail.com,
	bird@lzu.edu.cn,
	z1652074432@gmail.com,
	n05ec@lzu.edu.cn,
	enjou1224z@gmail.com
Subject: [PATCH v4] netfilter: xt_multiport: validate range encoding in checkentry
Date: Fri,  3 Apr 2026 23:52:52 +0800
Message-ID: <df9ac8b2cfbfcacf0cc4e6f2e01113f0b16ad37f.1775228821.git.n05ec@lzu.edu.cn>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1774624314.git.n05ec@lzu.edu.cn>
References: <cover.1774624314.git.n05ec@lzu.edu.cn>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:ygmowABXz_9U4s9p5d2jAA--.37129S2
X-Coremail-Antispam: 1UD129KBjvJXoWxZw45Cw4UuF45ur18uF45Wrg_yoW5Kr1xpa
	y5GF15GrWkZFWaqFsayr1kJF15Cr4kXr48ua43J3srJFsxWr95tw4rtF9IvFs8Ary5CFW8
	tF4qvrn0kw15u37anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBj1xkIjI8I6I8E6xAIw20EY4v20xvaj40_JFC_Wr1l1IIY67AE
	w4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2
	IY67AKxVW8JVW5JwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwA2z4x0Y4vEx4A2
	jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS0I0E0xvYzxvE52
	x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWU
	GwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI4
	8JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kIc2xKxwCY1x0262kK
	e7AKxVW8ZVWrXwCY02Avz4vE-syl42xK82IYc2Ij64vIr41l42xK82IY6x8ErcxFaVAv8V
	W8GwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480
	Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcVC0I7
	IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k2
	6cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxV
	AFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0pRpOJnUUUUU=
X-CM-SenderInfo: zqqvvuo6o23hxhgxhubq/1tbiAQMGCWnOkPwYCQAAsX

ports_match_v1() treats any non-zero pflags entry as the start of a
port range and unconditionally consumes the next ports[] element as
the range end.

The checkentry path currently validates protocol, flags and count, but
it does not validate the range encoding itself. As a result, malformed
rules can mark the last slot as a range start or place two range starts
back to back, leaving ports_match_v1() to step past the last valid
ports[] element while interpreting the rule.

Reject malformed multiport v1 rules in checkentry by validating that
each range start has a following element and that the following element
is not itself marked as another range start.

Fixes: a89ecb6a2ef7 ("[NETFILTER]: x_tables: unify IPv4/IPv6 multiport match")
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Co-developed-by: Yuan Tan <yuantan098@gmail.com>
Signed-off-by: Yuan Tan <yuantan098@gmail.com>
Suggested-by: Xin Liu <bird@lzu.edu.cn>
Tested-by: Yuhang Zheng <z1652074432@gmail.com>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
---
Changes in v2:
- drop the selftest patch
- send the fix publicly to netfilter-devel

Changes in v3:
- drop datatype cleanup from the fix
- keep the original check() interface unchanged
- validate malformed range encoding in checkentry

Changes in v4:
- follow Pablo's suggested validation form
- drop inline from multiport_valid_ranges
- reject reversed port ranges

 net/netfilter/xt_multiport.c | 34 ++++++++++++++++++++++++++++++----
 1 file changed, 30 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/xt_multiport.c b/net/netfilter/xt_multiport.c
index 44a00f5acde8..a1691ff405d3 100644
--- a/net/netfilter/xt_multiport.c
+++ b/net/netfilter/xt_multiport.c
@@ -105,6 +105,28 @@ multiport_mt(const struct sk_buff *skb, struct xt_action_param *par)
 	return ports_match_v1(multiinfo, ntohs(pptr[0]), ntohs(pptr[1]));
 }
 
+static bool
+multiport_valid_ranges(const struct xt_multiport_v1 *multiinfo)
+{
+	unsigned int i;
+
+	for (i = 0; i < multiinfo->count; i++) {
+		if (!multiinfo->pflags[i])
+			continue;
+
+		if (++i >= multiinfo->count)
+			return false;
+
+		if (multiinfo->pflags[i])
+			return false;
+
+		if (multiinfo->ports[i - 1] > multiinfo->ports[i])
+			return false;
+	}
+
+	return true;
+}
+
 static inline bool
 check(u_int16_t proto,
       u_int8_t ip_invflags,
@@ -127,8 +149,10 @@ static int multiport_mt_check(const struct xt_mtchk_param *par)
 	const struct ipt_ip *ip = par->entryinfo;
 	const struct xt_multiport_v1 *multiinfo = par->matchinfo;
 
-	return check(ip->proto, ip->invflags, multiinfo->flags,
-		     multiinfo->count) ? 0 : -EINVAL;
+	if (!check(ip->proto, ip->invflags, multiinfo->flags, multiinfo->count))
+		return -EINVAL;
+
+	return multiport_valid_ranges(multiinfo) ? 0 : -EINVAL;
 }
 
 static int multiport_mt6_check(const struct xt_mtchk_param *par)
@@ -136,8 +160,10 @@ static int multiport_mt6_check(const struct xt_mtchk_param *par)
 	const struct ip6t_ip6 *ip = par->entryinfo;
 	const struct xt_multiport_v1 *multiinfo = par->matchinfo;
 
-	return check(ip->proto, ip->invflags, multiinfo->flags,
-		     multiinfo->count) ? 0 : -EINVAL;
+	if (!check(ip->proto, ip->invflags, multiinfo->flags, multiinfo->count))
+		return -EINVAL;
+
+	return multiport_valid_ranges(multiinfo) ? 0 : -EINVAL;
 }
 
 static struct xt_match multiport_mt_reg[] __read_mostly = {
-- 
2.51.0

