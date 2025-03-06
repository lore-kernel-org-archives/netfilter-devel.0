Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87DE71990D9;
	Thu,  6 Mar 2025 15:34:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741275302; cv=none; b=D+LqyqOptIpcL+oG/r3A35EWK331ORacSOhbO+eg5+WgpmzClc7cP29NbAVkEVw/5vrA3yRsNo9/DsJhrLjCYDQ2RWHP5bcGypZJEFRUMFtkbpl6PeVV8nlCvWN7rzdap11sVH1sb/P/tCJ9wV5g5/Po5vQKYAMk72aW+7Ac5tY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741275302; c=relaxed/simple;
	bh=vpy/1a0310/A6O1uLdZCzoCsT6lCRgdx6V5eVdwIgV4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=gdtF9R6SWsJOUjsuNvR3q6sDFz01wHFPfphQr4AHB8jY99XWvH8Ge8oFqGNC2iZ51XJehYTFhMcPafpDU/enPyINy2vUkZ+3lZFfsS76Lf2yz4mQh8fJvNQ6HSutZAbEH+BI+vVIGPdixpEJ5KVBlhslqWZHDnEGlRYHQ+M+YLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=uGb8HMU6; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=tf0YzabV; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="uGb8HMU6";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="tf0YzabV"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 002C760308; Thu,  6 Mar 2025 16:34:53 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1741275294;
	bh=mkon9fs8xRiDE8tH3lMwSu4uXP3e+5V3rBY5SY2y3MA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uGb8HMU6nujod37W1e0HX3vaPb3rWfygpCXXDOHhqJclAo4WG9quilzMarqf08zgp
	 4ILITLtfDZU6nmrKCX//T0ETdBgTvjKC7rIC6lvhfTN0RxIQsjW8nIjUQKJtktyYEQ
	 IzggAdExTdFVfzC3o7t82sIAKDT0upg2yHjtPkvKqtLsuhA35hq1EsaCi46EFVJEvs
	 wLdH8esL+CLtkPCzfOOU97JNGXi7+WVmD3V4d8j34F/l4HHitkeIvT6oQntNNEE/so
	 mC7ZwHh7+KI/TwiEEibl6OddCIotf2wFtT1BnPKCDSkgDc7qLxqd/W+Pl+m9sUju1y
	 Svm5K1EtLmG5A==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 186E960306;
	Thu,  6 Mar 2025 16:34:52 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1741275292;
	bh=mkon9fs8xRiDE8tH3lMwSu4uXP3e+5V3rBY5SY2y3MA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tf0YzabVdE4fScL4S/sPpwfNhWNULcF2izUhQxWwd+Go3hEoCEthYfJv9pSPtdXKH
	 yn01icir5Hu6BNk2Q+oT9H6ofqU7i1PmS7hpVCy5VI1TL5xGcRNVcI+7ApZWTFHH0f
	 KZ0RbH2PLwprSxk19qyvMPswNzbJJK/bhbXOQM6NLBDSqZGW1lMnGvaev1yQ1P2ihk
	 ECYeYSeoVj5VH6/R3y6ZNeYnB35TryUl+KhI4+BYf6yHwS5gM5/AyVuLfykUc4AJ19
	 jr1/53/Av6dbQ8nNKkfRCdh0b4+mAGlyyHTNCdI6sdEExZyK24YkuvrgTVpxLXI5aS
	 6uJHieKqzNUow==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 1/3] netfilter: nft_ct: Use __refcount_inc() for per-CPU nft_ct_pcpu_template.
Date: Thu,  6 Mar 2025 16:34:44 +0100
Message-Id: <20250306153446.46712-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250306153446.46712-1-pablo@netfilter.org>
References: <20250306153446.46712-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

nft_ct_pcpu_template is a per-CPU variable and relies on disabled BH for its
locking. The refcounter is read and if its value is set to one then the
refcounter is incremented and variable is used - otherwise it is already
in use and left untouched.

Without per-CPU locking in local_bh_disable() on PREEMPT_RT the
read-then-increment operation is not atomic and therefore racy.

This can be avoided by using unconditionally __refcount_inc() which will
increment counter and return the old value as an atomic operation.
In case the returned counter is not one, the variable is in use and we
need to decrement counter. Otherwise we can use it.

Use __refcount_inc() instead of read and a conditional increment.

Fixes: edee4f1e9245 ("netfilter: nft_ct: add zone id set support")
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Reviewed-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_ct.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index 2e59aba681a1..d526e69a2a2b 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -230,6 +230,7 @@ static void nft_ct_set_zone_eval(const struct nft_expr *expr,
 	enum ip_conntrack_info ctinfo;
 	u16 value = nft_reg_load16(&regs->data[priv->sreg]);
 	struct nf_conn *ct;
+	int oldcnt;
 
 	ct = nf_ct_get(skb, &ctinfo);
 	if (ct) /* already tracked */
@@ -250,10 +251,11 @@ static void nft_ct_set_zone_eval(const struct nft_expr *expr,
 
 	ct = this_cpu_read(nft_ct_pcpu_template);
 
-	if (likely(refcount_read(&ct->ct_general.use) == 1)) {
-		refcount_inc(&ct->ct_general.use);
+	__refcount_inc(&ct->ct_general.use, &oldcnt);
+	if (likely(oldcnt == 1)) {
 		nf_ct_zone_add(ct, &zone);
 	} else {
+		refcount_dec(&ct->ct_general.use);
 		/* previous skb got queued to userspace, allocate temporary
 		 * one until percpu template can be reused.
 		 */
-- 
2.30.2

