Received: from azure-sdnproxy.icoremail.net (azure-sdnproxy.icoremail.net [13.75.44.102])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8600031079B
	for <netfilter-devel@vger.kernel.org>; Thu,  2 Apr 2026 17:35:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.75.44.102
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775151328; cv=none; b=X2OGoG8TlkNZabMXFXf2CFfJTi05O+GuQknoj2VYrQrtymvA7O6/yT4tf+0a5LG+8ZbM7QVokJ3VxVk/Vp8nWGCnSo29Ez3S9DvcGsLfkJELHi5xdT/Ig9pl+DuPbosUeBHyR6HBhMOEVAH9wBvFg6dKh3MKUPwl+XaToP8xaD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775151328; c=relaxed/simple;
	bh=uhdDD/SfNZaymQ1EJI5Y8ATJeISuWmxw9+RsC6xCVWk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rzOZ428eS8/Tpj9I49KvDuB3PqR5GGK7PRTiILiCRnYSA6jQQ2ZVv5Jh/EUb8oftYX5NzSCPcOAeTAvV3WAdGDU/27NFfngNJWIn+755a3SViKJ2Bl6gE5khFa5MCp+A4dMDJ0THqyPxjRljtBkpPVD/v6qsSBKFYoQQA7HaUuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lzu.edu.cn; spf=pass smtp.mailfrom=lzu.edu.cn; arc=none smtp.client-ip=13.75.44.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lzu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lzu.edu.cn
Received: from enjou-Legion-Y7000P-2019.coin-barley.ts.net (unknown [172.23.56.36])
	by app1 (Coremail) with SMTP id ygmowADnXwCvqM5pTmKhAA--.37297S2;
	Fri, 03 Apr 2026 01:34:39 +0800 (CST)
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
	kaber@trash.net,
	yasuyuki.kozakai@toshiba.co.jp,
	yifanwucs@gmail.com,
	tomapufckgml@gmail.com,
	yuantan098@gmail.com,
	bird@lzu.edu.cn,
	z1652074432@gmail.com,
	n05ec@lzu.edu.cn,
	enjou1224z@gmail.com
Subject: [PATCH v2] netfilter: xt_multiport: validate range encoding in checkentry
Date: Fri,  3 Apr 2026 01:34:39 +0800
Message-ID: <d5c0d106e724c732436b985dd694272bcb813bb1.1775149327.git.n05ec@lzu.edu.cn>
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
X-CM-TRANSID:ygmowADnXwCvqM5pTmKhAA--.37297S2
X-Coremail-Antispam: 1UD129KBjvJXoWxZw45Cw4UuF45ur18urW7Arb_yoW5CrW5pa
	y5GF15GrWkXFWaqFs2yr1kJF15CrWkJw48ua43G347trsxWr95ta1rtFWqvFs8Ary5CFW8
	JF4qvrn0kw45u37anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBY1xkIjI8I6I8E6xAIw20EY4v20xvaj40_JFC_Wr1l1IIY67AE
	w4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2
	IY67AKxVWUCVW8JwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwA2z4x0Y4vEx4A2
	jsIE14v26F4j6r4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UM2AIxVAIcxkEcV
	Aq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j
	6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64
	vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E8cxan2IY04v7MxkF7I0E
	n4kS14v26r4a6rW5MxkIecxEwVCm-wCF04k20xvY0x0EwIxGrwCF04k20xvE74AGY7Cv6c
	x26r48MxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCj
	r7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVW8ZVWrXwCIc40Y0x0EwIxGrwCI42IY6x
	IIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAI
	w20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x
	0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7sRi_HU3UUUUU==
X-CM-SenderInfo: zqqvvuo6o23hxhgxhubq/1tbiAQQFCWnOkPwAygAAsI

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
 net/netfilter/xt_multiport.c | 30 ++++++++++++++++++++++++++----
 1 file changed, 26 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/xt_multiport.c b/net/netfilter/xt_multiport.c
index 44a00f5acde8..07a0f2a3fc75 100644
--- a/net/netfilter/xt_multiport.c
+++ b/net/netfilter/xt_multiport.c
@@ -105,6 +105,24 @@ multiport_mt(const struct sk_buff *skb, struct xt_action_param *par)
 	return ports_match_v1(multiinfo, ntohs(pptr[0]), ntohs(pptr[1]));
 }
 
+static inline bool
+multiport_valid_ranges(const struct xt_multiport_v1 *multiinfo)
+{
+	unsigned int i;
+
+	for (i = 0; i < multiinfo->count; i++) {
+		if (!multiinfo->pflags[i])
+			continue;
+
+		if (i + 1 >= multiinfo->count || multiinfo->pflags[i + 1])
+			return false;
+
+		i++;
+	}
+
+	return true;
+}
+
 static inline bool
 check(u_int16_t proto,
       u_int8_t ip_invflags,
@@ -127,8 +145,10 @@ static int multiport_mt_check(const struct xt_mtchk_param *par)
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
@@ -136,8 +156,10 @@ static int multiport_mt6_check(const struct xt_mtchk_param *par)
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

