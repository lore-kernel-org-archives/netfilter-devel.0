Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CCB41C9EBD;
	Tue, 19 Nov 2024 10:19:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732011574; cv=none; b=Y5xAxkyOA/YCEibgz9j2tqGim+PnUriQ8wsklIsvrYpAL4yscbpO/z1uNo2Bx+qY8DAnCLqS70qmpg24a7l2gV31NEttymAIcBa8wHpLLHgxc9qCK8j8AU9msMz8uyd2WIk7MyhT7Tlx075r1VYnAjeP/BXT5YdvURVjqO816Mo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732011574; c=relaxed/simple;
	bh=0I6T/24QZkHjB/L8wZWMgXSyBUqTbRPz+vAmJSwHL+A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wop8B9YTBkFsuQEupsWjnV4TgWrxxenesJvu3Brr12GyNF1ZSX7JncKkdNOQAvG5IdBB6DRzHJqCNunHZn8d2sTk+Dq/yz4A882JPeXCVt/VnPBwH3xrdrt/KZ3Y/jPzMajtT9vzsnjXicpbawDeZHzhTm3mL933f/w4+V+9wFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=foJpRkro; arc=none smtp.client-ip=209.85.167.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="foJpRkro"
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-53da353eb2eso4502405e87.3;
        Tue, 19 Nov 2024 02:19:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732011570; x=1732616370; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3u3z/3aqnlj2QKTkwMuuz0nzsflPHuugQE1+9CzpwS8=;
        b=foJpRkrom9hYyiADMEEqkh3+QqgSPBcyJGBvBSfaLlTkfHWlYP5UkTagylPKaVLg9u
         2MPiYA8nX2OBbNU3KVJpwvqItr6ffxqjJJl19jkQrH/KO0HgwjzhjYPv0+0gUgcPuHvh
         SALwuLPtuEFf2E2Mz7NKrRuRPi3990F0j+u5Z56GgtjKzzdsdVNRdTo0eTqaY+vKmWEt
         EI3jC4mgQPqYrqcVd+RhWs5NmCuzQtQ0RajhoTjSTRxisI3ZJk7bk5eVyzvt3ZnwhKEL
         Bfj1INadBLCpw5LLd3UJtJQii+t2PvTxqnU+05Ve8wZloONLok8Zh2OtmGdAnIjedTpp
         tgxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732011570; x=1732616370;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3u3z/3aqnlj2QKTkwMuuz0nzsflPHuugQE1+9CzpwS8=;
        b=YT4OF3OFBW2VJZJ11Cs59FP9+ZIajRapNX4BJGkpHnemzQp2PZfy/DX/YUp/TgCQvX
         WaPOK66ZrtHo89HS0Y0K65YcWWmXNVjWsv1SJ6TKVBlI/lIBM6Rn9hAp8mTyFo/A710E
         bZpV1MESXRcuTzaW2/NLpMFST7+lXn5wM+XRvxl3DuVkfTkjaVIcr9lE7HSUc0SdeV6R
         DiOcb33ye/YSj6HG24Y3L2Fw8E9Ee6Zlw4sBBkk5x7rZrlhv3AW8fbYqZKTjV0tyjECV
         /afJxVS+GohaGe1UgMCvO5jwX5xhfOxUzu4Rz4m5CUAcEBLbnX4FVXQ0HHACnuZ6TqRC
         Ri8w==
X-Forwarded-Encrypted: i=1; AJvYcCXut+iEc0VmkNtJNZK+PdYYRQrSbrHQQTuKfs8M/RVuKNL7ocy/g+zUu3qETr8RcqeOO+7SOEmPZvnPf/QX4a+v@vger.kernel.org, AJvYcCXxrrUqgeD9AjsYwwk5A9xWCuqNzypdpHU0nPEWzmxXGKjw9aRkzkF1tbDfaDqYw7zLslGGzHQ0tYFmYJQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YxCJXBZ74SI4JAtffmBGAsHKkwmHBfsIDCyU5PU5S/kHAo+mOeE
	TAzQ9PD5UlnpaFmS8fUg3eku4QeNwnve8AhfhlcKnwWcXzKgwqYA4yUI5OEA
X-Google-Smtp-Source: AGHT+IGkiRcx+4ntGYaz++MVtIBeL1R2ddFZ1Ewy1ZLQRMvnRephj/zyQ1UBYhWvJx/x9a4afZDUfw==
X-Received: by 2002:a05:6512:3044:b0:533:c9d:a01f with SMTP id 2adb3069b0e04-53dab29527fmr10641351e87.4.1732011570368;
        Tue, 19 Nov 2024 02:19:30 -0800 (PST)
Received: from corebook.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa20e081574sm634875566b.179.2024.11.19.02.19.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Nov 2024 02:19:29 -0800 (PST)
From: Eric Woudstra <ericwouds@gmail.com>
To: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Jiri Pirko <jiri@resnulli.us>,
	Ivan Vecera <ivecera@redhat.com>,
	Roopa Prabhu <roopa@nvidia.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	David Ahern <dsahern@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Joe Damato <jdamato@fastly.com>,
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
	Eric Woudstra <ericwouds@gmail.com>
Subject: [PATCH RFC v2 net-next 09/14] netfilter: nft_flow_offload: Add NFPROTO_BRIDGE to validate
Date: Tue, 19 Nov 2024 11:19:01 +0100
Message-ID: <20241119101906.862680-10-ericwouds@gmail.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241119101906.862680-1-ericwouds@gmail.com>
References: <20241119101906.862680-1-ericwouds@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Need to add NFPROTO_BRIDGE to nft_flow_offload_validate() to support
the bridge-fastpath.

Signed-off-by: Eric Woudstra <ericwouds@gmail.com>
---
 net/netfilter/nft_flow_offload.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index cdf1771906b8..cce4c5980ed5 100644
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
2.45.2

