Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74A6D2882BC
	for <netfilter-devel@vger.kernel.org>; Thu, 22 May 2025 13:53:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747922016; cv=none; b=SuKM9k4lCJ+LmbKTlcJROS2XPrexsC1OIvU6BCQP7ibKkAXnDkGbqbzH4Gj2YcTfQRB6HBSNz5Mf9UiVblmPk9oirRCEgylWqLTUZtLU/2+W6DGtG0qWTp+dMGMNzYLnmwnd1/CZcJsIa4Amv/J3y4RPtF5OcpYByLd0a0nzOLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747922016; c=relaxed/simple;
	bh=Fsg7N5JgiS+Qg4H5bSHdR7hx0kXk8HhBgYg2+35xvcY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BvkF3slrIjPZLtUPs7y6IfY2XBa/qipHAN0yoWPERPwMoipi2s6zMhnJIqp2BXseQ+jKodXTKXWXkVAM1IPvxR/U03n5AgpceiGxUhvgTiv+75iSZ77FrXd82jrXjIItIOQs7wM7jbbMFlO3XJjDgaEPWnhtFFCS4r1+Z7ydHx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 3707F6014F; Thu, 22 May 2025 15:53:32 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next v2 1/2] netfilter: conntrack: make nf_conntrack_id callable without a module dependency
Date: Thu, 22 May 2025 15:49:33 +0200
Message-ID: <20250522134938.30351-2-fw@strlen.de>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250522134938.30351-1-fw@strlen.de>
References: <20250522134938.30351-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

While nf_conntrack_id() doesn't need any functionaliy from conntrack, it
does reside in nf_conntrack_core.c -- callers add a module
dependency on conntrack.

Followup patch will need to compute the conntrack id from nf_tables_trace.c
to include it in nf_trace messages emitted to userspace via netlink.

I don't want to introduce a module dependency between nf_tables and
conntrack for this.

Since trace is slowpath, the added indirection is ok.

One alternative is to move nf_conntrack_id to the netfilter/core.c,
but I don't see a compelling reason so far.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 No changes since v1.

 include/linux/netfilter.h         | 1 +
 net/netfilter/nf_conntrack_core.c | 6 ++++++
 2 files changed, 7 insertions(+)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index 2b8aac2c70ad..10d95556befe 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -470,6 +470,7 @@ struct nf_ct_hook {
 	void (*attach)(struct sk_buff *nskb, const struct sk_buff *skb);
 	void (*set_closing)(struct nf_conntrack *nfct);
 	int (*confirm)(struct sk_buff *skb);
+	u32 (*get_id)(const struct nf_conntrack *nfct);
 };
 extern const struct nf_ct_hook __rcu *nf_ct_hook;
 
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index de8d50af9b5b..201d3c4ec623 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -505,6 +505,11 @@ u32 nf_ct_get_id(const struct nf_conn *ct)
 }
 EXPORT_SYMBOL_GPL(nf_ct_get_id);
 
+static u32 nf_conntrack_get_id(const struct nf_conntrack *nfct)
+{
+	return nf_ct_get_id(nf_ct_to_nf_conn(nfct));
+}
+
 static void
 clean_from_lists(struct nf_conn *ct)
 {
@@ -2710,6 +2715,7 @@ static const struct nf_ct_hook nf_conntrack_hook = {
 	.attach		= nf_conntrack_attach,
 	.set_closing	= nf_conntrack_set_closing,
 	.confirm	= __nf_conntrack_confirm,
+	.get_id		= nf_conntrack_get_id,
 };
 
 void nf_conntrack_init_end(void)
-- 
2.49.0

