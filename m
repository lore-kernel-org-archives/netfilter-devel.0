From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH] netfilter: don't use INIT_RCU_HEAD()
Date: Thu, 11 Feb 2010 21:49:11 +0200
Message-ID: <20100211194911.GA9756@x200>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.158]:61398 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756399Ab0BKTtV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Feb 2010 14:49:21 -0500
Received: by fg-out-1718.google.com with SMTP id e21so79760fga.1
        for <netfilter-devel@vger.kernel.org>; Thu, 11 Feb 2010 11:49:19 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

call_rcu() will unconditionally reinitialize RCU head anyway.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 net/netfilter/nf_conntrack_expect.c |    1 -
 net/netfilter/nf_conntrack_extend.c |    1 -
 net/netfilter/nfnetlink_queue.c     |    1 -
 3 files changed, 3 deletions(-)

--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -232,7 +232,6 @@ struct nf_conntrack_expect *nf_ct_expect_alloc(struct nf_conn *me)
 
 	new->master = me;
 	atomic_set(&new->use, 1);
-	INIT_RCU_HEAD(&new->rcu);
 	return new;
 }
 EXPORT_SYMBOL_GPL(nf_ct_expect_alloc);
--- a/net/netfilter/nf_conntrack_extend.c
+++ b/net/netfilter/nf_conntrack_extend.c
@@ -59,7 +59,6 @@ nf_ct_ext_create(struct nf_ct_ext **ext, enum nf_ct_ext_id id, gfp_t gfp)
 	if (!*ext)
 		return NULL;
 
-	INIT_RCU_HEAD(&(*ext)->rcu);
 	(*ext)->offset[id] = off;
 	(*ext)->len = len;
 
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -112,7 +112,6 @@ instance_create(u_int16_t queue_num, int pid)
 	inst->copy_mode = NFQNL_COPY_NONE;
 	spin_lock_init(&inst->lock);
 	INIT_LIST_HEAD(&inst->queue_list);
-	INIT_RCU_HEAD(&inst->rcu);
 
 	if (!try_module_get(THIS_MODULE)) {
 		err = -EAGAIN;
