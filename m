Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C5412D374A;
	Mon, 13 Oct 2025 18:51:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760381467; cv=none; b=KvtLFAJPHCLzcqQm0wY2ZkmU9ZFHtvOK1YMnRWXt2hL7z9+P9TDx1tTcsMe0KXlLE8/2sRthCHeO93F8vLSw4uch9to8CCYOJHRYLO19ku0AIq91UCibJq6hW+nccwaLoA6OTDXPLptT6g2P5TQpSRXmeYiMaMnbesiGEPo0OmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760381467; c=relaxed/simple;
	bh=xoODF/iUh/HEdHd7uD+bNrTvk97jJ7xTJGd26loRJhc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=T2UY1Gx/IsyUCvRRI54wX7sbB0k0ZjJzvp7FSDz5CxaxYVaMv4njJ5UJsnBD2UCX/cmkjVGotRr93WEilb9/NqHRkU5s7eyDSjeTXRxZ6HpzQoVl3n2NKnH3lwfMeNt28sKvgWGfWaV0POMiSuFCesAexj4pWk3ueYPwrmtzb4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 3514C6042E; Mon, 13 Oct 2025 20:50:57 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org,
	sdf@fomichev.me
Subject: [PATCH net v2] net: core: fix lockdep splat on device unregister
Date: Mon, 13 Oct 2025 20:50:52 +0200
Message-ID: <20251013185052.14021-1-fw@strlen.de>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since blamed commit, unregister_netdevice_many_notify() takes the netdev
mutex if the device needs it.

If the device list is too long, this will lock more device mutexes than
lockdep can handle:

unshare -n \
 bash -c 'for i in $(seq 1 100);do ip link add foo$i type dummy;done'

BUG: MAX_LOCK_DEPTH too low!
turning off the locking correctness validator.
depth: 48  max: 48!
48 locks held by kworker/u16:1/69:
 #0: ..148 ((wq_completion)netns){+.+.}-{0:0}, at: process_one_work
 #1: ..d40 (net_cleanup_work){+.+.}-{0:0}, at: process_one_work
 #2: ..bd0 (pernet_ops_rwsem){++++}-{4:4}, at: cleanup_net
 #3: ..aa8 (rtnl_mutex){+.+.}-{4:4}, at: default_device_exit_batch
 #4: ..cb0 (&dev_instance_lock_key#3){+.+.}-{4:4}, at: unregister_netdevice_many_notify
[..]

Add a helper to close and then unlock a list of net_devices.
Devices that are not up have to be skipped - netif_close_many always
removes them from the list without any other actions taken, so they'd
remain in locked state.

Close devices whenever we've used up half of the tracking slots or we
processed entire list without hitting the limit.

Fixes: 7e4d784f5810 ("net: hold netdev instance lock during rtnetlink operations")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 v2: rewrite.

 net/core/dev.c | 40 +++++++++++++++++++++++++++++++++++-----
 1 file changed, 35 insertions(+), 5 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index a64cef2c537e..2acfa44927da 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -12176,6 +12176,35 @@ static void dev_memory_provider_uninstall(struct net_device *dev)
 	}
 }
 
+/* devices must be UP and netdev_lock()'d */
+static void netif_close_many_and_unlock(struct list_head *close_head)
+{
+	struct net_device *dev, *tmp;
+
+	netif_close_many(close_head, false);
+
+	/* ... now unlock them */
+	list_for_each_entry_safe(dev, tmp, close_head, close_list) {
+		netdev_unlock(dev);
+		list_del_init(&dev->close_list);
+	}
+}
+
+static void netif_close_many_and_unlock_cond(struct list_head *close_head)
+{
+#ifdef CONFIG_LOCKDEP
+	/* We can only track up to MAX_LOCK_DEPTH locks per task.
+	 *
+	 * Reserve half the available slots for additional locks possibly
+	 * taken by notifiers and (soft)irqs.
+	 */
+	unsigned int limit = MAX_LOCK_DEPTH / 2;
+
+	if (lockdep_depth(current) > limit)
+		netif_close_many_and_unlock(close_head);
+#endif
+}
+
 void unregister_netdevice_many_notify(struct list_head *head,
 				      u32 portid, const struct nlmsghdr *nlh)
 {
@@ -12208,17 +12237,18 @@ void unregister_netdevice_many_notify(struct list_head *head,
 
 	/* If device is running, close it first. Start with ops locked... */
 	list_for_each_entry(dev, head, unreg_list) {
+		if (!(dev->flags & IFF_UP))
+			continue;
 		if (netdev_need_ops_lock(dev)) {
 			list_add_tail(&dev->close_list, &close_head);
 			netdev_lock(dev);
 		}
+		netif_close_many_and_unlock_cond(&close_head);
 	}
-	netif_close_many(&close_head, true);
-	/* ... now unlock them and go over the rest. */
+	netif_close_many_and_unlock(&close_head);
+	/* ... now go over the rest. */
 	list_for_each_entry(dev, head, unreg_list) {
-		if (netdev_need_ops_lock(dev))
-			netdev_unlock(dev);
-		else
+		if (!netdev_need_ops_lock(dev))
 			list_add_tail(&dev->close_list, &close_head);
 	}
 	netif_close_many(&close_head, true);
-- 
2.51.0

