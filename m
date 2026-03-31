Received: from sgoci-sdnproxy-4.icoremail.net (sgoci-sdnproxy-4.icoremail.net [129.150.39.64])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48E6A3C3BFC
	for <netfilter-devel@vger.kernel.org>; Tue, 31 Mar 2026 07:35:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=129.150.39.64
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774942526; cv=none; b=OFQZ1gr9+/9evc5x089Zuq5BhueC5C7udLVC2XKs3piMMKPfIKWz0MR/IoY4FRQAbKpHAJW67AJJaqwnnwdBIEzivblyNQYaMBHgf2fyui8LqKMBPMxkSCk/JZeQCBkfb1/HL2608VRxYcL1UdaD3RfEQLh1Xe0/6LtT6BAv2Dw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774942526; c=relaxed/simple;
	bh=KZ06V6xNiQKiGsihPRFcar4LScO19ypPjdQDSHi5YMM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B/QhayMoVxOuRKj/RESJx6wmj7oDKK4yBY2tUzwzNOFNAqsEzaqrI8OliRzgMUqYRWeKmPdjcn8Nsn9pasSvPAwDJub+Byu99b7HbqZNeOTXyH/U9fII344hBAtGNz0B+rHKvS/mPHDweVzakUIH2XqSI1TNj12n3N2oQX9DXM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lzu.edu.cn; spf=pass smtp.mailfrom=lzu.edu.cn; arc=none smtp.client-ip=129.150.39.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lzu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lzu.edu.cn
Received: from enjou-Legion-Y7000P-2019.coin-barley.ts.net (unknown [172.23.56.36])
	by app1 (Coremail) with SMTP id ygmowABXyvoYectpnpeXAA--.52190S3;
	Tue, 31 Mar 2026 15:34:57 +0800 (CST)
From: Ren Wei <n05ec@lzu.edu.cn>
To: security@kernel.org,
	netfilter-devel@vger.kernel.org
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
Subject: [PATCH 1/1] netfilter: ip6t_eui64: validate MAC header before using it
Date: Tue, 31 Mar 2026 15:34:41 +0800
Message-ID: <5267bb5b37997fa793c28c4b928a828cfb3a3927.1774859629.git.zcliangcn@gmail.com>
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
X-CM-TRANSID:ygmowABXyvoYectpnpeXAA--.52190S3
X-Coremail-Antispam: 1UD129KBjvJXoWxGF18WF48Zr45Aw4fCr4DJwb_yoW5Xr4fpw
	s3KryrtrWkJr1akw1kKry8ZFZ8tF18ta43Was0k3s2gF4qgrn5tayrt3Wjva1FyrZYgF4f
	tryYvFn8Gw4DA37anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBY1xkIjI8I6I8E6xAIw20EY4v20xvaj40_JFC_Wr1l1IIY67AE
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
X-CM-SenderInfo: zqqvvuo6o23hxhgxhubq/1tbiAQQDCWnKnHsP8wAAs3

From: Zhengchuan Liang <zcliangcn@gmail.com>

`eui64_mt6()` derives a modified EUI-64 from the Ethernet source
address and compares it with the low 64 bits of the IPv6 source
address.

The match unconditionally reaches `skb_mac_header()` and `eth_hdr(skb)`
after a guard that only rejects an invalid MAC header when
`par->fragoff != 0`. As a result, non-fragment packets can still reach
`eth_hdr(skb)` even when the skb has no MAC header set, or when the MAC
header does not cover a full Ethernet header.

Fix this by first checking that the MAC header is set and spans a full
Ethernet header before accessing it, then using that validated header
directly for the EUI-64 comparison. Preserve the existing hotdrop
behavior for non-first fragments with an invalid MAC header.

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
 net/ipv6/netfilter/ip6t_eui64.c | 23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/net/ipv6/netfilter/ip6t_eui64.c b/net/ipv6/netfilter/ip6t_eui64.c
index d704f7ed300c2..dbf64948d72c0 100644
--- a/net/ipv6/netfilter/ip6t_eui64.c
+++ b/net/ipv6/netfilter/ip6t_eui64.c
@@ -19,21 +19,30 @@ MODULE_AUTHOR("Andras Kis-Szabo <kisza@sch.bme.hu>");
 static bool
 eui64_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 {
+	const unsigned char *mac;
+	const struct ethhdr *eth;
 	unsigned char eui64[8];
 
-	if (!(skb_mac_header(skb) >= skb->head &&
-	      skb_mac_header(skb) + ETH_HLEN <= skb->data) &&
-	    par->fragoff != 0) {
-		par->hotdrop = true;
+	if (!skb_mac_header_was_set(skb)) {
+		if (par->fragoff != 0)
+			par->hotdrop = true;
 		return false;
 	}
 
+	mac = skb_mac_header(skb);
+	if (mac < skb->head || mac + ETH_HLEN > skb->data) {
+		if (par->fragoff != 0)
+			par->hotdrop = true;
+		return false;
+	}
+	eth = (const struct ethhdr *)mac;
+
 	memset(eui64, 0, sizeof(eui64));
 
-	if (eth_hdr(skb)->h_proto == htons(ETH_P_IPV6)) {
+	if (eth->h_proto == htons(ETH_P_IPV6)) {
 		if (ipv6_hdr(skb)->version == 0x6) {
-			memcpy(eui64, eth_hdr(skb)->h_source, 3);
-			memcpy(eui64 + 5, eth_hdr(skb)->h_source + 3, 3);
+			memcpy(eui64, eth->h_source, 3);
+			memcpy(eui64 + 5, eth->h_source + 3, 3);
 			eui64[3] = 0xff;
 			eui64[4] = 0xfe;
 			eui64[0] ^= 0x02;
-- 
2.43.0

