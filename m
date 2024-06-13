Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59D08145B26
	for <netfilter-devel@vger.kernel.org>; Thu, 13 Jun 2024 14:32:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718289181; cv=none; b=LxZav7uETKT2B2r4dBsU8YdZE3mPoPgrH+713HSeMqStaTs9pyVeZnmotSKPxwb/CbsOF2VwCQidWny+4T36IWWysMKMglKO0z3dz263GvWX1ZvBFPQT+MfWoX6HC1u9/7VkqibirgNW4yYrudrHf0bg66J1vwRsZccSo3LKbQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718289181; c=relaxed/simple;
	bh=p+HoCpRxH1Kf/i84CW5y0nYqjOF6hkQofzduAIyM88g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TDycLoQrpTocaVoiwePwBXLXXOSUXeRyURn6jRwwE5Rt98kb6P1auulcn0smPvmu+uABvhPoOZ6y4juYyTLTnT3cOZaAzqb/QoB8zc8rZb1d1RG4W4zBgfF5gx5i4kzosOUJ49kMa4pMyb/JSRcCv4K28VlC0XW4+j2MHkD9f3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=pQ3uO1ca; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="pQ3uO1ca"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=kbq78l3vrRkBTzF92H9WS7PV/crd5Alh63ZJWaJcIpQ=; b=pQ3uO1caeUJXNoBW6fXIbcxm6L
	qiHcvGnj/sgCGre3oS/8oZZXCqC0dTrZEoSBG4z6KuG/iF/qmUdHPe9eKY1rNOvSmO9wfKrOXrCQV
	0708JIsgm7N60uVrtEMiCKxkRu04C05xb4S6XHtbN+BOT0Lh9sSrGF3FFsZLceRq/77xH2WquJG6K
	DFMaiRc9jR2uIsgKhqOhw4siTfiicoXfhgaoZtxh58S8xh9JYBzbh8L7IA4Kr73TCQVhEUCO/t+/t
	SJdRU7eczfCNCo9jfc/SXBi4KDUUcIDaVuK6jVjp8w61FCQGye5+dCiYgR1MIyjgiN5d/FLM2HPuL
	+k51TXQA==;
Received: from localhost ([::1] helo=xic)
	by orbyte.nwl.cc with esmtp (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1sHlVT-000000008WO-2mWh;
	Thu, 13 Jun 2024 16:32:51 +0200
From: Phil Sutter <phil@nwl.cc>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org,
	Fabio <pedretti.fabio@gmail.com>
Subject: [nf-next PATCH 1/2] netfilter: xt_reent: Reduce size of struct recent_entry::nstamps
Date: Thu, 13 Jun 2024 16:32:53 +0200
Message-ID: <20240613143254.26622-2-phil@nwl.cc>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240613143254.26622-1-phil@nwl.cc>
References: <20240613143254.26622-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There is no point in this change besides presenting its possibility
separate from a follow-up patch extending the size of both 'index' and
'nstamps' fields.

The value of 'nstamps' is initialized to 1 in recent_entry_init() and
adjusted in recent_entry_update() to match that of 'index' if it becomes
larger after being incremented. Since 'index' is of type u8, it will at
max become 255 (and wrap to 0 afterwards). Therefore, 'nstamps' will
also never exceed the value 255.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 net/netfilter/xt_recent.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/xt_recent.c b/net/netfilter/xt_recent.c
index ef93e0d3bee0..60259280b2d5 100644
--- a/net/netfilter/xt_recent.c
+++ b/net/netfilter/xt_recent.c
@@ -70,7 +70,7 @@ struct recent_entry {
 	u_int16_t		family;
 	u_int8_t		ttl;
 	u_int8_t		index;
-	u_int16_t		nstamps;
+	u_int8_t		nstamps;
 	unsigned long		stamps[];
 };
 
-- 
2.43.0

