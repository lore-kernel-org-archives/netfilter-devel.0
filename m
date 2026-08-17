Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1DA44322E4
	for <netfilter-devel@vger.kernel.org>; Mon, 17 Aug 2026 16:47:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786985265; cv=none; b=WD3a9cwkwcz8jcuR26hG+rK74ee5OL4sm9Uu3p4KrXusREaz8hmMjY5lnNuTNArdhriSrTGszPxF2ImjNdhH/gL4+yJ0QiDfJFyqkjyf2ocOsL0k+smfMs+hZ+kDXDmiklpcWXSzujn/arCTUz8G8tyiRZjrKG+7Pu4XqsLoX0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786985265; c=relaxed/simple;
	bh=mbmhFhVO0g1bOKvUP2XHCnNVb2B+yYWayxFSLVKXpLc=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oUyVtriwL44yC946UM2gThpJgeUHwS5kwtp1+ZuI/6vuO6q5nzehhbVRWfiFQIP8GI8vAZuoRo67zIXLVDxwzxSqurU+IQIbfwri3hmp7IZghQ3/4r1wBfLoAMetBKyZwK3KM+groOgrWXjEi8lt59L/u+wqWwe6A/OtLmHkEy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Rs6kYh/x; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Rs6kYh/x"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1786985262;
	bh=uZPJQRd8XrB7y14XTQWxJPXyUh5pSaD5GwaHPMmPFcQ=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=Rs6kYh/x+c/X///PKKwMMMWxvOq35p1KrKwrO+krRXdBkG1plCsl9rc8qq59E9wLq
	 mAI5bQlaFYqGPTmGCfGKyYkMvt/h/v8KxaH+b98RzjCxbXttvoY6xemPRTONRb3lWX
	 3VT9jTpvELrxR6444owwC2yhgVeh9jIykSMR016R4Q/T4e9cilzE/79UENrofk4c87
	 eT9Hb0Z0bucg5gwRmnOuS61hPt+6qqW1hDx1bfNZExkSEHncwCqJRUHkkF+ytiYOV0
	 w4lrqOVAD/2MHReCLg27iyceh/a6WrlShw75t0wiUEqjmGu16Hf2XJbwcI/mTljNA6
	 SJlAtasGYQ+0w==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 1C04860079
	for <netfilter-devel@vger.kernel.org>; Mon, 17 Aug 2026 18:47:42 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf,v3 3/4] netfilter: flowtable: serialize IPS_OFFLOAD bit clearing
Date: Mon, 17 Aug 2026 18:47:34 +0200
Message-ID: <20260817164735.1207999-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260817164735.1207999-1-pablo@netfilter.org>
References: <20260817164735.1207999-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Clear the IPS_OFFLOAD bit iif the teardown bit is unset to address a
race between GC, the netdevice event handler (which also results in a
lockless flowtable iteration to set on the teardown bit) and the
datapath (which can teardown the flow too). Otherwise, it is possible to
clear the offload bit of a different ct object that is recycling the
same memory area due to typesafe rcu semantics.

After this patch, the flow_offload_teardown() function is turned into
noop if the teardown bit has been already set on.

Fixes: d2d31ea8cd80 ("netfilter: conntrack: fix erronous removal of offload bit")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v3: new in this series

 net/netfilter/nf_flow_table_core.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 675d470ea581..8c84f02c4dd3 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -394,9 +394,10 @@ static void flow_offload_del(struct nf_flowtable *flow_table,
 
 void flow_offload_teardown(struct flow_offload *flow)
 {
-	clear_bit(IPS_OFFLOAD_BIT, &flow->ct->status);
-	if (!test_and_set_bit(NF_FLOW_TEARDOWN, &flow->flags))
+	if (!test_and_set_bit(NF_FLOW_TEARDOWN, &flow->flags)) {
+		clear_bit(IPS_OFFLOAD_BIT, &flow->ct->status);
 		flow_offload_fixup_ct(flow);
+	}
 }
 EXPORT_SYMBOL_GPL(flow_offload_teardown);
 
-- 
2.47.3

