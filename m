Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A05982F1FC7
	for <netfilter-devel@vger.kernel.org>; Fri, 10 Jul 2026 15:14:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783696460; cv=none; b=ZnqVE2bzN+6lzV2E4RUXwVRVlsotaMrs0E1QLx+fn01Ps2ikZsqtHCM9oDqckXbFLwQyQav7EEG1mfENpT1MnASl1C/xF9ZYSAMb9sb/1hmHecHyDlpWgECW3NoSoklMNGHPSS3Vhmm6p0IqmiHeXThrmCP7TzQo3arL2kAOkMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783696460; c=relaxed/simple;
	bh=HG9uJzo94Q3UmDonZPxhrSq7Mv9ubnWP0XGVB4/RR2k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t+H8VfDxt3nWE6FMtBXWAfL3KV2Ev1tRcJtFassXtseABVATS15AsfhvaLLwsEpnb2lUHQ5YDOIberujHdFXnqvDZD9ZjJD7fWllNGtnt+F38/fCs+cJh5mecD4u5ws6lJJVIirKZWiDfIdjW2rwtmZLTxhzbYZEWfiglZCUHgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=g17viaK2; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="g17viaK2"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=6ZRCR2bjFy4Y/JVz4XSdy/573FntfI0iVCJwV2etSY4=; b=g17viaK20Y7HCYhRL0R48tL0on
	Z8z9/RjJM5AU4AV6oy3lZL4g0X/sIy5y9Gk0m6IihjWlJvP7s1iH7Axz8berX00WkPCJjt5BtYYh0
	m7+UBLDK7J4TncffmB1q4GEGqzRNhjvwS2m9iCLYeW4j71NEvEUxF90wmpmEkXfiowkmBiTDg3rIm
	8/32p1LJ2DEBO7SVYINorB2ZF8LhUezgt+NWscyA5SwiqGOR56WWyfq7/aS240jShTQmpCyqzCFEy
	kIDG3/7kLC0OOMc1WUIf3D9Qs0NTRq6SviRoyy9byvAByC1b2nl4YVt7dAjf1L/DZ3DXIcDy1qOom
	vuRLFATw==;
Authentication-Results: mail.nwl.cc;
	iprev=pass (localhost) smtp.remote-ip=::1
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1wiCvg-000000001tZ-1DnN;
	Fri, 10 Jul 2026 17:14:16 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,
	Florian Westphal <fw@strlen.de>
Subject: [nf-next PATCH v3 3/4] netfilter: nfnetlink_hook: Handle multipart NAT hook dumps
Date: Fri, 10 Jul 2026 17:14:10 +0200
Message-ID: <20260710151411.2358773-4-phil@nwl.cc>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260710151411.2358773-1-phil@nwl.cc>
References: <20260710151411.2358773-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If the number of hooks exceeds available sk_buff space, the function is
called again for the remaining data. Make use of the second
netlink_callback::args field to store the current index between
invocations. Since this is an inner dump loop, it may run multiple times
(for different hook types) with the same context buffer, so manually
zero the stored value if complete array dump was possible.

Fixes: b010e2a4a9ac ("netfilter: nfnetlink_hook: Dump nat type chains")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 net/netfilter/nfnetlink_hook.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nfnetlink_hook.c b/net/netfilter/nfnetlink_hook.c
index 644070c8b456..be2f99b678be 100644
--- a/net/netfilter/nfnetlink_hook.c
+++ b/net/netfilter/nfnetlink_hook.c
@@ -345,22 +345,27 @@ static int nfnl_hook_dump_nat(struct sk_buff *nlskb,
 	struct nf_hook_entries *e = rcu_dereference(priv->entries);
 	struct nfnl_dump_hook_data *ctx = cb->data;
 	struct nf_hook_ops **nat_ops;
-	int i, err;
+	unsigned int i = cb->args[1];
+	int err = 0;
 
 	if (!e)
 		return 0;
 
 	nat_ops = nf_hook_entries_get_hook_ops(e);
 
-	for (i = 0; i < e->num_hook_entries; i++) {
+	for (; i < e->num_hook_entries; i++) {
 		err = nfnl_hook_dump_one(nlskb, ctx,
 					 READ_ONCE(nat_ops[i]),
 					 ops->priority, family,
 					 cb->nlh->nlmsg_seq);
 		if (err)
-			return err;
+			break;
 	}
-	return 0;
+
+	if (!err)
+		i = 0;
+	cb->args[1] = i;
+	return err;
 }
 
 static int nfnl_hook_dump(struct sk_buff *nlskb,
-- 
2.54.0

