Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 243DD13F432;
	Tue, 28 May 2024 22:55:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716936932; cv=none; b=gc2pxKhHbUiAzY5axmdvkq+djurY/uExX2jYro2kkNoWYsazpvuls53VDsAjREczNn4ZGalsOrofRAxdswZ/WZ2rdqWznGgUHevA6TyzUpNG/OHSeDP8HFw2wyNYPx2cgV/DSRYW280mktvUJjLT126yQ0Ij7mgM8eavf+xRg2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716936932; c=relaxed/simple;
	bh=TwFcmxRUKIIhZ96ExJZMQ8NkOjqunIl7YEgkcO9oJMY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=vBYBvVbjUh4UtUatjgMxHIoo2N4xlcoK8co2Z3BfdBP5Eme8qXf7kkxrT/BwMQZ5XG9jJDPKmB0ZBFODkDiBUT2gbP3qrV/D51SVBRxrOS0BQ2KHh99shaByBI9oAvWbBnOcb0uJm9bxcBVgavSD/2jugAIJNBMoX0odaEbzYow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	kadlec@netfilter.org
Subject: [PATCH net 5/6] netfilter: tproxy: bail out if IP has been disabled on the device
Date: Wed, 29 May 2024 00:55:18 +0200
Message-Id: <20240528225519.1155786-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240528225519.1155786-1-pablo@netfilter.org>
References: <20240528225519.1155786-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

syzbot reports:
general protection fault, probably for non-canonical address 0xdffffc0000000003: 0000 [#1] PREEMPT SMP KASAN PTI
KASAN: null-ptr-deref in range [0x0000000000000018-0x000000000000001f]
[..]
RIP: 0010:nf_tproxy_laddr4+0xb7/0x340 net/ipv4/netfilter/nf_tproxy_ipv4.c:62
Call Trace:
 nft_tproxy_eval_v4 net/netfilter/nft_tproxy.c:56 [inline]
 nft_tproxy_eval+0xa9a/0x1a00 net/netfilter/nft_tproxy.c:168

__in_dev_get_rcu() can return NULL, so check for this.

Reported-and-tested-by: syzbot+b94a6818504ea90d7661@syzkaller.appspotmail.com
Fixes: cc6eb4338569 ("tproxy: use the interface primary IP address as a default value for --on-ip")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv4/netfilter/nf_tproxy_ipv4.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ipv4/netfilter/nf_tproxy_ipv4.c b/net/ipv4/netfilter/nf_tproxy_ipv4.c
index 69e331799604..73e66a088e25 100644
--- a/net/ipv4/netfilter/nf_tproxy_ipv4.c
+++ b/net/ipv4/netfilter/nf_tproxy_ipv4.c
@@ -58,6 +58,8 @@ __be32 nf_tproxy_laddr4(struct sk_buff *skb, __be32 user_laddr, __be32 daddr)
 
 	laddr = 0;
 	indev = __in_dev_get_rcu(skb->dev);
+	if (!indev)
+		return daddr;
 
 	in_dev_for_each_ifa_rcu(ifa, indev) {
 		if (ifa->ifa_flags & IFA_F_SECONDARY)
-- 
2.30.2

