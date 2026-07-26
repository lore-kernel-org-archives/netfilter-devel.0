Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 583C0364926
	for <netfilter-devel@vger.kernel.org>; Sun, 26 Jul 2026 12:04:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785067456; cv=none; b=GTdOkJDRbFm0MO+RK8UB0RFItm20z2nNoDSTZEOZjqGPR09AuyhFW/ZqwJX1TrnBnsudgkAgehE0rgjGHu8hIh6GWnNZC7g4r//UMTbWHM5jxyg5rsV5R8qdaIoxxUgj9poOd8Pp1cCRwRGohuqzcYLjKRaLFR4GWrQkelshpQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785067456; c=relaxed/simple;
	bh=FGKsV8ImoPCSFyQuOs3PPXSenkfS7k0qbXsw6/gJzE8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=skhS7TVzziPSsT1XiA8kblxYlozN8qm/cuVV8jtFkyjlwtTaNmsQTsiaYXNrepRq01f6ySW05CjmwK/n2fbrM4iMw2Z91Qwsmb2KGfywGh1UBhDsnGnGMqlczL02AOZ7jdKVRgD+/5SLbfDPwUPabNpZbYP5fCHT7vjElbVA/Ps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XKVTSh7D; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XKVTSh7D"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2caea3f742bso23704125ad.0
        for <netfilter-devel@vger.kernel.org>; Sun, 26 Jul 2026 05:04:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785067454; x=1785672254; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3fMoyd4/5L04YOQj1O1Wm3TJLLgmkpWw9olt1eyRhmg=;
        b=XKVTSh7DAfcmF4UWx7+rlchYP+EVgei/vVr+CsesJb3Kt7iwWqzjPFLrj7Uowsr5wk
         4rBsoWMuhgnnnDsCB3DvSXBFabl+VXWR/aJidkftg+XXn33aP3idpNgI7s5e1CTucW5D
         geQBODeA7iRf9k0Qwa1m5p24VOwy5eZRsd2SIPrWzPnYq+OkIJej1T8eAloOsfiJWiZh
         2qPuWTkI2E7ha8x2X04zb17Ab3UhYcQ7BP/gdMP9uR0j9+k9H88JLnDBODQ4d7bLz00M
         w6xzb8kHS7Vmn6l2XFNS8T7sg5BWAjxw7H8MIWnt6qzVMA6dsPVfo0D0F9nVvzKRMrOV
         Q3og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785067454; x=1785672254;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=3fMoyd4/5L04YOQj1O1Wm3TJLLgmkpWw9olt1eyRhmg=;
        b=Al8bjg6HQYcct/bk2Y8PUrapCJH6AcYcacLiOIufKuKTRQE8Prw/V0Z8+4k2XoVVHm
         oDlCZbzuX8HkVq4PWbOFpYaO90nc0CxxzSMdmAqh8AEWoy2jqcMNz1nNSyZmNUTAW3Lx
         9ueyqjtl64/yVG0zYLZKn33SFfbitlARuYqJQ40rWSXGHQP7x4u840dRX/FZRhTv/FTf
         9H3x1z5hDX+N96pK6Y+CctkSUISkyb8aucUsXCglVNRt2bJDoNi+dVgY6+zIrhwkxi61
         ZL9Pw3NwaiydzRuyrlJBn5EgIvddA6Exeaa+Z1vWLIP945EEbL7YjwajwImdXp3Crz0X
         RT8w==
X-Forwarded-Encrypted: i=1; AHgh+RreA76CfcIfrQvw8X1XalOjlIbIkbdiYsgC5KV/q8k+TihNt+9wFZtrDKnzGhb1J8GWhDmQpFlSVTK8J0ChvCA=@vger.kernel.org
X-Gm-Message-State: AOJu0YytuKBZ3KIxzvm88OqYQoyUj36m0C7rJgzroamdNHDK3EYv6yae
	KNs6aQl7cGs2PWgCahZ+DfYzzSso2uLfeMoymh6OE0LyV5b7hq/cOIKG
X-Gm-Gg: AR+sD10XCAIKw/g0Tt/t5Evk3anf8S9M1GKZXhM5HyES0CUC0gDE8QMjmplcugRYfxg
	2myxeymnAc830ximBMaBd+vYoJLUqZ8M3JBIwwHXtEOVU9atUprrKr2gRW1NhSMaEbkIU8qj7UI
	OrFD6lgzl+E7cOrfcIUh9I3GgVpwk4jk54hFwN4/O5OTF7/75EShG3KTAV/5n6jEn6FnLiP+v9+
	3Vwlfs7UErp5aPaOrzkjy/HWfCkIDiZeI2KqAXozXlFLqVS8RyzpBdOwaKy3yrwwsI1Mp1gaZBe
	l8oXgNcJMUNqfuIcpyNoYA9Niu3s9vDUqQWGmv9BbJTyg0KPnZPIxsX0yQykgyJlvGTUiKKQu7M
	dmwn1RoPRfWqCYKemtouAzISfcKdnmEZUNS4gir5h8M5591JWpXb0/yCEYB9pDVOARCkcFfye/3
	wKc2RVi4nFmQ==
X-Received: by 2002:a17:902:e80a:b0:2ce:b096:e517 with SMTP id d9443c01a7336-2cfde67c05dmr49489305ad.5.1785067453412;
        Sun, 26 Jul 2026 05:04:13 -0700 (PDT)
Received: from bogon ([2408:8207:1832:1b44::c6b])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cfde59b451sm20020865ad.13.2026.07.26.05.04.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Jul 2026 05:04:12 -0700 (PDT)
From: Weiming Shi <bestswngs@gmail.com>
To: Claudiu Manoil <claudiu.manoil@nxp.com>,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Cong Wang <xiyou.wangcong@gmail.com>,
	Jiri Pirko <jiri@resnulli.us>
Cc: netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	syzbot+5a66db916cdde0dbcc1c@syzkaller.appspotmail.com,
	Xiang Mei <xmei5@asu.edu>,
	stable@vger.kernel.org
Subject: [PATCH net v2] net: flow_offload: serialize driver callback lists
Date: Sun, 26 Jul 2026 05:03:15 -0700
Message-ID: <20260726120338.488658-1-bestswngs@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260719175028.988301-2-bestswngs@gmail.com>
References: <20260719175028.988301-2-bestswngs@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Drivers keep flow_block_cb objects on callback lists which are often
shared globally. TC setup normally runs under RTNL, but nftables invokes
ndo_setup_tc() while holding only its per-netns commit mutex. Concurrent
transactions in different netns can therefore corrupt a shared driver
callback list.

The same list can also be changed after ndo_setup_tc() returns. If filter
replay fails while binding a TC block, tcf_block_bind() removes and frees
callbacks from its error path without synchronizing against an nftables
transaction walking the driver list.

Add a flow-offload callback mutex and hold it across direct and indirect
setup, callback ownership transfer and rollback. Move indirect-unregister
list removal into the flow-offload core, and keep indirect-device
registration transactional on setup failure. When TC must reject an
indirect bind after callback installation, unwind only the callbacks
created by that bind so existing callbacks remain intact.

Initialize the auxiliary callback list nodes so common error paths can
safely detach them. ENETC also inspects its callback list outside the
setup callback, so protect those accesses with the same mutex.

This fixes the following netdevsim failure:

  list_del corruption. next->prev should be ffff88800b3e30c0,
  but was ffff88800b539e40.
  WARNING: CPU: 0 PID: 79 at lib/list_debug.c:65
  RIP: __list_del_entry_valid_or_report
  flow_block_cb_setup_simple
  nft_block_offload_cmd
  nft_flow_rule_offload_commit
  nf_tables_commit
  nfnetlink_rcv_batch

Fixes: c9626a2cbdb2 ("netfilter: nf_tables: add hardware offload support")
Reported-by: Xiang Mei <xmei5@asu.edu>
Link: https://lore.kernel.org/netdev/20260719175028.988301-2-bestswngs@gmail.com/
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
---

v2:
  - Move serialization to common flow-offload paths, including rollback and indirect cleanup.
  - Preserve existing callbacks when an indirect bind fails.
    
  v1: https://lore.kernel.org/netdev/20260719175028.988301-2-bestswngs@gmail.com/
  review: https://lore.kernel.org/netdev/20260724142321.GL418547@horms.kernel.org/

 .../net/ethernet/freescale/enetc/enetc_qos.c  | 27 ++++--
 include/net/flow_offload.h                    |  6 +-
 net/core/flow_offload.c                       | 77 +++++++++++++++--
 net/netfilter/nf_flow_table_offload.c         | 28 +++---
 net/netfilter/nf_tables_offload.c             | 18 +++-
 net/sched/act_api.c                           |  4 +-
 net/sched/cls_api.c                           | 86 ++++++++++++++++---
 7 files changed, 201 insertions(+), 45 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_qos.c b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
index 7b17bca24f26..c994f878cacd 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_qos.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
@@ -1601,30 +1601,41 @@ int enetc_set_psfp(struct net_device *ndev, bool en)
 
 int enetc_psfp_init(struct enetc_ndev_priv *priv)
 {
+	int err = 0;
+
+	flow_block_cb_lock();
 	if (epsfp.psfp_sfi_bitmap)
-		return 0;
+		goto out;
 
 	epsfp.psfp_sfi_bitmap = bitmap_zalloc(priv->psfp_cap.max_psfp_filter,
 					      GFP_KERNEL);
-	if (!epsfp.psfp_sfi_bitmap)
-		return -ENOMEM;
+	if (!epsfp.psfp_sfi_bitmap) {
+		err = -ENOMEM;
+		goto out;
+	}
 
 	spin_lock_init(&epsfp.psfp_lock);
 
 	if (list_empty(&enetc_block_cb_list))
 		epsfp.dev_bitmap = 0;
 
-	return 0;
+out:
+	flow_block_cb_unlock();
+	return err;
 }
 
 int enetc_psfp_clean(struct enetc_ndev_priv *priv)
 {
-	if (!list_empty(&enetc_block_cb_list))
-		return -EBUSY;
+	int err = -EBUSY;
 
-	clean_psfp_all();
+	flow_block_cb_lock();
+	if (list_empty(&enetc_block_cb_list)) {
+		clean_psfp_all();
+		err = 0;
+	}
+	flow_block_cb_unlock();
 
-	return 0;
+	return err;
 }
 
 int enetc_setup_tc_psfp(struct net_device *ndev, void *type_data)
diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index 70a02ee14308..96a46ba2769d 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -647,6 +647,8 @@ struct flow_block_cb *flow_block_cb_lookup(struct flow_block *block,
 void *flow_block_cb_priv(struct flow_block_cb *block_cb);
 void flow_block_cb_incref(struct flow_block_cb *block_cb);
 unsigned int flow_block_cb_decref(struct flow_block_cb *block_cb);
+void flow_block_cb_lock(void);
+void flow_block_cb_unlock(void);
 
 static inline void flow_block_cb_add(struct flow_block_cb *block_cb,
 				     struct flow_block_offload *offload)
@@ -741,7 +743,9 @@ void flow_indr_dev_unregister(flow_indr_block_bind_cb_t *cb, void *cb_priv,
 int flow_indr_dev_setup_offload(struct net_device *dev, struct Qdisc *sch,
 				enum tc_setup_type type, void *data,
 				struct flow_block_offload *bo,
-				void (*cleanup)(struct flow_block_cb *block_cb));
+				void (*cleanup)(struct flow_block_cb *block_cb),
+				bool *indr_dev_added);
+void flow_indr_dev_setup_abort(void *data);
 bool flow_indr_dev_exists(void);
 
 #endif /* _NET_FLOW_OFFLOAD_H */
diff --git a/net/core/flow_offload.c b/net/core/flow_offload.c
index 5071d7fe6ce2..0b4d2a2cbaf8 100644
--- a/net/core/flow_offload.c
+++ b/net/core/flow_offload.c
@@ -270,6 +270,8 @@ struct flow_block_cb *flow_block_cb_alloc(flow_setup_cb_t *cb,
 	block_cb->cb_ident = cb_ident;
 	block_cb->cb_priv = cb_priv;
 	block_cb->release = release;
+	INIT_LIST_HEAD(&block_cb->driver_list);
+	INIT_LIST_HEAD(&block_cb->indr.list);
 
 	return block_cb;
 }
@@ -317,11 +319,27 @@ unsigned int flow_block_cb_decref(struct flow_block_cb *block_cb)
 }
 EXPORT_SYMBOL(flow_block_cb_decref);
 
+static DEFINE_MUTEX(flow_block_cb_mutex);
+
+void flow_block_cb_lock(void)
+{
+	mutex_lock(&flow_block_cb_mutex);
+}
+EXPORT_SYMBOL(flow_block_cb_lock);
+
+void flow_block_cb_unlock(void)
+{
+	mutex_unlock(&flow_block_cb_mutex);
+}
+EXPORT_SYMBOL(flow_block_cb_unlock);
+
 bool flow_block_cb_is_busy(flow_setup_cb_t *cb, void *cb_ident,
 			   struct list_head *driver_block_list)
 {
 	struct flow_block_cb *block_cb;
 
+	lockdep_assert_held(&flow_block_cb_mutex);
+
 	list_for_each_entry(block_cb, driver_block_list, driver_list) {
 		if (block_cb->cb == cb &&
 		    block_cb->cb_ident == cb_ident)
@@ -340,6 +358,8 @@ int flow_block_cb_setup_simple(struct flow_block_offload *f,
 {
 	struct flow_block_cb *block_cb;
 
+	lockdep_assert_held(&flow_block_cb_mutex);
+
 	if (ingress_only &&
 	    f->binder_type != FLOW_BLOCK_BINDER_TYPE_CLSACT_INGRESS)
 		return -EOPNOTSUPP;
@@ -431,12 +451,14 @@ int flow_indr_dev_register(flow_indr_block_bind_cb_t *cb, void *cb_priv)
 {
 	struct flow_indr_dev *indr_dev;
 
+	flow_block_cb_lock();
 	mutex_lock(&flow_indr_block_lock);
 	list_for_each_entry(indr_dev, &flow_block_indr_dev_list, list) {
 		if (indr_dev->cb == cb &&
 		    indr_dev->cb_priv == cb_priv) {
 			refcount_inc(&indr_dev->refcnt);
 			mutex_unlock(&flow_indr_block_lock);
+			flow_block_cb_unlock();
 			return 0;
 		}
 	}
@@ -444,12 +466,14 @@ int flow_indr_dev_register(flow_indr_block_bind_cb_t *cb, void *cb_priv)
 	indr_dev = flow_indr_dev_alloc(cb, cb_priv);
 	if (!indr_dev) {
 		mutex_unlock(&flow_indr_block_lock);
+		flow_block_cb_unlock();
 		return -ENOMEM;
 	}
 
 	list_add(&indr_dev->list, &flow_block_indr_dev_list);
 	existing_qdiscs_register(cb, cb_priv);
 	mutex_unlock(&flow_indr_block_lock);
+	flow_block_cb_unlock();
 
 	tcf_action_reoffload_cb(cb, cb_priv, true);
 
@@ -465,8 +489,10 @@ static void __flow_block_indr_cleanup(void (*release)(void *cb_priv),
 
 	list_for_each_entry_safe(this, next, &flow_block_indr_list, indr.list) {
 		if (this->release == release &&
-		    this->indr.cb_priv == cb_priv)
+		    this->indr.cb_priv == cb_priv) {
+			list_del_init(&this->driver_list);
 			list_move(&this->indr.list, cleanup_list);
+		}
 	}
 }
 
@@ -486,6 +512,7 @@ void flow_indr_dev_unregister(flow_indr_block_bind_cb_t *cb, void *cb_priv,
 	struct flow_indr_dev *this, *next, *indr_dev = NULL;
 	LIST_HEAD(cleanup_list);
 
+	flow_block_cb_lock();
 	mutex_lock(&flow_indr_block_lock);
 	list_for_each_entry_safe(this, next, &flow_block_indr_dev_list, list) {
 		if (this->cb == cb &&
@@ -499,11 +526,13 @@ void flow_indr_dev_unregister(flow_indr_block_bind_cb_t *cb, void *cb_priv,
 
 	if (!indr_dev) {
 		mutex_unlock(&flow_indr_block_lock);
+		flow_block_cb_unlock();
 		return;
 	}
 
 	__flow_block_indr_cleanup(release, cb_priv, &cleanup_list);
 	mutex_unlock(&flow_indr_block_lock);
+	flow_block_cb_unlock();
 
 	tcf_action_reoffload_cb(cb, cb_priv, false);
 	flow_block_indr_notify(&cleanup_list);
@@ -603,18 +632,31 @@ static int indir_dev_remove(void *data)
 int flow_indr_dev_setup_offload(struct net_device *dev,	struct Qdisc *sch,
 				enum tc_setup_type type, void *data,
 				struct flow_block_offload *bo,
-				void (*cleanup)(struct flow_block_cb *block_cb))
+				void (*cleanup)(struct flow_block_cb *block_cb),
+				bool *indr_dev_added)
 {
 	struct flow_indr_dev *this;
 	u32 count = 0;
 	int err;
 
+	lockdep_assert_held(&flow_block_cb_mutex);
+
+	if (indr_dev_added)
+		*indr_dev_added = false;
+
 	mutex_lock(&flow_indr_block_lock);
 	if (bo) {
-		if (bo->command == FLOW_BLOCK_BIND)
-			indir_dev_add(data, dev, sch, type, cleanup, bo);
-		else if (bo->command == FLOW_BLOCK_UNBIND)
+		if (bo->command == FLOW_BLOCK_BIND) {
+			err = indir_dev_add(data, dev, sch, type, cleanup, bo);
+			if (!err) {
+				if (indr_dev_added)
+					*indr_dev_added = true;
+			} else if (err != -EEXIST) {
+				goto out_unlock;
+			}
+		} else if (bo->command == FLOW_BLOCK_UNBIND) {
 			indir_dev_remove(data);
+		}
 	}
 
 	list_for_each_entry(this, &flow_block_indr_dev_list, list) {
@@ -623,14 +665,35 @@ int flow_indr_dev_setup_offload(struct net_device *dev,	struct Qdisc *sch,
 			count++;
 	}
 
+	err = (bo && list_empty(&bo->cb_list)) ? -EOPNOTSUPP : count;
+
+out_unlock:
 	mutex_unlock(&flow_indr_block_lock);
 
-	return (bo && list_empty(&bo->cb_list)) ? -EOPNOTSUPP : count;
+	return err;
 }
 EXPORT_SYMBOL(flow_indr_dev_setup_offload);
 
+void flow_indr_dev_setup_abort(void *data)
+{
+	lockdep_assert_held(&flow_block_cb_mutex);
+
+	mutex_lock(&flow_indr_block_lock);
+	WARN_ON_ONCE(indir_dev_remove(data));
+	mutex_unlock(&flow_indr_block_lock);
+}
+EXPORT_SYMBOL(flow_indr_dev_setup_abort);
+
 bool flow_indr_dev_exists(void)
 {
-	return !list_empty(&flow_block_indr_dev_list);
+	bool exists;
+
+	flow_block_cb_lock();
+	mutex_lock(&flow_indr_block_lock);
+	exists = !list_empty(&flow_block_indr_dev_list);
+	mutex_unlock(&flow_indr_block_lock);
+	flow_block_cb_unlock();
+
+	return exists;
 }
 EXPORT_SYMBOL(flow_indr_dev_exists);
diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index 801a3dd9ceea..2612978b27b4 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -1186,7 +1186,6 @@ static int nf_flow_table_block_setup(struct nf_flowtable *flowtable,
 	struct flow_block_cb *block_cb, *next;
 	int err = 0;
 
-	down_write(&flowtable->flow_block_lock);
 	switch (cmd) {
 	case FLOW_BLOCK_BIND:
 		list_splice(&bo->cb_list, &flowtable->flow_block.cb_list);
@@ -1201,8 +1200,6 @@ static int nf_flow_table_block_setup(struct nf_flowtable *flowtable,
 		WARN_ON_ONCE(1);
 		err = -EOPNOTSUPP;
 	}
-	up_write(&flowtable->flow_block_lock);
-
 	return err;
 }
 
@@ -1230,7 +1227,6 @@ static void nf_flow_table_indr_cleanup(struct flow_block_cb *block_cb)
 	nf_flow_table_gc_cleanup(flowtable, dev);
 	down_write(&flowtable->flow_block_lock);
 	list_del(&block_cb->list);
-	list_del(&block_cb->driver_list);
 	flow_block_cb_free(block_cb);
 	up_write(&flowtable->flow_block_lock);
 }
@@ -1239,13 +1235,15 @@ static int nf_flow_table_indr_offload_cmd(struct flow_block_offload *bo,
 					  struct nf_flowtable *flowtable,
 					  struct net_device *dev,
 					  enum flow_block_command cmd,
-					  struct netlink_ext_ack *extack)
+					  struct netlink_ext_ack *extack,
+					  bool *indr_dev_added)
 {
 	nf_flow_table_block_offload_init(bo, dev_net(dev), cmd, flowtable,
 					 extack);
 
 	return flow_indr_dev_setup_offload(dev, NULL, TC_SETUP_FT, flowtable, bo,
-					   nf_flow_table_indr_cleanup);
+					   nf_flow_table_indr_cleanup,
+					   indr_dev_added);
 }
 
 static int nf_flow_table_offload_cmd(struct flow_block_offload *bo,
@@ -1258,9 +1256,7 @@ static int nf_flow_table_offload_cmd(struct flow_block_offload *bo,
 
 	nf_flow_table_block_offload_init(bo, dev_net(dev), cmd, flowtable,
 					 extack);
-	down_write(&flowtable->flow_block_lock);
 	err = dev->netdev_ops->ndo_setup_tc(dev, TC_SETUP_FT, bo);
-	up_write(&flowtable->flow_block_lock);
 	if (err < 0)
 		return err;
 
@@ -1273,21 +1269,29 @@ int nf_flow_table_offload_setup(struct nf_flowtable *flowtable,
 {
 	struct netlink_ext_ack extack = {};
 	struct flow_block_offload bo;
+	bool indr_dev_added = false;
 	int err;
 
 	if (!nf_flowtable_hw_offload(flowtable))
 		return nf_flow_offload_xdp_setup(flowtable, dev, cmd);
 
+	flow_block_cb_lock();
+	down_write(&flowtable->flow_block_lock);
 	if (dev->netdev_ops->ndo_setup_tc)
 		err = nf_flow_table_offload_cmd(&bo, flowtable, dev, cmd,
 						&extack);
 	else
 		err = nf_flow_table_indr_offload_cmd(&bo, flowtable, dev, cmd,
-						     &extack);
-	if (err < 0)
-		return err;
+						     &extack,
+						     &indr_dev_added);
+	if (err >= 0)
+		err = nf_flow_table_block_setup(flowtable, &bo, cmd);
+	if (err < 0 && indr_dev_added)
+		flow_indr_dev_setup_abort(flowtable);
+	up_write(&flowtable->flow_block_lock);
+	flow_block_cb_unlock();
 
-	return nf_flow_table_block_setup(flowtable, &bo, cmd);
+	return err;
 }
 EXPORT_SYMBOL_GPL(nf_flow_table_offload_setup);
 
diff --git a/net/netfilter/nf_tables_offload.c b/net/netfilter/nf_tables_offload.c
index 8998a24651ff..7189e8c4e5a0 100644
--- a/net/netfilter/nf_tables_offload.c
+++ b/net/netfilter/nf_tables_offload.c
@@ -414,7 +414,6 @@ static void nft_indr_block_cleanup(struct flow_block_cb *block_cb)
 				    basechain, &extack);
 	nft_net = nft_pernet(net);
 	mutex_lock(&nft_net->commit_mutex);
-	list_del(&block_cb->driver_list);
 	list_move(&block_cb->list, &bo.cb_list);
 	nft_flow_offload_unbind(&bo, basechain);
 	mutex_unlock(&nft_net->commit_mutex);
@@ -426,19 +425,28 @@ static int nft_indr_block_offload_cmd(struct nft_base_chain *basechain,
 {
 	struct netlink_ext_ack extack = {};
 	struct flow_block_offload bo;
+	bool indr_dev_added = false;
 	int err;
 
 	nft_flow_block_offload_init(&bo, dev_net(dev), cmd, basechain, &extack);
 
 	err = flow_indr_dev_setup_offload(dev, NULL, TC_SETUP_BLOCK, basechain, &bo,
-					  nft_indr_block_cleanup);
-	if (err < 0)
+					  nft_indr_block_cleanup,
+					  &indr_dev_added);
+	if (err < 0) {
+		if (indr_dev_added)
+			flow_indr_dev_setup_abort(basechain);
 		return err;
+	}
 
 	if (list_empty(&bo.cb_list))
 		return -EOPNOTSUPP;
 
-	return nft_block_setup(basechain, &bo, cmd);
+	err = nft_block_setup(basechain, &bo, cmd);
+	if (err < 0 && indr_dev_added)
+		flow_indr_dev_setup_abort(basechain);
+
+	return err;
 }
 
 static int nft_chain_offload_cmd(struct nft_base_chain *basechain,
@@ -447,10 +455,12 @@ static int nft_chain_offload_cmd(struct nft_base_chain *basechain,
 {
 	int err;
 
+	flow_block_cb_lock();
 	if (dev->netdev_ops->ndo_setup_tc)
 		err = nft_block_offload_cmd(basechain, dev, cmd);
 	else
 		err = nft_indr_block_offload_cmd(basechain, dev, cmd);
+	flow_block_cb_unlock();
 
 	return err;
 }
diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index f141634df214..317b026f0463 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -205,8 +205,10 @@ static int tcf_action_offload_cmd_ex(struct flow_offload_action *fl_act,
 {
 	int err;
 
+	flow_block_cb_lock();
 	err = flow_indr_dev_setup_offload(NULL, NULL, TC_SETUP_ACT,
-					  fl_act, NULL, NULL);
+					  fl_act, NULL, NULL, NULL);
+	flow_block_cb_unlock();
 	if (err < 0)
 		return err;
 
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index fee4524adc98..1c230e33e1a5 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -808,7 +808,6 @@ static void tc_block_indr_cleanup(struct flow_block_cb *block_cb)
 			       &extack);
 	rtnl_lock();
 	down_write(&block->cb_lock);
-	list_del(&block_cb->driver_list);
 	list_move(&block_cb->list, &bo.cb_list);
 	tcf_block_unbind(block, &bo);
 	up_write(&block->cb_lock);
@@ -824,17 +823,20 @@ static int tcf_block_offload_cmd(struct tcf_block *block,
 				 struct net_device *dev, struct Qdisc *sch,
 				 struct tcf_block_ext_info *ei,
 				 enum flow_block_command command,
-				 struct netlink_ext_ack *extack)
+				 struct netlink_ext_ack *extack,
+				 bool *indr_dev_added,
+				 unsigned int *indr_cb_count,
+				 bool *indr_unlocked_driver_cb)
 {
 	struct flow_block_offload bo = {};
+	unsigned int cb_count;
+	int err;
 
 	tcf_block_offload_init(&bo, dev, sch, command, ei->binder_type,
 			       &block->flow_block, tcf_block_shared(block),
 			       extack);
 
 	if (dev->netdev_ops->ndo_setup_tc) {
-		int err;
-
 		err = dev->netdev_ops->ndo_setup_tc(dev, TC_SETUP_BLOCK, &bo);
 		if (err < 0) {
 			if (err != -EOPNOTSUPP)
@@ -845,21 +847,66 @@ static int tcf_block_offload_cmd(struct tcf_block *block,
 		return tcf_block_setup(block, &bo);
 	}
 
-	flow_indr_dev_setup_offload(dev, sch, TC_SETUP_BLOCK, block, &bo,
-				    tc_block_indr_cleanup);
-	tcf_block_setup(block, &bo);
+	err = flow_indr_dev_setup_offload(dev, sch, TC_SETUP_BLOCK, block, &bo,
+					  tc_block_indr_cleanup,
+					  indr_dev_added);
+	if (err < 0)
+		return err;
+	cb_count = list_count_nodes(&bo.cb_list);
+	err = tcf_block_setup(block, &bo);
+	if (err)
+		return err;
+	if (indr_cb_count)
+		*indr_cb_count = cb_count;
+	if (indr_unlocked_driver_cb)
+		*indr_unlocked_driver_cb = bo.unlocked_driver_cb;
 
 	return -EOPNOTSUPP;
 }
 
+static void
+tcf_block_indr_bind_rollback(struct tcf_block *block, struct net_device *dev,
+			     struct Qdisc *sch, struct tcf_block_ext_info *ei,
+			     unsigned int cb_count, bool unlocked_driver_cb,
+			     bool remove_indr_dev)
+{
+	struct flow_block_offload bo = {};
+	struct flow_block_cb *block_cb;
+
+	tcf_block_offload_init(&bo, dev, sch, FLOW_BLOCK_UNBIND,
+			       ei->binder_type, &block->flow_block,
+			       tcf_block_shared(block), NULL);
+	bo.unlocked_driver_cb = unlocked_driver_cb;
+
+	if (remove_indr_dev)
+		flow_indr_dev_setup_abort(block);
+
+	/* tcf_block_bind() splices this bind's callbacks at the list head. */
+	while (cb_count--) {
+		if (WARN_ON_ONCE(list_empty(&block->flow_block.cb_list)))
+			break;
+
+		block_cb = list_first_entry(&block->flow_block.cb_list,
+					    struct flow_block_cb, list);
+		list_del_init(&block_cb->driver_list);
+		list_del_init(&block_cb->indr.list);
+		list_move(&block_cb->list, &bo.cb_list);
+	}
+	tcf_block_unbind(block, &bo);
+}
+
 static int tcf_block_offload_bind(struct tcf_block *block, struct Qdisc *q,
 				  struct tcf_block_ext_info *ei,
 				  struct netlink_ext_ack *extack)
 {
 	struct net_device *dev = q->dev_queue->dev;
+	bool indr_unlocked_driver_cb = false;
+	bool indr_dev_added = false;
+	unsigned int indr_cb_count = 0;
 	int err;
 
 	down_write(&block->cb_lock);
+	flow_block_cb_lock();
 
 	/* If tc offload feature is disabled and the block we try to bind
 	 * to already has some offloaded filters, forbid to bind.
@@ -872,14 +919,15 @@ static int tcf_block_offload_bind(struct tcf_block *block, struct Qdisc *q,
 		goto err_unlock;
 	}
 
-	err = tcf_block_offload_cmd(block, dev, q, ei, FLOW_BLOCK_BIND, extack);
+	err = tcf_block_offload_cmd(block, dev, q, ei, FLOW_BLOCK_BIND, extack,
+				    &indr_dev_added, &indr_cb_count,
+				    &indr_unlocked_driver_cb);
 	if (err == -EOPNOTSUPP)
 		goto no_offload_dev_inc;
 	if (err)
 		goto err_unlock;
 
-	up_write(&block->cb_lock);
-	return 0;
+	goto out_unlock;
 
 no_offload_dev_inc:
 	if (tcf_block_offload_in_use(block))
@@ -888,6 +936,15 @@ static int tcf_block_offload_bind(struct tcf_block *block, struct Qdisc *q,
 	err = 0;
 	block->nooffloaddevcnt++;
 err_unlock:
+	if (err && indr_cb_count)
+		tcf_block_indr_bind_rollback(block, dev, q, ei,
+					     indr_cb_count,
+					     indr_unlocked_driver_cb,
+					     indr_dev_added);
+	else if (err && indr_dev_added)
+		flow_indr_dev_setup_abort(block);
+out_unlock:
+	flow_block_cb_unlock();
 	up_write(&block->cb_lock);
 	return err;
 }
@@ -899,14 +956,18 @@ static void tcf_block_offload_unbind(struct tcf_block *block, struct Qdisc *q,
 	int err;
 
 	down_write(&block->cb_lock);
-	err = tcf_block_offload_cmd(block, dev, q, ei, FLOW_BLOCK_UNBIND, NULL);
+	flow_block_cb_lock();
+	err = tcf_block_offload_cmd(block, dev, q, ei, FLOW_BLOCK_UNBIND, NULL,
+				    NULL, NULL, NULL);
 	if (err == -EOPNOTSUPP)
 		goto no_offload_dev_dec;
+	flow_block_cb_unlock();
 	up_write(&block->cb_lock);
 	return;
 
 no_offload_dev_dec:
 	WARN_ON(block->nooffloaddevcnt-- == 0);
+	flow_block_cb_unlock();
 	up_write(&block->cb_lock);
 }
 
@@ -1649,7 +1710,8 @@ static int tcf_block_bind(struct tcf_block *block,
 
 err_unroll:
 	list_for_each_entry_safe(block_cb, next, &bo->cb_list, list) {
-		list_del(&block_cb->driver_list);
+		list_del_init(&block_cb->driver_list);
+		list_del_init(&block_cb->indr.list);
 		if (i-- > 0) {
 			list_del(&block_cb->list);
 			tcf_block_playback_offloads(block, block_cb->cb,
-- 
2.55.0

