Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6BE437B402
	for <netfilter-devel@vger.kernel.org>; Thu,  9 Apr 2026 10:49:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775731794; cv=none; b=QAWP9JTkiYkvO7bQt0cw+fGCFI8jTf5Fag1ag4Y6FGLAxAWIOArUl+doANa8KY/5mKViAfiMYXWUixC0qYsJzKD+f9rRY8oCpt6AG5M+oREJYKUdJrZVg1+uleUhJvZ3lk84ZuYqjVXQXiKaQ6XaU3rX7WQ5I3XpuxGA+zTtqrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775731794; c=relaxed/simple;
	bh=JNT33Wmq43E/C5jtUNTbbsnfLcnJM8zf0ttEv/gKCIs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cm+Sif9YNwJJWR8ODMZwUSu1Bxl37H023vwXvFmu57gYXknjUQzJXfFcbk9iXMdlj9+8vevYlfOxn+UjxdE67WMSCsQMGkO1toEX7O5gzELR/ptwsxFppq0EuZCmXnlRZ/sNtNo4P+1OLDNK1tK4elL9wZLjfYwN8XZW3wJ+n4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WwfcPWkk; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WwfcPWkk"
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-358e3cc5e7eso470029a91.0
        for <netfilter-devel@vger.kernel.org>; Thu, 09 Apr 2026 03:49:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775731791; x=1776336591; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Ukbyd6N1MhmvxaPd3moBUEUJpBd5mNCDxCGpsq2J5LA=;
        b=WwfcPWkkwJgxDug0ekTYyXrV/xouXrB9HBUMAfrkdkjELiDzkLUX2IODG1upfUYKYS
         jQg2msyCQT2bCu989fFE1Fo3LBhWrj24SXXnKNVBEmtaYBzici0xmgW4x7yUQCsmr4Ng
         dUmgiCYZ1N0VcOTT3NuU09Ox/EjbbNq2zYCgLagY68DHcXt8h5101pDtWyWLJ2Y2eZTH
         ocM91IvDxQV1T59o+yWxCbdcPLiSTgLfGp7zmk9TMjf8XsNpBs9AHYYkgyCui7svfK+N
         ZGGrjjL8LlptLrTzzzI2MmViOu5jDKgOZ1Jn38iEOLJY6o8poGqBvKW+pdqV+EAlDsw6
         1K5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775731791; x=1776336591;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ukbyd6N1MhmvxaPd3moBUEUJpBd5mNCDxCGpsq2J5LA=;
        b=j2pALB+NEAG6GueCq9vRrH1WpwX6T1xv49l3BoxNtuyokYeffoQzOm3+T22Z/e4wcR
         Z9Pvv+BJj9IAsCpUcJDqDLoEHYjOF6R9WHAb6jlwI9nCEBPYJMvykokC9890ePMRpJih
         YKmZ6pGFOxtX+6A+K86ZMySsojijGaGNq6rvfHZ5VInEXWRd8VT4Qd02uIEfokn++NsQ
         gzAhqtIUGYrj71lfR+9ymlZRoQM7SLtBFMDIzDiwQN5v9+Txn4o8YvdvUBcg3vNsDdXB
         sn0VRxmt8pFZ7yX8jdJlSU+xXkz320MQ0mb3c/VcCcCW91B7asdH5Aj6EMlbC0WtEdsg
         c3zA==
X-Forwarded-Encrypted: i=1; AJvYcCXQ1Y5x3WTvtg84jhA60YsqycbYlUbstssvHCcS3E3uJ95Xs0UrnfPAQMoyIMrlucoqxMg23Ahz/AdbEOj9rdM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwxkDYBVCE3meIqXDC1kaLyRrAn5/RaqHV1tIVRTb6/+zzOdkpt
	kc7xnY/QyaSsRjalfVX7FEpDfwvUQoYU4ydwIspUd0WhdFnmpn+Mo1gj
X-Gm-Gg: AeBDievlXFlPaSs5qMmSPR2ijat+7d0VOH5Ibu21AAhccXqadSHEWoYtqCFrU3dXF74
	obWir18pso2Y5+CsZuy2+Zh026PaNZoeR4dobE7QqdpHB3Bn+NfPjnlpdhXOc8TFWzdYyZg40l0
	EnT69HH707HSOGhnLDpZTB+n5UJkuMEivtoiBfN4SFwlSy/TmfHwLYTfqFfuEXwYxAS0d66najA
	OtQh7c6tPtRl9veionwJqS+/FWZihC4Avn/v5R7BWj31pfouFo5rLYwKKyIHf7muy3CnQ66aU9I
	MXA1cWsXUoAXog7jsJQZlJlFtVCxuWwYa9wQTdh/13jNEwA5Xg7LBHpfaI1vcmnj1n2qadwIDdH
	IPP+Gx0IBg8KhhBkX2W8wOCeuuEDx5VV7loB1N9Ovjlbb8BwdVAHy9QjfF3nEj7CRoSjhzE3m7w
	3WnQ5LyZhEudkLYbARyKeE3OHSsDgIQvnsf24l4j5uhJ9rPNTElIjf17jMLFulYYtg+kNv7/DvH
	XunqebMEwLc
X-Received: by 2002:a17:90b:5585:b0:355:35b0:8b78 with SMTP id 98e67ed59e1d1-35de69a6545mr23786223a91.27.1775731790627;
        Thu, 09 Apr 2026 03:49:50 -0700 (PDT)
Received: from SLSGDTSWING002.tail0ac356.ts.net ([129.126.109.177])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35e3503b278sm3724426a91.16.2026.04.09.03.49.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Apr 2026 03:49:50 -0700 (PDT)
From: Weiming Shi <bestswngs@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Cc: Phil Sutter <phil@nwl.cc>,
	Simon Horman <horms@kernel.org>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>
Subject: [PATCH v2] netfilter: nft_fwd_netdev: use recursion counter in neigh egress path
Date: Thu,  9 Apr 2026 18:49:12 +0800
Message-ID: <20260409104911.722698-2-bestswngs@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

nft_fwd_neigh can be used in egress chains (NF_NETDEV_EGRESS). When the
forwarding rule targets the same device or two devices forward to each
other, neigh_xmit() triggers dev_queue_xmit() which re-enters
nf_hook_egress(), causing infinite recursion and stack overflow.

Move the nf_get_nf_dup_skb_recursion() accessor and NF_RECURSION_LIMIT
to the shared header nf_dup_netdev.h as a static inline, so that
nft_fwd_netdev can use the recursion counter directly without exported
function call overhead. Guard neigh_xmit() with the same recursion
limit already used in nf_do_netdev_egress().

Fixes: f87b9464d152 ("netfilter: nft_fwd_netdev: Support egress hook")
Reported-by: Xiang Mei <xmei5@asu.edu>
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
---
 include/net/netfilter/nf_dup_netdev.h | 13 +++++++++++++
 net/netfilter/nf_dup_netdev.c         | 16 ----------------
 net/netfilter/nft_fwd_netdev.c        |  7 +++++++
 3 files changed, 20 insertions(+), 16 deletions(-)

diff --git a/include/net/netfilter/nf_dup_netdev.h b/include/net/netfilter/nf_dup_netdev.h
index b175d271aec9..609bcf422a9b 100644
--- a/include/net/netfilter/nf_dup_netdev.h
+++ b/include/net/netfilter/nf_dup_netdev.h
@@ -3,10 +3,23 @@
 #define _NF_DUP_NETDEV_H_
 
 #include <net/netfilter/nf_tables.h>
+#include <linux/netdevice.h>
+#include <linux/sched.h>
 
 void nf_dup_netdev_egress(const struct nft_pktinfo *pkt, int oif);
 void nf_fwd_netdev_egress(const struct nft_pktinfo *pkt, int oif);
 
+#define NF_RECURSION_LIMIT	2
+
+static inline u8 *nf_get_nf_dup_skb_recursion(void)
+{
+#ifndef CONFIG_PREEMPT_RT
+	return this_cpu_ptr(&softnet_data.xmit.nf_dup_skb_recursion);
+#else
+	return &current->net_xmit.nf_dup_skb_recursion;
+#endif
+}
+
 struct nft_offload_ctx;
 struct nft_flow_rule;
 
diff --git a/net/netfilter/nf_dup_netdev.c b/net/netfilter/nf_dup_netdev.c
index fab8b9011098..a958a1b0c5be 100644
--- a/net/netfilter/nf_dup_netdev.c
+++ b/net/netfilter/nf_dup_netdev.c
@@ -13,22 +13,6 @@
 #include <net/netfilter/nf_tables_offload.h>
 #include <net/netfilter/nf_dup_netdev.h>
 
-#define NF_RECURSION_LIMIT	2
-
-#ifndef CONFIG_PREEMPT_RT
-static u8 *nf_get_nf_dup_skb_recursion(void)
-{
-	return this_cpu_ptr(&softnet_data.xmit.nf_dup_skb_recursion);
-}
-#else
-
-static u8 *nf_get_nf_dup_skb_recursion(void)
-{
-	return &current->net_xmit.nf_dup_skb_recursion;
-}
-
-#endif
-
 static void nf_do_netdev_egress(struct sk_buff *skb, struct net_device *dev,
 				enum nf_dev_hooks hook)
 {
diff --git a/net/netfilter/nft_fwd_netdev.c b/net/netfilter/nft_fwd_netdev.c
index 152a9fb4d23a..492bb599a499 100644
--- a/net/netfilter/nft_fwd_netdev.c
+++ b/net/netfilter/nft_fwd_netdev.c
@@ -141,13 +141,20 @@ static void nft_fwd_neigh_eval(const struct nft_expr *expr,
 		goto out;
 	}
 
+	if (*nf_get_nf_dup_skb_recursion() > NF_RECURSION_LIMIT) {
+		verdict = NF_DROP;
+		goto out;
+	}
+
 	dev = dev_get_by_index_rcu(nft_net(pkt), oif);
 	if (dev == NULL)
 		return;
 
 	skb->dev = dev;
 	skb_clear_tstamp(skb);
+	(*nf_get_nf_dup_skb_recursion())++;
 	neigh_xmit(neigh_table, dev, addr, skb);
+	(*nf_get_nf_dup_skb_recursion())--;
 out:
 	regs->verdict.code = verdict;
 }
-- 
2.43.0

