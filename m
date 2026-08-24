Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A602350A05
	for <netfilter-devel@vger.kernel.org>; Mon, 24 Aug 2026 22:19:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787609950; cv=none; b=EOBb5qhmlCXFRlWrFeGFse0vSy8nr7cwtqPkG9u3Ge4zf4o5p3i3hWgDCchhut6S4TfP+TKfoscH4d5y0/HE65yjHI+SWZv4wlce0ws1Q/2F0KB1O00HtnUVuLcf3FSnLGtFjGY6TK9uyuCG7vn+JhfIeSId4gKzwwCTwIa4es4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787609950; c=relaxed/simple;
	bh=Yh1jZ3+AxrVabd4VrdClN3ov/fhsHsUl4PGk/O3keqM=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=fht2CEe6RiooQp9/TMDHa1XEFFeo7tOX/Ffn9c7UmOu82iLCs3b4hu7NxEwmWMjt2EB2CsP/R82AVNI+Kh+s6V5/p7WA8h6sx+RGjFxwN3AJeFQXrIAGPIZdb1iIPe3bpe7jhrHC/2IPNY0qcIiEemoK/TQ3iwLjQ4Z/gxEB+EQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=EXbxNJTQ; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="EXbxNJTQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1787609946;
	bh=6XVoVpri3e9sFHZoc+U/2osKSPMavlWYeRVni++0xPI=;
	h=From:To:Subject:Date:From;
	b=EXbxNJTQdMxsl2lTe1siRFhIM230648LzMyuTqwEMD7tI2GKLm/+n8ncA5MEg7Njd
	 x0q5MbEFurrEJfDwGu5UuVsH+bW3cGued0/VyZVVoFIK3kPD5LAyEOvijhzrpekGAY
	 BrpDskmpzEx+tYfqn4aMN8ZrJ2lJTHYiNmSfwVq3qggw94rZ03EucSmJpc45S3ps1X
	 qhkHMIVo7wpJioCCKhbvhRPwZ42x5dfY34DYP6BkyK/z0UvP+uXBwDV9utgpkstgky
	 QapsFuy63ynCvVLQ5ChnPbJqxelsrpMEZSYt8cSCpTPqBoiN7QRzYmzZn+mb5XO7o9
	 gaix8CZuNlGaA==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id B58286008C
	for <netfilter-devel@vger.kernel.org>; Tue, 25 Aug 2026 00:19:06 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf] netfilter: lwtunnel: expose read-only sysctl nf_hooks_lwtunnel for non init-netns
Date: Tue, 25 Aug 2026 00:19:02 +0200
Message-ID: <20260824221902.96694-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Expose nf_hooks_lwtunnel sysctl with 0444 mode from non init-netns
instead of 0644, sashiko reports this is exposing a global static branch
to modification by unprivileged users.

Fixes: a2225e0250c5 ("netfilter: move the sysctl nf_hooks_lwtunnel into the netfilter core")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_hooks_lwtunnel.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_hooks_lwtunnel.c b/net/netfilter/nf_hooks_lwtunnel.c
index 4e1eef1ba0f1..0b4fca26233f 100644
--- a/net/netfilter/nf_hooks_lwtunnel.c
+++ b/net/netfilter/nf_hooks_lwtunnel.c
@@ -68,14 +68,18 @@ static int __net_init nf_lwtunnel_net_init(struct net *net)
 {
 	const struct ctl_table *table;
 	struct ctl_table_header *hdr;
+	struct ctl_table *dup;
 
 	table = nf_lwtunnel_sysctl_table;
 	if (!net_eq(net, &init_net)) {
-		table = kmemdup(nf_lwtunnel_sysctl_table,
-				sizeof(nf_lwtunnel_sysctl_table),
-				GFP_KERNEL);
-		if (!table)
+		dup = kmemdup(nf_lwtunnel_sysctl_table,
+			      sizeof(nf_lwtunnel_sysctl_table),
+			      GFP_KERNEL);
+		if (!dup)
 			goto err_alloc;
+
+		dup->mode = 0444;
+		table = dup;
 	}
 
 	hdr = register_net_sysctl_sz(net, "net/netfilter", table,
-- 
2.47.3

