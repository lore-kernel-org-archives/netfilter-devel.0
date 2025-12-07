Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BA222248BE;
	Sun,  7 Dec 2025 01:10:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765069806; cv=none; b=jx0FN3zXqjqbtVA/R2Q4tNXJT0Y+aznBJiD9PLw3vRxZacOeK9Zkl4Gnj6uFcOQIRGJW2sJ2z/gMdlHsQ4cO1iqQ7izIpbByyHkhdF7au9P6u/JGVK5uYwziKWvzUQ5y4wgpCKPU5JBO/5ptZ+z2zkO0rnudswReXXo0seE8UkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765069806; c=relaxed/simple;
	bh=11M5eBT/VPa9NHfWK0RvP/UC6pemO4CgvIoZi6pLj58=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f+Ig4xJG9lJvafO1S6mplK1mToNLZZuiV7RLplhjXactfMdapAztjzyoON0WmhEq56i+UGFiIIv7nEafJEFqSrPUPJPA6Cs1SjDo3bwiVeL31BxYcQiIihsZVXbA6+7Qskua8RtAphzjD8InqhqQ+Bms1P+ulT+l/TRpQ5JgJ5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ekWmmTF0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ekWmmTF0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BE46C4CEF5;
	Sun,  7 Dec 2025 01:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765069804;
	bh=11M5eBT/VPa9NHfWK0RvP/UC6pemO4CgvIoZi6pLj58=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ekWmmTF0bGRO5ZwGbtWek1zT9tWFHUNbd0GLsP0UxVOSPS7p1WCDkCNU2UjHINtUP
	 /zkx8IKC9yZZP15ZBoGjekE8VuZElWk0nfI95ibUh35J5LV683U2/nfbdPamdvb8Mq
	 H22CXnCRay++YG05Tyo8X/i7eIoGeH9rQgKv0JUglQKm2VFiypoJhecevZYEb9IPQK
	 iugix8n+SxoE6rjDy8crwDNw/VIKQGEfaHZ5Jm5DAXZX11qnDCqmCUHVQqnCqFStEP
	 VWDKp9+f8sJ/NuIpIyGeAK1PiMWHkNhC6z85m5TDgrWJLeR/ODh0rlEYU+mt4Hs0yG
	 Pf/w2UsuRJobQ==
From: Jakub Kicinski <kuba@kernel.org>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org,
	edumazet@google.com,
	pabeni@redhat.com,
	andrew+netdev@lunn.ch,
	horms@kernel.org,
	pablo@netfilter.org,
	fw@strlen.de,
	netfilter-devel@vger.kernel.org,
	willemdebruijn.kernel@gmail.com,
	kuniyu@google.com,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net 4/4] netfilter: conntrack: warn when cleanup is stuck
Date: Sat,  6 Dec 2025 17:09:42 -0800
Message-ID: <20251207010942.1672972-5-kuba@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251207010942.1672972-1-kuba@kernel.org>
References: <20251207010942.1672972-1-kuba@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

nf_conntrack_cleanup_net_list() calls schedule() so it does not
show up as a hung task. Add an explicit check to make debugging
leaked skbs/conntack references more obvious.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/netfilter/nf_conntrack_core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 0b95f226f211..d1f8eb725d42 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -2487,6 +2487,7 @@ void nf_conntrack_cleanup_net(struct net *net)
 void nf_conntrack_cleanup_net_list(struct list_head *net_exit_list)
 {
 	struct nf_ct_iter_data iter_data = {};
+	unsigned long start = jiffies;
 	struct net *net;
 	int busy;
 
@@ -2507,6 +2508,8 @@ void nf_conntrack_cleanup_net_list(struct list_head *net_exit_list)
 			busy = 1;
 	}
 	if (busy) {
+		DEBUG_NET_WARN_ONCE(time_after(jiffies, start + 60 * HZ),
+				    "conntrack cleanup blocked for 60s");
 		schedule();
 		goto i_see_dead_people;
 	}
-- 
2.52.0

