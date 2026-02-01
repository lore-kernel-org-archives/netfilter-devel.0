Received: from wilbur.contactoffice.com (wilbur.contactoffice.com [212.3.242.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F98B286410
	for <netfilter-devel@vger.kernel.org>; Sun,  1 Feb 2026 06:26:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.3.242.68
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769927211; cv=none; b=mt0dM7DBleiNUgptqIR5zQWt8EihS8aJhsoZOUnN5r7tf9h5GTUNmOva/ur9xX6awWt1KfOM4vBPVZAdj6pQNyb+giVyQC2xqkOJDUFYluwWHx/gKg/RwszM93nVc+uR18LINskeHvB6dITJNehXSmZ3Ux4gCK+WSnASqfjYnNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769927211; c=relaxed/simple;
	bh=VVbZ0uO88pfgS18Pe5ZgQwMaSqrURnbrS/9NjKaZwDw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bnlfcn8ImLANlr7vqEhJKRqY2ZG2Ej9qzl2B/g4blcPM0JJONMTrngynsHZNHMneybPhtqudelAYdgKfiNTDFVsBsCRJX6wnuP3QO1kl08VuIFMAblQ9h+zBGe13hsCvA65ZiAB1Z9ZwmAKjSKxJhi+L2n/KVgO2Vh+1Tn7EgfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailfence.com; spf=pass smtp.mailfrom=mailfence.com; dkim=pass (2048-bit key) header.d=mailfence.com header.i=brianwitte@mailfence.com header.b=hz0UJv0X; arc=none smtp.client-ip=212.3.242.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailfence.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mailfence.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mailfence.com header.i=brianwitte@mailfence.com header.b="hz0UJv0X"
Received: from smtpauth2.co-bxl (smtpauth2.co-bxl [10.2.0.24])
	by wilbur.contactoffice.com (Postfix) with ESMTP id B1919876F;
	Sun,  1 Feb 2026 07:26:39 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1769927199;
	s=20240605-akrp; d=mailfence.com; i=brianwitte@mailfence.com;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Transfer-Encoding;
	bh=vMhuiQk2fk8UgCkznKIiv/CJaE2Fxtd9n/M0Eb1jV94=;
	b=hz0UJv0XTrLUuLoikwhKYROQPILjikAy+wm9sGyUlqDBfHhwDJQT6xtkZ4ZsjRhU
	E8S+Wjm8k5IKnbD9B6/XXAV49aDi599Y8PzYZbN2mKIewdXMBHR02EI/W+43QIfC6OK
	vDwPptwuN3uQsvWxenvQW9vT3ETGoXWuhWbX5I/uIDdqroYwVb9r7NfhYZRcXMcIIfz
	Sw8R69Nr8xh/ijPf0aabiwb/W/UwjBlXi8HeInRpmQhPEPo9Lm19Adt6JVIHWBf0ea8
	wrSuDpd4BIt3GP2Bb4Yfvrsvse0dpt3F1gU4LgdLqc4gmCN/QuuAiA2QBClOtzCZXGm
	pbEN14MeMw==
Received: by smtp.mailfence.com with ESMTPSA ; Sun, 1 Feb 2026 07:26:36 +0100 (CET)
From: Brian Witte <brianwitte@mailfence.com>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org,
	fw@strlen.de,
	kadlec@blackhole.kfki.hu,
	syzbot+ff16b505ec9152e5f448@syzkaller.appspotmail.com,
	Brian Witte <brianwitte@mailfence.com>
Subject: [PATCH v2 nf-next] netfilter: nf_tables: use dedicated spinlock for reset operations
Date: Sun,  1 Feb 2026 00:25:17 -0600
Message-ID: <20260201062517.263087-1-brianwitte@mailfence.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ContactOffice-Account: com:441463380

Replace commit_mutex with a dedicated reset_lock spinlock for reset
operations. This fixes a circular locking dependency between
commit_mutex, nfnl_subsys_ipset, and nlk_cb_mutex-NETFILTER when nft
reset, ipset list, and iptables-nft with set match run concurrently:

  CPU0 (nft reset):        nlk_cb_mutex -> commit_mutex
  CPU1 (ipset list):       nfnl_subsys_ipset -> nlk_cb_mutex
  CPU2 (iptables -m set):  commit_mutex -> nfnl_subsys_ipset

Using a spinlock instead of a mutex means we stay in the RCU read-side
critical section throughout, eliminating the try_module_get/module_put
and rcu_read_unlock/rcu_read_lock dance that was needed to handle the
sleeping mutex.

Reported-by: syzbot+ff16b505ec9152e5f448@syzkaller.appspotmail.com
Fixes: https://syzkaller.appspot.com/bug?extid=ff16b505ec9152e5f448
Signed-off-by: Brian Witte <brianwitte@mailfence.com>
---
v2: Use spinlock instead of mutex as suggested by Florian Westphal.
    Avoids RCU warnings since we no longer drop rcu_read_lock() before
    acquiring the lock.
v1: https://lore.kernel.org/netfilter-devel/20260127030604.39982-1-brianwitte@mailfence.com/
---
 include/net/netfilter/nf_tables.h |  1 +
 net/netfilter/nf_tables_api.c     | 54 +++++++++----------------------
 2 files changed, 16 insertions(+), 39 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 31906f90706e..f5ad39fbc583 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1931,6 +1931,7 @@ struct nftables_pernet {
 	struct list_head	module_list;
 	struct list_head	notify_list;
 	struct mutex		commit_mutex;
+	spinlock_t		reset_lock;	/* protects object reset */
 	u64			table_handle;
 	u64			tstamp;
 	unsigned int		gc_seq;
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index be4924aeaf0e..f3f082ae5905 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3907,13 +3907,9 @@ static int nf_tables_dumpreset_rules(struct sk_buff *skb,
 	struct nftables_pernet *nft_net = nft_pernet(sock_net(skb->sk));
 	int ret;
 
-	/* Mutex is held is to prevent that two concurrent dump-and-reset calls
-	 * do not underrun counters and quotas. The commit_mutex is used for
-	 * the lack a better lock, this is not transaction path.
-	 */
-	mutex_lock(&nft_net->commit_mutex);
+	spin_lock(&nft_net->reset_lock);
 	ret = nf_tables_dump_rules(skb, cb);
-	mutex_unlock(&nft_net->commit_mutex);
+	spin_unlock(&nft_net->reset_lock);
 
 	return ret;
 }
@@ -4054,14 +4050,9 @@ static int nf_tables_getrule_reset(struct sk_buff *skb,
 		return nft_netlink_dump_start_rcu(info->sk, skb, info->nlh, &c);
 	}
 
-	if (!try_module_get(THIS_MODULE))
-		return -EINVAL;
-	rcu_read_unlock();
-	mutex_lock(&nft_net->commit_mutex);
+	spin_lock(&nft_net->reset_lock);
 	skb2 = nf_tables_getrule_single(portid, info, nla, true);
-	mutex_unlock(&nft_net->commit_mutex);
-	rcu_read_lock();
-	module_put(THIS_MODULE);
+	spin_unlock(&nft_net->reset_lock);
 
 	if (IS_ERR(skb2))
 		return PTR_ERR(skb2);
@@ -6346,16 +6337,14 @@ static int nf_tables_dumpreset_set(struct sk_buff *skb,
 	struct nft_set_dump_ctx *dump_ctx = cb->data;
 	int ret, skip = cb->args[0];
 
-	mutex_lock(&nft_net->commit_mutex);
-
+	spin_lock(&nft_net->reset_lock);
 	ret = nf_tables_dump_set(skb, cb);
+	spin_unlock(&nft_net->reset_lock);
 
 	if (cb->args[0] > skip)
 		audit_log_nft_set_reset(dump_ctx->ctx.table, cb->seq,
 					cb->args[0] - skip);
 
-	mutex_unlock(&nft_net->commit_mutex);
-
 	return ret;
 }
 
@@ -6668,16 +6657,11 @@ static int nf_tables_getsetelem_reset(struct sk_buff *skb,
 	if (!nla[NFTA_SET_ELEM_LIST_ELEMENTS])
 		return -EINVAL;
 
-	if (!try_module_get(THIS_MODULE))
-		return -EINVAL;
-	rcu_read_unlock();
-	mutex_lock(&nft_net->commit_mutex);
-	rcu_read_lock();
-
 	err = nft_set_dump_ctx_init(&dump_ctx, skb, info, nla, true);
 	if (err)
-		goto out_unlock;
+		return err;
 
+	spin_lock(&nft_net->reset_lock);
 	nla_for_each_nested(attr, nla[NFTA_SET_ELEM_LIST_ELEMENTS], rem) {
 		err = nft_get_set_elem(&dump_ctx.ctx, dump_ctx.set, attr, true);
 		if (err < 0) {
@@ -6686,13 +6670,9 @@ static int nf_tables_getsetelem_reset(struct sk_buff *skb,
 		}
 		nelems++;
 	}
-	audit_log_nft_set_reset(dump_ctx.ctx.table, nft_base_seq(info->net), nelems);
+	spin_unlock(&nft_net->reset_lock);
 
-out_unlock:
-	rcu_read_unlock();
-	mutex_unlock(&nft_net->commit_mutex);
-	rcu_read_lock();
-	module_put(THIS_MODULE);
+	audit_log_nft_set_reset(dump_ctx.ctx.table, nft_base_seq(info->net), nelems);
 
 	return err;
 }
@@ -8552,9 +8532,9 @@ static int nf_tables_dumpreset_obj(struct sk_buff *skb,
 	struct nftables_pernet *nft_net = nft_pernet(sock_net(skb->sk));
 	int ret;
 
-	mutex_lock(&nft_net->commit_mutex);
+	spin_lock(&nft_net->reset_lock);
 	ret = nf_tables_dump_obj(skb, cb);
-	mutex_unlock(&nft_net->commit_mutex);
+	spin_unlock(&nft_net->reset_lock);
 
 	return ret;
 }
@@ -8690,14 +8670,9 @@ static int nf_tables_getobj_reset(struct sk_buff *skb,
 		return nft_netlink_dump_start_rcu(info->sk, skb, info->nlh, &c);
 	}
 
-	if (!try_module_get(THIS_MODULE))
-		return -EINVAL;
-	rcu_read_unlock();
-	mutex_lock(&nft_net->commit_mutex);
+	spin_lock(&nft_net->reset_lock);
 	skb2 = nf_tables_getobj_single(portid, info, nla, true);
-	mutex_unlock(&nft_net->commit_mutex);
-	rcu_read_lock();
-	module_put(THIS_MODULE);
+	spin_unlock(&nft_net->reset_lock);
 
 	if (IS_ERR(skb2))
 		return PTR_ERR(skb2);
@@ -12194,6 +12169,7 @@ static int __net_init nf_tables_init_net(struct net *net)
 	INIT_LIST_HEAD(&nft_net->module_list);
 	INIT_LIST_HEAD(&nft_net->notify_list);
 	mutex_init(&nft_net->commit_mutex);
+	spin_lock_init(&nft_net->reset_lock);
 	net->nft.base_seq = 1;
 	nft_net->gc_seq = 0;
 	nft_net->validate_state = NFT_VALIDATE_SKIP;
-- 
2.47.3

