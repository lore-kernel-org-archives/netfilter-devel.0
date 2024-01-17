Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1F6822338;
	Wed, 17 Jan 2024 16:00:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705507251; cv=none; b=bv4zXFc0tYJM8grVvO8boPk9c3Hx12WOxcFe0oX3mqFiwV58wfvn2VqQ1wvCxxtqkRfmirj+FyA8lseLC3+oePWYpSCSksY29UZtlMjXpLm3dzdqOk8FZu9De3V8Yb6FPjPn8m/e2/U0WgrNwU97FV5WgayfA3W5W7iDnObUaAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705507251; c=relaxed/simple;
	bh=2I1vQzHJQUXyyPMZKx1yia1lgZBpH20Y4zLo/dOpCqc=;
	h=From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding; b=cvscnO3IEr9F5A0AH7i4PQzHsxl4xjO9+wLAbQBj4B68MnNB9CM4EggPMZhe6Bw9RGf2ZbxEQvO9lAXZtkuN0Fk0KkfvmOvCmRTL8s0upHczZhMG4bMe3NthbT+8lQuTryW/Gn3xBC7dCapi9iscoYcghwt/3lUSZ8Wqj3LeASE=
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
	fw@strlen.de
Subject: [PATCH net 05/14] netfilter: nfnetlink_log: use proper helper for fetching physinif
Date: Wed, 17 Jan 2024 17:00:21 +0100
Message-Id: <20240117160030.140264-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20240117160030.140264-1-pablo@netfilter.org>
References: <20240117160030.140264-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>

We don't use physindev in __build_packet_message except for getting
physinif from it. So let's switch to nf_bridge_get_physinif to get what
we want directly.

Signed-off-by: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nfnetlink_log.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index f03f4d4d7d88..134e05d31061 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -508,7 +508,7 @@ __build_packet_message(struct nfnl_log_net *log,
 					 htonl(br_port_get_rcu(indev)->br->dev->ifindex)))
 				goto nla_put_failure;
 		} else {
-			struct net_device *physindev;
+			int physinif;
 
 			/* Case 2: indev is bridge group, we need to look for
 			 * physical device (when called from ipv4) */
@@ -516,10 +516,10 @@ __build_packet_message(struct nfnl_log_net *log,
 					 htonl(indev->ifindex)))
 				goto nla_put_failure;
 
-			physindev = nf_bridge_get_physindev(skb);
-			if (physindev &&
+			physinif = nf_bridge_get_physinif(skb);
+			if (physinif &&
 			    nla_put_be32(inst->skb, NFULA_IFINDEX_PHYSINDEV,
-					 htonl(physindev->ifindex)))
+					 htonl(physinif)))
 				goto nla_put_failure;
 		}
 #endif
-- 
2.30.2

