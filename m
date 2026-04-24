Received: from azure-sdnproxy.icoremail.net (azure-sdnproxy.icoremail.net [207.46.229.174])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 321E218AFE
	for <netfilter-devel@vger.kernel.org>; Fri, 24 Apr 2026 09:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=207.46.229.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777023125; cv=none; b=AUUMN5Q/3+SxqXx7TXPmFX71wqgIKUN60j+jppcoHeiNbhG5DHPmYOIzYF7MwbGn1yqRUCz+lD0c5L9HmbJHN7/bFV67s6BCRSgzDf7q1l/z5LMN6Jm1z1maO5Ij328OH119R/H4xBqf+JECNo7Y4blEic+yf8BEfM9k/FJ3zt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777023125; c=relaxed/simple;
	bh=HV/HOmPr269yunyJbzTMG2ZKw9gGFaMudjaLHdZhMt8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NoqqQ7DGtb3avUKT6J83EIoc08MqZSC7dZm0inNTOjL/OMFwijGMWCf3JVuABx8ZQ8e3YD11MPaSf+niZvoIlbA+rm7hB1jd2riHeegGrlEyotCQj4IFsis8/92OStXdFvZBeLHSN52cFxp1d+IlYhQAh08RJpQ0378owDaHKho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lzu.edu.cn; spf=pass smtp.mailfrom=lzu.edu.cn; arc=none smtp.client-ip=207.46.229.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lzu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lzu.edu.cn
Received: from enjou-Legion-Y7000P-2019.coin-barley.ts.net (unknown [172.23.56.36])
	by app2 (Coremail) with SMTP id zQmowAAnv4VvOOtpjelCAA--.34880S3;
	Fri, 24 Apr 2026 17:31:30 +0800 (CST)
From: Ren Wei <n05ec@lzu.edu.cn>
To: netfilter-devel@vger.kernel.org,
	bridge@lists.linux.dev
Cc: pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	razor@blackwall.org,
	idosch@nvidia.com,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	yuantan098@gmail.com,
	yifanwucs@gmail.com,
	tomapufckgml@gmail.com,
	bird@lzu.edu.cn,
	rakukuip@gmail.com,
	n05ec@lzu.edu.cn
Subject: [PATCH nf 1/1] netfilter: ebtables: fix OOB read in compat_mtw_from_user
Date: Fri, 24 Apr 2026 17:23:00 +0800
Message-ID: <4e714f6189f9691fa5980087ce378a57cf625976.1776834093.git.rakukuip@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1776834093.git.rakukuip@gmail.com>
References: <cover.1776834093.git.rakukuip@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zQmowAAnv4VvOOtpjelCAA--.34880S3
X-Coremail-Antispam: 1UD129KBjvJXoW7Aw18XrWxJw43WF4kZF4kCrg_yoW8urWxpF
	9rCr13KFWaqry3t3s2y340vFWUWrs7W39xAr97G3s7Wr18KF1jyw1rKasxuF98Xas5ur45
	GF1qvr1Sk3y7ArJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBY1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AE
	w4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2
	IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8Jr0_Cr1UM28EF7xvwVC2
	z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0DM2AIxVAIcxkEcV
	Aq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j
	6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64
	vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E8cxan2IY04v7MxkF7I0E
	n4kS14v26r4a6rW5MxkIecxEwVCm-wCF04k20xvY0x0EwIxGrwCF04k20xvE74AGY7Cv6c
	x26r48MxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCj
	r7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVW8ZVWrXwCIc40Y0x0EwIxGrwCI42IY6x
	IIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAI
	w20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x
	0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7sRi_HU3UUUUU==
X-CM-SenderInfo: zqqvvuo6o23hxhgxhubq/1tbiAQsHCWnrLmIBQwAAsI

From: Luxiao Xu <rakukuip@gmail.com>

The function compat_mtw_from_user() converts ebtables extensions from
32-bit user structures to kernel native structures. However, it lacks
proper validation of the user-supplied match_size/target_size.

When certain extensions are processed, the kernel-side translation
logic may perform memory accesses based on the extension's expected
size. If the user provides a size smaller than what the extension
requires, it results in an out-of-bounds read as reported by KASAN.

This fix introduces a check to ensure match_size is at least as large
as the extension's required compatsize. This covers matches, watchers,
and targets, while maintaining compatibility with standard targets.

Fixes: 81e675c227ec ("netfilter: ebtables: add CONFIG_COMPAT support")
Cc: stable@kernel.org
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Signed-off-by: Luxiao Xu <rakukuip@gmail.com>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
---
 net/bridge/netfilter/ebtables.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index aea3e19875c6..80cd0233c088 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -1977,6 +1977,11 @@ static int compat_mtw_from_user(const struct compat_ebt_entry_mwt *mwt,
 		if (IS_ERR(match))
 			return PTR_ERR(match);
 
+		if (match_size < match->compatsize) {
+			module_put(match->me);
+			return -EINVAL;
+		}
+
 		off = ebt_compat_match_offset(match, match_size);
 		if (dst) {
 			if (match->compat_from_user)
@@ -1996,6 +2001,12 @@ static int compat_mtw_from_user(const struct compat_ebt_entry_mwt *mwt,
 					    mwt->u.revision);
 		if (IS_ERR(wt))
 			return PTR_ERR(wt);
+
+		if (match_size < wt->compatsize) {
+			module_put(wt->me);
+			return -EINVAL;
+		}
+
 		off = xt_compat_target_offset(wt);
 
 		if (dst) {
-- 
2.43.0

