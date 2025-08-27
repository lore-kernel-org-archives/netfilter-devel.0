Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1D2F356905;
	Wed, 27 Aug 2025 13:39:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756301954; cv=none; b=ibeeqvLB34IyvO41dHrQmVOTxaxX5BAFTFTXF1Lw2THFDkJxpwMVtALeNI1mDO4nOVCO0/7Rvfipiap45P3uquEL+ezhZndKI9DxPg6yEjh22LL+QB15EmF70p7FmexPLHxG6CnwTfmkWm+YcJXgTpzgpLdXTR+Cv2oJUuoIrCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756301954; c=relaxed/simple;
	bh=R9/RwdVAna50jhUlMWWMmt/Kb3eBKHoyP0ezR5iab+4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mYHm7Ru1hrGTC6ShVcBYQmcG1vFb3F6AkjEo/uTnKDCjdAEW8qWzCQHQOkWtis0qTdZQBM18yzptAZtlxcYwPBJHU8jQw8DN2QOKbXQTVOFsCmm7wIOOs0oKQaMXJZBKNoWkVNnLv3jWLOZcX8Tk4ecHHXCW2MEUHtXO5ulBP0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 10E8060329; Wed, 27 Aug 2025 15:39:09 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org,
	Wang Liang <wangliang74@huawei.com>
Subject: [PATCH net 1/2] netfilter: br_netfilter: do not check confirmed bit in br_nf_local_in() after confirm
Date: Wed, 27 Aug 2025 15:38:59 +0200
Message-ID: <20250827133900.16552-2-fw@strlen.de>
X-Mailer: git-send-email 2.49.1
In-Reply-To: <20250827133900.16552-1-fw@strlen.de>
References: <20250827133900.16552-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Wang Liang <wangliang74@huawei.com>

When send a broadcast packet to a tap device, which was added to a bridge,
br_nf_local_in() is called to confirm the conntrack. If another conntrack
with the same hash value is added to the hash table, which can be
triggered by a normal packet to a non-bridge device, the below warning
may happen.

  ------------[ cut here ]------------
  WARNING: CPU: 1 PID: 96 at net/bridge/br_netfilter_hooks.c:632 br_nf_local_in+0x168/0x200
  CPU: 1 UID: 0 PID: 96 Comm: tap_send Not tainted 6.17.0-rc2-dirty #44 PREEMPT(voluntary)
  RIP: 0010:br_nf_local_in+0x168/0x200
  Call Trace:
   <TASK>
   nf_hook_slow+0x3e/0xf0
   br_pass_frame_up+0x103/0x180
   br_handle_frame_finish+0x2de/0x5b0
   br_nf_hook_thresh+0xc0/0x120
   br_nf_pre_routing_finish+0x168/0x3a0
   br_nf_pre_routing+0x237/0x5e0
   br_handle_frame+0x1ec/0x3c0
   __netif_receive_skb_core+0x225/0x1210
   __netif_receive_skb_one_core+0x37/0xa0
   netif_receive_skb+0x36/0x160
   tun_get_user+0xa54/0x10c0
   tun_chr_write_iter+0x65/0xb0
   vfs_write+0x305/0x410
   ksys_write+0x60/0xd0
   do_syscall_64+0xa4/0x260
   entry_SYSCALL_64_after_hwframe+0x77/0x7f
   </TASK>
  ---[ end trace 0000000000000000 ]---

To solve the hash conflict, nf_ct_resolve_clash() try to merge the
conntracks, and update skb->_nfct. However, br_nf_local_in() still use the
old ct from local variable 'nfct' after confirm(), which leads to this
warning.

If confirm() does not insert the conntrack entry and return NF_DROP, the
warning may also occur. There is no need to reserve the WARN_ON_ONCE, just
remove it.

Link: https://lore.kernel.org/netdev/20250820043329.2902014-1-wangliang74@huawei.com/
Fixes: 62e7151ae3eb ("netfilter: bridge: confirm multicast packets before passing them up the stack")
Suggested-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Wang Liang <wangliang74@huawei.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/bridge/br_netfilter_hooks.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/bridge/br_netfilter_hooks.c b/net/bridge/br_netfilter_hooks.c
index 94cbe967d1c1..083e2fe96441 100644
--- a/net/bridge/br_netfilter_hooks.c
+++ b/net/bridge/br_netfilter_hooks.c
@@ -626,9 +626,6 @@ static unsigned int br_nf_local_in(void *priv,
 		break;
 	}
 
-	ct = container_of(nfct, struct nf_conn, ct_general);
-	WARN_ON_ONCE(!nf_ct_is_confirmed(ct));
-
 	return ret;
 }
 #endif
-- 
2.49.1

