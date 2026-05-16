Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC39C37C937;
	Sat, 16 May 2026 11:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778932602; cv=none; b=hc8wSg1J3imYNiN6LJW8Cs9kCyU3iCTTx5FcxNLXDN2WNgCt1QZg+AUzWY9FXtwKTBcbqMkqDjBgJ9NvDKOM9NuGdjcdNpXapuAqayiXxyHZe3wVcl044ckCcDuGDK0j3l6fnkJwf5LiIrK47/SBVF4IxqWF1uvxVFVdAm3zoNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778932602; c=relaxed/simple;
	bh=AkBosYE6dkFdWGwYlkNYL64YRPEyHCeZSUrdrVMZyR8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=P2ZNpjaJcuTQdFHfGnuXyIeJ4IFn9T+enbLidRQWm4tcAoT/nDx4sisq8scbpNiIqMH6SCIK6l3z6bYaX8L1WRjkiI5yYJ4r5+bH/KoDX6smDcWeBuFam6kUGgnKH/fU/O/woAl3TNnUkekEYYhU2reIFP83XIF74aFfAPZMEuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=HflGJOj8; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="HflGJOj8"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id BE092601A9;
	Sat, 16 May 2026 13:56:36 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1778932597;
	bh=0GmtqaXtt+ZaSlWG1mBiVsaFE9cLgk2OKCrSYbK+tnc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HflGJOj8vN7D4GLhuMBrQry+1dbB5l7p+30VuqGIh2Iv/SpKGMHq0P+KNX6Q2wm2k
	 IPfFYHkCYfvwQ1LZzo4Zh167AYVbQIkg6LveFyO+Jnwz64rHhedH2nmIxRnPO/z8tp
	 nz8/xGvxqVvREaWMPNPs754XknqOpaWibNFY9J7duIbWkkVpTrDoO3OH/yodfZ8W6Z
	 pS3gAzaGRe2nWaGUOkhFmLplsoIhbJUfjv1QM1C6i1Q5tWH4Rd/l1ZTsa+4QsniSSs
	 2WYTJtfW8u/nEDQptlh7UlbeKB0XDRdcRA5f47XfgdsaVFrzMkiG3tY+Ws28FHtRux
	 MtwWVop0K5D5A==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 04/12] netfilter: nft_inner: Fix IPv6 inner_thoff desync
Date: Sat, 16 May 2026 13:56:19 +0200
Message-ID: <20260516115627.967773-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260516115627.967773-1-pablo@netfilter.org>
References: <20260516115627.967773-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>

In nft_inner_parse_l2l3(), when processing inner IPv6 packets,
ipv6_find_hdr() correctly computes the transport header offset
traversing all extension headers, but the result is immediately
overwritten with nhoff + sizeof(_ip6h) (40 bytes), which only
accounts for the IPv6 base header. This creates a desync between
inner_thoff (wrong — points to extension header start) and l4proto
(correct — e.g., IPPROTO_TCP), enabling transport header forgery
and potential firewall bypass. This issue affects stable versions
from Linux 6.2.

For comparison, the normal (non-inner) IPv6 path correctly
preserves ipv6_find_hdr()'s result. Removing the incorrect overwrite
ensures that ipv6_find_hdr()'s calculated transport header offset is
preserved, thereby fixing the desynchronization.

Fixes: 3a07327d10a0 ("netfilter: nft_inner: support for inner tunnel header matching")
Cc: stable@vger.kernel.org
Reported-by: Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>
Reported-by: Yuxiang Yang <yangyx22@mails.tsinghua.edu.cn>
Reported-by: Xuewei Feng <fengxw06@126.com>
Reported-by: Qi Li <qli01@tsinghua.edu.cn>
Reported-by: Ke Xu <xuke@tsinghua.edu.cn>
Assisted-by: GLM:5.1 Z.ai
Signed-off-by: Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>
Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_inner.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/netfilter/nft_inner.c b/net/netfilter/nft_inner.c
index 03ffb1159fc1..859aa38e333b 100644
--- a/net/netfilter/nft_inner.c
+++ b/net/netfilter/nft_inner.c
@@ -163,7 +163,6 @@ static int nft_inner_parse_l2l3(const struct nft_inner *priv,
 			return -1;
 
 		if (fragoff == 0) {
-			thoff = nhoff + sizeof(_ip6h);
 			ctx->flags |= NFT_PAYLOAD_CTX_INNER_TH;
 			ctx->inner_thoff = thoff;
 			ctx->l4proto = l4proto;
-- 
2.47.3

