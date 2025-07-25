Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA2D32EFD85;
	Fri, 25 Jul 2025 17:03:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753463040; cv=none; b=qeaDG/xzpW8Sbk+fjNgr9RKcPR0trrMo2mTPC2eXQP3PH89G6e27sPaPcSr+mV6F8y3WcMplt4jE4IuBjxzR96d2jGr7PLgPN5ReyMRHvhIEoCoSZWg6fkniJcb0QPuFBnC/tNKJ2C+nZPkvqjowNbjWT1oJq2XY0FlCksiOHmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753463040; c=relaxed/simple;
	bh=5OHuMhNswoKCtye/NbqGUSYTfTk+LVATZHTa0K55btU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=c67GWHASAWmip3e9HP1QWFyxFuvumXLfwyb3XOVr8s9s2Bl7Yia3pV3AdV99Hj0fODx2jw8G1FVFVpzwEK7ARu8k1IJmfTaHNDWQLIRN2lpSWlitHlMP496ZFilFMxBucAz71BiY0R2CpKU/1MleESxdZo1Szj8TZ6EQHwmQiPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=V2DzIfos; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=jFR18wSY; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="V2DzIfos";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="jFR18wSY"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 5B6406026E; Fri, 25 Jul 2025 19:03:56 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1753463036;
	bh=cRYEVElLy/ry9oicID7W1+YXjtuM45ZIhRedTE1oMQg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V2DzIfosLESGt/6I1aqjdbOgJHGoASBSprTGGCkD7tUb/GY28+sPfdeAMW4jgcLGX
	 UqzXQVRsUg5aNQoe0uD4XiUpNgfjRI0xbj6okCSFRild/Dhyz/BjdGsAL5KIC7g7B6
	 i6hhJOop6M/BzqaZI5zBpXrPES4EwbdEOHLWFCOskJ58m6zqs0mGdiLoftv50xUS2h
	 6ddk9B39P7XsI3++MyyY9iHaGTMSVfi+r7km/YmXPAVBeDxrk1xg+/3adUdMhxpODI
	 JLO07iJkCQq8wgwEwDdjd8xw5AfafkMG7BDzW1dFv8vt0nZx4P+IQcU/JwIG65a0nT
	 hE4JTkfyFajGQ==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id DFA1160279;
	Fri, 25 Jul 2025 19:03:53 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1753463035;
	bh=cRYEVElLy/ry9oicID7W1+YXjtuM45ZIhRedTE1oMQg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jFR18wSYQ7Blrf1vQ/UQau9vuCq//etsdaKPS/mA/81nBQlcAeXZf3PlGnxQUmMf4
	 hIwGHX00xKZXyqOBkKrqMKE9XiyxNDRXZPdEHTxKvvT+ZKgk4ofOWoXoC96NRnRzo5
	 1F0v8XWVfiCbM+UIbjsMLcBYU6GwY3m2H8vs5NGjODaNIObc4WlWgZpfH0zqGv5h1F
	 KepwS5hmZg0zht7NHwqfF+s8MMJ6NquQQeMT6u3YUn56nxf3BbRnboVyi7sdp1XWOH
	 0EUKijcTKzCGwh9s/uvaPfgaCSMGly2mQOgJN+OnIpB8p/b0NwHuOAFoTeesFg4QF0
	 sSfmwVj60kw0w==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net-next 04/19] netfilter: nf_tables: Remove unused nft_reduce_is_readonly()
Date: Fri, 25 Jul 2025 19:03:25 +0200
Message-Id: <20250725170340.21327-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250725170340.21327-1-pablo@netfilter.org>
References: <20250725170340.21327-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Yue Haibing <yuehaibing@huawei.com>

Since commit 9e539c5b6d9c ("netfilter: nf_tables: disable expression
reduction infra") this is unused.

Signed-off-by: Yue Haibing <yuehaibing@huawei.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 5e49619ae49c..b092e57d3c75 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1939,11 +1939,6 @@ static inline u64 nft_net_tstamp(const struct net *net)
 #define __NFT_REDUCE_READONLY	1UL
 #define NFT_REDUCE_READONLY	(void *)__NFT_REDUCE_READONLY
 
-static inline bool nft_reduce_is_readonly(const struct nft_expr *expr)
-{
-	return expr->ops->reduce == NFT_REDUCE_READONLY;
-}
-
 void nft_reg_track_update(struct nft_regs_track *track,
 			  const struct nft_expr *expr, u8 dreg, u8 len);
 void nft_reg_track_cancel(struct nft_regs_track *track, u8 dreg, u8 len);
-- 
2.30.2

