Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5923819E99E;
	Sat, 15 Mar 2025 20:02:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742068927; cv=none; b=FpENnd4zxIzs5WhL1lASTHPUqkLSUCYjHcSGYNzYV3xbL8WYIP9L8k2jKvYyQ7VA5wJz2AmreNHQLeJ5JLKWQwyk5lLN6i6jXHLW48QD2IDvngh44+x7C7LfYz9VInV7g6BQMmZjI+VjWYt0KbTIJCnEQBN+0hpC7DureEPcdGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742068927; c=relaxed/simple;
	bh=kNP8x/IMGQOh3Wqh+fa0471RIWgjq6Z4id3flj79pJU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bJI8rVvwG1vzE0IPcnbkpBciXJ/PBehynIPkL8NAj6JuFWJYwckXTJwTwZLUespFJlWk3UAUqqWqdAm0/tDgeB6jg5952nbsIEOuXHz2F6U4GgFRS4t8Z8FbxDl5MC2EsitzGmxoXcrXIKK5iubUVtu2v9+X6o1VWv23K6yUPvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=d14QIIjV; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="d14QIIjV"
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-ac29fd22163so542322466b.3;
        Sat, 15 Mar 2025 13:02:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1742068923; x=1742673723; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NpqiiXZms0JGOtrihsd57qCqRp7MjUMv4uKgIUJzlhQ=;
        b=d14QIIjVrMlZHHgOZT8GxUCsg2n/IjqxkUzISZgkiSOhqzHuNotnBPbC2fb5Q/6fkm
         L9UyjTNH/rQ2SBVBfZ4f1Q7lPsnTkNMhxUhpuO2p+4OqSgL9lBauqpCrg0WBFPSXHWud
         6UMkcL09P7wpetPuAcWhLFm0XuBsGHACTZBIeiCw5os4n3xO0BQgTC9wGrq2CAwfqT6u
         Dxe/tzcXCFuNB9diQ5tkmyUlrHazPXAZQgP8m1fZwgzoK7bX8vWXOeyasxI1SsLLcbvM
         87M73i5WN5QPMGhqRPeIVjVLkS528mFr9il+uk4nZrPiE3ioNQidQNW7niWj7nTA7CUb
         8gaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742068923; x=1742673723;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NpqiiXZms0JGOtrihsd57qCqRp7MjUMv4uKgIUJzlhQ=;
        b=F16nsfQTBRMG86J+i3JyWM7J+N1kPnhmDMt0lOeIQMiyREllF3lCXGKIUebjUj5MFb
         QHP08VWS6IV3aU+rfCjeCGpr6wSIXWccJCoaRVk+L3+KFpKiAHubv+YlhU+R3F8Naknb
         w409AHvRzD9pI5vE6ap6Qfz8PRi6jrhCUWnHLua7N5TANZMNiKpzNyJeBDhMdUuL2zLZ
         mz1ksem3riFyRESdCX6B073QNEgFokrtK5XWozn3GE11LrpgEwc+4y3PSHgcVVf4c0ng
         VDe8+C82lQjQHujdwyvkgnE9IybvA8FIuH0sgFupLllQrTiVin4QyzAKsraqgABHIu1m
         NxeA==
X-Forwarded-Encrypted: i=1; AJvYcCWY5Nh5IrWepkRqeDOrwiRKkcP63V/Xfh/zo79em/ym0gQ8wDydrTYasygRefpe2umNGLOGwY9Ak8bp205edHs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzv7c5Xqi5q3DzoKygihb/9UA2zLmFrqhfg43fqVb/eLAW90lXq
	88BCQLlBySyFNT+M5NxwrB8WOOu/MTip4qgdZdPmUk7XcHgFDuJO
X-Gm-Gg: ASbGncvO5QMnKNpB+fMdgYujM++SFlrkUertamM7e6hcaz5+pYMjAMQW3YwjG+pLBrc
	C0VCCWKLg6ZYgCRygAkavLFl5Rfhf+B6l48SAHAMmlSvUh8OY8KcPrHBQZNsaGFP6g1H18miIin
	SpEzd2glrjT/vq1aBLwvy1ig01KV5nAlf2chyKxTuBtL49Z/VxfQBZky6SAxtKQpJ18O2vyI08Y
	goI8ljnGNLKb/NTNYt35EZyzInX5Vzl1OmmcCbzMp50w0tL1HKENqnZektZ8Jky+xVzOY8z1A5I
	a5ZTVHlqSFoeWRqiXMyZbKyu73fjoPvKk1ZBEQGotKajdLTpEGbblAdo2YpxkcPi/sI/EutuH1F
	AMoHd+dHX1UaVj43kybolAtDiCpkHFwT7+glbK37OtaRsyEVA5PqtKZ5F1fZJ8oM=
X-Google-Smtp-Source: AGHT+IHCa55+wjBQiSxD140JEHodCQYGe9wVqqYoJF9zBcrAQwDR+1enIfiBTks5BKAmzlgfv6jNXQ==
X-Received: by 2002:a17:907:6ea9:b0:ac2:c26:5608 with SMTP id a640c23a62f3a-ac3301e0b40mr826573566b.8.1742068922394;
        Sat, 15 Mar 2025 13:02:02 -0700 (PDT)
Received: from localhost.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac314a489c9sm411456766b.152.2025.03.15.13.02.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Mar 2025 13:02:01 -0700 (PDT)
From: Eric Woudstra <ericwouds@gmail.com>
To: Jiri Pirko <jiri@resnulli.us>,
	Ivan Vecera <ivecera@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Roopa Prabhu <roopa@nvidia.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Cc: netdev@vger.kernel.org,
	bridge@lists.linux.dev,
	netfilter-devel@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	Eric Woudstra <ericwouds@gmail.com>
Subject: [PATCH v10 nf-next 1/3] netfilter: nft_flow_offload: Add DEV_PATH_MTK_WDMA to nft_dev_path_info()
Date: Sat, 15 Mar 2025 21:01:45 +0100
Message-ID: <20250315200147.18016-2-ericwouds@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250315200147.18016-1-ericwouds@gmail.com>
References: <20250315200147.18016-1-ericwouds@gmail.com>
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
index acfdf523bd3b..05786d856530 100644
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

