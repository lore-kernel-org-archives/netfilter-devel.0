Received: from zg8tmtyylji0my4xnjeumjiw.icoremail.net (zg8tmtyylji0my4xnjeumjiw.icoremail.net [162.243.161.220])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6BF92480DF1
	for <netfilter-devel@vger.kernel.org>; Tue, 12 May 2026 07:57:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.243.161.220
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778572678; cv=none; b=fg4mhmoZhPxFbAKnnt5sLZw7Jbk59vDFwjrXZXr/RcVOoKzhoKWfzgvr5FpiMAYbhmsmo92u4y4Ulf2dLDrSNn+PXOKIEm8d5fpOZmfZrpEFLEJtvVAOoAmq/QKv2I2UYZc3NPdxHor6/XI2OFcRL5XSTesnQFmrqz2zJMscauw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778572678; c=relaxed/simple;
	bh=HvmN02b802VJXaimLgaUUoZAvNwc0rlykza/mErcCqY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MQLJlFsP5v4qQ2I6NqudSS9IKxNx0IS82DZhXyU/VCcQ68Fpj4tL/vi1C0U6ZIXevLqUuBtZhe9TDwHphWE/gWsq9y7QbHJSJd+4XjconNJTxNlpbWyIeY74lQpDMG7omoEef70bNJmKHQiUBYZsiEtR51KsKgccnogxWl31HSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lzu.edu.cn; spf=pass smtp.mailfrom=lzu.edu.cn; arc=none smtp.client-ip=162.243.161.220
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lzu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lzu.edu.cn
Received: from enjou-Legion-Y7000P-2019.coin-barley.ts.net (unknown [172.23.56.36])
	by app1 (Coremail) with SMTP id ygmowACXusRq3QJqzDwAAA--.447S3;
	Tue, 12 May 2026 15:57:35 +0800 (CST)
From: Ren Wei <n05ec@lzu.edu.cn>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	stephane.ml.bryant@gmail.com,
	yuantan098@gmail.com,
	yifanwucs@gmail.com,
	tomapufckgml@gmail.com,
	bird@lzu.edu.cn,
	royenheart@gmail.com,
	n05ec@lzu.edu.cn
Subject: [PATCH nf 1/1] netfilter: nf_queue: hold bridge skb->dev while queued
Date: Tue, 12 May 2026 15:57:25 +0800
Message-ID: <ca7ee343bbcb44905e1f5b853df2f3a5b7d40548.1778493188.git.royenheart@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1778493188.git.royenheart@gmail.com>
References: <cover.1778493188.git.royenheart@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:ygmowACXusRq3QJqzDwAAA--.447S3
X-Coremail-Antispam: 1UD129KBjvJXoWxCF1ftw17ZrWkWFyUXr4xJFb_yoW5trWxpF
	W5ta4xJ34xtF4UK3ykAr4xZr13urs5Wr9xua4akr95Ar9xXF1UZa1kKFZ0vay8Ars0kF43
	JFs09r4FqFn8ZF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUB21xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AE
	w4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2
	IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVWxJVW8Jr1l84ACjcxK6I8E
	87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AKxVWxJr0_GcWle2I262IYc4
	CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_
	Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x
	0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc7Cj
	xVAaw2AFwI0_Jw0_GFylc2xSY4AK6svPMxAIw28IcxkI7VAKI48JMxAIw28IcVCjz48v1s
	IEY20_Gr4l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s02
	6x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0x
	vE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE
	42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6x
	kF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUonmRUUUUU
X-CM-SenderInfo: zqqvvuo6o23hxhgxhubq/1tbiAQEFCWoCxO4DHQAAsQ

From: Haoze Xie <royenheart@gmail.com>

br_pass_frame_up() rewrites skb->dev from the ingress port to the bridge
master before queueing bridge LOCAL_IN packets. NFQUEUE only holds
references on state.in/out and bridge physdevs, so a queued bridge
packet can retain a freed bridge master in skb->dev until reinjection.

When the verdict is reinjected later, br_netif_receive_skb() re-enters
the receive path with skb->dev still pointing at the freed bridge master,
triggering a use-after-free.

Store skb->dev in the queue entry for bridge builds, hold a reference on
it for the queue lifetime, and use the saved device when dropping queued
packets during NETDEV_DOWN handling.

Fixes: ac2863445686 ("netfilter: bridge: add nf_afinfo to enable queuing to userspace")
Cc: stable@kernel.org
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Tested-by: Haoze Xie <royenheart@gmail.com>
Signed-off-by: Haoze Xie <royenheart@gmail.com>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
---
 include/net/netfilter/nf_queue.h | 1 +
 net/netfilter/nf_queue.c         | 5 +++++
 net/netfilter/nfnetlink_queue.c  | 3 +++
 3 files changed, 9 insertions(+)

diff --git a/include/net/netfilter/nf_queue.h b/include/net/netfilter/nf_queue.h
index d17035d14d96..1e7eb8e85932 100644
--- a/include/net/netfilter/nf_queue.h
+++ b/include/net/netfilter/nf_queue.h
@@ -17,6 +17,7 @@ struct nf_queue_entry {
 	unsigned int		id;
 	unsigned int		hook_index;	/* index in hook_entries->hook[] */
 #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
+	struct net_device	*skb_dev;
 	struct net_device	*physin;
 	struct net_device	*physout;
 #endif
diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
index a6c81c04b3a5..08da3f4700da 100644
--- a/net/netfilter/nf_queue.c
+++ b/net/netfilter/nf_queue.c
@@ -67,6 +67,7 @@ static void nf_queue_entry_release_refs(struct nf_queue_entry *entry)
 		nf_queue_sock_put(state->sk);
 
 #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
+	dev_put(entry->skb_dev);
 	dev_put(entry->physin);
 	dev_put(entry->physout);
 #endif
@@ -106,6 +107,7 @@ bool nf_queue_entry_get_refs(struct nf_queue_entry *entry)
 	dev_hold(state->out);
 
 #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
+	dev_hold(entry->skb_dev);
 	dev_hold(entry->physin);
 	dev_hold(entry->physout);
 #endif
@@ -207,6 +209,9 @@ static int __nf_queue(struct sk_buff *skb, const struct nf_hook_state *state,
 		.size	= sizeof(*entry) + route_key_size,
 	};
 
+#if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
+	entry->skb_dev = skb->dev;
+#endif
 	__nf_queue_entry_init_physdevs(entry);
 
 	if (!nf_queue_entry_get_refs(entry)) {
diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 58304fd1f70f..b64a59bb4ba7 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -1206,6 +1206,9 @@ dev_cmp(struct nf_queue_entry *entry, unsigned long ifindex)
 #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
 	int physinif, physoutif;
 
+	if (entry->skb_dev && entry->skb_dev->ifindex == ifindex)
+		return 1;
+
 	physinif = nf_bridge_get_physinif(entry->skb);
 	physoutif = nf_bridge_get_physoutif(entry->skb);
 
-- 
2.53.0

