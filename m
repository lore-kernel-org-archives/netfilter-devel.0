Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC48514F9F9;
	Sat,  8 Mar 2025 04:47:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741409251; cv=none; b=PeALiap0DPb56qUUx1N8k0EXYm1b50OhUyTnO8QJ+sdD5dp/6ON5lvbbpIK7eg5mLqQCS2GUOWzzM+BSL0hvsiNkWVS+i2THKmd4LVxg1FjzyLUKBnfIzWnYU7WKmM3JMkBm/fXVandYTfjbwiru0yB6M1yyhJCCGaeaxXDnrZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741409251; c=relaxed/simple;
	bh=3D+jBVMDzdXxgRO9ALyXgoL5Ci0t9RS4IUEZ1fzWwNc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hMQevH8cQ1jvpfoHyMhkhj0i9FSwrNXqyQdzAoY8+3DPHsPyevSFDUdeID5t0vSdhPGxMnsP3CME/RqF83kBaWBE2W8N/1jdKyCJrJoTryYgT5Qn4CblIlqlFwA/MYISuHlxuczzdvZJII6y3lQlawL4bHjIusvlq2jPi4rQ5Vw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fomichev.me; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fomichev.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-223f4c06e9fso46002235ad.1;
        Fri, 07 Mar 2025 20:47:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741409248; x=1742014048;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4U+v02y8A/g8OHY3lp2PwT5cFAoICJB3r4pAyC2rR4s=;
        b=uhiCZ/InrCkc+Z/5Ls4rh2BOcZ1ihDCbRKJY6xuC6eGQzrcXgzFjyYjqD+LXhGt2gj
         wC3iAJDVXqBC4cl0eKN3GwGR/25EVdNz1hYDZdkqkscQ9DdTQoC9t1jQcJu90qe699Er
         vKcJnL3oDaFaUpFwxpK+LU4ke5OfhpWpJkYUkY4q5FenfQ0VQhEvDzmSGLPwB5NbFzRz
         oZVlETn8KSzEmj6Cp+ymQHCt51AZR6K+ODaMeXM+edUXLsuyEptaiAswf442b/bJ4itZ
         89G7H2pdhlfoz9vJdwRDq/R0nuy3vsRhX9Es7S75hjWrWiLCaSmkuJljWQRfm0h0KlFC
         Ce4Q==
X-Forwarded-Encrypted: i=1; AJvYcCUl5s6bnSbk/6wpNlt9Jf8fbq8zL8Xz4TsPuE5N40wFVWqjmLRz3ziHYUbuiJ1CBOjP9ZT2EqNGy1YTfMjy@vger.kernel.org, AJvYcCVR6cXNCdvOuFzCcdhM24dm5pbVHrXVRJHF20PTu7iGInTo14ZT7s+akx2VFDW0i6rVbwUkJZrPIexDdV0mqHYz@vger.kernel.org, AJvYcCXiiE8w+IazvXetXH/Re8FN0rpLgrkuehZL4HeNGJHO96m3euYJfiynKM+Te7fbxX5rqCoy6pog6dE=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywle7cpDYXV8MIBFxz72asJs5jprCgdu85tOpUIBqTVhjOCeb9B
	oQ/b+kFIEBXX4jel6xCyOo5IyTjE0osRoUAi8iWJbrtc0tsuPIk1uFpz
X-Gm-Gg: ASbGncv/Pbqun8vuXDLgI/vtweVX3F8HFEhTJ2oopikWuW4p253mUo+l0cBysNM5wz2
	KDduJQiowKqLgp+kHnAqtAuy8Ycahbj1+Mr7ATi2AxBU2TX8MK60jmRrj/4vQW6i4rY6CmOd4bA
	sMSMSbjjdhXOnglAnbSR+Y4cgc0dyanf9dJljGAbarnvwycQUgrSS6gQAOGC0HHtQe4uTWrbl9j
	KAZoqiZT+2/TxzDUmeZhEqeEkG21XvD16j9gjmHQ7plRoXXFjgjqr0Scn5r2D89foiZBYUj7ps/
	eFhdWl4UqxvM4OyqE9Fympr0Y2JdLDWA/0PUppb9owLV
X-Google-Smtp-Source: AGHT+IFvsy6lprMK571V0NeoIWSZXlEdfTZEorJ3/9ymxQYI8szWuk8UX/tC3Jhz288kniaU0D0D5g==
X-Received: by 2002:a17:902:e5c4:b0:223:607c:1d99 with SMTP id d9443c01a7336-2244b098559mr41725445ad.0.1741409248256;
        Fri, 07 Mar 2025 20:47:28 -0800 (PST)
Received: from localhost ([2601:646:9e00:f56e:2844:3d8f:bf3e:12cc])
        by smtp.gmail.com with UTF8SMTPSA id d9443c01a7336-22410ab8babsm38817355ad.251.2025.03.07.20.47.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Mar 2025 20:47:27 -0800 (PST)
From: Stanislav Fomichev <sdf@fomichev.me>
To: netdev@vger.kernel.org
Cc: davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	horms@kernel.org,
	corbet@lwn.net,
	andrew+netdev@lunn.ch,
	pablo@netfilter.org,
	kadlec@netfilter.org,
	sdf@fomichev.me
Subject: [PATCH net-next] net: revert to lockless TC_SETUP_BLOCK and TC_SETUP_FT
Date: Fri,  7 Mar 2025 20:47:26 -0800
Message-ID: <20250308044726.1193222-1-sdf@fomichev.me>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There is a couple of places from which we can arrive to ndo_setup_tc
with TC_SETUP_BLOCK/TC_SETUP_FT:
- netlink
- netlink notifier
- netdev notifier

Locking netdev too deep in this call chain seems to be problematic
(especially assuming some/all of the call_netdevice_notifiers
NETDEV_UNREGISTER) might soon be running with the instance lock).
Revert to lockless ndo_setup_tc for TC_SETUP_BLOCK/TC_SETUP_FT. NFT
framework already takes care of most of the locking. Document
the assumptions.

ndo_setup_tc TC_SETUP_BLOCK
  nft_block_offload_cmd
    nft_chain_offload_cmd
      nft_flow_block_chain
        nft_flow_offload_chain
	  nft_flow_rule_offload_abort
	    nft_flow_rule_offload_commit
	  nft_flow_rule_offload_commit
	    nf_tables_commit
	      nfnetlink_rcv_batch
	        nfnetlink_rcv_skb_batch
		  nfnetlink_rcv
	nft_offload_netdev_event
	  NETDEV_UNREGISTER notifier

ndo_setup_tc TC_SETUP_FT
  nf_flow_table_offload_cmd
    nf_flow_table_offload_setup
      nft_unregister_flowtable_hook
        nft_register_flowtable_net_hooks
	  nft_flowtable_update
	  nf_tables_newflowtable
	    nfnetlink_rcv_batch (.call NFNL_CB_BATCH)
	nft_flowtable_update
	  nf_tables_newflowtable
	nft_flowtable_event
	  nf_tables_flowtable_event
	    NETDEV_UNREGISTER notifier
      __nft_unregister_flowtable_net_hooks
        nft_unregister_flowtable_net_hooks
	  nf_tables_commit
	    nfnetlink_rcv_batch (.call NFNL_CB_BATCH)
	  __nf_tables_abort
	    nf_tables_abort
	      nfnetlink_rcv_batch
	__nft_release_hook
	  __nft_release_hooks
	    nf_tables_pre_exit_net -> module unload
	  nft_rcv_nl_event
	    netlink_register_notifier (oh boy)
      nft_register_flowtable_net_hooks
      	nft_flowtable_update
	  nf_tables_newflowtable
        nf_tables_newflowtable

Fixes: c4f0f30b424e ("net: hold netdev instance lock during nft ndo_setup_tc")
Signed-off-by: Stanislav Fomichev <sdf@fomichev.me>
---
 Documentation/networking/netdevices.rst |  6 ++++++
 include/linux/netdevice.h               |  2 --
 net/core/dev.c                          | 19 -------------------
 net/netfilter/nf_flow_table_offload.c   |  2 +-
 net/netfilter/nf_tables_offload.c       |  2 +-
 5 files changed, 8 insertions(+), 23 deletions(-)

diff --git a/Documentation/networking/netdevices.rst b/Documentation/networking/netdevices.rst
index d235a7364893..ebb868f50ac2 100644
--- a/Documentation/networking/netdevices.rst
+++ b/Documentation/networking/netdevices.rst
@@ -290,6 +290,12 @@ struct net_device synchronization rules
 	Synchronization: netif_addr_lock spinlock.
 	Context: BHs disabled
 
+ndo_setup_tc:
+	``TC_SETUP_BLOCK`` and ``TC_SETUP_FT`` are running under NFT locks
+	(i.e. no ``rtnl_lock`` and no device instance lock). The rest of
+	``tc_setup_type`` types run under netdev instance lock if the driver
+	implements queue management or shaper API.
+
 Most ndo callbacks not specified in the list above are running
 under ``rtnl_lock``. In addition, netdev instance lock is taken as well if
 the driver implements queue management or shaper API.
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index d206c9592b60..87fd3b1f2b99 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -3395,8 +3395,6 @@ int dev_open(struct net_device *dev, struct netlink_ext_ack *extack);
 void netif_close(struct net_device *dev);
 void dev_close(struct net_device *dev);
 void dev_close_many(struct list_head *head, bool unlink);
-int dev_setup_tc(struct net_device *dev, enum tc_setup_type type,
-		 void *type_data);
 void netif_disable_lro(struct net_device *dev);
 void dev_disable_lro(struct net_device *dev);
 int dev_loopback_xmit(struct net *net, struct sock *sk, struct sk_buff *newskb);
diff --git a/net/core/dev.c b/net/core/dev.c
index a0f75a1d1f5a..8b3603b764a7 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1760,25 +1760,6 @@ void netif_close(struct net_device *dev)
 	}
 }
 
-int dev_setup_tc(struct net_device *dev, enum tc_setup_type type,
-		 void *type_data)
-{
-	const struct net_device_ops *ops = dev->netdev_ops;
-	int ret;
-
-	ASSERT_RTNL();
-
-	if (!ops->ndo_setup_tc)
-		return -EOPNOTSUPP;
-
-	netdev_lock_ops(dev);
-	ret = ops->ndo_setup_tc(dev, type, type_data);
-	netdev_unlock_ops(dev);
-
-	return ret;
-}
-EXPORT_SYMBOL(dev_setup_tc);
-
 void netif_disable_lro(struct net_device *dev)
 {
 	struct net_device *lower_dev;
diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index 0ec4abded10d..e06bc36f49fe 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -1175,7 +1175,7 @@ static int nf_flow_table_offload_cmd(struct flow_block_offload *bo,
 	nf_flow_table_block_offload_init(bo, dev_net(dev), cmd, flowtable,
 					 extack);
 	down_write(&flowtable->flow_block_lock);
-	err = dev_setup_tc(dev, TC_SETUP_FT, bo);
+	err = dev->netdev_ops->ndo_setup_tc(dev, TC_SETUP_FT, bo);
 	up_write(&flowtable->flow_block_lock);
 	if (err < 0)
 		return err;
diff --git a/net/netfilter/nf_tables_offload.c b/net/netfilter/nf_tables_offload.c
index b761899c143c..64675f1c7f29 100644
--- a/net/netfilter/nf_tables_offload.c
+++ b/net/netfilter/nf_tables_offload.c
@@ -390,7 +390,7 @@ static int nft_block_offload_cmd(struct nft_base_chain *chain,
 
 	nft_flow_block_offload_init(&bo, dev_net(dev), cmd, chain, &extack);
 
-	err = dev_setup_tc(dev, TC_SETUP_BLOCK, &bo);
+	err = dev->netdev_ops->ndo_setup_tc(dev, TC_SETUP_BLOCK, &bo);
 	if (err < 0)
 		return err;
 
-- 
2.48.1

