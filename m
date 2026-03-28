Received: from sgoci-sdnproxy-4.icoremail.net (sgoci-sdnproxy-4.icoremail.net [129.150.39.64])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DFADB331A44
	for <netfilter-devel@vger.kernel.org>; Sat, 28 Mar 2026 14:52:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=129.150.39.64
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774709543; cv=none; b=DcCoeXWqmry0BhK4kigif53Ot/HjGF76T+YhlOgz3v53zccXOXllRb7FexFSfnGtDaorsMQN52I0p3zl2ybPB+/+rtf0HiAFjreuDAO6cgpnsSpaYO0BmjHF+2A9plYcqG7a4f7xv3BveWZhRBsKaHOHTyAMIGGJA7uuWTVq//c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774709543; c=relaxed/simple;
	bh=gpqj4ko0bX3bD1IeooY2opj6uWZUfRBkAQaY/KNltNI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EhPcMKMt3xOllTxWEUaElkJWws0Af5MAbX7o8ZZe0VQyd5bhIbQKlY39iC072h+KqLm/SAMeJ/I3+q1xz5x8rZlC7Wcen65T7rSi/Z+8wlchboRNRzXBPh7NHyLnAtR/g649X+muUaUPvvo/7XxHP9A2AfzWMVI5fK/gKPnCr3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lzu.edu.cn; spf=pass smtp.mailfrom=lzu.edu.cn; arc=none smtp.client-ip=129.150.39.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lzu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lzu.edu.cn
Received: from enjou-Legion-Y7000P-2019.coin-barley.ts.net (unknown [172.23.56.36])
	by app3 (Coremail) with SMTP id ywmowADHAJjr6sdph94rAA--.35221S2;
	Sat, 28 Mar 2026 22:51:24 +0800 (CST)
From: Ren Wei <n05ec@lzu.edu.cn>
To: netfilter-devel@vger.kernel.org
Cc: security@kernel.org,
	pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	shuah@kernel.org,
	yuantan098@gmail.com,
	bird@lzu.edu.cn,
	z1652074432@gmail.com,
	kaber@trash.net,
	yasuyuki.kozakai@toshiba.co.jp,
	yifanwucs@gmail.com,
	tomapufckgml@gmail.com,
	n05ec@lzu.edu.cn,
	enjou1224z@gmail.com
Subject: [PATCH v2] netfilter: xt_multiport: reject trailing range markers
Date: Sat, 28 Mar 2026 22:51:23 +0800
Message-ID: <dc1b0139fc250e188657e874ce4bb67f60af6e0c.1774659119.git.n05ec@lzu.edu.cn>
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
X-CM-TRANSID:ywmowADHAJjr6sdph94rAA--.35221S2
X-Coremail-Antispam: 1UD129KBjvJXoWxZw45Zr1UJrWDtr47KrykKrg_yoWrAFyUpa
	y5WF13JrW8XFWaqrs2yrykXF4rCrs7Jr47ua43G34xtFy3XryYqa1rtayv9F95AryYkFW7
	JF4kZw1Yk345A37anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBj1xkIjI8I6I8E6xAIw20EY4v20xvaj40_JFC_Wr1l1IIY67AE
	w4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2
	IY67AKxVW5JVW7JwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwA2z4x0Y4vEx4A2
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
X-CM-SenderInfo: zqqvvuo6o23hxhgxhubq/1tbiAQQACWnGp-sGXQAXsz

ports_match_v1() treats any non-zero pflags entry as the start of a
port range and unconditionally consumes the next ports[] element as
the range end.

The checkentry path currently validates protocol, flags and count, but
it does not reject a malformed rule whose final slot is marked as a
range start. That leaves ports_match_v1() to step past the last valid
ports[] element when such a rule is installed.

Fix this by rejecting multiport v1 rules with a trailing range marker
in checkentry. This keeps malformed rules out of the runtime matching
path and preserves the existing exact-match and valid-range behavior.

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
 net/netfilter/xt_multiport.c | 50 +++++++++++++++++++++++-------------
 1 file changed, 32 insertions(+), 18 deletions(-)

diff --git a/net/netfilter/xt_multiport.c b/net/netfilter/xt_multiport.c
index 44a00f5acde8..38aa5b90d38e 100644
--- a/net/netfilter/xt_multiport.c
+++ b/net/netfilter/xt_multiport.c
@@ -26,10 +26,10 @@ MODULE_ALIAS("ip6t_multiport");
 /* Returns 1 if the port is matched by the test, 0 otherwise. */
 static inline bool
 ports_match_v1(const struct xt_multiport_v1 *minfo,
-	       u_int16_t src, u_int16_t dst)
+	       u16 src, u16 dst)
 {
 	unsigned int i;
-	u_int16_t s, e;
+	u16 s, e;
 
 	for (i = 0; i < minfo->count; i++) {
 		s = minfo->ports[i];
@@ -106,20 +106,36 @@ multiport_mt(const struct sk_buff *skb, struct xt_action_param *par)
 }
 
 static inline bool
-check(u_int16_t proto,
-      u_int8_t ip_invflags,
-      u_int8_t match_flags,
-      u_int8_t count)
+multiport_valid_ranges(const struct xt_multiport_v1 *multiinfo)
+{
+	unsigned int i;
+
+	for (i = 0; i < multiinfo->count; i++) {
+		if (!multiinfo->pflags[i])
+			continue;
+
+		if (i == multiinfo->count - 1)
+			return false;
+
+		i++;
+	}
+
+	return true;
+}
+
+static inline bool
+check(u16 proto, u8 ip_invflags, const struct xt_multiport_v1 *multiinfo)
 {
 	/* Must specify supported protocol, no unknown flags or bad count */
-	return (proto == IPPROTO_TCP || proto == IPPROTO_UDP
-		|| proto == IPPROTO_UDPLITE
-		|| proto == IPPROTO_SCTP || proto == IPPROTO_DCCP)
-		&& !(ip_invflags & XT_INV_PROTO)
-		&& (match_flags == XT_MULTIPORT_SOURCE
-		    || match_flags == XT_MULTIPORT_DESTINATION
-		    || match_flags == XT_MULTIPORT_EITHER)
-		&& count <= XT_MULTI_PORTS;
+	return (proto == IPPROTO_TCP || proto == IPPROTO_UDP ||
+		proto == IPPROTO_UDPLITE ||
+		proto == IPPROTO_SCTP || proto == IPPROTO_DCCP) &&
+	       !(ip_invflags & XT_INV_PROTO) &&
+	       (multiinfo->flags == XT_MULTIPORT_SOURCE ||
+		multiinfo->flags == XT_MULTIPORT_DESTINATION ||
+		multiinfo->flags == XT_MULTIPORT_EITHER) &&
+	       multiinfo->count <= XT_MULTI_PORTS &&
+	       multiport_valid_ranges(multiinfo);
 }
 
 static int multiport_mt_check(const struct xt_mtchk_param *par)
@@ -127,8 +143,7 @@ static int multiport_mt_check(const struct xt_mtchk_param *par)
 	const struct ipt_ip *ip = par->entryinfo;
 	const struct xt_multiport_v1 *multiinfo = par->matchinfo;
 
-	return check(ip->proto, ip->invflags, multiinfo->flags,
-		     multiinfo->count) ? 0 : -EINVAL;
+	return check(ip->proto, ip->invflags, multiinfo) ? 0 : -EINVAL;
 }
 
 static int multiport_mt6_check(const struct xt_mtchk_param *par)
@@ -136,8 +151,7 @@ static int multiport_mt6_check(const struct xt_mtchk_param *par)
 	const struct ip6t_ip6 *ip = par->entryinfo;
 	const struct xt_multiport_v1 *multiinfo = par->matchinfo;
 
-	return check(ip->proto, ip->invflags, multiinfo->flags,
-		     multiinfo->count) ? 0 : -EINVAL;
+	return check(ip->proto, ip->invflags, multiinfo) ? 0 : -EINVAL;
 }
 
 static struct xt_match multiport_mt_reg[] __read_mostly = {
-- 
2.51.0

