Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72EDB3AEF37
	for <netfilter-devel@vger.kernel.org>; Fri, 20 Mar 2026 12:59:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774011599; cv=none; b=hlRJYIPCW3FqWdpwBhCcZdXcipMXgGmC8r6PBlgOdG0jYJXkzyzavcaEXK0x/kaE+/mIpC74k6t5foFcXX+8kBwEIvGkVQKMBrIjc1h1BHl4bTEAFVvg33JIxLgQfJhxQd60+mVrqAIMXw+f9UmNbMB5sO9rVlWlhSULgYY+Y80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774011599; c=relaxed/simple;
	bh=cW4pgMz2gqzW2lp6MKR7hIW4DjqoYA4iS+aFHtkwOx4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IG5jAoJgQCXoDT21AngtBy3tM6T3N8IsMkLVgUdAN9ZQan29jNqnMnEp0C4W/5Hn3VhouySu5pwuWnY86xyWTJy8/nk7Pgq3JaUkD1AWcIrtpjCGmvSiSWJWjz4TTQCO4Ma+NtgjNhlfLbIxCGb13n2GYe0Ybb1L3OEkIX6glig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=DZjIXyiO; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="DZjIXyiO"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id DF27660178;
	Fri, 20 Mar 2026 13:59:56 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1774011597;
	bh=zXO2KCwOrzIoB+sDRRmDT3jprvXvCIHkbpUfi0RSksE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DZjIXyiOAfX/F1S8MyNIKSPwDcBXuIwTwGh0HUqkUkoSjkPz5x1kUJ0inXBx+PPO4
	 IsQrXBxYbUZvUFHqICoHZE1t1FWgNWcNkzJdTxBdtgbF7WLkneKg2Y8dfdv8ABJXX2
	 U3tgFfF/bSN9HSm2xBLI/SMAS1DoKJYTJb5D66+LCKEtjqWhoFGU95PA6/AsR9ZjdE
	 wpfS1LWAe58Gl8ZU/F1RpaSgH74giVhGaNzWrk4s8kkhJ6Uarp54ZS87EYg5jxt2gK
	 l8i7viBhMw5AbbNkK7XC1/PA1ttdfIt1Qs6WsHt6QGYlLy0w4/kvUE9jeqxUWrPcLL
	 VFaf4AnMUts1g==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de
Subject: [PATCH nf 5/5] netfilter: nf_conntrack_expect: skip expectations in other netns via proc
Date: Fri, 20 Mar 2026 13:59:47 +0100
Message-ID: <20260320125947.305117-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260320125947.305117-1-pablo@netfilter.org>
References: <20260320125947.305117-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Skip expectations that do not reside in this netns.

Similar to e77e6ff502ea ("netfilter: conntrack: do not dump other netns's
conntrack entries via proc").

Fixes: 5a1fb391d881 ("netfilter: netns nf_conntrack: add ->ct_net -- pointer from conntrack to netns")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_expect.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index 4f2c0cb871d7..adb542a2407b 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -643,11 +643,15 @@ static int exp_seq_show(struct seq_file *s, void *v)
 {
 	struct nf_conntrack_expect *expect;
 	struct nf_conntrack_helper *helper;
+	struct net *net = seq_file_net(s);
 	struct hlist_node *n = v;
 	char *delim = "";
 
 	expect = hlist_entry(n, struct nf_conntrack_expect, hnode);
 
+	if (!net_eq(nf_ct_exp_net(expect), net))
+		return 0;
+
 	if (expect->timeout.function)
 		seq_printf(s, "%ld ", timer_pending(&expect->timeout)
 			   ? (long)(expect->timeout.expires - jiffies)/HZ : 0);
-- 
2.47.3

