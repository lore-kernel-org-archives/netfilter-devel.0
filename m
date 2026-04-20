Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A15D23ED5B;
	Mon, 20 Apr 2026 13:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776690968; cv=none; b=XwKKR0IQ/3SLVN9EM4CzbM6CnqaUyeYVaoEoaQLo2bNLl2yL7sz6iMlmlOVHvtmyzyS/HWkMBPYesLmwK0+3DsD30NVoTxkmE06zECil6ZlWHANYPSkuEt5v+gapva5RhmQPiSe6r5Op3evRZvO52kw+8bkGpJah41uwGOcgbdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776690968; c=relaxed/simple;
	bh=PY00X5IV4JpUSmoJ41N7TTVq2lNmpdVturPjoc87vBE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A+Gd5bpps9HPNlsG2wKTmhEwsn72CreNr3PYD38p+TPPc145sEaoU9EAwQlfqsXGSXFkrvqMnRN9cZzpU0tjb/Lidtz00X2qMbGhO5G/Z8GxlmzBp25DLaZ8cVPCxCv+8BNVoa4b6HBNE5Cz4PG9eohJYyWlrFubkynxROZNzz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eSFWE5at; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eSFWE5at"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4738C2BCB4;
	Mon, 20 Apr 2026 13:16:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776690967;
	bh=PY00X5IV4JpUSmoJ41N7TTVq2lNmpdVturPjoc87vBE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eSFWE5atr2IlZCpKkm3Xbngja437Kg45hCRI3yvoR4ZoOwwzG6ri5NpVTLe6Fxxqv
	 wpEbHcQfR6uBHkVwhT5WyhQRRNcosTzFOqOaUXOth7aG8qIm03jZkhnVT3CCl8eem8
	 f+qwyeWeLDIQS3z+cJ9pW2WP4Vv0Bh83EsJCdjw9dCzzo/Avrx3j6h1K92nnead54m
	 dqFqXu0kzjSN0KUmn9vGHezQwP2leTDN4B4wTFghAaBDgFOqZl2/fMrB2078aeyjIg
	 NU1dTwbhgDq5R0cs0IvQfkQJd/CPc0A56Y/Q91nocYYop4V5Bin5mMsLLSFRbHnfo1
	 j9ZbimYBUBeFQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Ren Wei <n05ec@lzu.edu.cn>,
	Yifan Wu <yifanwucs@gmail.com>,
	Juefei Pu <tomapufckgml@gmail.com>,
	Yuan Tan <yuantan098@gmail.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Yuhang Zheng <z1652074432@gmail.com>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>,
	pablo@netfilter.org,
	kadlec@netfilter.org,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	yasuyuki.kozakai@toshiba.co.jp,
	kaber@trash.net,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] netfilter: xt_multiport: validate range encoding in checkentry
Date: Mon, 20 Apr 2026 09:08:02 -0400
Message-ID: <20260420131539.986432-16-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420131539.986432-1-sashal@kernel.org>
References: <20260420131539.986432-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.23
Content-Transfer-Encoding: 8bit

From: Ren Wei <n05ec@lzu.edu.cn>

[ Upstream commit ff64c5bfef12461df8450e0f50bb693b5269c720 ]

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
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Error: Failed to generate final synthesis

 net/netfilter/xt_multiport.c | 34 ++++++++++++++++++++++++++++++----
 1 file changed, 30 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/xt_multiport.c b/net/netfilter/xt_multiport.c
index 44a00f5acde8a..a1691ff405d3c 100644
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
2.53.0

