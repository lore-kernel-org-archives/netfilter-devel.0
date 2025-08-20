Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9C9D1D5146;
	Wed, 20 Aug 2025 04:33:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755664390; cv=none; b=pJ/+Kukuoy9NYaoK9D2l0XVCOgxV9mP9WYVixfnCErlkvuJu3GincR5TaP42yhIzM08HCoQYphEOh4B5oGWbGZ8+VSz+AeO4wGB9qMDTe1EL2gUueQhoQlA7OPnGRZkFzPrJFCspl39CvhzzFCpaAhnCixKvSO1jkpdQuV238JM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755664390; c=relaxed/simple;
	bh=+sZR4pVtM4D1/iCNqe2AY2fiLorrX6QjbH8YFnC4x6M=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=u1Vt6Up7/iS7ConEURuAo0tur+j/vNeB/YkpZQnD8nEBL2r9o1dxB3TkPEOLg82Ef09b8Mf9S6TAJz/rDgCw1Ihz4B2mobZXAPHsv3SDcWpw+J5ZfrpBaiKBoPDAHCgc9g0ffYyP9PaomMtQD1v5R9v1OiavGZSJ5081UCxkLnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4c6D7N27WvztT3D;
	Wed, 20 Aug 2025 12:32:00 +0800 (CST)
Received: from dggpemf500016.china.huawei.com (unknown [7.185.36.197])
	by mail.maildlp.com (Postfix) with ESMTPS id 463181402C4;
	Wed, 20 Aug 2025 12:32:59 +0800 (CST)
Received: from huawei.com (10.175.104.170) by dggpemf500016.china.huawei.com
 (7.185.36.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 20 Aug
 2025 12:32:57 +0800
From: Wang Liang <wangliang74@huawei.com>
To: <pablo@netfilter.org>, <kadlec@netfilter.org>, <fw@strlen.de>,
	<razor@blackwall.org>, <idosch@nvidia.com>, <davem@davemloft.net>,
	<edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
	<horms@kernel.org>
CC: <yuehaibing@huawei.com>, <zhangchangzhong@huawei.com>,
	<wangliang74@huawei.com>, <netfilter-devel@vger.kernel.org>,
	<coreteam@netfilter.org>, <bridge@lists.linux.dev>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: [PATCH net] netfilter: br_netfilter: reread nf_conn from skb after confirm()
Date: Wed, 20 Aug 2025 12:33:29 +0800
Message-ID: <20250820043329.2902014-1-wangliang74@huawei.com>
X-Mailer: git-send-email 2.33.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 dggpemf500016.china.huawei.com (7.185.36.197)

Previous commit 2d72afb34065 ("netfilter: nf_conntrack: fix crash due to
removal of uninitialised entry") move the IPS_CONFIRMED assignment after
the hash table insertion.

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
issue. Fix it by rereading nfct from skb.

Fixes: 62e7151ae3eb ("netfilter: bridge: confirm multicast packets before passing them up the stack")
Signed-off-by: Wang Liang <wangliang74@huawei.com>
---
 net/bridge/br_netfilter_hooks.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/bridge/br_netfilter_hooks.c b/net/bridge/br_netfilter_hooks.c
index 94cbe967d1c1..55b1b7dcb609 100644
--- a/net/bridge/br_netfilter_hooks.c
+++ b/net/bridge/br_netfilter_hooks.c
@@ -626,6 +626,7 @@ static unsigned int br_nf_local_in(void *priv,
 		break;
 	}
 
+	nfct = skb_nfct(skb);
 	ct = container_of(nfct, struct nf_conn, ct_general);
 	WARN_ON_ONCE(!nf_ct_is_confirmed(ct));
 
-- 
2.33.0

