Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F21812920A8;
	Fri, 23 May 2025 13:27:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748006875; cv=none; b=ITpqORgcHOWhTCfnUBcBfwTDoylUPqXQ182Yqt9WSwsbgyXWf3QC1t8iDuLcIt/v62zVOek9J2+GfPUuR1oeXgxyj8+Ad7VdHpgbNmrbt4tOSBjUvy6yJDg8OagM0qfef14B30fr9zaYs36qZK96avmbgud199VU06iUsYPsWAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748006875; c=relaxed/simple;
	bh=Ma2619K6JlGt617K8eDhrURbu18LN3hIGjrMFA1r2co=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=gT32SMInvbJhF59LZADY7W7anGGx36rZ7BTw29tCThzEeYjSrQb/bsbZmCluAqdIqEk7//oiyAlBnn/t3Yebp3j7hEvONh5f5jJgAdTkpg+aEmcz250oGO6l35ZE9a8B7U27CxVew9xBtZp+ms26VjIOFAkZSMeZtqkXX3QwfvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=hLVwwx4r; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=uoLRUdSF; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="hLVwwx4r";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="uoLRUdSF"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id B548E60307; Fri, 23 May 2025 15:27:52 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1748006872;
	bh=s3IRiWwEpkmC0HelhLsEJvCeRxFecKfpzzHFGbjUW9o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hLVwwx4rpehDkr3XXH4Fponuqqxjxd/JKqvCWsEWMhjbdyN7XpiPSmViWe88v4O7G
	 tDBNc6MkQRy7qcYynFvRHKTOb/p5WHqEow8PLSt68vaeQeaN8JXxTbaNtqMiuJ0yN+
	 KuOYHeZfCom5Arws91D7ssnMdqXzGAnp8Q2Juo7qV0s5Ra7saft7GwLbn7WFxZqa6A
	 5KViK1FitY3TfiCBNdRtRQYfnkPyWE+n1KUJKTQdi/40eXzLpGBgtk/dmRVSI3pQ3R
	 ykDc+RTN4St9NUE7NpQAsoHHUsRaLuDQPEiZzYgDMo5yVWHS0xNBeHfQ/dEqQtpHMg
	 0B3Jcw2f1l44g==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 2900460763;
	Fri, 23 May 2025 15:27:27 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1748006847;
	bh=s3IRiWwEpkmC0HelhLsEJvCeRxFecKfpzzHFGbjUW9o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uoLRUdSFS5Q4E6CU46ys99kRciKiZmbEzuT4mUDzq3FP3Ib3mm+gKZUqdz1S764MZ
	 x8+y7AwrTJchsKaMCMa9WDCRaOtR1l1ebWT/RsZUviLrt4a6KxU/2WEbgHwFDKoqms
	 BWLYBhls5rdDN/wU1IRbJWvtj36Eki3DmbS1lrpyB2eT5eYj3TsF1tOkhuAX/A5wVj
	 Z8F2AAPMwBgDbPPztdzTBmV4wNmr8OHuBOQz+tA0+dG5TGmr+w9wesuU4vu6mgDro6
	 gNeCpq7nsNdtoVfFZSWMwU7v9Y6H18VNyxC/UqsAZ/p8H5FMOUk7innfQHl+RIK644
	 omkglPSc8BwDA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net-next 11/26] netfilter: nf_dup_netdev: Move the recursion counter struct netdev_xmit
Date: Fri, 23 May 2025 15:26:57 +0200
Message-Id: <20250523132712.458507-12-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250523132712.458507-1-pablo@netfilter.org>
References: <20250523132712.458507-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

nf_dup_skb_recursion is a per-CPU variable and relies on disabled BH for its
locking. Without per-CPU locking in local_bh_disable() on PREEMPT_RT
this data structure requires explicit locking.

Move nf_dup_skb_recursion to struct netdev_xmit, provide wrappers.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netdevice_xmit.h |  3 +++
 net/netfilter/nf_dup_netdev.c  | 22 ++++++++++++++++++----
 2 files changed, 21 insertions(+), 4 deletions(-)

diff --git a/include/linux/netdevice_xmit.h b/include/linux/netdevice_xmit.h
index 848735b3a7c0..813a19122ebb 100644
--- a/include/linux/netdevice_xmit.h
+++ b/include/linux/netdevice_xmit.h
@@ -11,6 +11,9 @@ struct netdev_xmit {
 #if IS_ENABLED(CONFIG_NET_ACT_MIRRED)
 	u8 sched_mirred_nest;
 #endif
+#if IS_ENABLED(CONFIG_NF_DUP_NETDEV)
+	u8 nf_dup_skb_recursion;
+#endif
 };
 
 #endif
diff --git a/net/netfilter/nf_dup_netdev.c b/net/netfilter/nf_dup_netdev.c
index a8e2425e43b0..fab8b9011098 100644
--- a/net/netfilter/nf_dup_netdev.c
+++ b/net/netfilter/nf_dup_netdev.c
@@ -15,12 +15,26 @@
 
 #define NF_RECURSION_LIMIT	2
 
-static DEFINE_PER_CPU(u8, nf_dup_skb_recursion);
+#ifndef CONFIG_PREEMPT_RT
+static u8 *nf_get_nf_dup_skb_recursion(void)
+{
+	return this_cpu_ptr(&softnet_data.xmit.nf_dup_skb_recursion);
+}
+#else
+
+static u8 *nf_get_nf_dup_skb_recursion(void)
+{
+	return &current->net_xmit.nf_dup_skb_recursion;
+}
+
+#endif
 
 static void nf_do_netdev_egress(struct sk_buff *skb, struct net_device *dev,
 				enum nf_dev_hooks hook)
 {
-	if (__this_cpu_read(nf_dup_skb_recursion) > NF_RECURSION_LIMIT)
+	u8 *nf_dup_skb_recursion = nf_get_nf_dup_skb_recursion();
+
+	if (*nf_dup_skb_recursion > NF_RECURSION_LIMIT)
 		goto err;
 
 	if (hook == NF_NETDEV_INGRESS && skb_mac_header_was_set(skb)) {
@@ -32,9 +46,9 @@ static void nf_do_netdev_egress(struct sk_buff *skb, struct net_device *dev,
 
 	skb->dev = dev;
 	skb_clear_tstamp(skb);
-	__this_cpu_inc(nf_dup_skb_recursion);
+	(*nf_dup_skb_recursion)++;
 	dev_queue_xmit(skb);
-	__this_cpu_dec(nf_dup_skb_recursion);
+	(*nf_dup_skb_recursion)--;
 	return;
 err:
 	kfree_skb(skb);
-- 
2.30.2

