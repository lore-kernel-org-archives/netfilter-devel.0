Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E4BE19F127;
	Sat, 15 Mar 2025 20:02:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742068928; cv=none; b=AtpTfbkZXmTtNRVUGHW8RuWixem2BiIwAG2KQ7BaufNM5cApS+TsfN63h4X/2sHxu6wTD9vNZAkIbq0OnVclzpo1L4ibIcNno2kh6KLdl40krYOyYK7c5iq54vH/lird8H33Rz0gILQKp4hQnvxhtkzDhRPFPYVyR2PP9QSBEMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742068928; c=relaxed/simple;
	bh=PQaRq495yBD2gObfPrbPn3PgSekFS9Bzk4unPsNuczk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kEZAnqyZ0R9DRUycMYHlTvVPkMr2FPOAsXyOdtCfopautxWRgs+3HtCfiGeKwcthREOd5CNTxh08JSc+WbNwujK6s5EuW3S01hubw2flF7hlveoqOVntqpd7K2QFQCsGLEkxVnvQmOp5uGcdBh9NANcVOlbsUf/4YluiBgWZabI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nPkx6X/p; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nPkx6X/p"
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-ac297cbe017so777069366b.0;
        Sat, 15 Mar 2025 13:02:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1742068925; x=1742673725; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rnv8s8ozBwrftot2Snzl1fMe2ZQjCLjk8NZLpN8fPs4=;
        b=nPkx6X/pIrgX6B1NkL7MIjLks5Jo4ph8fbQwRKtpkZEseTZ/bY+6iXzY5IfzArOAmh
         V54VuiL4KhDcmXUZ7BfO5pJy7uqNckN6qgzgxvpdKy6N9gXTiEWoOSbRwnU4zh9VAcnH
         vp0uxwgqZZlqcy4pFgJ9FpBJfGJ4aXqizwjBSKh1EqP9Mnu82opxKQVve9SoRjS8nFDT
         48SCwo/Ra/fYnuqFFppOjFMyWwwOKpSoRJsce3tllR8+vuPRbjdFy6TZO8g1Z2ycWJod
         bzmo/Lx+647yf3oUx1kAYV42TNmAmTlQGYZ6EU9LTlMUHQClXXLCJIfcWdVlxdPjhy9T
         UE+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742068925; x=1742673725;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rnv8s8ozBwrftot2Snzl1fMe2ZQjCLjk8NZLpN8fPs4=;
        b=IlzRQ2bXWxDwXFtx98HDj5VOO4EHrillUFpu2SKoBjoqCAlv3EWRa0Av7iXku75dqT
         vAPl0jBeNoPeKMdsGpv4/7VCQWGsk2/Wo9PqRraf9p1hSaXU1h/oPZ3kcWf32554/Zxj
         2W0FGshs+YGh0TWS8D6YGwFz9R01tHu1IB2CDcAwSSuHTkePVNQViU77Sbng6LxrLbXd
         CkWjHCO8miM9Fbd9n8cf0NA4Kgg6wDct46SGRzGYLIpxpzHbAyUm8ysob/xg2tJVpFNa
         AhDYc+ZaVGnqAtxxLHaJohj8obNLQ3po/jOQsZct7OsL8aTkNLkc92pD2QBgz4PlDpa5
         TSxg==
X-Forwarded-Encrypted: i=1; AJvYcCWDjH8pdY0v1/yCEz7jpJRqIDEvqHuyTnNlQ7HYgehCSaxVBakt3Lh9DAPgqy6nxlJMABoCm1LIOrSfJFtPVpM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyq6/PO2CeqycPB5fPhQJQFGUUEeWUVZD1EOSryn6Js4/WwVUit
	C1PhEEpqTGSmqAbWLMgYId9YdQdyLMP7zwgR2QVfPwupot1CCUmz
X-Gm-Gg: ASbGncsO9POQZ/USJ95C5lUOjgE2Q17is4oSX7shniXfqzFB7rKw6kfT1bFTXOwr+hJ
	nSwO+Sq8HuAVhlVwlwOovULyJeRx8UUWURXuDheMo+5FAJ2A+f6wVrDE8GJGnYlLeJDddER2Tar
	utX57fixKQ1xc7MOUzz+y7QUOoDwBolOqP3auRddc9ElPArwzVCrabuTcSL5cPq8TeputVMUgal
	bmYhJgQQYCmyXHZ225GWIP/k8y2+xImeB7koLerkWrhHDsGu34Pyc5aIvEu0s8CGA/PHWeBIJd2
	8x0IWTs6shKt23lQnftDO6DAcoFUG2Ybc+B5r3e6aiMBaKfTDRDiPp6aOFa6iHNmUR1VKlVYfGw
	Ga1GHJ5jsX7bmYhIh3YYPorqVEFvCDmVFJGs04G44H9kqFgHfpKdCd94o1BTfE9MMG7N3ucLVqg
	==
X-Google-Smtp-Source: AGHT+IE7wQUwPzmc9fAU28R+QPw4AyOXOfaovqueWq9l20dn3Msl4kW9Ypx3UjNa/A+DViUSNtfwjw==
X-Received: by 2002:a17:907:d38a:b0:ac2:9a4:700b with SMTP id a640c23a62f3a-ac31234318amr1268268766b.16.1742068924742;
        Sat, 15 Mar 2025 13:02:04 -0700 (PDT)
Received: from localhost.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac314a489c9sm411456766b.152.2025.03.15.13.02.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Mar 2025 13:02:03 -0700 (PDT)
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
Subject: [PATCH v10 nf-next 2/3] netfilter: nft_flow_offload: No ingress_vlan forward info for dsa user port
Date: Sat, 15 Mar 2025 21:01:46 +0100
Message-ID: <20250315200147.18016-3-ericwouds@gmail.com>
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

The bitfield info->ingress_vlans and corresponding vlan encap are used for
a switchdev user port. However, they should not be set for a dsa user port.

Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>
Signed-off-by: Eric Woudstra <ericwouds@gmail.com>
---
 net/netfilter/nft_flow_offload.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index 05786d856530..a2c7b64261b3 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -116,6 +116,11 @@ static void nft_dev_path_info(const struct net_device_path_stack *stack,
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

