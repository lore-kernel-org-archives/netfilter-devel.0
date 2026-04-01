Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84C8B3F8814;
	Wed,  1 Apr 2026 10:37:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775039824; cv=none; b=DspdN4htRFUzeLVbXU2U3KwbrcQD9MUwFtcRZWeZuucFJCEEb7rpaSxkXTAYmkXW4rvj6x+OvIUAhxLmI6X+7+yrj6GrePu6OqPHBGgB27YSbxjyVvBklJqNkq4VKbdYucYjmwEPEhPsqjFjQ9IxpruV2SJOZv8TA6H3DVxxxsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775039824; c=relaxed/simple;
	bh=Tqr1aN/Ur/VuXzMuNfJZiX+Ig/Bu/+C8ySXbOw2Z47M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J+/+0FOMEcUOKTCHYcVOKcqfCvUBh+n/T/y6HUTkw8RAVu6dBx7lUIUPy7jdv+3D/rKS3sP70bNnAj67QQN/cvIKLLmYBK1P1rcE53G6+4m5iUyuTJ619Pk2KPlecOLUGvjQSr+R3lLpT7Zs1cncn2MKSFMDfFXs0vkJ/E70tl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=knvfLF+E; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="knvfLF+E"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 9B60760273;
	Wed,  1 Apr 2026 12:36:59 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1775039820;
	bh=UYgOAwQm64h1KCB28H/YfUCYmOhCIrUdcDI7vWgzGFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=knvfLF+EQDXyRX0PTnnu+0YDGMMA5B2b8R0e4U2ZeIzh6WG+kpFO7SaUb/6PHgGN4
	 Q7bkjHMAqMwXmACLiSTG30/zFkdNTPn0McTuqFM9wDysH9FcmtEggRndes4iGAhc8p
	 S4D9vnnDIvY5I5P0NtU9CtMChv1OGGMaCNc7HXLFQw257vHaaoFMr4J//Ed8FELQDv
	 n10vXLrap2uKIP0NiNEsyCi096PNzwvdLaQj/oKr2+fa7iidmo3wFqdG0i6o7fYAZ2
	 K3s4n+IAzbx1Y/y91Ju9rzlDT7eQzBCjzvDc+dLxbm+kH9KBQ5hT/W+ayz+dvlyU5G
	 mUrAr02v7yeWw==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 06/10] netfilter: ctnetlink: zero expect NAT fields when CTA_EXPECT_NAT absent
Date: Wed,  1 Apr 2026 12:36:42 +0200
Message-ID: <20260401103646.1015423-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260401103646.1015423-1-pablo@netfilter.org>
References: <20260401103646.1015423-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Qi Tang <tpluszz77@gmail.com>

ctnetlink_alloc_expect() allocates expectations from a non-zeroing
slab cache via nf_ct_expect_alloc().  When CTA_EXPECT_NAT is not
present in the netlink message, saved_addr and saved_proto are
never initialized.  Stale data from a previous slab occupant can
then be dumped to userspace by ctnetlink_exp_dump_expect(), which
checks these fields to decide whether to emit CTA_EXPECT_NAT.

The safe sibling nf_ct_expect_init(), used by the packet path,
explicitly zeroes these fields.

Zero saved_addr, saved_proto and dir in the else branch, guarded
by IS_ENABLED(CONFIG_NF_NAT) since these fields only exist when
NAT is enabled.

Confirmed by priming the expect slab with NAT-bearing expectations,
freeing them, creating a new expectation without CTA_EXPECT_NAT,
and observing that the ctnetlink dump emits a spurious
CTA_EXPECT_NAT containing stale data from the prior allocation.

Fixes: 076a0ca02644 ("netfilter: ctnetlink: add NAT support for expectations")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Qi Tang <tpluszz77@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_netlink.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 3f408f3713bb..38bd7124d9f7 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -3588,6 +3588,12 @@ ctnetlink_alloc_expect(const struct nlattr * const cda[], struct nf_conn *ct,
 						 exp, nf_ct_l3num(ct));
 		if (err < 0)
 			goto err_out;
+#if IS_ENABLED(CONFIG_NF_NAT)
+	} else {
+		memset(&exp->saved_addr, 0, sizeof(exp->saved_addr));
+		memset(&exp->saved_proto, 0, sizeof(exp->saved_proto));
+		exp->dir = 0;
+#endif
 	}
 	return exp;
 err_out:
-- 
2.47.3

