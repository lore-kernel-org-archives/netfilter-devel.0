Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E66E371CE6
	for <netfilter-devel@vger.kernel.org>; Wed,  8 Jul 2026 16:19:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783527598; cv=none; b=hFs6OLB8kTB5rNOufU9KWrOX3Zu7lMSTwHGDhE+VE7wGD+2xQ1P3BjdVvSDeOl8U4OKM3Ta5s6do230tLGk/xRdqVl0Y/zjvilB5OXnfF402NsUqiCj9/H5lJt2DLWprmgyufLi2Tx1cw4DtSHvWTmtJhHcpqAeMiF9+v8laX5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783527598; c=relaxed/simple;
	bh=RUNc+u7Nf904qtnFiMExe8Rk/r6SQuHAENS8LJZEWfo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RnQBAu+nc2+lg7/vnh3p1q7m9qs4r4oms5A8hEL9bMcSLT+kcHG/zHOc0O00JG9LS1Bx4e+kDppgRvHR7H2tQl400alOc/c271PXmvuZ1KSOJd0zpJOqAwgrVt2Yv7H9VN2xnvWBIP+FIUBtfXg2y+UmlTe054QY0QGGcJcIEvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=CJATuPww; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="CJATuPww"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Y9JHlDnpxpLAhDaUEwKhaqSyijdAegnUyLsxAAa/a34=; b=CJATuPwwNXt+8VnK0yB43GqoFJ
	aC25WUu6kEOf9L6VN7pIiD6fzc5IL+9K0moU64oZipKko9tUWOEz58F76wslxQibeSjv4fUU4IYrV
	kSge1G1AkmHqkWDPH+B/3jByUhfJ2OtF+9SIBDQu+RPvpCJRgF4VbcQV/gK+O6cZjxy6ounD5kC3R
	0XRpqZU9mBsWim/Z4uBH4oUpiu24d4zNXXJ0Ss7ALxs25tD5kGDsizaPmRxYRuxCPw3+PprVz8S1k
	q/B2EOanxqq1gHkisgnsZ24oTz/5C+5PWlyYU70vbehCm0EVjStb30FuVFbddBhCOYZ3i6PXcInyt
	sgIgdXbw==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1whUzy-000000001s3-0srt;
	Wed, 08 Jul 2026 18:19:46 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org,
	Paolo Abeni <pabeni@redhat.com>
Subject: [nf-next PATCH 4/4] netfilter: nfnetlink_hook: Fix for concurrent NAT hooks dump and change
Date: Wed,  8 Jul 2026 18:19:40 +0200
Message-ID: <20260708161940.1477671-5-phil@nwl.cc>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260708161940.1477671-1-phil@nwl.cc>
References: <20260708161940.1477671-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If hooks are added or deleted, the nf_hook_entries buffer is reallocated
and the RCU-protected pointer updated. If a dump requires multiple parts
(exceeding sk_buff space) the second invocation may see a different
nf_hook_entries pointer than the first one. Detect this just like the
outer nfnl_hook_dump function does, by storing the pointer value in
context. If it changes, signal user space it must restart.

As with the stored loop counter, that stored pointer value must be
manually zeroed upon successful loop completion since this inner
function may run multiple times for different nf_hook_ops but with same
context.

Fixes: b010e2a4a9ac ("netfilter: nfnetlink_hook: Dump nat type chains")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 net/netfilter/nfnetlink_hook.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nfnetlink_hook.c b/net/netfilter/nfnetlink_hook.c
index 0657fbb3e605..e01e59eddd64 100644
--- a/net/netfilter/nfnetlink_hook.c
+++ b/net/netfilter/nfnetlink_hook.c
@@ -55,6 +55,7 @@ static int nf_netlink_dump_start_rcu(struct sock *nlsk, struct sk_buff *skb,
 struct nfnl_dump_hook_data {
 	char devname[IFNAMSIZ];
 	unsigned long headv;
+	unsigned long natv;
 	u8 hook;
 };
 
@@ -351,6 +352,15 @@ static int nfnl_hook_dump_nat(struct sk_buff *nlskb,
 	if (!e)
 		return 0;
 
+	if (!ctx->natv)
+		ctx->natv = (unsigned long)e;
+
+	if (i >= e->num_hook_entries ||
+	    ctx->natv != (unsigned long)e) {
+		cb->seq++;
+		return -EINTR;
+	}
+
 	nat_ops = nf_hook_entries_get_hook_ops(e);
 
 	for (; i < e->num_hook_entries; i++) {
@@ -361,8 +371,10 @@ static int nfnl_hook_dump_nat(struct sk_buff *nlskb,
 			break;
 	}
 
-	if (!err)
+	if (!err) {
+		ctx->natv = 0
 		i = 0;
+	}
 	cb->args[1] = i;
 	return err;
 }
-- 
2.54.0

