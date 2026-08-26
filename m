Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59EBC396D28
	for <netfilter-devel@vger.kernel.org>; Wed, 26 Aug 2026 23:32:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787787149; cv=none; b=JEfoYCtW70WZIdLpn09j5A6gw59TOtP9+oiBQUqPh4sDzxurmDy9qyo30q+8lktx0auASs4G0zjMNJKKZTbvIHIN15UUkzpiPM5/zM+bMWmM6bjX34ERd+3GcAEXxKKMNQL4ChDbqM0ivRyfOKRpAgoTNQMnjfhKvWl1QSwlQcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787787149; c=relaxed/simple;
	bh=KE4775PuxJkvWGCjCpwssTUeqN7SfDOwqirKPuT3/RY=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lDGBFGdH0FhhX+t0srTnBONKJHFQeK89Zx9OdhkoqW2VoCLIlaE1UgjxiMovvOj1ui8bNA9rLR5mB44zOKh9J8OT0qM3CZ1Ku9qZT3Kgj19IluEEurmBkCVMrbRCvCHtT4mhabz6O3zyEI9NF5f3w+7AmILIxUR0ssY6NTG+wgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=nUNz87rA; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="nUNz87rA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1787787140;
	bh=0/xh+Jc85RZ+DxxP+Dx0kOEtSEZGiJZjgJ13yXeg1Nw=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=nUNz87rAO2jj4rmWdX401lVONSULtRAT2cVdLyOq35eTXLMo1rFGhyGdzn5h1E5WH
	 NDwIchAduWmFMCIiP2Zb70na7AauEOIgMVp0bk1Xmzoy6Fj/+mOZn1y1no6DzThzid
	 OUdSBkbWsYs5aZDtJkK2Utb30rfeZnO0nfwC/GZTso86QBlvd5NBiYpY/kfrHt7xOw
	 O9+lUO7YnGTFURrFVOoJoWY67HPphj/k2nxmOwh6VzXK002AYmBv5d/7j1XUw+/lWj
	 4hx9AbxWq2KOtc/Ni4E723zbSzzOILR/F5zHtCRAdObFAtudNQ/ne8g2hdjW4YnE8f
	 PKeu1N3/eyeBA==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 7716A6007B
	for <netfilter-devel@vger.kernel.org>; Thu, 27 Aug 2026 01:32:20 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf 2/2] netfilter: flowtable: bump ct refcount before teardown
Date: Thu, 27 Aug 2026 01:32:15 +0200
Message-ID: <20260826233215.279277-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260826233215.279277-1-pablo@netfilter.org>
References: <20260826233215.279277-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The existing ct state and timeout fix up after setting the teardown bit
is unsafe. The flowtable GC owns the flow entry once the teardown bit is
set on. Therefore, it might release the flow entry and drop the
reference on the ct while the ct fix up is being performed from either
packet path or netdevice notifier.

Bump the ct refcount, in combination with the teardown bit, as a
synchronization point, if refcount is zero, then this flow is being
teardown. Furthermore, if the teardown bit has been already set, then
this CPU lost race to tear down this flow.

Fixes: d2d31ea8cd80 ("netfilter: conntrack: fix erronous removal of offload bit")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v1: new in this series.

 net/netfilter/nf_flow_table_core.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 625caaa8addf..1a9fd5442b0c 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -392,9 +392,15 @@ static void flow_offload_del(struct nf_flowtable *flow_table,
 
 void flow_offload_teardown(struct flow_offload *flow)
 {
-	clear_bit(IPS_OFFLOAD_BIT, &flow->ct->status);
-	if (!test_and_set_bit(NF_FLOW_TEARDOWN, &flow->flags))
+	if (unlikely(!refcount_inc_not_zero(&flow->ct->ct_general.use)))
+		return;
+
+	if (!test_and_set_bit(NF_FLOW_TEARDOWN, &flow->flags)) {
 		flow_offload_fixup_ct(flow);
+		smp_mb__before_atomic();
+		clear_bit(IPS_OFFLOAD_BIT, &flow->ct->status);
+	}
+	nf_ct_put(flow->ct);
 }
 EXPORT_SYMBOL_GPL(flow_offload_teardown);
 
-- 
2.47.3

