Received: from azure-sdnproxy.icoremail.net (azure-sdnproxy.icoremail.net [4.193.249.245])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 902B43A7F52;
	Sat,  4 Apr 2026 09:40:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=4.193.249.245
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775295644; cv=none; b=ZEb9F1vML7IlIbj8HmAOl7WBZniOYks82ijLLbrV9zKgpnlgkQnntib1gtHjy49jFnKCuhpG55u9jvE1x+n4KpZV40fVBe4fTgILsoyfG/RI0O4s8fEjeVpteKD2GyAUjBjxgbw6N3Qidju282bLEvCXNaj4MoGQyzwQIuvml4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775295644; c=relaxed/simple;
	bh=QGGjTspDMpFhM1XzLTZu7uZb0YzfwmyvxKR3zZdIklo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ssxQx5ELc95fQUS28kYDZ4BpK+c57r6xoMY8gRCB7aaXEYf5NO9/8PRY/aPmSpkQ+FDmUu8UN2SS6zu/SHMsBjrLvYelHmHWCEoipMUBMjWuXodcE9ULqm1KlmZBBoHG47WnJI6tSZwCMxKOiR6hQOpKYu6SMMlBfJnKafw4RHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lzu.edu.cn; spf=pass smtp.mailfrom=lzu.edu.cn; arc=none smtp.client-ip=4.193.249.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lzu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lzu.edu.cn
Received: from enjou-Legion-Y7000P-2019.coin-barley.ts.net (unknown [172.23.56.36])
	by app1 (Coremail) with SMTP id ygmowADnXwB93NBps2+lAA--.38592S2;
	Sat, 04 Apr 2026 17:40:14 +0800 (CST)
From: Ren Wei <n05ec@lzu.edu.cn>
To: netfilter-devel@vger.kernel.org,
	netdev@vger.kernel.org
Cc: pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	davem@davemloft.net,
	dsahern@kernel.org,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	yifanwucs@gmail.com,
	tomapufckgml@gmail.com,
	yuantan098@gmail.com,
	bird@lzu.edu.cn,
	enjou1224z@gmail.com,
	zcliangcn@gmail.com,
	n05ec@lzu.edu.cn
Subject: [PATCH nf v2 1/2] netfilter: ip6t_eui64: reject invalid MAC header for all packets
Date: Sat,  4 Apr 2026 17:39:47 +0800
Message-ID: <89bf7d5997ef9cbb0902518677c6ec5f4de7e56b.1775260446.git.zcliangcn@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1774859629.git.zcliangcn@gmail.com>
References: <cover.1774859629.git.zcliangcn@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:ygmowADnXwB93NBps2+lAA--.38592S2
X-Coremail-Antispam: 1UD129KBjvJXoW7uFy3GryDXFWruFy5AF4xJFb_yoW8ur48pr
	ZxGry8JayDJr1akr4v9ry8XFW5Aa1kGF1IgFZ0y34vgwn8urs5Ja98Kr4UZa40yrs8KFZY
	yr90vr98G3Z8Z37anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBY1xkIjI8I6I8E6xAIw20EY4v20xvaj40_JFC_Wr1l1IIY67AE
	w4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2
	IY67AKxVW8JVW5JwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwA2z4x0Y4vEx4A2
	jsIE14v26F4UJVW0owA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Cr1j6rxdM2AIxVAIcxkEcV
	Aq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j
	6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64
	vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E8cxan2IY04v7MxkF7I0E
	n4kS14v26r4a6rW5MxkIecxEwVCm-wCF04k20xvY0x0EwIxGrwCF04k20xvE74AGY7Cv6c
	x26r48MxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCj
	r7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVW8ZVWrXwCIc40Y0x0EwIxGrwCI42IY6x
	IIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAI
	w20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x
	0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7sRi_HU3UUUUU==
X-CM-SenderInfo: zqqvvuo6o23hxhgxhubq/1tbiAQQHCWnP4nwFqgAAsc

From: Zhengchuan Liang <zcliangcn@gmail.com>

`eui64_mt6()` derives a modified EUI-64 from the Ethernet source
address and compares it with the low 64 bits of the IPv6 source
address.

The existing guard only rejects an invalid MAC header when
`par->fragoff != 0`. For packets with `par->fragoff == 0`,
`eui64_mt6()` can still reach `eth_hdr(skb)` even when the MAC header
is not valid.

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
---
Changes in v2:
This patch specifically fixes the memory-safety issue in `eui64_mt6()`:
the old guard only rejected invalid MAC headers for non-first fragments,
while our PoC triggers the KASAN report with a non-fragment packet
(`par->fragoff == 0`). This patch is sufficient enough to fix the
memory-safety issue, and we do not find other `eth_hdr(skb)` users with
similar use-after-free or out-of-bound issues.

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
2.43.0

