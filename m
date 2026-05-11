Received: from azure-sdnproxy.icoremail.net (azure-sdnproxy.icoremail.net [13.75.44.102])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12CFD2D12EC;
	Mon, 11 May 2026 13:38:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.75.44.102
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778506720; cv=none; b=KlAU4+IQEUScsOMa/f5dwKKNVgtjtmmaBNhDqChNqUgIjYlupylMOUbgBFaHEvqnXIbylqox6oMHsUa6AhNG9GllmhwtwUZhrY+WrzsV6PI9rS6zBnwmveuyvoea6ZJgPm60VaNX6luGIbEkL03rs+2ttNMNezyZjxzLFaeOgsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778506720; c=relaxed/simple;
	bh=1gikFVlJ6Is+k457j029Qz0aS+tfcjwpe/DX4X8k1Jo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nDh8guT5K+FKwT+S+FvwO5+GphVBODSl04FVwsHtYuI9CYRd3R7ZyLHBTsRWbuDz9BNhqDtd17dYdPvT6x26XrBzlsXr5IdKbbU0sMzEfSnehP3UTCtaDKjOTebUDFWr4nVNodrMdhJ7+ggLunVFe4sHxhlPBHp6RiurNUmI8so=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mails.tsinghua.edu.cn; spf=pass smtp.mailfrom=mails.tsinghua.edu.cn; dkim=pass (1024-bit key) header.d=mails.tsinghua.edu.cn header.i=@mails.tsinghua.edu.cn header.b=GuzC42vM; arc=none smtp.client-ip=13.75.44.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mails.tsinghua.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mails.tsinghua.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mails.tsinghua.edu.cn header.i=@mails.tsinghua.edu.cn header.b="GuzC42vM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=mails.tsinghua.edu.cn; s=dkim; h=Received:From:To:Cc:Subject:
	Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Type:
	Content-Transfer-Encoding; bh=8+eQAK+QtABeFzGLd6qtmVFerpZsvbvgyp
	ZsmziEyfU=; b=GuzC42vMxRA5+k+6fFnE+nVD1JUh/t0hOlmcuMjJF8KAj7RQOD
	wvMGyDF4Vks/jdsVMZVh2xEUl0UpC3ki/Y9NyWelxRKTT24NOH3X8qQ4aKlUC37u
	kXaEMcuMJJK8b0Jt8YXXKmqSFWIeP85D0UmQVlDAuFUQxNprmAWNikxuE=
Received: from localhost.localdomain (unknown [36.110.46.68])
	by web4 (Coremail) with SMTP id ywQGZQD3CJ632wFqp85mAQ--.52980S2;
	Mon, 11 May 2026 21:38:00 +0800 (CST)
From: Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>
To: fmancera@suse.de
Cc: davem@davemloft.net,
	edumazet@google.com,
	fengxw06@126.com,
	fw@strlen.de,
	horms@kernel.org,
	kuba@kernel.org,
	netfilter-devel@vger.kernel.org,
	pabeni@redhat.com,
	pablo@netfilter.org,
	phil@nwl.cc,
	qli01@tsinghua.edu.cn,
	stable@vger.kernel.org,
	xuke@tsinghua.edu.cn,
	yangyx22@mails.tsinghua.edu.cn,
	zhaoyz24@mails.tsinghua.edu.cn
Subject: [PATCH v2 nft] netfilter: nft_inner: Fix IPv6 inner_thoff desync
Date: Mon, 11 May 2026 21:37:42 +0800
Message-ID: <20260511133744.6716-1-zhaoyz24@mails.tsinghua.edu.cn>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <0bbeadd4-a4b4-44e9-9312-85e563f2bd1c@suse.de>
References: <0bbeadd4-a4b4-44e9-9312-85e563f2bd1c@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:ywQGZQD3CJ632wFqp85mAQ--.52980S2
X-Coremail-Antispam: 1UD129KBjvJXoW7WF18ZFWxXF13CF4xCw43trb_yoW8CF1Upa
	y5G3y5AFyxGry7Aws2ya9rAr4rAF4kCr4xZFWUtry5ZFn0gFy5X34rKrWUuFyqyrZrKw4F
	qFZ0yFyYvwn8XrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUP014x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1lnxkEFVAIw20F6cxK64vIFxWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xv
	F2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r
	4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I
	648v4I1lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc7CjxVAaw2AFwI0_Jw0_GFylc2xSY4AK67
	AK6ry8MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAF
	wI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVW8ZVWrXwCIc4
	0Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AK
	xVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr
	1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUjySoJUU
	UUU==
X-CM-SenderInfo: 52kd05r2suqzpdlo2hxwvl0wxkxdhvlgxou0/1tbiAQYEAWoBiy6eoAAAsy

Thank you for your suggestions. Here's the v2 version of our patch.

In nft_inner_parse_l2l3(), when processing inner IPv6 packets,
ipv6_find_hdr() correctly computes the transport header offset
traversing all extension headers, but the result is immediately
overwritten with nhoff + sizeof(_ip6h) (40 bytes), which only
accounts for the IPv6 base header. This creates a desync between
inner_thoff (wrong — points to extension header start) and l4proto
(correct — e.g., IPPROTO_TCP), enabling transport header forgery
and potential firewall bypass. This issue affects stable versions
from Linux 6.2.

For comparison, the normal (non-inner) IPv6 path correctly
preserves ipv6_find_hdr()'s result. Removing the incorrect overwrite
ensures that ipv6_find_hdr()'s calculated transport header offset is
preserved, thereby fixing the desynchronization.

Fixes: 3a07327d10a0 ("netfilter: nft_inner: support for inner tunnel header matching")
Reported-by: Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>
Reported-by: Yuxiang Yang <yangyx22@mails.tsinghua.edu.cn> 
Reported-by: Xuewei Feng <fengxw06@126.com>
Reported-by: Qi Li <qli01@tsinghua.edu.cn>
Reported-by: Ke Xu <xuke@tsinghua.edu.cn>
Assisted-by: GLM:5.1 Z.ai
Signed-off-by: Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>
---
 net/netfilter/nft_inner.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/netfilter/nft_inner.c b/net/netfilter/nft_inner.c
index c4569d4b9..1b3e7a976 100644
--- a/net/netfilter/nft_inner.c
+++ b/net/netfilter/nft_inner.c
@@ -163,7 +163,6 @@ static int nft_inner_parse_l2l3(const struct nft_inner *priv,
 			return -1;
 
 		if (fragoff == 0) {
-			thoff = nhoff + sizeof(_ip6h);
 			ctx->flags |= NFT_PAYLOAD_CTX_INNER_TH;
 			ctx->inner_thoff = thoff;
 			ctx->l4proto = l4proto;
-- 
2.43.0

