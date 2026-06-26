Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B78213DBD55
	for <netfilter-devel@vger.kernel.org>; Fri, 26 Jun 2026 11:40:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782474048; cv=none; b=BYQhBBVG3tb5+Isu/H1Fs2uRuzhG7FLHyBM/8a/YIqC3ugWHrZRFIXnUGFbLI2v0ZtpebbHDjuAx2ZPouKtumJEwxxrqbsglIWRQYZ1zq4+KgBg9MCNtkDYxBQm5ZE9RCMGDHpznTCwvDbh5xjCkQoNLXmH0B9hvAIovWYbXb1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782474048; c=relaxed/simple;
	bh=8n/znfvIg9weJ9DTMUBZslAI69/A8W7UE5bRjRqaj40=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=j+6vejG0/FKkJk5AsGC165JcfjzXsBOM2KMIJelqYJRgsTjlYdvv0eX3uMgXF9Ijce4xsE3OpKb6dU7KPL5c8gIF/1cN9ZT94aZs28Tt5JtEyA26rHNMd9KCUKaXis43+ca0a/QyhLV+9RNQ9KTqa0yCUHsA7Gv/oJvc4fDzhOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Xzj/x6A7; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Xzj/x6A7"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id A34C16058E
	for <netfilter-devel@vger.kernel.org>; Fri, 26 Jun 2026 13:40:45 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1782474045;
	bh=wobwtPb65wrcCSck+ADJCfoY8cx48V37kDXvWxj8/t4=;
	h=From:To:Subject:Date:From;
	b=Xzj/x6A777jaXLHjPGA6rKZeK1TH7MgPzAcCmrYa46JwgrMw3Du+Gg1oLaE/g8+3E
	 o6HHOcSgfVPhNf0Rf1huv3zIj8RsajAzxPUjvjcM/sBSjBlJKXhl/jvT9FvwVIZRFe
	 Ey9HzONYxIdQFuPzYZNV74XBZXL+pjRmwQYihUR7UVs0cYOVcPsi3E3ZturUG0H7FT
	 VugA2jEPyp7Z9DjjD6IOZ6OsaI0hKwpLSFRHpc1Fkn9LMhFSMTN/gN6lPiFdty89Ae
	 Mr3dcaew/fZlO5DaHtzxvQSvNo1sNcvut3CKT/UD0/OoOdljBfaBv02Wpwrkq/eYXo
	 bEnVRZYZrCAAg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf] netfilter: nfnetlink_cthelper: cap to maximum number of expectation per master
Date: Fri, 26 Jun 2026 13:40:42 +0200
Message-ID: <20260626114042.849218-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If userspace helper policy updates sets maximum number of expectation to
zero, cap it to NF_CT_EXPECT_MAX_CNT (255) on updates too.

Fixes: 397c8300972f ("netfilter: nf_conntrack_helper: cap maximum number of expectation at helper registration")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
reported by sashiko in the last PR.

 net/netfilter/nfnetlink_cthelper.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/nfnetlink_cthelper.c b/net/netfilter/nfnetlink_cthelper.c
index f1460b683d7a..2cbcca9110db 100644
--- a/net/netfilter/nfnetlink_cthelper.c
+++ b/net/netfilter/nfnetlink_cthelper.c
@@ -163,6 +163,8 @@ nfnl_cthelper_expect_policy(struct nf_conntrack_expect_policy *expect_policy,
 		    tb[NFCTH_POLICY_NAME], NF_CT_HELPER_NAME_LEN);
 	expect_policy->max_expected =
 		ntohl(nla_get_be32(tb[NFCTH_POLICY_EXPECT_MAX]));
+	if (!expect_policy->max_expected)
+		expect_policy->max_expected = NF_CT_EXPECT_MAX_CNT;
 	if (expect_policy->max_expected > NF_CT_EXPECT_MAX_CNT)
 		return -EINVAL;
 
-- 
2.47.3

