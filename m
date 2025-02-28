Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9788027E1A3;
	Fri, 28 Feb 2025 20:16:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740773794; cv=none; b=k23iExNL+YB7Z6nhIzrBEDiWcsIAqM91yVPIkq36xtHpBX0CbAQAxFiegBokLcJTnugJfhYBbyD+gGqXQ9izZREj30R8dTeGmrBIDZOMTqcDvRnn9DqhGnnmJJga2+IPK/UTyD42fMkwPyjG0l4qe/fhP1XZhuCasDDIM5LlDww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740773794; c=relaxed/simple;
	bh=Vja1w1A/Wnz062ttT6Bt+MXuQBy3cdFVFTFu9bvZ8Ag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a7zBOKVVHLdGEkfMEdA9lWgGlpb5Clvk/Cvk3ijok2xURL13Xw3xxdQ4MLYKbPtRmVguNJD2TWcivUOflBc606Hu2VBsSgURmiIgZoxottejCQZcMVHXvHqXKbLHctrQcGcU1HQOOoST9UggxEalTvyhbUrVot2gcj5UOdRdg2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lCkKeEjm; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lCkKeEjm"
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-aaf0f1adef8so489321166b.3;
        Fri, 28 Feb 2025 12:16:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740773791; x=1741378591; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Gr1wMzwLJ3r114jkr+fSh/N13xzOYrfc9OnXbfM4Z7I=;
        b=lCkKeEjm7rZjF3fNI+tdf0ijLE1TtYA2myW+HQjcyi6CO0fksVHYVb0+qkAWDEXsvv
         vKVSgOVQ2E61YRHRFt1Ql3okKUUPYE0d0QHCLaqwT2c35sm0meWENUFpi39IRLQBwM+7
         TZeef2cFXn/2k3McudVtxMtQokqsaQ7DQMVvMyO94y1Ea++sWlGRTCx6MQD+DFtBK/x6
         xg9WNvKGumnoFKYFEp8T/ANC6n8nbUkuwhmMLOybJwLN9OWANBOC63QbCH7TeU1T1YTc
         ouY1OFEr3nVkV1pQ3szgXGo6fNkj43Pwu69B25bpSMlZZH2yB+kksHqed396SfBjzVbp
         25wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740773791; x=1741378591;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Gr1wMzwLJ3r114jkr+fSh/N13xzOYrfc9OnXbfM4Z7I=;
        b=dxk3nEPEE9ZAr7Djcr8eYQn+bKPCErQSc0o5uJnOTqLwe8gV65+EXhxIcOIqZO1Xs9
         9tjdIpEbwyOuTgkQa4W1K1257HJ0vOpcPcVSOsfFZ/YuZDuVtKkjXQD8B5cGl8lYV4aF
         Hy/DYUEbn+XToIEOZ0Dej3pYyeWCBxyHUQlsVotczLVzbU3a9wT6Oft2Vb8Aaq+dp89O
         Od09QTIKQ3tEkz+wu5e9pQhqaVqzUW0jLp8KXnb0YPafKb6WfwdH1XOB3XlfioVYt77U
         ZONfv5HUlVaxpL0xrIXGbR4NUaQUesN7BkCTsbFwokNiQm1yYNHxGcnkp+spCA3zGxsh
         zijA==
X-Forwarded-Encrypted: i=1; AJvYcCWIm4C63LzO4WWU9YviaG1BtWD2iUHok2tmdi1nXOTjiJXJINPucSGu2wwgN3yyr8m7oCBHwZjZObtsQzlcDpM=@vger.kernel.org, AJvYcCXTqoDCXay8xxaCf87dZVkcIOCUxvo2RcFHw9Yu9P4M7EggvFcrE3mH99rEHo8odY6tiLuEbNfMbW5Y+s00@vger.kernel.org, AJvYcCXl8XiLU4gpOHv8Gcb4Xkl7disR0Q1YHDZk+LRWH/uW0BX0Yu1pDclmowf5DiOj6VrDO/MRubClrHLiR/RoUK7d@vger.kernel.org
X-Gm-Message-State: AOJu0YyK2ppX9k9kT8n4xXrwJMsaSTVa5bClVVK38aAXjdhdqDA8K9KQ
	cIG+Kh7LF2S7yLf15FSC1PCMSCtQTefgcIvnhPQ5P/iim6evtuMm
X-Gm-Gg: ASbGncsDnV96i4ecKNrN79eEj0Yj91GCtstiRM+Z98IlIIE4mI6IkJz9EUhVNlTmVcL
	eet0b121eiGFpivzsNLeVMokJPIBxWzl8oYDquY4q9UrCznxZX9UrrYzIkFEIYNEEcFgKd2M4Ux
	nNEnn0cyCvJJch+xtCYP3YKddJO1qk9gevZh+obm4sAO7JRwGg4hSp/l/L6v9BWO1308ZpttgR4
	iDtLp4hl3zs5YhyxDIhG1S2vlMVk1OVXV9+SMfSP2d6h5SlAht3GXTYY+Vs0r88xRnag9Gk9S9d
	zxmKaYdrkSrbA6VCNWWmwxY/0lr0L6k/dyubrB/WLy3jg75pwbNP080SbzZTsjInLl/MwSc7nSz
	9UXSdrqbjlU5wf2eXrbQxc7Qdp4dWzpY+QTn9QXYtsEQ=
X-Google-Smtp-Source: AGHT+IGIlmp0gTErSS4DfDNJ2k0q+U7DXk7nnE8hCWt5GhbV6qmR8RoCNHygavxB4lOMiFfar//Acg==
X-Received: by 2002:a17:907:3fa4:b0:ab6:d7c5:124 with SMTP id a640c23a62f3a-abf265e8ed2mr386410966b.43.1740773790747;
        Fri, 28 Feb 2025 12:16:30 -0800 (PST)
Received: from corebook.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-abf0c755c66sm340812666b.136.2025.02.28.12.16.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Feb 2025 12:16:30 -0800 (PST)
From: Eric Woudstra <ericwouds@gmail.com>
To: Michal Ostrowski <mostrows@earthlink.net>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
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
Subject: [PATCH v8 net-next 10/15] netfilter: nft_flow_offload: Add NFPROTO_BRIDGE to validate
Date: Fri, 28 Feb 2025 21:15:28 +0100
Message-ID: <20250228201533.23836-11-ericwouds@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250228201533.23836-1-ericwouds@gmail.com>
References: <20250228201533.23836-1-ericwouds@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Need to add NFPROTO_BRIDGE to nft_flow_offload_validate() to support
the bridge-fastpath.

Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>
Signed-off-by: Eric Woudstra <ericwouds@gmail.com>
---
 net/netfilter/nft_flow_offload.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index 5ef2f4ba7ab8..323c531c7046 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -421,7 +421,8 @@ static int nft_flow_offload_validate(const struct nft_ctx *ctx,
 
 	if (ctx->family != NFPROTO_IPV4 &&
 	    ctx->family != NFPROTO_IPV6 &&
-	    ctx->family != NFPROTO_INET)
+	    ctx->family != NFPROTO_INET &&
+	    ctx->family != NFPROTO_BRIDGE)
 		return -EOPNOTSUPP;
 
 	return nft_chain_validate_hooks(ctx->chain, hook_mask);
-- 
2.47.1

