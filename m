Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2087B427A1A
	for <netfilter-devel@vger.kernel.org>; Wed,  1 Jul 2026 10:47:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782902832; cv=none; b=r7ld7N0wnAn+hPVBpOv6+aDxA4WXJN087mJeMHCC6lHibIhx3RoqrucfT1/i2yWmrSIKFFD1XoyrV65QwC7szsNQ6DRBBvDSiGmQ5c/byL84zdxGTMrqbLRIc65EqVwEjppaBi57Wzeg2OTHg0/aygiysu5Vvq0hUqwPt8OssME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782902832; c=relaxed/simple;
	bh=BpkR4FJPh3KbROWrHo+BvkhE+Gjt75n3dpP4FsnJhiE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ct6A85R+pGC3w5gjCtOrjWZp0v3AD7GoLBlNX7KOjuEjaYEaLFYs+Zm5sTCL1uMwn3ff7L8pQwWfQv77/t8zGAKtj3XjH2wNuGplRY9X36tM57XBFU1YfU6pmDcPUOCP6bJom+eZRGlnwlD0Ik2wkCYPAAq4QR5jFN8NUrNhf5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=GCp6JoR6; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="GCp6JoR6"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 3857D60576;
	Wed,  1 Jul 2026 12:47:01 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1782902821;
	bh=Ll8qcA9bAygU8+D69BBN7k3A4Ya+G/PvSDdeNITOWEQ=;
	h=From:To:Cc:Subject:Date:From;
	b=GCp6JoR6zAVhYxa+dMnOJfEthrLWIvxDJy/iJw0TFJAO5U7zmmSyecyNgeZXMo/8j
	 4rgaEw1hDbicj0z0GIbxZgCLynzOjjCO6sln6hx92jDFsNERbOkGEdJdoZV1Q+Wld/
	 jfhMR0mMbegcX4r9yqco+E8HipKobNkGsRsqYj2yPzfrizI5UGrl4bY2ShQNlwXzVq
	 QQM38pLk/b3lZpv3YYqy/mPSyUZ3KW42xU33UY/KJRuNzAyXDHV00QomCmW6ggbnZg
	 INpUDmJ7fs6e6cVIzPpNCxRuUvt+q0zS6ZvKni5UgHtJCW1G6zHWyLMb49TC14XdIB
	 9VCvXQ4gczF2w==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de
Subject: [PATCH nf] netfilter: nfnetlink_cthelper: cap to maximum number of expectation per master on updates
Date: Wed,  1 Jul 2026 12:46:57 +0200
Message-ID: <20260701104657.199425-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Really cap it to NF_CT_EXPECT_MAX_CNT (255) on updates.

The commit ("netfilter: nfnetlink_cthelper: cap to maximum number of
expectation per master") only covers creation of helpers, not updates.

Fixes: 397c8300972f ("netfilter: nf_conntrack_helper: cap maximum number of expectation at helper registration")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nfnetlink_cthelper.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/nfnetlink_cthelper.c b/net/netfilter/nfnetlink_cthelper.c
index f1460b683d7a..c71966ca9955 100644
--- a/net/netfilter/nfnetlink_cthelper.c
+++ b/net/netfilter/nfnetlink_cthelper.c
@@ -314,6 +314,8 @@ nfnl_cthelper_update_policy_one(const struct nf_conntrack_expect_policy *policy,
 
 	new_policy->max_expected =
 		ntohl(nla_get_be32(tb[NFCTH_POLICY_EXPECT_MAX]));
+	if (!new_policy->max_expected)
+		new_policy->max_expected = NF_CT_EXPECT_MAX_CNT;
 	if (new_policy->max_expected > NF_CT_EXPECT_MAX_CNT)
 		return -EINVAL;
 
-- 
2.47.3

