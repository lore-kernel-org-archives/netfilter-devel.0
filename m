Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19F07358373;
	Fri, 19 Jun 2026 11:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781870112; cv=none; b=bd/4QguDt4IeT+ToEq7cgqLKs7TWtxeUAEpA/1N5sE79RCt9jG8HGSr1kOB02J3DBBuNP9SIf6G101G91IofAHShfabeLbapftezh4ZeJN1nEv46RmR/XMyKTAiAIvOeVhKiMf/otXzG1IvyT1opt/qv+tOIfTkyeqOMZzsXGKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781870112; c=relaxed/simple;
	bh=xOTCz2eEKk1cNmAJIH8oJTHtpOcF4/qvEfuRtiRngUI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r2ltrr5DdvTpdlLAOPQuyk3OAW1Mnq4/NncUrr0LhRV9u/TjrAfG/VoHWEZqJ9hbrE8jpNh6cu3htCeUFkt8JK1VI51dr1xhpsglvlc1fNA8whOap4v0DmO8NAD0W/dKAZA+ANBw8gqVIOOOEzDTTqeUTxVGCvpWoOCFHYh7Sb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=g/WzD1k9; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="g/WzD1k9"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 65923601C0;
	Fri, 19 Jun 2026 13:55:08 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1781870108;
	bh=6TS7DFy4fIY13Z9GYaoKRN4Y7nMyxSg/ESPd3aHpwMM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g/WzD1k9DGvZc+CMs/RV5SParMzn8nTBDm5NSGSste4HxF7vrEiAIV+ancgdjMrX8
	 4RLlcl/M5HlXSTZs5HQSvhmv8Dcdo4l0AG2YD3Oce7z+F5Ge3Cu4W11e9l03lxveas
	 NyrMUv2NWr8vsaEqX+m82NQhKAtMgZq5cp1KO5PXC8HdPYU736fmTZJZfZWMYjYgYL
	 FcSVip1O7hgDiHxGIIWMgfUadyFBbn0+MCjY5OD8iazvH1F47qFlN/F0pF75TeVvl7
	 4mH8wL/1OKWtHh7mSie2DZO4QR0tdDvAIiGiyNOdFeJv1TbjfN9MrjgQW6Dq1OFZaU
	 JBzpK7m8OVGiw==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 08/16] netfilter: ipset: fix order of kfree_rcu() and rcu_assign_pointer()
Date: Fri, 19 Jun 2026 13:54:43 +0200
Message-ID: <20260619115452.93949-9-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260619115452.93949-1-pablo@netfilter.org>
References: <20260619115452.93949-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jozsef Kadlecsik <kadlec@netfilter.org>

Sashiko pointed out that kfree_rcu() was called before
rcu_assign_pointer() in handling the comment extension.
Fix the order so that rcu_assign_pointer() called first.

Fixes: b57b2d1fa53f ("netfilter: ipset: Prepare the ipset core to use RCU at set level")
Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/ipset/ip_set_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index 3706b4a85a0f..a531b654b8d9 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -351,8 +351,8 @@ ip_set_init_comment(struct ip_set *set, struct ip_set_comment *comment,
 
 	if (unlikely(c)) {
 		set->ext_size -= sizeof(*c) + strlen(c->str) + 1;
-		kfree_rcu(c, rcu);
 		rcu_assign_pointer(comment->c, NULL);
+		kfree_rcu(c, rcu);
 	}
 	if (!len)
 		return;
@@ -393,8 +393,8 @@ ip_set_comment_free(struct ip_set *set, void *ptr)
 	if (unlikely(!c))
 		return;
 	set->ext_size -= sizeof(*c) + strlen(c->str) + 1;
-	kfree_rcu(c, rcu);
 	rcu_assign_pointer(comment->c, NULL);
+	kfree_rcu(c, rcu);
 }
 
 typedef void (*destroyer)(struct ip_set *, void *);
-- 
2.47.3

