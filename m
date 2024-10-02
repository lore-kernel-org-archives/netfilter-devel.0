Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F7FC1D0F58
	for <netfilter-devel@vger.kernel.org>; Wed,  2 Oct 2024 16:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727884944; cv=none; b=BHTNol6Cn0xlp4cplZ8yO2LJlqzyLIbfaku52rr8jUC0Eb2ypTUkMZUA0x8qp4K7v2UNo8bJfGryK85qJuAOcC5EAu1evF43Wv2C6T11MYUOCHeF097GGKEaFoiWkE2rYA7pieVLPjzkLld8pG6S623mxcEjdzR/5i8QBU1Eo6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727884944; c=relaxed/simple;
	bh=1+qEdYw9A3KDSxxJkQfuyxtLmZWEgm9KdU6ld5EnJtg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cqs8eO4rGx3/uv/FWE3BtAnFRNZxoB1qMmQOc6en1aNEBSoxQBATgcgRps1chhlVqxY5rcX1qn4fIgTKupNKdFgB3I05dVMDN1LozB8quVvKp4iymmwxmTyq9tUcSC1q21pStDK0FEl8OlKjoq6s20K5mWuWScM+RhlyaqFJwXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1sw1nw-0003Yx-Ow; Wed, 02 Oct 2024 18:02:20 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 2/4] netfilter: xt_nat: drop packet earlier
Date: Wed,  2 Oct 2024 17:55:40 +0200
Message-ID: <20241002155550.15016-3-fw@strlen.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241002155550.15016-1-fw@strlen.de>
References: <20241002155550.15016-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Let net dropmonitor pick up a more specific location rather than the
catchall core.c:nf_hook_slow drop point.

This isn't moved into nf_nat_setup_info() because we do not pass
the skb to it.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/xt_nat.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/xt_nat.c b/net/netfilter/xt_nat.c
index d04f7cf6b94d..aaf31bd8381b 100644
--- a/net/netfilter/xt_nat.c
+++ b/net/netfilter/xt_nat.c
@@ -20,6 +20,7 @@ xt_nat_setup_info(struct sk_buff *skb,
 {
 	enum ip_conntrack_info ctinfo;
 	struct nf_conn *ct;
+	int ret;
 
 	ct = nf_ct_get(skb, &ctinfo);
 	if (WARN_ON(!ct))
@@ -30,7 +31,11 @@ xt_nat_setup_info(struct sk_buff *skb,
 	    (ctinfo == IP_CT_RELATED_REPLY && maniptype == NF_NAT_MANIP_SRC))))
 		return NF_ACCEPT;
 
-	return nf_nat_setup_info(ct, range, maniptype);
+	ret = nf_nat_setup_info(ct, range, maniptype);
+	if (ret != NF_DROP)
+		return ret;
+
+	return NF_DROP_REASON(skb, SKB_DROP_REASON_NETFILTER_DROP, EPERM);
 }
 
 static int xt_nat_checkentry_v0(const struct xt_tgchk_param *par)
-- 
2.45.2

