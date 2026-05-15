Received: from zg8tmtyylji0my4xnjqumte4.icoremail.net (zg8tmtyylji0my4xnjqumte4.icoremail.net [162.243.164.118])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C6D5315D33
	for <netfilter-devel@vger.kernel.org>; Fri, 15 May 2026 03:19:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.243.164.118
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778815163; cv=none; b=ONNdf8J4XPm4BZkHwn0C//FJ6W3WYA8IZlvOZhCiVm+C3LkUFVaZDIyd3TVbsW5IQb64+K7mbLtQmpKAXdgG2aHLEPMDzysX1vraHdQcImA3V0M/aDAzZrn4Ck6N57fwXcasGVmrbvO1d3WTiTFi9tGu7j2egMpD/iBbczzhxfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778815163; c=relaxed/simple;
	bh=d4XfTUjX/r670lDs4l/LZ2T3YoQ6i9w1Z89skCjEU8I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nTAaYxp4ZWDNM5AugSUlxzOQRGwbf/FYYrukjCFXgPE1Cd5Os66fMw83rb9LJyxayu778IfmZ2XObwwrihvQVN3mZcN6RcGz+WYAJ/LvJEzrHeUL2O4qCgCg3gmdM8P6dIk81/FpI2hMTwUVVOWRsyNRMUMLgOwudH3qHuC0VCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lzu.edu.cn; spf=pass smtp.mailfrom=lzu.edu.cn; arc=none smtp.client-ip=162.243.164.118
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lzu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lzu.edu.cn
Received: from enjou-Legion-Y7000P-2019.coin-barley.ts.net (unknown [172.23.56.36])
	by app3 (Coremail) with SMTP id ywmowADHpvymkAZqXbYBAA--.2140S2;
	Fri, 15 May 2026 11:19:03 +0800 (CST)
From: Ren Wei <n05ec@lzu.edu.cn>
To: netfilter-devel@vger.kernel.org,
	pablo@netfilter.org
Cc: fw@strlen.de,
	phil@nwl.cc,
	stephane.ml.bryant@gmail.com,
	yuantan098@gmail.com,
	yifanwucs@gmail.com,
	tomapufckgml@gmail.com,
	bird@lzu.edu.cn,
	royenheart@gmail.com,
	n05ec@lzu.edu.cn
Subject: [PATCH nf v2 1/1] netfilter: nf_queue: hold bridge skb->dev while queued
Date: Fri, 15 May 2026 11:19:02 +0800
Message-ID: <2c773ffa2b7c6b6ba12c31188fb75a72d4854265.v2.1778493188.git.royenheart@gmail.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:ywmowADHpvymkAZqXbYBAA--.2140S2
X-Coremail-Antispam: 1UD129KBjvJXoWxCF1ftw17ZrWkWFyxAw13Jwb_yoWrJry3pF
	W5Ga4xJ34xtF1jk3ykZrWxZr13uws5GrsxCrySk3s5AFnxXF1UZF4rKFW5Zay8ArZ0kF47
	JF1qgrsYqan8ZFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUB01xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AE
	w4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2
	IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVWxJVW8Jr1l84ACjcxK6I8E
	87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE3s1le2I262IYc4CY6c
	8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_
	Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwI
	xGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc7CjxVAa
	w2AFwI0_Jw0_GFylc2xSY4AK6svPMxAIw28IcxkI7VAKI48JMxAIw28IcVCjz48v1sIEY2
	0_Gr4l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8G
	jcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2I
	x0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK
	8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I
	0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUonmRUUUUU
X-CM-SenderInfo: zqqvvuo6o23hxhgxhubq/1tbiAQwHCWoFZ+8GFAAHsx

From: Haoze Xie <royenheart@gmail.com>

br_pass_frame_up() rewrites skb->dev from the ingress port to the bridge
master before queueing bridge LOCAL_IN packets. NFQUEUE only holds
references on state.in/out and bridge physdevs, so a queued bridge
packet can retain a freed bridge master in skb->dev until reinjection.

When the verdict is reinjected later, br_netif_receive_skb() re-enters
the receive path with skb->dev still pointing at the freed bridge master,
triggering a use-after-free.

Store skb->dev in the queue entry, hold a reference on it for the queue
lifetime, and use the saved device when dropping queued packets during
NETDEV_DOWN handling.

Fixes: ac2863445686 ("netfilter: bridge: add nf_afinfo to enable queuing to userspace")
Cc: stable@kernel.org
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Signed-off-by: Haoze Xie <royenheart@gmail.com>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
---
v2:
- move skb->dev refcounting into the generic nf_queue lifetime handling
- keep the saved-device check in dev_cmp()
- v1 Link: https://lore.kernel.org/all/ca7ee343bbcb44905e1f5b853df2f3a5b7d40548.1778493188.git.royenheart@gmail.com
---
 include/net/netfilter/nf_queue.h | 1 +
 net/netfilter/nf_queue.c         | 4 +++-
 net/netfilter/nfnetlink_queue.c  | 2 ++
 3 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/include/net/netfilter/nf_queue.h b/include/net/netfilter/nf_queue.h
index d17035d14d96..3978c3174cdb 100644
--- a/include/net/netfilter/nf_queue.h
+++ b/include/net/netfilter/nf_queue.h
@@ -14,6 +14,7 @@ struct nf_queue_entry {
 	struct list_head	list;
 	struct rhash_head	hash_node;
 	struct sk_buff		*skb;
+	struct net_device	*skb_dev;
 	unsigned int		id;
 	unsigned int		hook_index;	/* index in hook_entries->hook[] */
 #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
index a6c81c04b3a5..57b450024a99 100644
--- a/net/netfilter/nf_queue.c
+++ b/net/netfilter/nf_queue.c
@@ -61,6 +61,7 @@ static void nf_queue_entry_release_refs(struct nf_queue_entry *entry)
 	struct nf_hook_state *state = &entry->state;
 
 	/* Release those devices we held, or Alexey will kill me. */
+	dev_put(entry->skb_dev);
 	dev_put(state->in);
 	dev_put(state->out);
 	if (state->sk)
@@ -102,6 +103,7 @@ bool nf_queue_entry_get_refs(struct nf_queue_entry *entry)
 	if (state->sk && !refcount_inc_not_zero(&state->sk->sk_refcnt))
 		return false;
 
+	dev_hold(entry->skb_dev);
 	dev_hold(state->in);
 	dev_hold(state->out);
 
@@ -202,11 +204,11 @@ static int __nf_queue(struct sk_buff *skb, const struct nf_hook_state *state,
 
 	*entry = (struct nf_queue_entry) {
 		.skb	= skb,
+		.skb_dev = skb->dev,
 		.state	= *state,
 		.hook_index = index,
 		.size	= sizeof(*entry) + route_key_size,
 	};
-
 	__nf_queue_entry_init_physdevs(entry);
 
 	if (!nf_queue_entry_get_refs(entry)) {
diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 58304fd1f70f..984a0eb9e149 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -1212,6 +1212,8 @@ dev_cmp(struct nf_queue_entry *entry, unsigned long ifindex)
 	if (physinif == ifindex || physoutif == ifindex)
 		return 1;
 #endif
+	if (entry->skb_dev && entry->skb_dev->ifindex == ifindex)
+		return 1;
 	if (entry->state.in)
 		if (entry->state.in->ifindex == ifindex)
 			return 1;
 
-- 
2.53.0

