Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E0CA3E92A5
	for <netfilter-devel@vger.kernel.org>; Fri, 16 Oct 2026 08:52:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792140736; cv=none; b=Kp8dn9B/mRYGv7t6ruqiNBK3MKE/VTl/mN3GI46IPed1RVGiXRddxefXL6PDp8gIVdbrTc0Tl+MfjDzCYPzTqIkt+5eoxMpfLeXHEKWMTiUNktaX5niRr+4m4wDaYETp0C4zRo0ZVKPm7ImTDFPwFKfZJKAtu3Ti92mdqZIyygs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792140736; c=relaxed/simple;
	bh=uJ1fw8txAPH7HOgGZLLgBAqtW0qOV0CByG3IzXHMbyw=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=QzTRNIm0ikUlbnNe/9JQH1lYYKCaFsaG9h+izrg0geKojrZjbugsbZtrpqXD2yZapnP84oOLsrRcbSZjuvBTkkr7XqqVX4+mJ2gWKd95lx58q0cra51tYkK9o5w60jlVP1m7PwKMQ9v9IVQZYfl1ONz0CaSiKYd8Y/kmcqRNhyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=XR/zxgPc; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="XR/zxgPc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1792140725;
	bh=U7wrGPGvypBKnlXL7pe0M4uIo5aNCdsm4Tg/k5HZnIo=;
	h=From:To:Subject:Date:From;
	b=XR/zxgPcDNY8EnDiMjuJmAXxpPwetbKdlWOwrom3KvyLKkhOg0jtFcTVtTrl07ZPU
	 ZvLiot/g7ssIJ0Mabff7EntwM43JIF6tq528coG4C2cF3Wj+7U8Xk2zJQKiTcRE6K+
	 UJ2zjl6JQbMyTqoz1mPUNWDusUkMePL0GzMcH4K3qWs6Ohf3G+yV6SpVhohJzSlhrQ
	 9LTpPhiK0VfOXDCI6ED/TBRMRBdECL1D6ZOtU0TLBTWSLDs6hb9QxqbV9/2mzesmhm
	 ugeO43lsgajKAUNhbIE1/GO2VyKS0pyAOZGeW1hRq9cpwmaG8J3vMzDAJWpzuI7n1X
	 LFepJ4c5KkHng==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 3B9A260050
	for <netfilter-devel@vger.kernel.org>; Fri, 16 Oct 2026 10:52:05 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next] netfilter: flowtable: do not hw offload flows in teardown state
Date: Fri, 16 Oct 2026 10:52:01 +0200
Message-ID: <20261016085202.1670076-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Sashiko reports that refreshing hw offload from packet path is racy
since the flow might be already going away. Refresh the flow instead via
GC worker to address this, ie. if hardware offload fails, next GC run
will give this flow a chance to offload it to hardware.

Since commit 7c549fb7eecd ("netfilter: flowtable: generalize pending
status bit"), GC skips flow entries that are still pending to be
offloaded. Let's just check for the teardown status bit after the
pending bit is set on to address this race.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
Another attempt, aiming at a more simple approach to address the race.

 net/netfilter/nf_flow_table_offload.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index 5aed013d6468..0473696ddb1d 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -1101,8 +1101,9 @@ nf_flow_offload_work_alloc(struct nf_flowtable *flowtable,
 		return NULL;
 
 	offload = kmalloc_obj(struct flow_offload_work, GFP_ATOMIC);
-	if (!offload) {
+	if (!offload || test_bit(NF_FLOW_TEARDOWN, &flow->flags)) {
 		clear_bit(NF_FLOW_PENDING, &flow->flags);
+		kfree(offload);
 		return NULL;
 	}
 
-- 
2.47.3

