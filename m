Received: from wilbur.contactoffice.com (wilbur.contactoffice.com [212.3.242.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA32D2FD66D
	for <netfilter-devel@vger.kernel.org>; Tue, 27 Jan 2026 03:06:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.3.242.68
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769483205; cv=none; b=eykRoKcaVFP/J6E8TEf166hRoanQeoogMNHfwfyQWZtUM68QF1giL/qcFogUMzVAagdWeY3hsw/MM46n2qLGMkvZjcBxxY/hbmJW25p2jQipX+t1GWwBc/W2TyVj/IjMLHpBklUBBgxHybUhcJ3rd8FEodR2gzhQAMJ98u+ufUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769483205; c=relaxed/simple;
	bh=n4gtVyllIhS60OggznlfVYUDiD1yOUUiKcUXgfGZTDw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZKyq3a7HsFSdyhxRUFdGvUk8Gx0TGeUUNO/bXS1TdBwfW1PM1n5neF+plSFc6tWe1X5KpayzwiMdliMbzxmSQMZiuuA6EpTCiNZJ7kOEiZbHY4gnTKHH3HYUEIT0HNbSqWV0y5ZPW+OI0wUbaHhj3nvCuFWv2GoJuCrykVmD07w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailfence.com; spf=pass smtp.mailfrom=mailfence.com; dkim=pass (2048-bit key) header.d=mailfence.com header.i=brianwitte@mailfence.com header.b=plH+WUwh; arc=none smtp.client-ip=212.3.242.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailfence.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mailfence.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mailfence.com header.i=brianwitte@mailfence.com header.b="plH+WUwh"
Received: from smtpauth2.co-bxl (smtpauth2.co-bxl [10.2.0.24])
	by wilbur.contactoffice.com (Postfix) with ESMTP id A4269C99;
	Tue, 27 Jan 2026 04:06:41 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1769483201;
	s=20240605-akrp; d=mailfence.com; i=brianwitte@mailfence.com;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Transfer-Encoding;
	bh=naE23BES8tH/nT8USq4+FSw9s3m7FtSIiSkF0TeYraE=;
	b=plH+WUwh5osycf8Mkkl3am68n+887qfuFXHmr0Xcghpp+TPHITft4LcMYsDYbt7u
	hGtP0rEqjcQPXFZVt3Was3OHqjXVNgzMF1l5YcenR8RkwEXHiCwnmNsn4i1JET1euhP
	GgAiLonp4834XNG+3l1X1+Xzhsj6VW/Q9+IniiLqNszCr3LdoW3tNr861wCM4SvMrPR
	a9hhnz0tglyjypD5wFVh7i9RZZIygTBTm90mi+q1UJdmq41UUJWih3gkF+CWbyOI8fj
	zMka/2tfqWvXrF42uKZ24ZClVifjD1q5yl67xin2v6F/WtGl6+ndb1/T7GTFNlxs9j7
	Im+UxeYQAA==
Received: by smtp.mailfence.com with ESMTPSA ; Tue, 27 Jan 2026 04:06:38 +0100 (CET)
From: Brian Witte <brianwitte@mailfence.com>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org,
	fw@strlen.de,
	kadlec@blackhole.kfki.hu
Subject: [PATCH nf-next] netfilter: nf_tables: use dedicated mutex for reset operations
Date: Mon, 26 Jan 2026 21:06:04 -0600
Message-ID: <20260127030604.39982-1-brianwitte@mailfence.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ContactOffice-Account: com:441463380

Add a dedicated reset_mutex to serialize reset operations instead of
reusing the commit_mutex. This fixes a circular locking dependency
between commit_mutex, nfnl_subsys_ipset, and nlk_cb_mutex-NETFILTER
that could lead to deadlock when nft reset, ipset list, and
iptables-nft with set match run concurrently:

  CPU0 (nft reset):        nlk_cb_mutex -> commit_mutex
  CPU1 (ipset list):       nfnl_subsys_ipset -> nlk_cb_mutex
  CPU2 (iptables -m set):  commit_mutex -> nfnl_subsys_ipset

The reset_mutex only serializes concurrent reset operations to prevent
counter underruns, which is all that's needed. Breaking the commit_mutex
dependency in the dump-reset path eliminates the circular lock chain.

Reported-by: syzbot+ff16b505ec9152e5f448@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=ff16b505ec9152e5f448
Signed-off-by: Brian Witte <brianwitte@mailfence.com>
---
 include/net/netfilter/nf_tables.h |  1 +
 net/netfilter/nf_tables_api.c     | 30 +++++++++++++++---------------
 2 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 31906f90706e..85cdd93e564b 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1931,6 +1931,7 @@ struct nftables_pernet {
 	struct list_head	module_list;
 	struct list_head	notify_list;
 	struct mutex		commit_mutex;
+	struct mutex		reset_mutex;
 	u64			table_handle;
 	u64			tstamp;
 	unsigned int		gc_seq;
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index be4924aeaf0e..c82b7875c49c 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3907,13 +3907,12 @@ static int nf_tables_dumpreset_rules(struct sk_buff *skb,
 	struct nftables_pernet *nft_net = nft_pernet(sock_net(skb->sk));
 	int ret;
 
-	/* Mutex is held is to prevent that two concurrent dump-and-reset calls
-	 * do not underrun counters and quotas. The commit_mutex is used for
-	 * the lack a better lock, this is not transaction path.
+	/* Mutex is held to prevent that two concurrent dump-and-reset calls
+	 * do not underrun counters and quotas.
 	 */
-	mutex_lock(&nft_net->commit_mutex);
+	mutex_lock(&nft_net->reset_mutex);
 	ret = nf_tables_dump_rules(skb, cb);
-	mutex_unlock(&nft_net->commit_mutex);
+	mutex_unlock(&nft_net->reset_mutex);
 
 	return ret;
 }
@@ -4057,9 +4056,9 @@ static int nf_tables_getrule_reset(struct sk_buff *skb,
 	if (!try_module_get(THIS_MODULE))
 		return -EINVAL;
 	rcu_read_unlock();
-	mutex_lock(&nft_net->commit_mutex);
+	mutex_lock(&nft_net->reset_mutex);
 	skb2 = nf_tables_getrule_single(portid, info, nla, true);
-	mutex_unlock(&nft_net->commit_mutex);
+	mutex_unlock(&nft_net->reset_mutex);
 	rcu_read_lock();
 	module_put(THIS_MODULE);
 
@@ -6346,7 +6345,7 @@ static int nf_tables_dumpreset_set(struct sk_buff *skb,
 	struct nft_set_dump_ctx *dump_ctx = cb->data;
 	int ret, skip = cb->args[0];
 
-	mutex_lock(&nft_net->commit_mutex);
+	mutex_lock(&nft_net->reset_mutex);
 
 	ret = nf_tables_dump_set(skb, cb);
 
@@ -6354,7 +6353,7 @@ static int nf_tables_dumpreset_set(struct sk_buff *skb,
 		audit_log_nft_set_reset(dump_ctx->ctx.table, cb->seq,
 					cb->args[0] - skip);
 
-	mutex_unlock(&nft_net->commit_mutex);
+	mutex_unlock(&nft_net->reset_mutex);
 
 	return ret;
 }
@@ -6671,7 +6670,7 @@ static int nf_tables_getsetelem_reset(struct sk_buff *skb,
 	if (!try_module_get(THIS_MODULE))
 		return -EINVAL;
 	rcu_read_unlock();
-	mutex_lock(&nft_net->commit_mutex);
+	mutex_lock(&nft_net->reset_mutex);
 	rcu_read_lock();
 
 	err = nft_set_dump_ctx_init(&dump_ctx, skb, info, nla, true);
@@ -6690,7 +6689,7 @@ static int nf_tables_getsetelem_reset(struct sk_buff *skb,
 
 out_unlock:
 	rcu_read_unlock();
-	mutex_unlock(&nft_net->commit_mutex);
+	mutex_unlock(&nft_net->reset_mutex);
 	rcu_read_lock();
 	module_put(THIS_MODULE);
 
@@ -8552,9 +8551,9 @@ static int nf_tables_dumpreset_obj(struct sk_buff *skb,
 	struct nftables_pernet *nft_net = nft_pernet(sock_net(skb->sk));
 	int ret;
 
-	mutex_lock(&nft_net->commit_mutex);
+	mutex_lock(&nft_net->reset_mutex);
 	ret = nf_tables_dump_obj(skb, cb);
-	mutex_unlock(&nft_net->commit_mutex);
+	mutex_unlock(&nft_net->reset_mutex);
 
 	return ret;
 }
@@ -8693,9 +8692,9 @@ static int nf_tables_getobj_reset(struct sk_buff *skb,
 	if (!try_module_get(THIS_MODULE))
 		return -EINVAL;
 	rcu_read_unlock();
-	mutex_lock(&nft_net->commit_mutex);
+	mutex_lock(&nft_net->reset_mutex);
 	skb2 = nf_tables_getobj_single(portid, info, nla, true);
-	mutex_unlock(&nft_net->commit_mutex);
+	mutex_unlock(&nft_net->reset_mutex);
 	rcu_read_lock();
 	module_put(THIS_MODULE);
 
@@ -12194,6 +12193,7 @@ static int __net_init nf_tables_init_net(struct net *net)
 	INIT_LIST_HEAD(&nft_net->module_list);
 	INIT_LIST_HEAD(&nft_net->notify_list);
 	mutex_init(&nft_net->commit_mutex);
+	mutex_init(&nft_net->reset_mutex);
 	net->nft.base_seq = 1;
 	nft_net->gc_seq = 0;
 	nft_net->validate_state = NFT_VALIDATE_SKIP;
-- 
2.47.3

