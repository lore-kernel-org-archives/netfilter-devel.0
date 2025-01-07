Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 037BE1E3770;
	Tue,  7 Jan 2025 09:06:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736240781; cv=none; b=CEWkVIE7Q5CB76ti80LsxLCDQ8yZ44MRx0U7pKiPU7IJBJoGjDRQgyXioZSpxF1deVONCpJn0kPMVJchCpR5itvcKtMTfMMYcnemihlkxDkFePAAELMWijwt2XBp5XDiYF2SkZQnR0u81mkG7KV5CPWVG+TmCbsiU5fFUwnpHWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736240781; c=relaxed/simple;
	bh=dbAGsONnKRZzlx83jeLRPcTwW8qS9zwjqCZyp+6J28s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g/9gdNgtmlex0xhY63icG7j9qcE0GINl6iRFsulbQHPNRTi17yAkhMC2qBbYt+ouXACurp/wi2qkxh7NKsfORyyx5PNubWU5wZ9NByCHpp2CYO+rwe/TcWN5pSLFJHs6+8MHgydCoKPNWH8k9IAuxN7PrGDG0UkIl7SzwjwvxpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ngVLpnKH; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ngVLpnKH"
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-5d3d14336f0so7465020a12.3;
        Tue, 07 Jan 2025 01:06:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736240777; x=1736845577; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BztZ0cfqRt9dxay4EdRKv7PmLiYD1WDU1Ehk6gLPnTE=;
        b=ngVLpnKHbFXNkRCDd9ATImdHzBtzFws297/bIyf1ONNWsyt2Uno4E/nQrovcc6iJxb
         lajTW1YJNbqMg0tYdF89Z+8/mrdT2q+Y+QZecz/kKJLcp/fmX8k55JwLU8RpJdkYgtFJ
         +hFvZXykTuGwBTALbGUG1IIHiVpE5ZUiBhu0Q6P5bP4pEOKj8w2JxUSWJAd0vrde22wC
         mdKVzMCt7DjTBeDXmozidUIzMSfjzVSZPgGIOVSBZ6FI6VzxQkJoi/8xqD9HfPDlaujK
         nSbW85wgHxZRg4rHNyZd/PZKBX2kULwk1y+P6LlFEdEy5IB65t5ygq+M8/kXVKUquYbl
         aemA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736240777; x=1736845577;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BztZ0cfqRt9dxay4EdRKv7PmLiYD1WDU1Ehk6gLPnTE=;
        b=aQHfREHXsvRP+veR1kmUEb7ExLcEfYRnqSe6Uu+GudzWNN3h4/CbT6yUsF0m7PIjaz
         +ClXwmSwn5EAOEcZq4KFogulocYGcIL9rl/v+i/gugAsq7BJTYa3bPa4l8a8PLvNfruy
         Ou0uOF2161DgkezWpvn+zNwmBDk23V3Y8qNzco5vsQ7BMfnJD7lG46V1rrChCPjH+d35
         uuRPF35Pkrucnt4M9sPWvwBvEdZBtMFBzHlIx8XuZwhO5FQTUYnzbn6gDTPAcpXjdzYs
         EbaF6zh6rX1dlTOFPzMd3SZCRTCtI+ThxP2wU0hjAm3q9FyIelWxj7TBLMUdVdaLYKpy
         89BA==
X-Forwarded-Encrypted: i=1; AJvYcCU0KNgvFL1QUAoghzlAsVV/mlLRCC3Id7vCgx5CHg/2Oz5c+PjKzJI7Sp5X4NqJnLVqLnvSx8HM22TV4NM=@vger.kernel.org, AJvYcCXjRyXc8KIj/sHSZYyWZvN8TVs/SpwYetHmP+bygjoR+Yef6yPdY3/S9PHYML1bdS9YWZsxNhAzMUBkvq7sji68@vger.kernel.org
X-Gm-Message-State: AOJu0Yw8vG+Dnquch33BMuhmXN0puEjcwvtQymxF30B3juaLGD434ERo
	MV0XBGkbqjFoSBmmPQq8ZMTnhI2EBqpfBKHbamwaGIMne85JYn/0
X-Gm-Gg: ASbGnct0FhYsQOnTChvffNfz2oRBGFZ0ZZTPTl2DaVvOlQDG+fDyzyfdiGbIJOtd6bu
	hEcmA19MB4AGvf8DzPzl9FvcvT3r/44jwoc6GjROxrKNXXEUs1bdd1v6nBEBqkluZJIOLoCNw8U
	VzVnLKFsFaupISHvze0IPNlUBkW/l7MJ6lz5DdQsCMiqAm2SC0WvVAAYBR/KZAMbhNisznfuCw6
	DaZk2RBfc7AteHBQH1IzmN49RuHX3EmbfGfmhPylcG9MWByNm3BJHjyzmKbhGlxmlouBXZVw973
	jZmb4Oy1GRiPKW9036S7qtPt2SHGO9s7coKZJ5DluPI6tbdDV5EUQNY5Zgh94CWOv1BVPIIq5g=
	=
X-Google-Smtp-Source: AGHT+IEMDL6I9+h+aUrnAuxFNluD15rn5fjLxiMza8iUCfO2DRYtl2bUPleLH8zIiEcHnLjnMReziQ==
X-Received: by 2002:a05:6402:5253:b0:5d0:aa2d:6eee with SMTP id 4fb4d7f45d1cf-5d81ddf7fb6mr57943041a12.26.1736240776693;
        Tue, 07 Jan 2025 01:06:16 -0800 (PST)
Received: from corebook.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5d80676f3f9sm24005333a12.23.2025.01.07.01.06.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jan 2025 01:06:16 -0800 (PST)
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
Subject: [PATCH v4 net-next 10/13] netfilter: nft_flow_offload: No ingress_vlan forward info for dsa user port
Date: Tue,  7 Jan 2025 10:05:27 +0100
Message-ID: <20250107090530.5035-11-ericwouds@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250107090530.5035-1-ericwouds@gmail.com>
References: <20250107090530.5035-1-ericwouds@gmail.com>
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

