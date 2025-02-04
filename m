Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BC8F21D001;
	Tue,  4 Feb 2025 19:50:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738698606; cv=none; b=ViaVLCym9TfFjdwAy4J2BivPNLSs5QNJrd5Qhr8Mpo2hRJbp86RkjXwDUe1HP6jNfN0iRDRycIcoh8LSXdez81vbmOycY+s7LbQPhYnufdnGF2S8tPNo7Mwke0un8e1H+wztUhmZZoCphoJUYoWPakia4JM5HhxhG5dpyVE4n54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738698606; c=relaxed/simple;
	bh=30vB1mNe4s/jWwmqRCrvbxpqeV4vu0iBchGE3vNDSNk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F46z0MawZdCpTP78af9qe/vi5YP4K813w7gwkp6OX5DjTN9ayhFIZW+wrGauO1px2/w8Bf9sieS/+Siv4RX2Y+cUD3c/3gQ7e+iTEKk2ZM/D1QWGEcwdb1B0mVTQMJsHsKzOqdYVSDfhu9Zu4REHRqYpCYfwDM9wD1lH88qsKi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VOSY0iDR; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VOSY0iDR"
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-ab7515df1faso176698666b.2;
        Tue, 04 Feb 2025 11:50:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738698602; x=1739303402; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KfNQ5cmnsawBulJakMMTQobb95EzKwEtX4OwcNbEVcc=;
        b=VOSY0iDRDF4LijR/4o/huudKPRPEayKOhsLnCdugGOLkPLzQ5nLSlnkmozFNmf+7qU
         vk8ivRC/6ukElQm2uvZezjoS5kYon2xMy5FtUjrwMK7mgWuTQ+vv7g0AhI4FpoAv0Eso
         PK8I2uUCTf+OQ2djSNf6HF2+McFQHBZkNm+YQmJLdCvvxKP3Z0jImny6vz4uSY0YxmhA
         u7UA4AV26kEC8399kYh19e1P+kAunMSyoBdrXWzaRlz3d7wek5RD5Wgx7mDMdh5t22bS
         KSn49cTduuQwJ6W6xmb/RqPVSTF8QOCk4QrXoqbhTsXuiHnM539W60PGH6J5fEA83LBs
         euqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738698602; x=1739303402;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KfNQ5cmnsawBulJakMMTQobb95EzKwEtX4OwcNbEVcc=;
        b=nNL4FXHuJ00NVtVAkChGUQx8hHtVmJsdRaTXcRZlyJN2t59ZNpsG2v1npMizTq8ZA2
         IiUsbqsW7O7eTg7okZpTMPgi43pBp5xbvWskp/1Fg53TrcF3tWfsaj2pkqtcjDju9aFz
         ucW85l4wvCv/IMZGyckiqvQqTLyx30DekOYL7fvgWcN5o6TnvRrsQtMu5qrzUD1bzcZL
         XvS7z3pgrcZ8JvVECMA0N3nW/e1aU8YKBb87ZAWmnXXWe5P2x9lo+9zHKYsQb9XHjHA4
         kJ13IaTbklW4d85IkraKnWF/8Q9OzZwSMOe3gFGMnL7fvljW8r7SXAkp4XfWBIQxwmF7
         7UCg==
X-Forwarded-Encrypted: i=1; AJvYcCW76mSmZyqGiSMwEXuw/KMRkZ6EQBFTED1tkAimrM+vf+589gU9rBpHXwP+ioUpgYp1RDucr6O3Gc6Cazk=@vger.kernel.org, AJvYcCWNW2PKcuEVdFwdEKELD1n+nXpcilalZ/W6e0tCxVZxswRewG5eAWeLWGhEBOoCC6V8fQr7+BK2P2czFOWmWKPy@vger.kernel.org
X-Gm-Message-State: AOJu0YwA3+sAg5J6PEeQiTqAh9o7jP0Brkormpm74XpA6MLrNGX/msJf
	yfOa8PIMxKRRlNj8vrZ/QfQa6l78/cMJroyIM2dr/E4Zu/9hP62R
X-Gm-Gg: ASbGncu13k/pbNqV+Z8441O8hnGKSJ75qKnYccZOxLA9NiA8O0s80exjlaDRk7iAYid
	YiTyF6ms8gI2GF7F6knZEB8s5DBl9dcRCP6G7H+qFWbdSWgPvxU3M4B0OKeM6U7XoQCVF8fUW7/
	AiZBWIwryfSlQbHxxtw2Uc0UlDJGQSs/MlRg/79NbKkMfmZwk8CyGtAtWP7ulva9CcTFbykDRdr
	xORA/RWJtWzBxFP/nvFXGyhHui9C1ps80b56VnQDYJmakOoO3LcxEQdlRwZPoNGdSe9tVp/eVeI
	DeKW5Z8OuFiAwhSoHlCzc819SJndh4bhFxBmLoLbW9PuuwsiKAx26oSRHkl94UkwZz29RAH0u/E
	Oe7mna/QuPaVI0kYZP5lqFD9ApLFs8IEp
X-Google-Smtp-Source: AGHT+IF0i6wSQMkgrmjCQzY0taa6wuEGcCy7CIK6oAwJpMPmap+r+O5XJX2h9JbKqG9hmQnHQyXFmA==
X-Received: by 2002:a17:907:c0d:b0:aab:c78c:a705 with SMTP id a640c23a62f3a-ab6cfe41079mr2625537666b.52.1738698602307;
        Tue, 04 Feb 2025 11:50:02 -0800 (PST)
Received: from corebook.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab6e4a5635bsm964684466b.164.2025.02.04.11.50.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Feb 2025 11:50:02 -0800 (PST)
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
Subject: [PATCH v5 net-next 09/14] netfilter: nft_flow_offload: Add NFPROTO_BRIDGE to validate
Date: Tue,  4 Feb 2025 20:49:16 +0100
Message-ID: <20250204194921.46692-10-ericwouds@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250204194921.46692-1-ericwouds@gmail.com>
References: <20250204194921.46692-1-ericwouds@gmail.com>
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

