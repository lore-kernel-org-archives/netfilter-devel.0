Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FB11261B7F;
	Wed,  8 Oct 2025 12:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759928399; cv=none; b=MpTx9CYFaSyeHhBVCOQyD1/2wIuh4jglOkcI0GdpXlaXXKpBnsUWJKBn2bzRQXKdwsngy/nR7P5ll1iADhwcp9X4x5+VfsJz24fUESVNtQJpf9FvSo5nTvvnC3hE/RnSz7NcPkM6FKLi/0W1WTjJcqWBP7wg7rtl3vc5LmO+vBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759928399; c=relaxed/simple;
	bh=C4lgwcqZvFmWpLXPL2A9sSUfHfPj1Vpmt9tftfkELto=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q2FsfWQFv0rdFEZdSYZEKPn501BV+2+RaXAoorXQKhEkW1Y8lVdUtOcF5I4/0sCnh5kekYx3Xk05aFGNysu3VbEFq5/m9v8hPqrFeE8zDIMCg1ykHw5025OjBW2orcJffgBf9w3m0YtgReY4tAgPEd0rZTmYnHMMkPBWsr7zQbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id D6A8B607C2; Wed,  8 Oct 2025 14:59:55 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net 2/4] bridge: br_vlan_fill_forward_path_pvid: use br_vlan_group_rcu()
Date: Wed,  8 Oct 2025 14:59:40 +0200
Message-ID: <20251008125942.25056-3-fw@strlen.de>
X-Mailer: git-send-email 2.49.1
In-Reply-To: <20251008125942.25056-1-fw@strlen.de>
References: <20251008125942.25056-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Woudstra <ericwouds@gmail.com>

net/bridge/br_private.h:1627 suspicious rcu_dereference_protected() usage!
other info that might help us debug this:

rcu_scheduler_active = 2, debug_locks = 1
7 locks held by socat/410:
 #0: ffff88800d7a9c90 (sk_lock-AF_INET){+.+.}-{0:0}, at: inet_stream_connect+0x43/0xa0
 #1: ffffffff9a779900 (rcu_read_lock){....}-{1:3}, at: __ip_queue_xmit+0x62/0x1830
 [..]
 #6: ffffffff9a779900 (rcu_read_lock){....}-{1:3}, at: nf_hook.constprop.0+0x8a/0x440

Call Trace:
 lockdep_rcu_suspicious.cold+0x4f/0xb1
 br_vlan_fill_forward_path_pvid+0x32c/0x410 [bridge]
 br_fill_forward_path+0x7a/0x4d0 [bridge]

Use to correct helper, non _rcu variant requires RTNL mutex.

Fixes: bcf2766b1377 ("net: bridge: resolve forwarding path for VLAN tag actions in bridge devices")
Signed-off-by: Eric Woudstra <ericwouds@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/bridge/br_vlan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
index ae911220cb3c..ce72b837ff8e 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -1457,7 +1457,7 @@ void br_vlan_fill_forward_path_pvid(struct net_bridge *br,
 	if (!br_opt_get(br, BROPT_VLAN_ENABLED))
 		return;
 
-	vg = br_vlan_group(br);
+	vg = br_vlan_group_rcu(br);
 
 	if (idx >= 0 &&
 	    ctx->vlan[idx].proto == br->vlan_proto) {
-- 
2.49.1

