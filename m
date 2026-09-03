Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D650184
	for <netfilter-devel@vger.kernel.org>; Thu,  3 Sep 2026 12:18:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788437895; cv=none; b=osDfDdhc7LiNHbCz2hB/+b+3DUQvRf+20DiC00dYUxAu/Vsz3dbB7CKfyWy2iYFrDnEOPz9pelzVuRq01yCilskm6PHn9iFv04uk3/4F2e/CGFpq7etkUl7Pr8FVIZMXdz8/mW/tAzWmczincVvEmATC1MVJS+6wdeDLxYX05sY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788437895; c=relaxed/simple;
	bh=Q9uLEjPuUsW8cwmTICkYlym/RVuiMzxRLrjoajqUW+o=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nr0Bb37B7cOtkXxOgy0DQVmbm6Be1lfo4T5pC61NqcGOmxXcOin70Nmbgq0qRsqhNJyVzmAIRLqfpaCMoNYPAB6Zohgf5+L8f1rdZKBXBptuNJzyl82jah4MgPZ2YsXVftfMnOfGuUCMg1QQagiclCI7tbk2MYuu15S/+IsyCF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QOdP+vzq; arc=none smtp.client-ip=209.85.167.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QOdP+vzq"
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-5b15dcaca31so2226425e87.0
        for <netfilter-devel@vger.kernel.org>; Thu, 03 Sep 2026 05:18:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788437891; x=1789042691; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=/fGnKM9GO11+CKzG0GTZXAjAlnoptWC/LUlsemO5pbE=;
        b=QOdP+vzqL0xearGydJsDKTswjqdrKKVTga1kQKO8ZV8m5wLPxGDjTaWgeSwz8HxyWI
         gmKg8W0S0k82u+yOaeHeTm1EsIBqzCoTNrDgIUdSNSlctb18ijes1SGpJjZQTdAAJSeO
         XRSGive4YBYJwV2+1+n8oeudZ7Z7jd8tAQQwcv9ACCAPC4cwbIqjXTPNwHe6gPRdmq9L
         Ex95VAxu7RoRhkyhPxb/x7AoKStKuTrkfs7YzLK0bT8RokoPNrwoeyKQFQIHYiPokzS2
         mhDMLfy7Pz2l6gNUHPJiBge4XjxGEAbVvqbABX/+rBxGbu5UkK6ITa7p5cShqs4InJdL
         aCpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788437891; x=1789042691;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/fGnKM9GO11+CKzG0GTZXAjAlnoptWC/LUlsemO5pbE=;
        b=AOfpS9eHZ/d2sgsUfjUnqvf4n5c+CpByerQZ6Dx9VXvNPHJA8W7v+4KwtwKSR8omZC
         2lfAUHAzeS9WMjaeoqvS9UWtaZK05+k1xYB4f/vWHU1DmZ9cqJUy0IWvWhFcbmkr4Gx6
         +OL1x2TtDtW2+Rk+tOrpLKqGTbYCjyWg4+DqtIrFQ0NnEOa5vKJUtSs2i3fFNs4ECDAY
         QNBd6m2LHKMLYwotpEW5qd1KRXJ3NubClUUO4VBjrctyaRBrkEbo0GXd7zuh8ufPlbZ2
         vEykxy7PS7ah6NAFtsh5MJQyuDYbBgohZwoP7utzwJIC7i/gsxyouoxaDaSPZUDAQ7vX
         P2LA==
X-Forwarded-Encrypted: i=1; AKwUvBwsJ6XgAJlnTuXc+vmjC/WQ4lev+ZXy34xvnYAWdQGJVkhDKVDlLPVWzU4hOyuKam/DOfT98kE+bzp9IldFEds=@vger.kernel.org
X-Gm-Message-State: AFuF++nBwPvphg+GjOVJs6b27wmLZLf/91qg7tQQWe15ywxzUfbjOzzP
	+/9imnydNAVdBiwuDrnxUdzzZ1TlSPe6QCV/R6HWMGps3glKjswj4DBf
X-Gm-Gg: AYBFou0/dW/nRBTQeSw6SDdmO8XCkg6G5YTs1prmLTd1gXBOV03kw5+h0LK3mMvM1R0
	j3MgoiUw+YYAm2/oJ2ntumO21PSUK3kAJrsILGqYid1MQcmj/bL7t4/2mGkeEbl15BE4sbq+Fp7
	g6V5nfNujxXxlCbkz4vNevhHIXvZP/SUKhiedLe3q8ARGKUYVeQSdZIW8xpi8GIQhv4IVtQ7W81
	rHZcXQ3T5uNCxhIBPnohboLH8l0qDyXjv6drvUfmfB++yV2y3N8clGzvwhQj9tCCfv1SEUGbufv
	6BNHoH+hbOc+hxRYSW5PsShmL0YeoCpXroC5e8ExtuDL+qS7aHsHBYS6grBLBOgMtW31WD/5GCK
	Y0qoUrrCJ4gP70+cRyYKSHzHz/c+N4M//SbWR5L3029wx5K6FXl8iyTaVqwu37krKgrIfpqy+Py
	GLic5bdtgkJK3AmbWIWaY6O0OqkERySD1cZNw7JzfBs7osA+uRRdq1glemIrqew8YgxfVCvmbTX
	gqjoEj8FA==
X-Received: by 2002:a05:6512:318d:b0:5b2:a558:b222 with SMTP id 2adb3069b0e04-5b6083395a2mr3870492e87.10.1788437890958;
        Thu, 03 Sep 2026 05:18:10 -0700 (PDT)
Received: from grower.astralinux.ru ([38.74.72.197])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b606b1cb8bsm1251212e87.22.2026.09.03.05.18.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2026 05:18:10 -0700 (PDT)
From: Alexander Martyniuk <alexevgmart@gmail.com>
To: stable@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alexander Martyniuk <alexevgmart@gmail.com>,
	lvc-project@linuxtesting.org,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	"David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@kernel.org,
	Yuan Tan <yuantan098@gmail.com>,
	Yifan Wu <yifanwucs@gmail.com>,
	Juefei Pu <tomapufckgml@gmail.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Haoze Xie <royenheart@gmail.com>,
	Ren Wei <n05ec@lzu.edu.cn>
Subject: [PATCH 5.10] netfilter: nf_queue: pin bridge device while NFQUEUE holds fake dst
Date: Thu,  3 Sep 2026 15:17:57 +0300
Message-ID: <20260903121758.3660436-1-alexevgmart@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Haoze Xie <royenheart@gmail.com>

commit c9c9b37f8c5505224e8d206184df3bb668ee00cf upstream.

The br_netfilter fake rtable is embedded in struct net_bridge and is
attached to bridged packets with skb_dst_set_noref(). If such a packet is
queued to NFQUEUE, __nf_queue() upgrades that fake dst with
skb_dst_force().

At that point the queued skb can hold a real dst reference after bridge
teardown has started. The problem is not that every bridged packet needs
its own dst reference. The problem is that NFQUEUE can keep the bridge
private fake dst alive after unregister begins.

Fix this by keeping the bridge fake dst model unchanged and pinning the
bridge master device only while the packet sits in NFQUEUE. Record the
bridge device in nf_queue_entry when the queued skb carries a bridge fake
dst, take a device reference for the queue lifetime, and drop it when the
queue entry is freed.

Also make sure queued entries are reaped when that bridge device goes
down, and drop the redundant nf_bridge_info_exists() test from the fake
dst detection.

This keeps netdev_priv(br->dev) alive until verdict completion, so the
embedded fake rtable and its metrics backing storage cannot be freed out
from under dst_release(). It also avoids the constant refcount bump and
avoids using ipv4-specific dst helpers for IPv6 bridge traffic.

Fixes: 34666d467cbf ("netfilter: bridge: move br_netfilter out of the core")
Cc: stable@kernel.org
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Signed-off-by: Haoze Xie <royenheart@gmail.com>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Alexander Martyniuk <alexevgmart@gmail.com>
---
Backport fix for CVE-2026-72255
 include/net/netfilter/nf_queue.h |  1 +
 net/netfilter/nf_queue.c         | 16 ++++++++++++++++
 net/netfilter/nfnetlink_queue.c  |  3 +++
 3 files changed, 20 insertions(+)

diff --git a/include/net/netfilter/nf_queue.h b/include/net/netfilter/nf_queue.h
index 6b4de68a762e..2637d1512929 100644
--- a/include/net/netfilter/nf_queue.h
+++ b/include/net/netfilter/nf_queue.h
@@ -16,6 +16,7 @@ struct nf_queue_entry {
 	unsigned int		id;
 	unsigned int		hook_index;	/* index in hook_entries->hook[] */
 #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
+	struct net_device	*bridge_dev;
 	struct net_device	*physin;
 	struct net_device	*physout;
 #endif
diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
index d9d35658a357..47ed9a353107 100644
--- a/net/netfilter/nf_queue.c
+++ b/net/netfilter/nf_queue.c
@@ -67,6 +67,7 @@ static void nf_queue_entry_release_refs(struct nf_queue_entry *entry)
 		nf_queue_sock_put(state->sk);
 
 #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
+	dev_put(entry->bridge_dev);
 	dev_put(entry->physin);
 	dev_put(entry->physout);
 #endif
@@ -83,6 +84,8 @@ static void __nf_queue_entry_init_physdevs(struct nf_queue_entry *entry)
 {
 #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
 	const struct sk_buff *skb = entry->skb;
+	struct dst_entry *dst = skb_dst(skb);
+	struct net_device *dev = NULL;
 	struct nf_bridge_info *nf_bridge;
 
 	nf_bridge = nf_bridge_info_get(skb);
@@ -93,6 +96,18 @@ static void __nf_queue_entry_init_physdevs(struct nf_queue_entry *entry)
 		entry->physin = NULL;
 		entry->physout = NULL;
 	}
+
+	if (entry->state.pf == NFPROTO_BRIDGE &&
+	    dst && (dst->flags & DST_FAKE_RTABLE)) {
+		WARN_ON_ONCE(!rcu_read_lock_held());
+		dev = READ_ONCE(dst->dev);
+	}
+
+	/* Must hold a reference on the bridge device: dst_hold() protects
+	 * the dst itself, but the fake rtable is embedded in bridge-private
+	 * storage that netdevice teardown can free independently.
+	 */
+	entry->bridge_dev = dev;
 #endif
 }
 
@@ -109,6 +124,7 @@ bool nf_queue_entry_get_refs(struct nf_queue_entry *entry)
 	dev_hold(state->out);
 
 #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
+	dev_hold(entry->bridge_dev);
 	dev_hold(entry->physin);
 	dev_hold(entry->physout);
 #endif
diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 1541d6801001..f91cc1b8804d 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -910,6 +910,9 @@ dev_cmp(struct nf_queue_entry *entry, unsigned long ifindex)
 
 	if (physinif == ifindex || physoutif == ifindex)
 		return 1;
+
+	if (entry->bridge_dev && entry->bridge_dev->ifindex == ifindex)
+		return 1;
 #endif
 	if (entry->skb_dev && entry->skb_dev->ifindex == ifindex)
 		return 1;
-- 
2.43.0

