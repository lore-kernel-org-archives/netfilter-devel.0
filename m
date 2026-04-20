Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB396410D1D;
	Mon, 20 Apr 2026 13:27:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691644; cv=none; b=ubNK/YupGXw+2ZL/nTU7OSTDla1ylZtgLvzhHg337jIs7OsZieLqpBbbDkKigKLVRFFSref5gkSnCLfNjn5EmA7GFDffGPE2CfSLmzPdJM6VlHdcP1FdKsQld9yZ/YlfwN2udNACryhIPqwPTRobqtjPjyWRWaQMUSjt2hAv1Pk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691644; c=relaxed/simple;
	bh=zcpRu7PTle2h3X/ZDntIMH5OT49jZM9svO4tKruyPtI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ilZ6P2aUBhHmq60caSQhQNNWSyE63TiLFB+suNj735AZFO8r9iEowCFYOf29lbLRbJa3OJhzFlFrQ59kcB0TVx6CHpTiwLg7qRcXvAabq+iNri7G8gSQSsit8oi7rb/ObKqL0oGtqmu2JMHi9lPdTdpwI8CzLJKx0eaVMmhvAgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n+oJmv8k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n+oJmv8k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A69B8C4AF09;
	Mon, 20 Apr 2026 13:27:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691643;
	bh=zcpRu7PTle2h3X/ZDntIMH5OT49jZM9svO4tKruyPtI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n+oJmv8khECyeWvNgffxI0PhV5D3tqtW/c6ZnlayQL0oIvMnUZK1l79L4CBdbJ9d0
	 qnnN0B6xL+C0Y5FJZ6YQNKeBnGbktW4JghhP5MM7gn3oCenXR+0pg+S541SfXdS3Mg
	 Nxz1FvQP1doSf5F3+BsfR+e35Fdlz4LxkCvknjeoGg2z4KHdipN01AYWR8yCfcElVO
	 1L1rjLgMDstvKcWhlbApYtmtnqLHOlKtK2FJbO5z6BWmNt1sswYKM+OoTr9Qck3XUI
	 /gB+yV+AWM+0/leebvZAUwlOercsLBxAgTW4CBkl9WdsXd2PYiqsR6Cbt5dslnOSjA
	 1ajOGpi8euonw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Zhengchuan Liang <zcliangcn@gmail.com>,
	Yifan Wu <yifanwucs@gmail.com>,
	Juefei Pu <tomapufckgml@gmail.com>,
	Yuan Tan <yuantan098@gmail.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Ren Wei <enjou1224z@gmail.com>,
	Ren Wei <n05ec@lzu.edu.cn>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>,
	pablo@netfilter.org,
	davem@davemloft.net,
	dsahern@kernel.org,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] netfilter: ip6t_eui64: reject invalid MAC header for all packets
Date: Mon, 20 Apr 2026 09:19:02 -0400
Message-ID: <20260420132314.1023554-148-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420132314.1023554-1-sashal@kernel.org>
References: <20260420132314.1023554-1-sashal@kernel.org>
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

From: Zhengchuan Liang <zcliangcn@gmail.com>

[ Upstream commit fdce0b3590f724540795b874b4c8850c90e6b0a8 ]

`eui64_mt6()` derives a modified EUI-64 from the Ethernet source address
and compares it with the low 64 bits of the IPv6 source address.

The existing guard only rejects an invalid MAC header when
`par->fragoff != 0`. For packets with `par->fragoff == 0`, `eui64_mt6()`
can still reach `eth_hdr(skb)` even when the MAC header is not valid.

Fix this by removing the `par->fragoff != 0` condition so that packets
with an invalid MAC header are rejected before accessing `eth_hdr(skb)`.

Fixes: 1da177e4c3f41 ("Linux-2.6.12-rc2")
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Co-developed-by: Yuan Tan <yuantan098@gmail.com>
Signed-off-by: Yuan Tan <yuantan098@gmail.com>
Suggested-by: Xin Liu <bird@lzu.edu.cn>
Tested-by: Ren Wei <enjou1224z@gmail.com>
Signed-off-by: Zhengchuan Liang <zcliangcn@gmail.com>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Error: Failed to generate final synthesis

 net/ipv6/netfilter/ip6t_eui64.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/ipv6/netfilter/ip6t_eui64.c b/net/ipv6/netfilter/ip6t_eui64.c
index d704f7ed300c2..da69a27e8332c 100644
--- a/net/ipv6/netfilter/ip6t_eui64.c
+++ b/net/ipv6/netfilter/ip6t_eui64.c
@@ -22,8 +22,7 @@ eui64_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 	unsigned char eui64[8];
 
 	if (!(skb_mac_header(skb) >= skb->head &&
-	      skb_mac_header(skb) + ETH_HLEN <= skb->data) &&
-	    par->fragoff != 0) {
+	      skb_mac_header(skb) + ETH_HLEN <= skb->data)) {
 		par->hotdrop = true;
 		return false;
 	}
-- 
2.53.0

