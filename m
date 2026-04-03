Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C508D1DF254
	for <netfilter-devel@vger.kernel.org>; Fri,  3 Apr 2026 12:22:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775218931; cv=none; b=h8T3d2sZA7IIMwrG4yHbrpXffkS4wuWToPIXy2bJt7dGX4ors8xQVsYBuJUmblIdR9PlTMNWflY3WqCC8OzZNC6npUevLygk0DARXbCLoPLG3sJIoKjaE5qv2X15GAI8Kjq4UwPy6NjnF7q0D2nEu6bh+c7mJygdJIH7mzzx2DE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775218931; c=relaxed/simple;
	bh=EUBtIWsN+iC/3KXf8rU44ziWp48iFUK+cv9y3wIISmw=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=sWOYcJWWmZDCXHlJIf1gWjscP17HQPIYC2EL2ZfIU+yIq07Vs+PYwEis1F8WYl1Q0Xh9nuTtBHuLP9HCl7vyolMBm55TohG31Q9T5jnsVqVd3upiJBf2JA1Jji8L7WuQqzeWqrRLaws0mYNyZ6KqwMADhgETMAdhger7vRMrSRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id F396B60913; Fri, 03 Apr 2026 14:22:01 +0200 (CEST)
Date: Fri, 3 Apr 2026 14:22:01 +0200
From: Florian Westphal <fw@strlen.de>
To: Scott Mitchell <scott.k.mitch1@gmail.com>
Cc: netfilter-devel@vger.kernel.org
Subject: nfnetlink_queue crashes kernel
Message-ID: <ac-w6e33txkgTRJj@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

nfnetlink_queue is currently broken in at least two ways.
1). kernel will crash under pressure because
    struct nf_queue_entry is freed via kfree, but parallel
    cpu can still observe this while walking the (global) rhashtable.

2) a4400a5b343d ("netfilter: nfnetlink_queue: nfqnl_instance GFP_ATOMIC -> =
GFP_KERNEL_ACCOUNT allocation") should have updated the spinlock to use the=
 _bh variant, if the queue exists we risk deadlock via softirq recursion.

Minimal fix, that I am not a fan of:

diff --git a/include/net/netfilter/nf_queue.h b/include/net/netfilter/nf_qu=
eue.h
--- a/include/net/netfilter/nf_queue.h
+++ b/include/net/netfilter/nf_queue.h
@@ -24,6 +24,7 @@ struct nf_queue_entry {
 	bool			nf_ct_is_unconfirmed;
 	u16			size; /* sizeof(entry) + saved route keys */
 	u16			queue_num;
+	struct rcu_head		head;
=20
 	/* extra space to store route keys */
 };
diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
index 7f12e56e6e52..385d1fe704ae 100644
--- a/net/netfilter/nf_queue.c
+++ b/net/netfilter/nf_queue.c
@@ -74,7 +74,7 @@ static void nf_queue_entry_release_refs(struct nf_queue_e=
ntry *entry)
 void nf_queue_entry_free(struct nf_queue_entry *entry)
 {
 	nf_queue_entry_release_refs(entry);
-	kfree(entry);
+	kfree_rcu(entry, head);
 }
 EXPORT_SYMBOL_GPL(nf_queue_entry_free);
=20
diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queu=
e.c
index 47f7f62906e2..fc44ea4e5128 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -190,7 +190,7 @@ instance_create(struct nfnl_queue_net *q, u_int16_t que=
ue_num, u32 portid)
 	spin_lock_init(&inst->lock);
 	INIT_LIST_HEAD(&inst->queue_list);
=20
-	spin_lock(&q->instances_lock);
+	spin_lock_bh(&q->instances_lock);
 	if (instance_lookup(q, queue_num)) {
 		err =3D -EEXIST;
 		goto out_unlock;
@@ -204,7 +204,7 @@ instance_create(struct nfnl_queue_net *q, u_int16_t que=
ue_num, u32 portid)
 	h =3D instance_hashfn(queue_num);
 	hlist_add_head_rcu(&inst->hlist, &q->instance_table[h]);
=20
-	spin_unlock(&q->instances_lock);
+	spin_unlock_bh(&q->instances_lock);
=20
 	return inst;
=20



A probably better fix is to make the rhashtable perqueue, which is
much more intrusive at this late stage.

I prefer to revert both changes and not accept a reworked hashtable
until we have an extension to nft_queue.sh selftest.

Anything using queue balancing (pacing packets to n queues) with
enough streams to have parallel invocation of the rhashtable should
demonstrate the crash.

Thoughts?
