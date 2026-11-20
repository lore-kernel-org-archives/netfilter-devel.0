Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795134624;
	b=Cr1qJATx2fiksb7zy/RuoHw0XiHYPSJiQbeQ2e5X0ihiNpOi3JabLDzw0idHkHm9UyLf
	 yVbi8m2Ka3LhmaNJPCZzAwkeV5e0hn2HueAxxuaOTNcA+/UEMX+opNe/0eTfYi+lB3AY1
	 UsdVdjKllLuJcvn2sGwjFU9jUK5dTYGANiy9vcjWP3NhCBEj5tATW595pq/dy9esNA3L3
	 PlK0U9a6+DCRVRQZYTRcG7eVaSxr9Z7PZPY7ZETS7WX18Zb9ou3uIURTsYkiyUydswkDH
	 EIfbJ+pmHl7Uu7MV8z+K4DrawcAUrk2GyRDvRKSf+Il1GIU8nvqgT/BSniavZDjgmgw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795134624;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=dcJtOzCahS1n5v4vdyKF/AYuAt8N0bDuM9kuNElu8Sw=;
	b=r0pDEJPnAFdv9IUkL99QKFwHdn1gD3046dWUTYlZa0G6WAr7PKV+YIAuamsKbHh6oheg
	 1yZ8KTcmStwHbynWW6PoVD9lPDQPSX/yNUMSaYVJ+xXuNtnBIl4Outd72ymE7P2UTw4mW
	 j0wIFEamIHrM/+TIRkmZYMPdEEypjxFxk5gpbqApRVRtUeeJl478vcnidEzTl0hJRMNUH
	 GNyJCaOVd/RMrvavfKWC0Y4yW8JZ8jYsz4EDT27uPa1CkppzrdqZ8qyG1iY+omFujcK+K
	 kEZlSTGMiQ3TrvdwWeEt2r2DQOxjHJ6MXVN2VHmWKv5mSHMnz9ueRgyrxS89pAVEFIA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=dyIOvMH+;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00C2560A261C
	for <netfilter-devel@vger.kernel.org>; Fri, 20 Nov 2026 00:30:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 00C2560A261C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=dyIOvMH+
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1795134621;
	bh=dcJtOzCahS1n5v4vdyKF/AYuAt8N0bDuM9kuNElu8Sw=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=dyIOvMH+4V1PG1nwmgWrv/R6EEBXeib+DvrLUAth+TLcbgGDKSz49+hZYEBwuIJpb
	 QorM/Yf2IVN9bXHl/Z2SM30yl8ci3dAY2EtToXUGgtnkD61aLOUUt6A0kH+9TiELE9
	 6qzcH3tAwTf1avWlc+3YZ8C8LiULlHiS+S9TKf6mVRhMWMoSG9RGASKbSr4oHcCEgU
	 WJtwiWaeoNGaBzS8G6v+6LwJ5z4cXKgICSYbTNySjheLRqa4O0lN23c9CSdJPvGqXZ
	 aMax+q5VBTecIJVfWwsPNCMO0BAeIpwARFdSU+5anN4fCKnocKUmtmzFxcIW6EhroT
	 lxmJWL1yG1a/Q==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id B45A360088
	for <netfilter-devel@vger.kernel.org>; Fri, 20 Nov 2026 01:30:21 +0100 (CET)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf,v4 2/3] netfilter: nf_tables: flush destroy work from flowtable netdev event handler
Date: Fri, 20 Nov 2026 01:30:12 +0100
Message-ID: <20261120003013.3441877-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261120003013.3441877-1-pablo@netfilter.org>
References: <20261120003013.3441877-1-pablo@netfilter.org>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Sashiko reports that the following race is possible while dismantling
the flowtable with hardware offload:

CPU0                                  CPU1 (kworker)
nf_tables_commit()
  list_del_rcu(&flowtable->list)
  nft_unregister_flowtable_net_hooks()
nf_tables_commit_release()
  schedule_work(&destroy_work)
  mutex_unlock(&commit_mutex)
                                      nf_tables_trans_destroy_work()
                                        synchronize_rcu()
                                        ...
unregister_netdevice()
  nf_tables_flowtable_event()
    /* flowtable not in
     * table->flowtables, ops->dev
     * stays on flowtable->hook_list
     */
  free_netdev(dev)
                                        nf_tables_flowtable_destroy()
                                          nft_flowtable_hooks_destroy()
                                            ...
                                            flowtable->data.type->setup(
                                              ..., ops->dev,
                                              FLOW_BLOCK_UNBIND)
                                              <-- use-after-free

A netdevice event could happen in between the netns .pre_exit and .exit.
After .pre_exit, the flowtable has been removed from the table list,
therefore, it is not reachable by the flowtable netdevice handler so the
hook cannot be unregistered and a stale reference to the netdevice
remains in place, leading to possible UaF from the commit_release path
when accessing the netdevice.

Fix this by flushing the pending destroy work before handling netdevice
events.

This patch is a requirement for the follow up commit ("netfilter:
nf_tables: perform unbind callback on hook release").

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v4: new in this series

 net/netfilter/nf_tables_api.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index d3c04a71c924..24db948b851b 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -9902,6 +9902,8 @@ static int nf_tables_flowtable_event(struct notifier_block *this,
 	nft_net = nft_pernet(net);
 	mutex_lock(&nft_net->commit_mutex);
 
+	nf_tables_trans_destroy_flush_work(net);
+
 	if (event == NETDEV_CHANGENAME) {
 		if (__nf_tables_flowtable_event(NETDEV_REGISTER, dev, true)) {
 			ret = NOTIFY_BAD;
-- 
2.47.3

