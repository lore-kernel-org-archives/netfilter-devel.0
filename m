Received: from azure-sdnproxy.icoremail.net (azure-sdnproxy.icoremail.net [13.75.44.102])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 350F21EB1AA
	for <netfilter-devel@vger.kernel.org>; Fri, 26 Jun 2026 06:50:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.75.44.102
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782456608; cv=none; b=JXh/khoRIGbhbUC0XAXR+OARTLgGV9nbYfrDOKkP5njuAdAnDAaEoNMzsnqLPGTgCJcbT4CL7nh8Sw9YVlKeidOAQdGIBzbvZ+7+zpI3LTXQpNzpe3OHbP8vUwi3Vj+efQPwmjx/ZqfGbndDuz6gLACrV1wn7ybhb+ixbLAhEso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782456608; c=relaxed/simple;
	bh=//k3onHVlf458KXwGh2Hv/HKrgL4OOwS12nX0lBZhPE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T8IcNlHXaUgXccfGEdtgiUbwH6hKUJuLI0pujSAn7IBV7Nys6gFurv0RMYbOClvGmL4I8hWVPURVgjCzGmAJG8GBN4Gk0pQ/FQJY9909jGdovYqiz5N6y2c1hb1fpaIPM2OaAGPbD2abi91cBEVXCldk1E6xk65CpURHuAovEo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lzu.edu.cn; spf=pass smtp.mailfrom=lzu.edu.cn; arc=none smtp.client-ip=13.75.44.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lzu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lzu.edu.cn
Received: from enjou-Legion-Y7000P-2019 (unknown [172.23.56.36])
	by app3 (Coremail) with SMTP id ywmowACXqfwMIT5qX4QxAA--.45653S3;
	Fri, 26 Jun 2026 14:49:51 +0800 (CST)
From: Ren Wei <n05ec@lzu.edu.cn>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	alin.nastac@gmail.com,
	yuantan098@gmail.com,
	yifanwucs@gmail.com,
	tomapufckgml@gmail.com,
	bird@lzu.edu.cn,
	chzhengyang2023@lzu.edu.cn,
	n05ec@lzu.edu.cn
Subject: [PATCH nf 1/1] netfilter: nf_conntrack_sip: guard against missing skb dst
Date: Fri, 26 Jun 2026 14:49:37 +0800
Message-ID: <47e6e0bdba06326388cd7778403326ff78faf8f0.1782349677.git.chzhengyang2023@lzu.edu.cn>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1782349677.git.chzhengyang2023@lzu.edu.cn>
References: <cover.1782349677.git.chzhengyang2023@lzu.edu.cn>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:ywmowACXqfwMIT5qX4QxAA--.45653S3
X-Coremail-Antispam: 1UD129KBjvJXoW7uw4DAr1kGr13WrWDXFWxtFb_yoW8uFy5pF
	97Kws3JrZ7JF1Yy3WkW3y8ZF15Zrs3G34fGryrua45A3Z8tryfGayrKFy7ZFs5JFWkGay7
	Ar4jvryqkan8CrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBY1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AE
	w4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2
	IY67AKxVW5JVW7JwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8Jr0_Cr1UM28EF7xvwVC2
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
X-CM-SenderInfo: zqqvvuo6o23hxhgxhubq/1tbiAQEKCWo85NQPKAAAsC

From: Zhengyang Chen <chzhengyang2023@lzu.edu.cn>

set_expected_rtp_rtcp() dereferences skb_dst(skb)->dev when
sip_external_media is enabled. The SIP helper can run from tc ingress
before routing has attached a dst to the skb, so skb_dst(skb) can be
NULL and the helper crashes while parsing SDP media expectations.

Handle a missing skb dst by skipping the same-interface external-media
optimization. Still release the routed media dst when one was obtained,
and keep the existing expectation setup path unchanged.

Fixes: a3419ce3356c ("netfilter: nf_conntrack_sip: add sip_external_media logic")
Cc: stable@vger.kernel.org
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Assisted-by: Codex:gpt-5.4
Signed-off-by: Zhengyang Chen <chzhengyang2023@lzu.edu.cn>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>

---
 net/netfilter/nf_conntrack_sip.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index 5ec3a4a4bbd7..302dc60c5381 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -956,7 +956,8 @@ static int set_expected_rtp_rtcp(struct sk_buff *skb, unsigned int protoff,
 			return NF_ACCEPT;
 		saddr = &ct->tuplehash[!dir].tuple.src.u3;
 	} else if (sip_external_media) {
-		struct net_device *dev = skb_dst(skb)->dev;
+		struct dst_entry *skbdst = skb_dst(skb);
+		struct net_device *dev = skbdst ? skbdst->dev : NULL;
 		struct dst_entry *dst = NULL;
 		struct flowi fl;
 
@@ -977,12 +978,14 @@ static int set_expected_rtp_rtcp(struct sk_buff *skb, unsigned int protoff,
 		/* Don't predict any conntracks when media endpoint is reachable
 		 * through the same interface as the signalling peer.
 		 */
-		if (dst) {
+		if (dst && dev) {
 			bool external_media = (dst->dev == dev);
 
 			dst_release(dst);
 			if (external_media)
 				return NF_ACCEPT;
+		} else if (dst) {
+			dst_release(dst);
 		}
 	}
 
-- 
2.43.0

