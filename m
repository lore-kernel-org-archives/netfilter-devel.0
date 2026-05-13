Received: from azure-sdnproxy.icoremail.net (azure-sdnproxy.icoremail.net [52.229.168.213])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01CCD3D75C9
	for <netfilter-devel@vger.kernel.org>; Wed, 13 May 2026 07:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.229.168.213
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778659092; cv=none; b=l7AR0trFGnQZAn5sC2qAGr1avHPwI2stnU2AIG/UcC5MyBHyLjWRv6AGTnQ3i9un7ez669ylaOnJVusj7Vcv5YEI4pTW2w/qQfXVqPFS6bPz2TO9+qN/88Ec3smS9wZ6hu4Vd1fXsbR9z/00nNJbrSA4ygJ8PuSKU4NtAtVvpi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778659092; c=relaxed/simple;
	bh=q/7venarg057X54K/KIDXSbmaBL77/mMK5Nars1Q/KI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WW+YsfG4cvI10aBCPiGGr5RE2oHamIWKCVyXfObzR7MvM/Lq1n2PuJhzLwLpXW6MhpRM4xd7Z6UzKvCAKa54fhLVw5cK1GHp09dKxiYvELCknVfnKOtBRqv7Otp3qveluPhznqZsxmc0nDRD/ZjugEUvdkkBVdKIPRLVuubUab8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lzu.edu.cn; spf=pass smtp.mailfrom=lzu.edu.cn; arc=none smtp.client-ip=52.229.168.213
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lzu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lzu.edu.cn
Received: from enjou-Legion-Y7000P-2019.coin-barley.ts.net (unknown [172.23.56.36])
	by app1 (Coremail) with SMTP id ygmowABXesTuLgRq5XQDAA--.4023S3;
	Wed, 13 May 2026 15:57:44 +0800 (CST)
From: Ren Wei <n05ec@lzu.edu.cn>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	yuantan098@gmail.com,
	yifanwucs@gmail.com,
	tomapufckgml@gmail.com,
	bird@lzu.edu.cn,
	zcliangcn@gmail.com,
	n05ec@lzu.edu.cn
Subject: [PATCH nf 1/1] netfilter: ip6t_hbh: reject oversized option lists
Date: Wed, 13 May 2026 15:57:17 +0800
Message-ID: <d2ac2409a17211ebad6d137cb4cf81f3f329d875.1778633212.git.zcliangcn@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1778633212.git.zcliangcn@gmail.com>
References: <cover.1778633212.git.zcliangcn@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:ygmowABXesTuLgRq5XQDAA--.4023S3
X-Coremail-Antispam: 1UD129KBjvJXoW7Ary8XFyftw1Dur1rAFyfCrg_yoW8XF4xpa
	y3Gry7Jr98Gr18Cr4kJrW8CrW3AFs8Jr42qF90y34kWry5XF15Xw409FyavF1ayFZ0k3yf
	tFs0vFWDZan8Aa7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBY1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AE
	w4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2
	IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8Jr0_Cr1UM28EF7xvwVC2
	z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0DM2AIxVAIcxkEcV
	Aq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j
	6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64
	vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E8cxan2IY04v7MxkF7I0E
	n4kS14v26r1q6r43MxkIecxEwVCm-wCF04k20xvY0x0EwIxGrwCF04k20xvE74AGY7Cv6c
	x26r48MxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCj
	r7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6x
	IIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAI
	w20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x
	0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUbGQ6JUUUUU==
X-CM-SenderInfo: zqqvvuo6o23hxhgxhubq/1tbiAQ0GCWoEFm8C5wAAsx

From: Zhengchuan Liang <zcliangcn@gmail.com>

struct ip6t_opts stores at most IP6T_OPTS_OPTSNR option descriptors,
but hbh_mt6_check() does not reject larger optsnr values supplied from
userspace.

Validate optsnr in the rule setup path so only match data that fits the
fixed-size opts array can be installed. This follows the existing xtables
pattern of rejecting invalid user-provided counts in checkentry() and
keeps the packet matching path unchanged.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")

Cc: stable@kernel.org
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Signed-off-by: Zhengchuan Liang <zcliangcn@gmail.com>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
---
 net/ipv6/netfilter/ip6t_hbh.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/ipv6/netfilter/ip6t_hbh.c b/net/ipv6/netfilter/ip6t_hbh.c
index e7a3fb9355ee..450dd53846a2 100644
--- a/net/ipv6/netfilter/ip6t_hbh.c
+++ b/net/ipv6/netfilter/ip6t_hbh.c
@@ -168,6 +168,10 @@ static int hbh_mt6_check(const struct xt_mtchk_param *par)
 		pr_debug("unknown flags %X\n", optsinfo->invflags);
 		return -EINVAL;
 	}
+	if (optsinfo->optsnr > IP6T_OPTS_OPTSNR) {
+		pr_debug("too many supported opts specified\n");
+		return -EINVAL;
+	}
 
 	if (optsinfo->flags & IP6T_OPTS_NSTRICT) {
 		pr_debug("Not strict - not implemented");
-- 
2.47.3

