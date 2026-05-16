Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 232603D649F;
	Sat, 16 May 2026 11:56:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778932601; cv=none; b=A4WMlN/4Vk7lwdpQioPmKs4O+j+WfZGnxz1Kax3tJlLFpCeEmcmoTkdGM90zMaW3LMfb4hBWKmVCG06PKWfIUzcU88JLZR1tykt5MMufTgUBfPe9yFN1JdDus5x+DBnnUJTcleuYkZFhllvA9hGum0qhU9C4vVQe/LN/Q+9R/qk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778932601; c=relaxed/simple;
	bh=fUhc3No5F31SupMyXeBkRp+8c9BKgzQXYGX99CL2u1g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CyCyF61F1oNxFtDHeMh+s2gOFiYYpTHcqTjvWX+qKClazd1ytUHB9g87mRGNt/PZWG0/PyqiOeJLWn9tOsYI8DaVcyfw1FAEd9yDrHo/VefEnpGLhIHeH8HOPhz3XpX7bb+bGyuwe3y8e+BuQhaSGnf4VNMmWMpRx0jKGR+0CvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=QZcWZrEV; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="QZcWZrEV"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 84426601A5;
	Sat, 16 May 2026 13:56:32 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1778932593;
	bh=57GA0S6LBPkf3G9fBfZQH51PjmOpFsu1dMlcjI//taQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QZcWZrEV8G+R0z7LC+Xjyr0XHySTq6TbO8dnMyL3A16cDXR+zxvF9xYiBpABeVs8H
	 3+QGXYln8vkZiuXSwHtUOm/mpSWD8QPw6K0KYsGLpSTA5do33dAjVdTw3u1volpLVB
	 m06lF2afv1QrcqnkpIIOXXkiPKA9BupX4qCIDqEuNRy1jCNwxNwlxEIl2j2hNnsZ49
	 rO0xgMcBz+qzqceVsIKe7ROkvpsqC78DxBy4wICIGzc+aNCSh3FoGdr93aBIldWxRR
	 YdOoyE9sa2qFIzEjewKL6Tr8jeAEuF1h9fMpiAlXA0bD8oOIl+mzf0UelJls8LFnt7
	 tMGUGexRSs74Q==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 01/12] netfilter: nf_conntrack_helper: fix possible null deref during error log
Date: Sat, 16 May 2026 13:56:16 +0200
Message-ID: <20260516115627.967773-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260516115627.967773-1-pablo@netfilter.org>
References: <20260516115627.967773-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

Reported by sashiko: there is a small race window.

If a helper module is unloaded or a userspace-defined helper is
removed, nf_conntrack_helper_unregister() sets ->helper to NULL.

Handle this safely.  This needs a second patch to close related
race during nf_conntrack_helper_unregister().

Fixes: b20ab9cc63ca ("netfilter: nf_ct_helper: better logging for dropped packets")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_helper.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index b594cd244fe1..17e971bd4c74 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -321,8 +321,8 @@ __printf(3, 4)
 void nf_ct_helper_log(struct sk_buff *skb, const struct nf_conn *ct,
 		      const char *fmt, ...)
 {
+	const char *helper_name = "(null)";
 	const struct nf_conn_help *help;
-	const struct nf_conntrack_helper *helper;
 	struct va_format vaf;
 	va_list args;
 
@@ -331,14 +331,17 @@ void nf_ct_helper_log(struct sk_buff *skb, const struct nf_conn *ct,
 	vaf.fmt = fmt;
 	vaf.va = &args;
 
-	/* Called from the helper function, this call never fails */
 	help = nfct_help(ct);
+	if (help) {
+		const struct nf_conntrack_helper *helper;
 
-	/* rcu_read_lock()ed by nf_hook_thresh */
-	helper = rcu_dereference(help->helper);
+		helper = rcu_dereference(help->helper);
+		if (helper)
+			helper_name = helper->name;
+	}
 
 	nf_log_packet(nf_ct_net(ct), nf_ct_l3num(ct), 0, skb, NULL, NULL, NULL,
-		      "nf_ct_%s: dropping packet: %pV ", helper->name, &vaf);
+		      "helper %s dropping packet: %pV ", helper_name, &vaf);
 
 	va_end(args);
 }
-- 
2.47.3

