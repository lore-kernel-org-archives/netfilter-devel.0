Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04A8C22E9E3;
	Tue, 10 Dec 2024 09:46:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733823992; cv=none; b=KI8HqDJ/yibM7eWGh8FLxQtMWB1rnKprGydy88Ry+N2wRAdXigK1mPzzyTe6vacr4xSXpxcXT2IutRcIbsombtRD0zjGy+sH6lHLUdNrbSm1q4grwzyNFzw4LdJGFN0NEMLAzTRABH47JtjvADWYIpGVCuX/23Isj84cSMSquSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733823992; c=relaxed/simple;
	bh=dbAGsONnKRZzlx83jeLRPcTwW8qS9zwjqCZyp+6J28s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D8TtPVN5sxPAadEopa7GUmTs9dmw1ImtvNFF+23ikaGRRY67NaYjUg3zwIg16uMzNBFRDd1yeTjtkKzUQZRlvZgnsz4k/yyGEcvIdRkWJzeCvvVDE7uHQrWb7nsEqWmULhflL6z3hnk96EknllVsW/CrnOGlj0PgcbmnoW6EkOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Wq9YlrBX; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Wq9YlrBX"
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-5d41848901bso2136294a12.0;
        Tue, 10 Dec 2024 01:46:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733823989; x=1734428789; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BztZ0cfqRt9dxay4EdRKv7PmLiYD1WDU1Ehk6gLPnTE=;
        b=Wq9YlrBXe/xWtGOW9hSm+3krz2JwWsIXeZ0J9XXiUurdjmCC7qP3sC+afUv1K45MqE
         fwVbqk4cpfydCejFzgquP+zEaow9KbmVTRbu1S3k6QDTyizZvSnkK4qIAwD30YKCelSh
         vlD2nyKNyZE9ZufJdhXN6m5OvWzDf85lKnEEK4uC8NIzmDUasnJXpePo0rAVfSn2tA/4
         BBVivgh/6wAEnpGAsR9VkDEyWudvRyMgtH1KOzXf20+wL5YI4NIvxYfsW/hr4JNtDuED
         DCfxrHliY/PSfVTVUzodKzBXtJahDeyJMHcQv+KZUJQ1ia7C6IfUktBgPgPhcDyYwtVc
         VSaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733823989; x=1734428789;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BztZ0cfqRt9dxay4EdRKv7PmLiYD1WDU1Ehk6gLPnTE=;
        b=jm7w83zeLZreBVslWS4urv2GgGfxVoQADjnmw/98vnqK0DPNPGGvmhMFmQ3vMKWIjO
         QmjZV+Kc8U2ffLIYrfu7M9HgZWoHdug+xJruiXpJVdPwWuMAdLNN+CoRU7FPTK3u9O3j
         uATEPOHvQKj81d02/1X0/BZMIFrRSPiMh9v/+mRGPw4ihWqEniuJtwL0IHLb65BuKIpW
         VYv6h4Wl+omPL6gzMqzJdHIs3gwfYhtfvvjrm8bXEUTWdStY3Z6j1xdjhbKtdGqI53Wh
         ukpDLQYmvI7jDQFP9cvvUCjr0ZkG/IvjDfUbb6U6VN9r8QJuxsWxigpA0+OEFMBH5VBX
         Zj/A==
X-Forwarded-Encrypted: i=1; AJvYcCWoMHyy+qM1a2yotvwhebQW8JfF06iDGKXoPJoHa50a7SshF5aKwtgtf4YcOKLaopgkKKnBIrnXfo2zXFs=@vger.kernel.org, AJvYcCXTV554gWZMj8PklJYcUKP8l3q3nVVVZ6BQqZjYSL3PACdNeOSr1spydidS1mKgOdGrsRw0SGSQ2CpF7ieppgbt@vger.kernel.org
X-Gm-Message-State: AOJu0Yxz1FaPc9FoOrOR6+LEmaflWdV1S9CAeyJYY79SG12hUg7DF4rd
	A8zl53OVAVFLFA2m/9j3Lqh6QnI4AuQerEEIUokfW1kPzAtI+Epz
X-Gm-Gg: ASbGncu8LIjggp3ImqY2lfCOGPlkLxDLqq29ajp7nG+w8LgZaN9M2P47aHYF2sVlDiS
	1xIxppr6U5O4o9eqgyzSuTLO7Xjjw8HI+SsqBcrzT6uswBfttR+GNOPoJrZiIh0nH6e/fSVtxPu
	mbXg41DSoook4h6rX4ydBbYqIz+Ajy45HHVkEGS3jop3R1WAbuaTA66PesHUr9Fpkq5MrCeUr3m
	nzy6FfOdz5y71rJ6GpsxKb2FOjz2wChL6VQu79Qw+aOBFyXmBfzFVEFRsUoAhpjixG8CgN5vCr7
	kdHK0sAnlZjN1ggwkrOHFAiVs4qsiuzJn6PhgVHK/Pp9SRwV0S3w44Z4crHZJqa4bhaEUtk=
X-Google-Smtp-Source: AGHT+IFyTeE5viLWDV5JNS3lSXCPHMg3QwwF9F8vVIQIRSBON1JTkjS6u5VFo+SMdaaFOV+dkCijqQ==
X-Received: by 2002:a05:6402:524e:b0:5d0:e461:68e6 with SMTP id 4fb4d7f45d1cf-5d41e36d2acmr2440521a12.17.1733823989216;
        Tue, 10 Dec 2024 01:46:29 -0800 (PST)
Received: from corebook.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5d14b609e56sm7313936a12.40.2024.12.10.01.46.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Dec 2024 01:46:28 -0800 (PST)
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
Subject: [PATCH RFC v3 net-next 10/13] netfilter: nft_flow_offload: No ingress_vlan forward info for dsa user port
Date: Tue, 10 Dec 2024 10:44:58 +0100
Message-ID: <20241210094501.3069-11-ericwouds@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241210094501.3069-1-ericwouds@gmail.com>
References: <20241210094501.3069-1-ericwouds@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The bitfield info->ingress_vlans and correcponding vlan encap are used for
a switchdev user port. However, they should not be set for a dsa user port.

Signed-off-by: Eric Woudstra <ericwouds@gmail.com>
---
 net/netfilter/nft_flow_offload.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index f7c2692ff3f2..387e5574c31f 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -117,6 +117,11 @@ static void nft_dev_path_info(const struct net_device_path_stack *stack,
 				break;
 			if (path->type == DEV_PATH_DSA) {
 				i = stack->num_paths;
+				if (!info->num_encaps ||
+				    !(info->ingress_vlans & BIT(info->num_encaps - 1)))
+					break;
+				info->num_encaps--;
+				info->ingress_vlans &= ~BIT(info->num_encaps - 1);
 				break;
 			}
 			if (path->type == DEV_PATH_MTK_WDMA) {
-- 
2.47.1

