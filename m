Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CA59469856;
	Thu, 27 Aug 2026 14:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787840271; cv=none; b=PM/Tkubi8OaqXenKj3ymPkz9Vo/+qbW40OKCpZSnqUh3i10YF3NYUXdg2d2qC7uCRYv1Q/sqASf9ZRocFLblof6FduD9HaL+GwUkpiqv1l/yeB3YdDbadEyQQsP1Ba7NLCqQdthYwUDSoH78AQe3NUC82Pxi+qFU/cj3Z5DAdE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787840271; c=relaxed/simple;
	bh=T8bM4HQ95BX3xprgC4vGRfG1bi9SmwTfhRVEP1jauCw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m299nNwWYtvqC1P/nk9GaFP7qcjoIgnKsh09ry+L/KHYbSO1HUxHMw0mIpY1zXUs93I3xid40cwqhsWB8sGreXyi9s8/dH5PWaFQrUuztW+9bxKOxYyksERTV0KRr0BCQ1qIiBWB3Pjt49nKECseoRRM/Wsrf67ibiD0SETgKdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=TVhRtTA4; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="TVhRtTA4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1787840261;
	bh=6a4SMX45FUp/eYu0m0MKSwkwq2xDCf0eQzlTqw/9AL0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TVhRtTA4wyw3A2HksrHHviOq0/38iSusNxv+ZnTVE0wvkWe1kTNwoucUWFXLW5uRl
	 GAr2JLSWGU4GQYiRNlEO/eQWrHVEaNSVR8QrvoSg62xl88vZtVmIzUAuyZWtATkmyr
	 KZ6Oz3IyHhdFLvVC8jHK3DLX6ZjmLRLLOd18XKt/8LDdaqv1O5J0v+U6ruK0DW9Lu6
	 k7Fz6uPsMK6XC2LEg8znqwqqjz7AizcYyft+OYn72y/+ZmnBlJd+55BgQCBJYWEsXl
	 rS4wnsIo97IC0QxTk6v60Q7bc1R9BWC3/qeedu9wOameJYzqBZmb/Hx12/stW7vFw9
	 6Z8SAyS32GUdQ==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 51D5760079;
	Thu, 27 Aug 2026 16:17:41 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: [PATCH net 2/9] netfilter: conncount: use DEBUG_NET_WARN_ON_ONCE on reaching count limit
Date: Thu, 27 Aug 2026 16:17:26 +0200
Message-ID: <20260827141733.423453-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260827141733.423453-1-pablo@netfilter.org>
References: <20260827141733.423453-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Fernando Fernandez Mancera <fmancera@suse.de>

Replace WARN_ON_ONCE with DEBUG_NET_WARN_ON_ONCE in __nf_conncount_add.
The function handles count limit breaches safely by returning
-EOVERFLOW, so a production backtrace is not needed. This prevents
unnecessary system panics when panic_on_warn=1 is enabled in production
systems.

Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conncount.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conncount.c b/net/netfilter/nf_conncount.c
index 85487f92af50..4292c3d9addd 100644
--- a/net/netfilter/nf_conncount.c
+++ b/net/netfilter/nf_conncount.c
@@ -251,7 +251,8 @@ static int __nf_conncount_add(struct net *net,
 	list->last_gc_count = list->count;
 
 add_new_node:
-	if (WARN_ON_ONCE(list->count > INT_MAX)) {
+	if (unlikely(list->count > INT_MAX)) {
+		DEBUG_NET_WARN_ON_ONCE(1);
 		err = -EOVERFLOW;
 		goto out_put;
 	}
-- 
2.47.3

