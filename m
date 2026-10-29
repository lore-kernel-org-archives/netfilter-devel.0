Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793295166;
	b=rjKCKEUqZz/u+z3NvXvtTVT8QXatiJwlMxkxiIWGohEwzEqY38/qJtgi2472Twkj1Qrd
	 YmUihKygMT2TcDGEljIvEyKgpjZ2go+PaoEcoHzycfUrmXfH9S2jWmezZ5Y9fVANVOWqW
	 ete0ULcC0h31xcNwDedM5DPPWKqXWtndvvNTmTsxy2IyLDp7YYcU7vb9X1gv43N1ip7yz
	 nXvnveZC7W87QIaMZkN4TnhDC5gvCLM3Tg0ZNVKAAsLLOCfk/RcVlDa2Z9l/vEQopVkkm
	 zIEHVGvyRDntPRCNASgvMibjXhzKHXxZoYLVPL++G5MzAgRXZu2zUv9JXOd/A8KFeOg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793295166;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding:X-Spam-Status:
	 X-Spam-Checker-Version;
	bh=0S/TjjQVMRldhVT5+NcjA9+M+QuaaAI1QiXd/7tVNHA=;
	b=A81tod5dDm9LEOrkoI/xsRr+f3WI3NlBXT0KR9hKcS5v4L5iYqw6SRNqNxpYMJWhAOy0
	 1U3+TB+dzHrNLbwJIPbAURGColT9NDzGOU83xsQlUUVMDy+tULpU3MV2cegoYsa3qLJax
	 r7gr+cOsfu0DFBxy7RptjsRUZlOjvaSbL/4o7LkGLett35hRuQT4dsTMfm322ZSTM/zjG
	 +z3L6qATxsAFKYETGGoTMo1x+8DAa3BPXFGwOqMeqx34meX9JFESa9KJhppuWDxmB0XdF
	 xclCXsVf9rvWja37Uk8iv/KLzVt6BDR1TzIf45ZhtUstEn3YO3HH1JLyiBwm1nTqmnQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b="KoVe/qL9";
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60611606A31E
	for <netfilter-devel@vger.kernel.org>; Thu, 29 Oct 2026 17:32:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 60611606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=KoVe/qL9
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1793295163;
	bh=0S/TjjQVMRldhVT5+NcjA9+M+QuaaAI1QiXd/7tVNHA=;
	h=From:To:Subject:Date:From;
	b=KoVe/qL9hmFVsi7S9xq6Av4r+NkgfXudRXrz7NA9L6+6OPWOFY69Vf5V4WnXX+7YD
	 u7ZfxZ6/7bRjbwAkA/7VCZF0QHMhmFhG6JltuVrKLeTzgeIApzSs3EP6eg0KLKfMbm
	 qxBjlcwizo+NA/6BXEBXjGeFLlb6x6QRGzIDuaYzcWHCjoEeS0etRAFfHrsG5tyddz
	 o/Y5euDWdmO4XZ1m8gZAr7MHOUeoR0TDUyF5m8aeDaIGxgDj56CdBCJ4xja+5gUM2h
	 qG914OeipGDhxnNb0SkGBwnczifdPQXN3zZ2iIh9yhU8yjG51/ooZNzplsDBcphhmN
	 f2hK8HLZK+K3g==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id D17DB60078
	for <netfilter-devel@vger.kernel.org>; Thu, 29 Oct 2026 18:32:42 +0100 (CET)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf] netfilter: lwtunnel: expose read-only sysctl nf_hooks_lwtunnel for non init-netns
Date: Thu, 29 Oct 2026 18:32:39 +0100
Message-ID: <20261029173239.224766-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
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

Expose nf_hooks_lwtunnel sysctl with 0444 mode from non init-netns
instead of 0644, sashiko reports this is exposing a global static branch
to modification by unprivileged users.

Fixes: 7a3f5b0de364 ("netfilter: add netfilter hooks to SRv6 data plane")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
Posted in late August, LLMs keep flagging this as a CRITICAL(!?issue, shrug.
Resubmitting this patch.

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

