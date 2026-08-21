Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D47B48F859
	for <netfilter-devel@vger.kernel.org>; Fri, 21 Aug 2026 14:38:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787323125; cv=none; b=rkXSmhQZ/qIfHnPWOeQ96UARoIgiH0ByKlYt7fqprPH4htlaN82EMn8iZiT/JAIBTqFXj9U9ZN2CJjJgY/h16c0OJ09Gi4i0GoW1096M0Z1WO1yUVpUea05kEzAoO1C7zMc3Stid/pULMNYx2j08rvpG4JsAChFBw72K8sZDkDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787323125; c=relaxed/simple;
	bh=wHuc1Xd8VFN5AV7CzAXi3tYtrNXnMgGo1DJn4pr6poU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TT1/ld5DmNBGv4XYOH6dJwv6tUfsm6nLhiFWZ//KXRXMnSknLskJd5luy4UMYeRUwOINDRNZZg5DGlw2ZHOIK1jAnbMooZilRsF1UdIgdsdoOCUKQ731ghwEG/SH547FmmR+zLwb0BPVdyMV0onta/2AqmuBvqkKkRI3Y1tUejc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=mQ7yXvGU; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="mQ7yXvGU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1787323117;
	bh=OL+RLDl+eORDZz3/aVMHDvQiKQO+37TL+ONDjnSWUdI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mQ7yXvGUhgV7Cvs85WPvq3L9T1VMFnD87AlrPrs5+R1NLPjtQHY+XLov502iEOQxA
	 6oPHx3J0ZC79TgjXO6hz9ruySQ/v6MX9tyMD3E5QrHsWLy7cycisZrEi/mqlQ62mvy
	 r+YKeQQxCIO2PkKCFmLajQxLI+16W5LbYVTSYtLyvaRyX8d+NS8U+/Ev0hjijMfXQ+
	 n8hZ7JsoiujGvMLKRt2AAl5Nfne6M4pKpKmeyhqbe0o/XsGcIGoHponmWcGilqGbh5
	 5+9qQStFxcSEGcq4ENTwvMFdlXUQ1/6KudiNOAburoN59LjHK31DLof6bJiZUDj7mf
	 dqmfiu70A/4DQ==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 575BB6008E;
	Fri, 21 Aug 2026 16:38:37 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de
Subject: [PATCH nf-next 05/10] netfilter: nf_log: use GFP_KERNEL_ACCOUNT
Date: Fri, 21 Aug 2026 16:38:22 +0200
Message-ID: <20260821143827.183963-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260821143827.183963-1-pablo@netfilter.org>
References: <20260821143827.183963-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

GFP_KERNEL_ACCOUNT is preferred these days for memcg, replace
GFP_KERNEL by GFP_KERNEL_ACCOUNT.

Allocate per-netns sysctl via GFP_KERNEL_ACCOUNT.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_log.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_log.c b/net/netfilter/nf_log.c
index f4d80654dfe6..f1d3649e3fc6 100644
--- a/net/netfilter/nf_log.c
+++ b/net/netfilter/nf_log.c
@@ -493,7 +493,7 @@ static int netfilter_log_sysctl_init(struct net *net)
 	if (!net_eq(net, &init_net)) {
 		table = kmemdup(nf_log_sysctl_table,
 				 sizeof(nf_log_sysctl_table),
-				 GFP_KERNEL);
+				 GFP_KERNEL_ACCOUNT);
 		if (!table)
 			goto err_alloc;
 	} else {
-- 
2.47.3

