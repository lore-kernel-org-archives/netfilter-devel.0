Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03B2840628A
	for <netfilter-devel@vger.kernel.org>; Mon, 29 Jun 2026 12:33:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782736413; cv=none; b=vBML9wtwvul4w5Yw/qdMKyHf0gA/WDtWMiT5bBMNFGR5tfbx9bXLchnpk/6mfSp+5cAtb2apho2kRHnE4y9+D+2cGLeIpJ9ZuEGtrpee5HT0dEI1t62V2/hfa5dYyaQ6k45cM9vRwqxW+k3mU/kw+LUl67FxhwHvE3IqksD55Es=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782736413; c=relaxed/simple;
	bh=to4R4ee8k2o5804/vpzYrLJhMjVE1Ml1XXys9wSRdes=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=umtpzgVSrOek0iEQSwFSJRlCCvJt1c7UEgzPgyyMwaor6plwQqPHe4v+UuhOrQoLJj8lRX/tbs3UWxuLxKi5tx3Z+REqnTc04VEgc7pLRUozBh3wIxqlo/Hebb4G11T1hLWzdR97wzThxRxV/ToTW2ZoWFtedBKWV8F6DVax5bo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=qP82+Ly+; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qP82+Ly+"
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-c126e47a82cso95924466b.2
        for <netfilter-devel@vger.kernel.org>; Mon, 29 Jun 2026 05:33:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782736410; x=1783341210; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=K3SLRCeShC2U5Lb0rTb1U6hkwISYxR1k50UcKsPQ0QE=;
        b=qP82+Ly+pTyhNmHfZVdXAkqPPxuYMLaGEYeFWzOyAq29zwQoqp+uKOlbqywHHMqu9a
         nx0If8obfUutF05+AzCXfgdR3ZBshK5+ljNNRdXccgnQYMCQYJktM/nzHvGgo8ftDZGo
         G1OUezFh6atAsSgf7e1RqDrYuigwFQ/n8jcMbPPNgOzihyUJvo6QwxhE6rerbga4TZTm
         0t6+8yEPhxtxaywRKdIhUbxd5suOJqq9i1RaHkdbKGkMrC/4K9/2aweb35O5GutGGOvX
         bihLa7SiqLIn89jC9eSAFZKTXj3pzjw0vYUZOXLQsTy3mvZ9DmrhrpYgrIeNxRpXUeE2
         Y1FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782736410; x=1783341210;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=K3SLRCeShC2U5Lb0rTb1U6hkwISYxR1k50UcKsPQ0QE=;
        b=HOEpifkpL3pYGXI9Eq79ryAz5b3iY/VeZXQvC7x8Q56zolmzHLRctc1g6TmcYHVtRl
         mpMlZhVaY4OLSf2h6V2CmYdVb+RaOfrTG9+9Rb1PU5cfbHjihSFihZU7go3fTTAn4qGo
         9xH+Bm73ESZBTwWn4iWhWnc2MdEqc9KRAMoY3qYuW3GW/SIo1WDt2AA015WO16omhzpT
         z2GM52dQ4aynTLGVzCDhw86vqlETOAowcKswtiBOsLhZKyeYywcW7zTr/sCSh7g48d/Q
         Jd2ICWzpKFZYhvulu5BT1t1ZmxobD8KjxK85+aKqJBWFsg5f5tU2Oi4yizMyhIEajrP9
         QJhQ==
X-Gm-Message-State: AOJu0Yzd4MmaVyh9rqTqmRoaca2yHMirPpdWN+AYnTGl+QeiUqEMw8mx
	CyrKCORaFfgltlMifIKQa05KCcjZwMdbUfZBCH6oXYOm9Xc0u36OKLmoXmr0NHwC
X-Gm-Gg: AfdE7cnHykoxISfc8659NMrNNrm455R6lLtxxi5SbMyU62ZbIsSILstW7C4PXCfiuMx
	Nh+Xt2mIj7e6zC1tgB6OsUkfTT63fxdIrSDHsP+76bLSD2s/o7nPK/BlCt70p4jcKptRcI6ihq2
	zRNHJNsyL6aKlRSEhrSX5bjystCkxG1frzj00zQhyMjHGc1tr+v8etvsMgEq8X2z83FWIMc+aho
	reqF+93bzuW4e+q+Dmqm0R5hHaxrU74Ubj1XpqRDUWhMu1Agcflb+rDK3BOqN9e+DinbPMia46A
	jIDRsj5AZsYC7E1HsAcwuhaJ+sfFkVS1plrJnwdlfLX6J5DZVpDTQNyBYmngQ9V+k1EYpMGyWp2
	SescUmMWdR08ZDTIsT6PUPR1rfmWOFwUUbn12sM3I2OupXOtrqbeJUWSSxmgG1gUGGH+wh6F+vC
	8cwhQhOec=
X-Received: by 2002:a17:906:6a1b:b0:c12:6b39:2211 with SMTP id a640c23a62f3a-c126b392346mr184315266b.43.1782736410170;
        Mon, 29 Jun 2026 05:33:30 -0700 (PDT)
Received: from fedora ([46.205.218.111])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c11fbe05c22sm773866566b.39.2026.06.29.05.33.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2026 05:33:28 -0700 (PDT)
From: Daniel Pawlik <pawlik.dan@gmail.com>
To: netfilter-devel@vger.kernel.org,
	netdev@vger.kernel.org
Cc: pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	andrew+netdev@lunn.ch,
	razor@blackwall.org,
	idosch@nvidia.com,
	matthias.bgg@gmail.com,
	angelogioacchino.delregno@collabora.com,
	bridge@lists.linux.dev,
	coreteam@netfilter.org,
	linux-mediatek@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org,
	rchen14b@gmail.com,
	lorenzo@kernel.org,
	Daniel Pawlik <pawlik.dan@gmail.com>
Subject: [PATCH 4/5] netfilter: nf_flow_table_path: handle DEV_PATH_MTK_WDMA in path info
Date: Mon, 29 Jun 2026 14:32:52 +0200
Message-ID: <20260629123253.1912621-5-pawlik.dan@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260629123253.1912621-1-pawlik.dan@gmail.com>
References: <20260629123253.1912621-1-pawlik.dan@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Ryan Chen <rchen14b@gmail.com>

Without this change, nft_dev_path_info() hits the default -ENOENT path
for WiFi bridge offload via WDMA on MT7996. When a bridged flow goes
through the MT7996 WiFi device, the DEV_PATH_MTK_WDMA step does not set
h_source, causing the PPE entry to receive a zero source MAC and packets
to stall in both software fastpath and hardware path.

Based on a MediaTek SDK patch by Bo-Cun Chen <bc-bocun.chen@mediatek.com>.
Signed-off-by: Ryan Chen <rchen14b@gmail.com>
Signed-off-by: Daniel Pawlik <pawlik.dan@gmail.com>
---
 net/netfilter/nf_flow_table_path.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/netfilter/nf_flow_table_path.c b/net/netfilter/nf_flow_table_path.c
index 6c470854127f..580aa1db3cb4 100644
--- a/net/netfilter/nf_flow_table_path.c
+++ b/net/netfilter/nf_flow_table_path.c
@@ -219,6 +219,10 @@ static int nft_dev_path_info(const struct net_device_path_stack *stack,
 			}
 			info->xmit_type = FLOW_OFFLOAD_XMIT_DIRECT;
 			break;
+		case DEV_PATH_MTK_WDMA:
+			if (is_zero_ether_addr(info->h_source))
+				memcpy(info->h_source, path->dev->dev_addr, ETH_ALEN);
+			break;
 		default:
 			return -1;
 		}
-- 
2.54.0

