Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 874F322069E;
	Tue,  4 Feb 2025 19:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738698608; cv=none; b=dWCBQkNGOpwLMhe8pDbJoo1dhSGSS5kz4CWTkIabj5ICNrSzQhGrXjjxZMiv/qHKr3BuwWaIhfSmQ6MUOovNDH93hqIm0jD1HmjgKeumWOtPGiBaATbXHOcCBBuj1prnnYtJzTZhYFJFrFV+/dcXe7EWP7QCwcOolTO+KgEQ8u4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738698608; c=relaxed/simple;
	bh=Xf5mlATXYp8EYoXU9a3w+XGI157o2p4WZAmB5ikh7tM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hhFy0PfJZHvOBeMBobJuoWUeGKS51bv8uzxDItuhPVCX8zwVgJAAOHs2fhsghb+m7qZmMtw75xbBvRj3bgWosQQAnKsynABfTn6I4e/5TVSTGVtCwsCi0M7gaYUcprcBNNtUCRera5HLyiq8Sf3NzwyYb7UGLaQ+arniilCsfLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Wj/D84lV; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Wj/D84lV"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-ab7515df1faso176702566b.2;
        Tue, 04 Feb 2025 11:50:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738698604; x=1739303404; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mNvAyhAv6GepxNEYkCskllQBVi38mrCeZ4SsbbR7WSY=;
        b=Wj/D84lVwge5N4IUDldx9tnW+XLgN4Yi6N/mge0Dk+6brzwoy8Up61X9IdVHZLycsd
         YIMJJmdcZG56cCiHUmit3DQ9DDAKMR94w5NGGyOaggZNNN8Q1b+6j3RUL+AbvAlmTA0S
         dVOP9EOxbhxiCjto9bfEKH0acBkfMp4s6sFX+Y4h60tNS4TITyfGvX8KUHoZVDERCTf9
         n9EZKBY5pB3/so7HRfnx6P7u7/pTKeGGLQEmSYSS4cnknWIFV4/ihI9t8LjBpQY9d2e5
         fd87T8odBPB4sTp7N8WPVaBDEUTM0Xl0OlzmXmTs925YGkGDg2IX8Hqi74Pqmvp1ke12
         Y7QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738698604; x=1739303404;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mNvAyhAv6GepxNEYkCskllQBVi38mrCeZ4SsbbR7WSY=;
        b=ZwNcs2Rx1uot6SKbwcIZNfFCQEJ2X65LjORyOTCPbGQIK1X2/kp+mCqnvQE5KkEjc9
         H3yUoOYdeJCyc0lXP+M5GInKAG6Vx9qbQDORuuRo7bsqqfoA6z+bt2y+M5INNiMho1/t
         2fmks7TC+8eoANhzoIsaG9HButgagMaqItykZnfY/OOVQ8fpRWRjO6qgDVoyT3Zq776L
         skOihXOznMaPa2d+ols6PjeAuwYoTFC6H6liNkhGg6O/jOcLLV4sGtvIfPnTUHzKFrjN
         9zu8zGA5fV+X0MkrvDWkaBMbBy3djmEKhcJsmAGeLuae2Pxk7MnZG/Frz9ZQtb2x7D/F
         d0Kw==
X-Forwarded-Encrypted: i=1; AJvYcCVFhRlFs7v5htrN8SNoVfx8+VBi34gtEMarzffgY8B9IeuiajxQGewXqikL8hNQ318QCGbEGG4PLbwOlfg=@vger.kernel.org, AJvYcCVM6t5aukSUlIk+AWOm/MEYhVQFfREGwWfe5aQwPsgOSvcNv2OAJ9S0eQ16y44X1oJsKfkjWmPrTxCtUrbpx1vx@vger.kernel.org
X-Gm-Message-State: AOJu0YwLFxX80CNKOPAv58v3X5aXL22tyyJdGT5g4xtebfrydNS4vMSi
	n6JCtQlmhN1qcyEeCJrXZCkKexrgxoNzlESP8FExASe/ZMyyOj83
X-Gm-Gg: ASbGncsV0s9TAWDlsSNQ4XGTq2AT1bJZVUMxyoNSftNZk5OQzOSO2swr0e3IyV+EwLA
	hMGPRi79jiLcZpMOXze0FE0A7yy3U6wB1vIqoKCZ9qqbtlj8IZzs/dZtM0m+bWQ6oF7/1CGNNEo
	nvClU8/YPGnrFvX2xy6MlnEbcfknXicjBNeMMD/i13+8JwC5JcAmvnzoH5GM4/ME70jpzvAT2U1
	CqMdNh4HGMyms1K8BQJziJHvmgkghRXJy5Mk0KNfFgX1+4rgHoJ6c2S/HjbB5GSMD3VYughxyXc
	gwCJOL+NpJqPxiM1bQMZ7FtUX2RraZIKD5hdMLIUyuB7hEuvsRdJ2LH1Oxth09W3/ne0/dUOdwc
	HvySme9qESa6s9E5mM/uvm2taYW3pYLIY
X-Google-Smtp-Source: AGHT+IF3Pc3NKrXdQnXqPQwcc/aC4MWpA9WJONMBdLCJSxY43xKupXfl7aBElhm4x8MYzyDeLkdj+A==
X-Received: by 2002:a17:907:3f20:b0:ab6:dc00:e2e8 with SMTP id a640c23a62f3a-ab6dc010668mr2925881766b.3.1738698603538;
        Tue, 04 Feb 2025 11:50:03 -0800 (PST)
Received: from corebook.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab6e4a5635bsm964684466b.164.2025.02.04.11.50.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Feb 2025 11:50:03 -0800 (PST)
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
Subject: [PATCH v5 net-next 10/14] netfilter: nft_flow_offload: Add DEV_PATH_MTK_WDMA to nft_dev_path_info()
Date: Tue,  4 Feb 2025 20:49:17 +0100
Message-ID: <20250204194921.46692-11-ericwouds@gmail.com>
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

In case of using mediatek wireless, in nft_dev_fill_forward_path(), the
forward path is filled, ending with mediatek wlan1.

Because DEV_PATH_MTK_WDMA is unknown inside nft_dev_path_info() it returns
with info.indev = NULL. Then nft_dev_forward_path() returns without
setting the direct transmit parameters.

This results in a neighbor transmit, and direct transmit not possible.
But we want to use it for flow between bridged interfaces.

So this patch adds DEV_PATH_MTK_WDMA to nft_dev_path_info() and makes
direct transmission possible.

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

