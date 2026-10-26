Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.28.169
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793019207;
	b=OiByDZ6F+Du4abrpcm8VqPzL/55vZTMm472jVSzya+oyDVJl+jLpGGghAVGcMQ8sKBPo
	 FQiNr356d7SuX8aAAR53pegAMU2yp4rX3z8YM7WqdXLaIyGUh7RuveYhdy1xZVIVJCnni
	 Yf4jgs0d9u96hGcDdPeR8fgW1bUFrRE80BkGuEi9hVUdwKNvbZp9hSyrnPP8SHnv7iQwe
	 2PozQz6tpQJq8ZpiwOKspC0jLlKdGmIqp5XdjPFk2Wv/auCxLW0NRSa6H7ifChAMFc3Io
	 rN5X1BYhJdAmfwjtT9qx1ue3zKLgzaN8ImWmdKLhYtEKPUhYlnxbTt/aEQJ9gqzkAbA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793019207;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:From:To:Cc:
	 Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=4sPsWijS0o1vuhCMct6ehUV/2rvCyrpEssuEEpT4abY=;
	b=OvtRb0ywLae+NntUE46ywdEFIn+Zle7r55qgnhPkIndZwgrNvxQOrpo8lq/hsPQ7h+S+
	 zrG3zTWL4/kRUe7U9Lo0Xe2UFvj/MYvaWVsWCr2cXm04/HbSd4cK+5okAD4rXQQOtInCB
	 a7Z5q2IM0bLfD6/FlfOs5T4yBgdg5W7fOSPtHhRMJYHJ1N1HFwyojlk2pv5pt47WFmk+l
	 ca9+0mv7EQ8hYyEtW81OEG7wX/EwdduP1MWI682WR1eItqRWdsZTwaqLXhvOf4RvW8/ZN
	 tkU99i84aIWxpRcKm3vQ629CkmUemBqCFuDpXtSdmriNdvAoeGwH8wdrmE2BQH8S/cQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=xiaopeng.com;
	spf=pass smtp.mailfrom=xiaopeng.com;
	dkim=pass header.d=xiaopeng.com header.i=@xiaopeng.com header.a=rsa-sha256 header.s=default header.b=AWBEHmIh;
	arc=none smtp.remote-ip=115.124.28.169
Received: from out28-169.mail.aliyun.com (out28-169.mail.aliyun.com [115.124.28.169])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3C31606A31A;
	Mon, 26 Oct 2026 12:53:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E3C31606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=xiaopeng.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xiaopeng.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=xiaopeng.com header.i=@xiaopeng.com header.a=rsa-sha256 header.s=default header.b=AWBEHmIh
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=xiaopeng.com; s=default;
	t=1793019196; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=4sPsWijS0o1vuhCMct6ehUV/2rvCyrpEssuEEpT4abY=;
	b=AWBEHmIhQCCnHyNEvCdhbg0f2AuqsF7AlHUVK/HiYovR0/32IKs2kjcIZCP069tXRLWsw/u9r0GZvDRiQBOO+corbwKai9+asfvc8LkSD5n9JSMRfgArWLl/p4/yQ/HuJ7UF0iDP5uKNHdQbTH1bPtR6aLSLpmo5tfDFCJAyKXo=
X-Alimail-AntiSpam:AC=CONTINUE;BC=0.05106358|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_system_inform|0.0177122-0.0906822-0.891606;FP=18328251804473314834|0|0|0|0|-1|-1|-1;HT=maildocker-contentspam033037034138;MF=fangxy@xiaopeng.com;NM=1;PH=DS;RN=13;RT=13;SR=0;TI=SMTPD_---.jq1bEE5_1793019194;
Received: from localhost.localdomain(mailfrom:fangxy@xiaopeng.com fp:SMTPD_---.jq1bEE5_1793019194 cluster:ay29)
          by smtp.aliyun-inc.com;
          Mon, 26 Oct 2026 20:53:15 +0800
From: Fang Xieyan <fangxy@xiaopeng.com>
To: pablo@netfilter.org,
	fw@strlen.de
Cc: phil@nwl.cc,
	davem@davemloft.net,
	edumazet@kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Weibin Liu <liuwb@xiaopeng.com>
Subject: [PATCH] netfilter: xt_policy: add NULL check for skb_dst() in output policy match
Date: Mon, 26 Oct 2026 20:53:13 +0800
Message-ID: <20261026125313.14810-1-fangxy@xiaopeng.com>
X-Mailer: git-send-email 2.50.1
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

match_policy_out() accesses dst->xfrm without checking whether
skb_dst() returned NULL. If no dst entry is attached to the skb,
this dereference is invalid.

Check dst before accessing dst->xfrm and return -1 when no dst entry
is present. This follows the existing handling of a dst entry
without XFRM state and preserves the XT_POLICY_MATCH_NONE semantics
in policy_mt().

Code review identified the unchecked dereference. No reachable path
that passes an skb with a NULL dst to match_policy_out() has been
identified in current kernels.
Reviewed-by: Weibin Liu <liuwb@xiaopeng.com>
Signed-off-by: Fang Xieyan <fangxy@xiaopeng.com>
---
 net/netfilter/xt_policy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/xt_policy.c b/net/netfilter/xt_policy.c
index ff54e3a8581e..6bbaf92f0cfc 100644
--- a/net/netfilter/xt_policy.c
+++ b/net/netfilter/xt_policy.c
@@ -87,7 +87,7 @@ match_policy_out(const struct sk_buff *skb, const struct xt_policy_info *info,
 	int strict = info->flags & XT_POLICY_MATCH_STRICT;
 	int i, pos;
 
-	if (dst->xfrm == NULL)
+	if (!dst || dst->xfrm == NULL)
 		return -1;
 
 	for (i = 0; dst && dst->xfrm;
-- 
2.50.1

