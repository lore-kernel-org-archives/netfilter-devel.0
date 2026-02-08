Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF5352F49F4
	for <netfilter-devel@vger.kernel.org>; Sun,  8 Feb 2026 11:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770548491; cv=none; b=B+Y2TAiHR4FYMppO8vcvyrzktwGT/t8XHUjdXC7ClrZ9u0GXX4xKBmOrbSQGDblhfl186m7cRJ32MX3pV0zPWkt1gTGuE0pSCBjzOuEtIJ5DiuZcucWB/+fgNvOIEue3aS78fDxsMpJEnP90ma/h48C1DmEcUm3kEnHBPI5x+8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770548491; c=relaxed/simple;
	bh=OUr0/EjBwKUIq9wjaQQSTfUmconlBsUbiqw3HhthXB0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=QSUhBsbP61ZAaSVfo2BMK9auQQdEygWZ28HJGZQU81sYbygzMKbGwbccjp26h33slMa8w36pe704POrgM8EVjIxGAhu+PDebgacgJ3yViKEWAbEOA1G2fyekg6mqBG8t+1iQdv4FIRPu6qO5TN8zjLWxh1HANOXiPSqrbTvd4O8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=S8ViZ8wY; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=YndmM42O; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="S8ViZ8wY";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="YndmM42O"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770548491;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=2399lSML0+N3Gvm8VDP9m3yONrvPxPlMoYg9untbM60=;
	b=S8ViZ8wYmdN+hErAcfUYqRRHlUl9OKNDJpTQVzRv8qn1XNJOPlM5kmQgN5w+XSMNo4i4Ui
	ASnbHX0OfW9AzZ1xhw767trOPf8oksKgK7x20y1MJDQFfpaEG0UeY6O9oaQIFVnUFRCD58
	YxZYvARO3N0PrFmBsQUtOQ/vMbL82WI=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-297-ELWUWH4XMdeUpZpV9qinCg-1; Sun, 08 Feb 2026 06:01:29 -0500
X-MC-Unique: ELWUWH4XMdeUpZpV9qinCg-1
X-Mimecast-MFC-AGG-ID: ELWUWH4XMdeUpZpV9qinCg_1770548489
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2a75ed2f89dso20535845ad.1
        for <netfilter-devel@vger.kernel.org>; Sun, 08 Feb 2026 03:01:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1770548486; x=1771153286; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=2399lSML0+N3Gvm8VDP9m3yONrvPxPlMoYg9untbM60=;
        b=YndmM42ONeEvHU4fMdkFa/H0cDz2uLPFLfs8yDIEIRcWL9Y8G6CiEoGPg0pX/pGJoe
         B9n6RQVhSHjcaE9Vb/Phu/A3vke5bCMIQYIrGnE1GLZTdVUo2Ejf3RMuN/wy+XIvEQ9H
         EZ9xI6KOrmI+7qlOxPIBzTO8cT+GFT4bPt47cI0EUjkxLLFc+61u+cZLF0+NDyJRWjTC
         chT2HGAcnDNtMImdoODhdc5ZoarYgCV+q0f4bWVI6rykAdKeuzSUHyvoM9SujnAhlV08
         K1/J4z5J9WJP8Ae8QOizsfulp8jFTM9FIkIUYIE0kC+nVQESHdzK/w+8pt4SzrB33LhD
         yXdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770548486; x=1771153286;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2399lSML0+N3Gvm8VDP9m3yONrvPxPlMoYg9untbM60=;
        b=Gp1GtAZvm3pPiGfZDBXrLiQtN++fjoXZKaGT5cWJv6xeKN1tp+1yG3pwIm+okp9ySC
         qLeOZhh2nxBE2jib67XKOz89GpJmReQyJCdsWe+qSxYf7DLVR1Zmq54lJGiuq3w5X16A
         uXfFSORzomjOOpYxPUEngf0SxPtasYeZCO6GrVuzJjZcZCuHAgyImGsIkx6DIw6ZlZVw
         ut1VL+iRNknnXgMF0AihwllbF5z1KKsM8+iWxUqOkqr5x8xJk1MygGZmUuDXjvbxxPtM
         QMpXhznMGJWIo7X3CTZjUMN4tC1VGeK8dtwiPAsm9Bykjxc3khpfWB6e8xkh79s9XZ+i
         Hpug==
X-Forwarded-Encrypted: i=1; AJvYcCVGVzu0W0/Sv2eJvENsw9aOISvxmkLD8KWWrIc7CdIjH42MXe/h1byorutiWrBYsaiA5l6SJqGqps6UmokMZSs=@vger.kernel.org
X-Gm-Message-State: AOJu0YxmN/aviykeX9Pe8tiI+6YzebpsOt40yRtkv5VQ93Z2ZlkczB82
	u28DTNfkYX4WK7gZS3ABqiRbAQLTOIQgmFrphTw1rzff2rUN1/V3xxvU1jJBuU1ZuuRIQXG5Oh0
	L2aHYGw9dPBCq2usPuEq8UBENP3zbSKeWRci/W7t/FeNHwYOF4C+zioscm4FMDkHOs+inMQ==
X-Gm-Gg: AZuq6aJnRZnueMGrHK1+vgaNMHS6FgNh4hAfSDNjLJ3N6Dg6mnAtInQ3ijfp6BSW7yy
	SEhH/dYGA2n9nJwVUk/K4ZNXUWTO0L9GhJWvHEQSTJVCl3UoUMAnGrK+RoGmE3PtI2xlx0rViOh
	XS2+LNCX2SIrdFt0SxvdPVD0Jdcxzr+UcaHZwFOGwGHqk7u/7zJrtyDUXUcZCs/QsMWJD6JMHf1
	7tGCbOSL550ZOaqnHVyj2+NZsxDr5yHFMUXRrJRhLBtoda7NogNZSLWfnqPu+QVsrkygL91mK6m
	aLe0iggFzLQck0dVCDOqLgdMWnbZ9BXOw1Oc3/eh1SmohwZRLMqZE9fPfSr180sA8ESeKBlVM6+
	ADbZ/7Aih/pcZJdW0p8971awSVCA0qtgT/Q==
X-Received: by 2002:a17:902:cf0a:b0:2a8:ff32:5f96 with SMTP id d9443c01a7336-2a95165a927mr76312255ad.13.1770548486256;
        Sun, 08 Feb 2026 03:01:26 -0800 (PST)
X-Received: by 2002:a17:902:cf0a:b0:2a8:ff32:5f96 with SMTP id d9443c01a7336-2a95165a927mr76312055ad.13.1770548485801;
        Sun, 08 Feb 2026 03:01:25 -0800 (PST)
Received: from kernel-devel.tail62cea.ts.net ([240d:1a:c0d:9f00:be24:11ff:fe35:71b3])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a951a638b5sm92796505ad.11.2026.02.08.03.01.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Feb 2026 03:01:25 -0800 (PST)
From: Shigeru Yoshida <syoshida@redhat.com>
To: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	Shigeru Yoshida <syoshida@redhat.com>
Cc: syzbot+5a66db916cdde0dbcc1c@syzkaller.appspotmail.com,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org
Subject: [PATCH net] net: flow_offload: protect driver_block_list in flow_block_cb_setup_simple()
Date: Sun,  8 Feb 2026 20:00:50 +0900
Message-ID: <20260208110054.2525262-1-syoshida@redhat.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

syzbot reported a list_del corruption in flow_block_cb_setup_simple(). [0]

flow_block_cb_setup_simple() accesses the driver_block_list (e.g.,
netdevsim's nsim_block_cb_list) without any synchronization. The
nftables offload path calls into this function via ndo_setup_tc while
holding the per-netns commit_mutex, but this mutex does not prevent
concurrent access from tasks in different network namespaces that
share the same driver_block_list, leading to list corruption:

- Task A (FLOW_BLOCK_BIND) calls list_add_tail() to insert a new
  flow_block_cb into driver_block_list.

- Task B (FLOW_BLOCK_UNBIND) concurrently calls list_del() on another
  flow_block_cb from the same list.

- The concurrent modifications corrupt the list pointers.

Fix this by adding a static mutex (flow_block_cb_list_lock) that
protects all driver_block_list operations within
flow_block_cb_setup_simple(). Also add a flow_block_cb_remove_driver()
helper for external callers that need to remove a block_cb from the
driver list under the same lock, and convert nft_indr_block_cleanup()
to use it.

[0]:
list_del corruption. prev->next should be ffff888028878200, but was ffffffff8e940fc0. (prev=ffffffff8e940fc0)
------------[ cut here ]------------
kernel BUG at lib/list_debug.c:64!
Oops: invalid opcode: 0000 [#1] SMP KASAN PTI
CPU: 1 UID: 0 PID: 6308 Comm: syz.3.231 Not tainted syzkaller #0 PREEMPT(full)
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/18/2025
RIP: 0010:__list_del_entry_valid_or_report+0x15a/0x190 lib/list_debug.c:62
[...]
Call Trace:
 <TASK>
 __list_del_entry_valid include/linux/list.h:124 [inline]
 __list_del_entry include/linux/list.h:215 [inline]
 list_del include/linux/list.h:229 [inline]
 flow_block_cb_setup_simple+0x62d/0x740 net/core/flow_offload.c:369
 nft_block_offload_cmd net/netfilter/nf_tables_offload.c:397 [inline]
 nft_chain_offload_cmd+0x293/0x660 net/netfilter/nf_tables_offload.c:451
 nft_flow_block_chain net/netfilter/nf_tables_offload.c:471 [inline]
 nft_flow_offload_chain net/netfilter/nf_tables_offload.c:513 [inline]
 nft_flow_rule_offload_commit+0x40d/0x1b60 net/netfilter/nf_tables_offload.c:592
 nf_tables_commit+0x675/0x8710 net/netfilter/nf_tables_api.c:10925
 nfnetlink_rcv_batch net/netfilter/nfnetlink.c:576 [inline]
 nfnetlink_rcv_skb_batch net/netfilter/nfnetlink.c:649 [inline]
 nfnetlink_rcv+0x1ac9/0x2590 net/netfilter/nfnetlink.c:667
 netlink_unicast_kernel net/netlink/af_netlink.c:1320 [inline]
 netlink_unicast+0x82c/0x9e0 net/netlink/af_netlink.c:1346
 netlink_sendmsg+0x805/0xb30 net/netlink/af_netlink.c:1896
 sock_sendmsg_nosec net/socket.c:727 [inline]
 __sock_sendmsg+0x219/0x270 net/socket.c:742
 ____sys_sendmsg+0x505/0x830 net/socket.c:2630
 ___sys_sendmsg+0x21f/0x2a0 net/socket.c:2684
 __sys_sendmsg net/socket.c:2716 [inline]
 __do_sys_sendmsg net/socket.c:2721 [inline]
 __se_sys_sendmsg net/socket.c:2719 [inline]
 __x64_sys_sendmsg+0x19b/0x260 net/socket.c:2719
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Fixes: 955bcb6ea0df ("drivers: net: use flow block API")
Reported-by: syzbot+5a66db916cdde0dbcc1c@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=5a66db916cdde0dbcc1c
Tested-by: syzbot+5a66db916cdde0dbcc1c@syzkaller.appspotmail.com
Signed-off-by: Shigeru Yoshida <syoshida@redhat.com>
---
 include/net/flow_offload.h        |  2 ++
 net/core/flow_offload.c           | 41 ++++++++++++++++++++++++-------
 net/netfilter/nf_tables_offload.c |  2 +-
 3 files changed, 35 insertions(+), 10 deletions(-)

diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index 596ab9791e4d..ff6d2bcb2cca 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -673,6 +673,8 @@ int flow_block_cb_setup_simple(struct flow_block_offload *f,
 			       flow_setup_cb_t *cb,
 			       void *cb_ident, void *cb_priv, bool ingress_only);
 
+void flow_block_cb_remove_driver(struct flow_block_cb *block_cb);
+
 enum flow_cls_command {
 	FLOW_CLS_REPLACE,
 	FLOW_CLS_DESTROY,
diff --git a/net/core/flow_offload.c b/net/core/flow_offload.c
index bc5169482710..137a44af5e1c 100644
--- a/net/core/flow_offload.c
+++ b/net/core/flow_offload.c
@@ -334,6 +334,8 @@ bool flow_block_cb_is_busy(flow_setup_cb_t *cb, void *cb_ident,
 }
 EXPORT_SYMBOL(flow_block_cb_is_busy);
 
+static DEFINE_MUTEX(flow_block_cb_list_lock);
+
 int flow_block_cb_setup_simple(struct flow_block_offload *f,
 			       struct list_head *driver_block_list,
 			       flow_setup_cb_t *cb,
@@ -341,6 +343,7 @@ int flow_block_cb_setup_simple(struct flow_block_offload *f,
 			       bool ingress_only)
 {
 	struct flow_block_cb *block_cb;
+	int err = 0;
 
 	if (ingress_only &&
 	    f->binder_type != FLOW_BLOCK_BINDER_TYPE_CLSACT_INGRESS)
@@ -348,32 +351,52 @@ int flow_block_cb_setup_simple(struct flow_block_offload *f,
 
 	f->driver_block_list = driver_block_list;
 
+	mutex_lock(&flow_block_cb_list_lock);
+
 	switch (f->command) {
 	case FLOW_BLOCK_BIND:
-		if (flow_block_cb_is_busy(cb, cb_ident, driver_block_list))
-			return -EBUSY;
+		if (flow_block_cb_is_busy(cb, cb_ident, driver_block_list)) {
+			err = -EBUSY;
+			break;
+		}
 
 		block_cb = flow_block_cb_alloc(cb, cb_ident, cb_priv, NULL);
-		if (IS_ERR(block_cb))
-			return PTR_ERR(block_cb);
+		if (IS_ERR(block_cb)) {
+			err = PTR_ERR(block_cb);
+			break;
+		}
 
 		flow_block_cb_add(block_cb, f);
 		list_add_tail(&block_cb->driver_list, driver_block_list);
-		return 0;
+		break;
 	case FLOW_BLOCK_UNBIND:
 		block_cb = flow_block_cb_lookup(f->block, cb, cb_ident);
-		if (!block_cb)
-			return -ENOENT;
+		if (!block_cb) {
+			err = -ENOENT;
+			break;
+		}
 
 		flow_block_cb_remove(block_cb, f);
 		list_del(&block_cb->driver_list);
-		return 0;
+		break;
 	default:
-		return -EOPNOTSUPP;
+		err = -EOPNOTSUPP;
+		break;
 	}
+
+	mutex_unlock(&flow_block_cb_list_lock);
+	return err;
 }
 EXPORT_SYMBOL(flow_block_cb_setup_simple);
 
+void flow_block_cb_remove_driver(struct flow_block_cb *block_cb)
+{
+	mutex_lock(&flow_block_cb_list_lock);
+	list_del(&block_cb->driver_list);
+	mutex_unlock(&flow_block_cb_list_lock);
+}
+EXPORT_SYMBOL(flow_block_cb_remove_driver);
+
 static DEFINE_MUTEX(flow_indr_block_lock);
 static LIST_HEAD(flow_block_indr_list);
 static LIST_HEAD(flow_block_indr_dev_list);
diff --git a/net/netfilter/nf_tables_offload.c b/net/netfilter/nf_tables_offload.c
index fd30e205de84..d60838bceafb 100644
--- a/net/netfilter/nf_tables_offload.c
+++ b/net/netfilter/nf_tables_offload.c
@@ -414,7 +414,7 @@ static void nft_indr_block_cleanup(struct flow_block_cb *block_cb)
 				    basechain, &extack);
 	nft_net = nft_pernet(net);
 	mutex_lock(&nft_net->commit_mutex);
-	list_del(&block_cb->driver_list);
+	flow_block_cb_remove_driver(block_cb);
 	list_move(&block_cb->list, &bo.cb_list);
 	nft_flow_offload_unbind(&bo, basechain);
 	mutex_unlock(&nft_net->commit_mutex);
-- 
2.52.0

