Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 424FE13DBBE
	for <netfilter-devel@vger.kernel.org>; Thu, 12 Sep 2024 18:58:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726167522; cv=none; b=qxLoY9iRONzmt3ac9fb88XUbEIS5SIl/0dNMmQuTccDot9eEvQqkS+UMd+uHENySsp/iaYfkJn8S5c2kKVmmkpeBDN6Nqaa59dTwI2xHnKwINI5lG696UliASV9ICV9G81xYAhbW1cSlmrQKKo2rhDl0KKJCdmfMispm9wzDeP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726167522; c=relaxed/simple;
	bh=3ZWGBJOFyDh4D0xDdx2xoutyvf/jgQJRBzJRUgsVFgg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=THoiHEaAgzE+tLGEJofpJrQgrWAhU/KcOenD0WxgERzhlcHo1vMzYNmhpoDBfR1a5dm23dBjj2S/zbyR0iFlLKOe9A9v/UoB6xh9HRS6MOPtMqyhJSARgcbh5RKeIHB0n03ZyG8svyWvm8nvrk+hu62mZsMNeFMGQ9eU0tuQHk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: antonio.ojea.garcia@gmail.com
Subject: [PATCH nf] netfilter: nfnetlink_queue: reroute reinjected packets from postrouting
Date: Thu, 12 Sep 2024 20:58:32 +0200
Message-Id: <20240912185832.11962-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

368982cd7d1b ("netfilter: nfnetlink_queue: resolve clash for unconfirmed
conntracks") adjusts NAT again in case that packet loses race to confirm
the conntrack entry.

The reinject path triggers a route lookup again for the output hook, but
not for the postrouting hook where queue to userspace is also possible.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: Antonio Ojea <antonio.ojea.garcia@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
I tried but I am not managing to make a selftest that runs reliable.
I can reproduce it manually and validate that this works.

./nft_queue -d 1000 helps by introducing a delay of 1000ms in the
userspace queue processing which helps trigger the race more easily,
socat needs to send several packets in the same UDP flow.

@Antonio: Could you try this patch meanwhile there is a testcase for
this.

 net/netfilter/nfnetlink_queue.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index e0716da256bf..aeb354271e85 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -276,7 +276,8 @@ static int nf_ip_reroute(struct sk_buff *skb, const struct nf_queue_entry *entry
 #ifdef CONFIG_INET
 	const struct ip_rt_info *rt_info = nf_queue_entry_reroute(entry);
 
-	if (entry->state.hook == NF_INET_LOCAL_OUT) {
+	if (entry->state.hook == NF_INET_LOCAL_OUT ||
+	    entry->state.hook == NF_INET_POST_ROUTING) {
 		const struct iphdr *iph = ip_hdr(skb);
 
 		if (!(iph->tos == rt_info->tos &&
-- 
2.30.2

