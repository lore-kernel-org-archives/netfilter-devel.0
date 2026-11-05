Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.231.198
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793879309;
	b=dFbRyHHqdnFAwzOcgbaYj0TD9uK2jfyHsGMDiw1hkHhFJkEuLfAupy2KeVzFXgs4haHh
	 dfFhrVFcgt8/RgzC+oqIOCiZX31ke1dOT8YMk9fwg341GzB9vuGkhAtZWmckIwk75/x+x
	 /9rtu3dCbovE90jPgA7RtBv+RrXelylkKBRvpPpHGV7zHgMGgiR8CJhZlOUAqu3x+KNHn
	 Ioq8aZXGhTzxomxvW/+Ic4U4tOdIqsUaKwbroHR28rD5+VNvM0ImXZ0dsdkhTYn2n/pzb
	 YmCIMuum9BGfiqJZCBfKjtPfZRFVSCcksGYsq22jW1RJd2iF0EJ5gwZ00i+1gcRSfrA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793879309;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=hg7j3aQDkYF3jTcoB7Va9I6kezijOkG/5q0FsvMla1Q=;
	b=eg8owq2KZurX38pU4WuxwNofVNSU3fD8Ibenp8fxKFsxd/35CIKXe2BHzFjiTQ/s/Iz/
	 ym1uatte4/BsBPronzp9D5xVtfSHlkn9Hpi1C9dAQzjePkCDdc5gMhoOlhlvIfITV6RcB
	 3zVYHJ/DEE+Sby4yEblbz1PlwQG9RM6fEc1epXtkBuUsgxs4irvKfcukYOo3xKe1Fav8I
	 s4iLHaw/Fx2UqTThHckjyOAontxB77tDeilmBpwv03QClkhPYQH1DBNiPBUtgzJhNzaGG
	 u8QxQB0Eeas/Nmw+Up05U9zNgJ9wXWej2T88s2ZfOB8zqkbNhc8yRTTTBfewejp4J6w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=PW8KOHRd;
	arc=none smtp.remote-ip=74.125.231.198
Received: from mail-oi2-f6.google.com (mail-oi2-f6.google.com [74.125.231.198])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3AA7606CE85
	for <netfilter-devel@vger.kernel.org>; Thu,  5 Nov 2026 11:48:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B3AA7606CE85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=PW8KOHRd
Received: by mail-oi2-f6.google.com with SMTP id 5614622812f47-550f311b527so811083b6e.1
        for <netfilter-devel@vger.kernel.org>; Thu, 05 Nov 2026 03:48:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793879307; x=1794484107; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=hg7j3aQDkYF3jTcoB7Va9I6kezijOkG/5q0FsvMla1Q=;
        b=PW8KOHRdWbSwfyWxw+XKu/l+tmM288fhr1OYE5FJZVbxY5ulQxNFff0Jf6SiE/gFaQ
         kbVQ0XqUg/v1s2B33XaTrmKPbrtM5Fg9qn7LHQHbGR7y/IOkRBew0BlcAeXBUgkxjdQ2
         hXqub0fyoZBkGtRoB9djCFqwGMOvReGM/Asv8hNLv2j6h5ubRnri5KYbcLhB/bbCK3Ua
         1mXyXFa6AWGyovLrO3TVrYlztFu6wte90iVz+bV2gQZ/43ZPki0FSGsKi1VvKmZOIFII
         S+7hj+lurEb7FvmUcuDytAzT5TU8bD+xgrH7ot3UqY7EsjdIaRgeQsxVgxrJxpuw84Kl
         xvVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793879307; x=1794484107;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hg7j3aQDkYF3jTcoB7Va9I6kezijOkG/5q0FsvMla1Q=;
        b=W61Oa8+jnNoX2q2WJjPEOW049rBjLM1EcqJlIsJBgYOxS2amAd7exKlzEYwSrkYgSB
         Pf5HmdeuAEg8zQIzheoikdxjUvboNxzNxexuBv1EH7cubpSRhgYq+xwKA5WTOKX+Lect
         6clYl4suBP2wzWLaDkZKVa2nXp+gKFWYEPfCemQaOSnZBIOVQYBn9XvQatpwTtOsww4I
         BcfKFEeSjQlYsi4janSzBMAf6DGZ1rRZqSWSMnftrMyMdW54S7E7MeUfqy7K/l2HIpjt
         ze9HRgCaaqLiJW3AHvoQ0lQKoEzQETJT3cBbfrgUTGNsJHQF95KNgcOgpZPUcZVPwXrP
         ffQg==
X-Gm-Message-State: APuU4Z9tXrz1Asud1hawwE7VT7s4bdh1Rz2rUN4D0ADv+GF5ZM1OXfDf
	rFtFSAov+5VDS3FDFqgvLUXsjTpA8XSOtu5UGUZKcr8jyCt831p8/fjT
X-Gm-Gg: AYBFou3vAE0uvn/oJlIeiyBqXd3NMaZJDpp9uAQzCwWqQVgViDcx+rty9ygB9bYLu+y
	xQRvdV22elYlRQmxqmyDtxa4Vd0papfgzgv+L30cTRUNaJ/Ldo1cNbeOd5J+pkWn8+uobrFCu2e
	NqZGv8iLKZjmKHU88mhp3rhGDekqdwQGr5D3jwjoTRrKRQ2knv33L+RXe1uhX1blJT2RjekUCHO
	jArr/ok0E1+XR5TrX2W44V28il4BOxnwBdm+c6Wh221NyFvJqx9HA+40UKgVJ9qH+Tf/RDnnOax
	3Om7CZxUM6nmUBdAWkWZQLZTW/BCJ9u6Ysz35Ko9MxZZRD7pwxr9cAfEJXlDlL06plV1InmvIgP
	WJiSVMqVKNpo/cC9CMGxqhxVU7wY9/YvagPrHeJHtaGdMrVM/WGaxy0rSxcAON2AMWpJzkEL0MA
	vKQ3TAR0Wc0NBAA4JJ9afEeFepoqXRXshMgwj6oeG6L2MyZsQocWyiXhNnwBg72BP0YKNSaRa/N
	kli65RNDm8bmXziy31r+VHhwlXKgoX4E/yTarCHsQwiHg26YdI+A1RITuS+K8SBjy13Ztfnnp46
	Tz4HqLLQ63j7SyNbKXfSQtfS8WEZBWSA+iwp0CC5KSLwd9DQxvU7VGYD1KDQdwB8tSpR
X-Received: by 2002:a05:6808:1793:b0:553:66a3:d863 with SMTP id 5614622812f47-5640dc200damr13347009b6e.21.1793879307507;
        Thu, 05 Nov 2026 03:48:27 -0800 (PST)
Received: from localhost.localdomain ([14.116.239.41])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-567a9f93e30sm4054807b6e.13.2026.11.05.03.48.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 03:48:26 -0800 (PST)
From: Henry Martin <bsdhenrymartin@gmail.com>
To: pablo@netfilter.org,
	fw@strlen.de,
	davem@davemloft.net,
	edumazet@kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com
Cc: netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	stable@vger.kernel.org,
	Henry Martin <bsdhenrymartin@gmail.com>
Subject: [PATCH] netfilter: nf_tables: fix pernet use-after-free on UNREGISTER rebroadcast
Date: Thu,  5 Nov 2026 19:48:17 +0800
Message-ID: <20261105114817.3033625-1-bsdhenrymartin@gmail.com>
X-Mailer: git-send-email 2.43.7
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

A device unregistered outside its netns teardown can be stuck in
netdev_wait_allrefs_any() while the pernet exit handlers of its
netns run to completion.  The nftables pernet storage is freed on
that path.  The rebroadcasts then hit the nf_tables netdev
notifiers (base chain, flowtable, offload), which read the freed
storage via nft_pernet() and take commit_mutex on it, e.g. on
mainline v7.4-rc1 (KASAN build):

    BUG: KASAN: slab-use-after-free in nf_tables_netdev_event+0x17c
    Read of size 8 at addr ffff88811061c980 by task ip/422
    Call Trace:
     nf_tables_netdev_event+0x17c/0x1c0
    Freed by task 62:
     kfree+0x161/0x450
     net_passive_dec+0xe5/0x180
     cleanup_net+0x45a/0x780

Skip the rebroadcasts in all three notifiers, which are the only
NETDEV_UNREGISTER events delivered with reg_state ==
NETREG_UNREGISTERED.  This mirrors commit fd0909e963ed8
("netdev-genl: ignore NETDEV_UNREGISTER rebroadcasts").

This issue was discovered by Tencent CodeBuddy Security.

Fixes: 8a4fc54b07d75 ("net: get rid of rtnl_lock_unregistering()")
Cc: stable@vger.kernel.org
Signed-off-by: Henry Martin <bsdhenrymartin@gmail.com>
---
 net/netfilter/nf_tables_api.c     | 9 +++++++++
 net/netfilter/nf_tables_offload.c | 8 ++++++++
 net/netfilter/nft_chain_filter.c  | 9 +++++++++
 3 files changed, 26 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 59ac623e6805f..e43a1b9fefc36 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -9902,6 +9902,15 @@ static int nf_tables_flowtable_event(struct notifier_block *this,
 	    event != NETDEV_CHANGENAME)
 		return NOTIFY_DONE;
 
+	/* netdev_wait_allrefs_any() rebroadcasts NETDEV_UNREGISTER
+	 * while waiting for the last references to be dropped; the
+	 * netns and its nftables pernet storage may already be torn
+	 * down by then.
+	 */
+	if (event == NETDEV_UNREGISTER &&
+	    READ_ONCE(dev->reg_state) == NETREG_UNREGISTERED)
+		return NOTIFY_DONE;
+
 	net = dev_net(dev);
 	nft_net = nft_pernet(net);
 	mutex_lock(&nft_net->commit_mutex);
diff --git a/net/netfilter/nf_tables_offload.c b/net/netfilter/nf_tables_offload.c
index 0ac3c26dfb3d1..d360e233d0366 100644
--- a/net/netfilter/nf_tables_offload.c
+++ b/net/netfilter/nf_tables_offload.c
@@ -672,6 +672,14 @@ static int nft_offload_netdev_event(struct notifier_block *this,
 	if (event != NETDEV_UNREGISTER)
 		return NOTIFY_DONE;
 
+	/* netdev_wait_allrefs_any() rebroadcasts NETDEV_UNREGISTER
+	 * while waiting for the last references to be dropped; the
+	 * netns and its nftables pernet storage may already be torn
+	 * down by then.
+	 */
+	if (READ_ONCE(dev->reg_state) == NETREG_UNREGISTERED)
+		return NOTIFY_DONE;
+
 	nft_net = nft_pernet(net);
 	mutex_lock(&nft_net->commit_mutex);
 	chain = __nft_offload_get_chain(nft_net, dev);
diff --git a/net/netfilter/nft_chain_filter.c b/net/netfilter/nft_chain_filter.c
index e04e689f22284..b3cfe8d426753 100644
--- a/net/netfilter/nft_chain_filter.c
+++ b/net/netfilter/nft_chain_filter.c
@@ -412,6 +412,15 @@ static int nf_tables_netdev_event(struct notifier_block *this,
 	    event != NETDEV_CHANGENAME)
 		return NOTIFY_DONE;
 
+	/* netdev_wait_allrefs_any() rebroadcasts NETDEV_UNREGISTER
+	 * while waiting for the last references to be dropped; the
+	 * netns and its nftables pernet storage may already be torn
+	 * down by then.
+	 */
+	if (event == NETDEV_UNREGISTER &&
+	    READ_ONCE(dev->reg_state) == NETREG_UNREGISTERED)
+		return NOTIFY_DONE;
+
 	nft_net = nft_pernet(dev_net(dev));
 	mutex_lock(&nft_net->commit_mutex);
 
-- 
2.43.7

