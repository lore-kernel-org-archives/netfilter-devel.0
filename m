Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3B2C24C66A;
	Thu,  3 Apr 2025 11:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743681488; cv=none; b=kUh2PCLLxQdHKrBgErAnM1SN1TRsCSgCMlTmoXP03k9is/OhkJk8XRAUxxZw4uo1MjVbVLmDmRMOJniIreQ/o2RURvLIcr9fbmRd5LTUXCrC9aWM55RrRHJD2fwLG/g92DmRNsY/hEmvo8TmZ6jVh9QegWPzN+gd5gubGCfFSYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743681488; c=relaxed/simple;
	bh=+j/Y7sCwLMqA1nv2LkBoaFeInW+9iGKEYvtnIXttesc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=CFphDbuI9m9/H6TjNHVHAbm4EuWrVPd/IycDciD8KK4spLjrydnZx+q5xmFgOHCykuh+4MYcHHVboWjvJuBs0Bdvd7VUemTiEs66+BrlCFcQ8s8dwBFnvlg1lZpXYzYq8nIm6jkFw9QbfbOsnwWplyN70SaLLY+/KYPQjh1l3sI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=QDWSl8d0; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=a788r+kS; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="QDWSl8d0";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="a788r+kS"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 2ECF26064C; Thu,  3 Apr 2025 13:58:05 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1743681485;
	bh=XEvOGkCzgV4FR1qgYwDn6pvrE/rEpvXA9UV2CI+r1F8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QDWSl8d0tEcuemO848O+MEN8ojv5a64Vr32++GO1Crqx52tqflzEaCVU6Z5iDKOPp
	 oSqL0tLxbxqp1pGMK5Tx8KzqA3bmUS/4w12NfzaHfqOLG7iFwL4pIocPQX+wkA6goM
	 0S55SYywzqCDphBPaKzHjAYvUnN47QVjmbuQLjRLQmPHREEcy9w0/+5M47GAuTYJLl
	 PMb0XBR4gmRkpKHAzsrr0+DFHe1I2Nj5xn51ttjuX8Y44ONC4nrf82h2iaokImWOd5
	 SR0WEfIghQ3l+Eos7rKxtr6bcU2brYgEpHRDGnCVqNkB/2vpX+knTDUHz9D9Sloiae
	 h1jvvcE149jbA==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id AACAB6063A;
	Thu,  3 Apr 2025 13:58:01 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1743681482;
	bh=XEvOGkCzgV4FR1qgYwDn6pvrE/rEpvXA9UV2CI+r1F8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a788r+kSbPGA3OwEhZt/IrWRjCbpfwo5EhrMHBDwQl/AmGtk0F1A/TDZ69YGCh9TW
	 QFoX960fmjXXc9WSUpR9joMNpJz6sjdNm8PUjsQ3SwNnCzR3NSR0TI1hoKaAFqam5M
	 7OOwvsBpmamVo2eug0ESMuUWhtUtdL9ptJIS6X3Bc5WEOzgraMyvZK/HnEXK9Snfa+
	 FmX3UutWCxJcXGrYgfGx2j9DP1paFk/c7wkdaiJ3yzK3onSL0zHFNdmKOj0FYVC0ZK
	 73eonQdrxbMkILGTsdPfAHWg4hRHv7MNxNYKpxOZKcVyePA5TfKRXBlR6TNU9aizrT
	 9Ir4xoCmEwhOw==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 2/3] netfilter: nf_tables: don't unregister hook when table is dormant
Date: Thu,  3 Apr 2025 13:57:51 +0200
Message-Id: <20250403115752.19608-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250403115752.19608-1-pablo@netfilter.org>
References: <20250403115752.19608-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

When nf_tables_updchain encounters an error, hook registration needs to
be rolled back.

This should only be done if the hook has been registered, which won't
happen when the table is flagged as dormant (inactive).

Just move the assignment into the registration block.

Reported-by: syzbot+53ed3a6440173ddbf499@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=53ed3a6440173ddbf499
Fixes: b9703ed44ffb ("netfilter: nf_tables: support for adding new devices to an existing netdev chain")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index c2df81b7e950..a133e1c175ce 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2839,11 +2839,11 @@ static int nf_tables_updchain(struct nft_ctx *ctx, u8 genmask, u8 policy,
 			err = nft_netdev_register_hooks(ctx->net, &hook.list);
 			if (err < 0)
 				goto err_hooks;
+
+			unregister = true;
 		}
 	}
 
-	unregister = true;
-
 	if (nla[NFTA_CHAIN_COUNTERS]) {
 		if (!nft_is_base_chain(chain)) {
 			err = -EOPNOTSUPP;
-- 
2.30.2

