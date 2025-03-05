Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52DBB20E003;
	Wed,  5 Mar 2025 10:30:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741170621; cv=none; b=LKhc2UTz15Db8mEr2RX2hGa0rQb67aKx3LrLjMVzkBuYVdz0cCIHhc3YOEGYAGN7mhN0g/72EQVJqVXbPpAuh4xt+ZDk1n8PPACHsZLOWYTel+4s271qmoAKncvzyf0ZMSSCUVUpjLrdYODmuWfuijuyl07eodA8ayG+DZJ43Go=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741170621; c=relaxed/simple;
	bh=nk13k6wj03cZHg9dHsnlBzPD6tzHgIxvMuOve1nbFK4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oU5jbhscZ0p5myckuxdh5eGa5gj7fHj7TTAeaNlyW5fwcHepFn5zYHnDx/PfhRjtuUpVRb8VNUhKVlVe6+XETt1N1SzocTP9muKdt2cilXbNbe+AFWFcs+rnrTEngVcAMx96mtEZhR4qXGWop++xnfhsrWIOmKrEUZFtrKYNDqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SGqYz3yS; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SGqYz3yS"
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-abfe7b5fbe8so439083766b.0;
        Wed, 05 Mar 2025 02:30:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741170617; x=1741775417; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZIyBMmpEX16BmxV1lcAMHYOSL+4ClOY5xXpYYnXA1xg=;
        b=SGqYz3ySFNxI3tABxyFnHBKVpUUY+1aJdV1KS+hf2fMBKIvd0UGwgnZKJbC3U0MeXc
         az7NzlNdnIwJjl823iRUwrX521wFmdxWYUEbdxXNg51WsNU/Ofd/JZJIyffp/3a6tUY2
         i0Ds4xZRVpXVMw7s6X8dTMhbaHcf04hjK64xOSII3zK6smKYe8G9c5ayeOqbF7aaftPd
         bwh/5w210cSxWRnpOKE0/LygOKDJJY+/ZXMpU8go3aj+mvC72PMWLYt7PjjrfaGM3P3T
         R75tvfkj+yDGkLktqj5Fgij0f6lA/+/2WTOj3cLdHxMd/wxkXslm4sZaFO5E3VQ/AryK
         VR6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741170617; x=1741775417;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZIyBMmpEX16BmxV1lcAMHYOSL+4ClOY5xXpYYnXA1xg=;
        b=Oz1CTGgUNS/uj1/HHrlMy3zoQZd/JB4V46XS6b93c1FULSz3i6oIJ8XJp5ofyA5Ds0
         jkkHuz4llSXvCfBafSVz692oMWZnxDEqm4T6HowdvCJ+UR0KKcHf6Swt5eEopZLJ1/9/
         rj32GnPGmu3C0xMC+3PpBbTNu1g3DrZfPV9/10qOGvOVrzLqg+a4aHiLDTw167mufTqt
         KdVUOrsz/eTR0Ze5M+QXFJiyqdciw0HisV0VJyV8HFWwZxrq/BfLc5MpZD8MGVz+kNDz
         eoudnCByW+lMA1oX0IsgJhoBG/3qx8DDce6HR/Cq7JBfSFlfSRVPEGtmEwZq4ru0SvVy
         Nv3A==
X-Forwarded-Encrypted: i=1; AJvYcCUSMbz3hKlERATw6w7C/tKBb9rT5pWXLTIh4Bln4d12tERppGmg/pc8mQIrUojFs4FESqT/pAKElPYBBeEyRb0k@vger.kernel.org, AJvYcCVhid6sa+3oQBje3sndXfLdczjLvehDZTj2wi30qRKLunDilTkjNp6HgQ0JXyD3G14fEIGdQWKzfj9/kXCFOX8=@vger.kernel.org, AJvYcCWcXFdoBn9IUGG5el0D9mTaLdvoCquGNzweyeC60Q68JWWGdy3IFOGxEddU268xZhnsnBO4qq6y5CjSs9qX@vger.kernel.org
X-Gm-Message-State: AOJu0Yyn8eYnr/jvvUNMpi4UMv31XXRJfYhd6x1UMrXGiay2nIFWlkiW
	vDcfV5R68Q2tRHmG2VmrNnYrzWG5RxvFyVlGNc6ytpcRcvvvOKrF
X-Gm-Gg: ASbGncujK3jENOUhaQwYeZ/l42eYAuBxJK2OMUz6CDFeWjldUXjAfnyT3tiFHl4ofVJ
	lvNNafw43JDXy/H+PY9aNLObxc/0ieMGPDIhOMc85WyepvxBSwtgyfVTb8xYZT2GGwII7aMpEQh
	Z9MKfAs3FbWzTsfpGFQHEeQ8tBf6f0aRUUS/BBL5ItJP9w0r0dwQdRXfjOYeObUf3hPw1zTUXb1
	KN8NA82x8cwj2GOxeCDDW4nXxDtiTR9B3ClYVfd/qgBa0MX5mYd7S/71+1sHyNttdJq5YI8U8LJ
	6WKk5MduUxAjAVMFcrV8LocRBCGuh1xqzTgJgZyRn/vtRtwpSGWtsw+4B2PfBaQFPp1O4bDhi7s
	YuJ9AZF55utkD4C/9x8//dSAAlBR145TNZUC+uJ3OMf7xAbZFs7qnPJcnuc/lSQ==
X-Google-Smtp-Source: AGHT+IFpDcHd77fpjokL8xxmcGiwz3SLhwhSLzmlQa1UAPVTwjRjFufxV/YyrDHwyugNXvXH+p5hhQ==
X-Received: by 2002:a05:6402:5109:b0:5e0:8b68:e2c3 with SMTP id 4fb4d7f45d1cf-5e59f4b6e02mr6129743a12.29.1741170616901;
        Wed, 05 Mar 2025 02:30:16 -0800 (PST)
Received: from corebook.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac1f7161a4esm247154266b.161.2025.03.05.02.30.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Mar 2025 02:30:16 -0800 (PST)
From: Eric Woudstra <ericwouds@gmail.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Jiri Pirko <jiri@resnulli.us>,
	Ivan Vecera <ivecera@redhat.com>,
	Roopa Prabhu <roopa@nvidia.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Ahmed Zaki <ahmed.zaki@intel.com>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	"Frank Wunderlich" <frank-w@public-files.de>,
	Daniel Golle <daniel@makrotopia.org>
Cc: netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	bridge@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org,
	linux-hardening@vger.kernel.org,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Eric Woudstra <ericwouds@gmail.com>
Subject: [PATCH v9 nf 11/15] netfilter: nft_flow_offload: Add DEV_PATH_MTK_WDMA to nft_dev_path_info()
Date: Wed,  5 Mar 2025 11:29:45 +0100
Message-ID: <20250305102949.16370-12-ericwouds@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250305102949.16370-1-ericwouds@gmail.com>
References: <20250305102949.16370-1-ericwouds@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In case of using mediatek wireless, in nft_dev_fill_forward_path(), the
forward path is filled, ending with mediatek wlan1.

Because DEV_PATH_MTK_WDMA is unknown inside nft_dev_path_info() it returns
with info.indev = NULL. Then nft_dev_forward_path() returns without
setting the direct transmit parameters.

This results in a neighbor transmit, and direct transmit not possible.
But we want to use it for flow between bridged interfaces.

So this patch adds DEV_PATH_MTK_WDMA to nft_dev_path_info() and makes
direct transmission possible.

Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>
Signed-off-by: Eric Woudstra <ericwouds@gmail.com>
---
 net/netfilter/nft_flow_offload.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index 323c531c7046..b9e6d9e6df66 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -105,6 +105,7 @@ static void nft_dev_path_info(const struct net_device_path_stack *stack,
 		switch (path->type) {
 		case DEV_PATH_ETHERNET:
 		case DEV_PATH_DSA:
+		case DEV_PATH_MTK_WDMA:
 		case DEV_PATH_VLAN:
 		case DEV_PATH_PPPOE:
 			info->indev = path->dev;
@@ -117,6 +118,10 @@ static void nft_dev_path_info(const struct net_device_path_stack *stack,
 				i = stack->num_paths;
 				break;
 			}
+			if (path->type == DEV_PATH_MTK_WDMA) {
+				i = stack->num_paths;
+				break;
+			}
 
 			/* DEV_PATH_VLAN and DEV_PATH_PPPOE */
 			if (info->num_encaps >= NF_FLOW_TABLE_ENCAP_MAX) {
-- 
2.47.1

