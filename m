Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D2B7283CBD
	for <netfilter-devel@vger.kernel.org>; Tue,  8 Jul 2025 13:04:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751979858; cv=none; b=VScm3aOTYCuPIOEDNHL0qOVQTao0E0SwU33WDXEYupc+1fWxin3wGdNQvnv7U8meCYY3sKUSx5tZs8VqX4vbHoSH19Iwpf2uwzrhpGS+MLAB84mejpKwcd6rADf1mVv+EXWtw+FNO6Qw8Rd2hNsRqGcmF/CX59izLn4xTGBjN8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751979858; c=relaxed/simple;
	bh=G01e6JEF7oe0KeCZmAHaayFXADlHCf+hZTXqbNv64fo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Y41pmArGdzkEHd+C6F9cLA3YR0ruupJ4pHFNECUeUl7ftWA1HHYieTJHqwHjy02qTDufLsrJx/z5BQn3hCpdrtA7HsIrOJhIeNSh+WQhtCm8FByX2W225ylq7MQToYgSKUH0V/l6v6433Utr4ak5oqKXT0arnJNjTbENg+zjsyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=KyfqPiWm; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="KyfqPiWm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=hc7mCcbLrRWjJwCSr/SfVDfRCSEPSBRuMyfKBb2+xSk=; b=KyfqPiWmNr8PEliXy82+voHRYs
	uTQTmo21GbV87SKJusyc4MdFqDHpwPi65SMfiBX4m7KxwGDCqCOilJzYwo+Koxu3Z+7XQ3D691eUW
	VoZdTQ8jBr30nDOW71Wd1daEFOWMNiFuM5mxQvNohISk505wLYS2PZmZAf+/s+47QqV21g93AmwEK
	7npOvKngcIvHwgWY7F7Pj3FQR7oBAdDOWV4E6ymq2dDRHAm3ie7QXBHc8lEsVdCCDjLPGD/kPKQsf
	gDEx4vYOxaDp0HfOWOrKd5SZIxLsugXIh2mwZVQfEvk5feun26TqfUoRNR3WA8OEQoHAgsg0Pn9YP
	ZCXvS8Sw==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uZ7zT-000000002o3-2YEM;
	Tue, 08 Jul 2025 15:04:07 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org
Subject: [nf-next PATCH 1/2] netfilter: nfnetlink: New NFNLA_HOOK_INFO_DESC helper
Date: Tue,  8 Jul 2025 15:04:01 +0200
Message-ID: <20250708130402.16291-1-phil@nwl.cc>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Introduce a helper routine adding the nested attribute for use by a
second caller later.

Note how this introduces cancelling of 'nest2' for categorical reasons.
Since always followed by cancelling of the outer 'nest', it is
technically not needed.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 net/netfilter/nfnetlink_hook.c | 47 ++++++++++++++++++----------------
 1 file changed, 25 insertions(+), 22 deletions(-)

diff --git a/net/netfilter/nfnetlink_hook.c b/net/netfilter/nfnetlink_hook.c
index ade8ee1988b1..cd4056527ede 100644
--- a/net/netfilter/nfnetlink_hook.c
+++ b/net/netfilter/nfnetlink_hook.c
@@ -109,13 +109,30 @@ static int nfnl_hook_put_bpf_prog_info(struct sk_buff *nlskb,
 	return -EMSGSIZE;
 }
 
+static int nfnl_hook_put_nft_info_desc(struct sk_buff *nlskb, const char *tname,
+				       const char *name, u8 family)
+{
+	struct nlattr *nest;
+
+	nest = nla_nest_start(nlskb, NFNLA_HOOK_INFO_DESC);
+	if (!nest ||
+	    nla_put_string(nlskb, NFNLA_CHAIN_TABLE, tname) ||
+	    nla_put_string(nlskb, NFNLA_CHAIN_NAME, name) ||
+	    nla_put_u8(nlskb, NFNLA_CHAIN_FAMILY, family)) {
+		nla_nest_cancel(nlskb, nest);
+		return -EMSGSIZE;
+	}
+	nla_nest_end(nlskb, nest);
+	return 0;
+}
+
 static int nfnl_hook_put_nft_chain_info(struct sk_buff *nlskb,
 					const struct nfnl_dump_hook_data *ctx,
 					unsigned int seq,
 					struct nft_chain *chain)
 {
 	struct net *net = sock_net(nlskb->sk);
-	struct nlattr *nest, *nest2;
+	struct nlattr *nest;
 	int ret = 0;
 
 	if (WARN_ON_ONCE(!chain))
@@ -128,29 +145,15 @@ static int nfnl_hook_put_nft_chain_info(struct sk_buff *nlskb,
 	if (!nest)
 		return -EMSGSIZE;
 
-	nest2 = nla_nest_start(nlskb, NFNLA_HOOK_INFO_DESC);
-	if (!nest2)
-		goto cancel_nest;
-
-	ret = nla_put_string(nlskb, NFNLA_CHAIN_TABLE, chain->table->name);
-	if (ret)
-		goto cancel_nest;
-
-	ret = nla_put_string(nlskb, NFNLA_CHAIN_NAME, chain->name);
-	if (ret)
-		goto cancel_nest;
-
-	ret = nla_put_u8(nlskb, NFNLA_CHAIN_FAMILY, chain->table->family);
-	if (ret)
-		goto cancel_nest;
+	ret = nfnl_hook_put_nft_info_desc(nlskb, chain->table->name,
+					  chain->name, chain->table->family);
+	if (ret) {
+		nla_nest_cancel(nlskb, nest);
+		return ret;
+	}
 
-	nla_nest_end(nlskb, nest2);
 	nla_nest_end(nlskb, nest);
-	return ret;
-
-cancel_nest:
-	nla_nest_cancel(nlskb, nest);
-	return -EMSGSIZE;
+	return 0;
 }
 
 static int nfnl_hook_dump_one(struct sk_buff *nlskb,
-- 
2.49.0

