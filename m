Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 422C427D775;
	Fri, 28 Feb 2025 20:16:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740773793; cv=none; b=tVUwIIP30un0IrxVvijXacgxEwFsphE2y6D7MRDu19Zcpn3lO871d9UCWvVkj5FGnDIDYQHJomDXBJ1GMgfz7JERRgBMjNGfYvkAI82AF6YhwmtK4UKhKS/s2Wyos4kzk8Ob4gO3LOAhZ5cyX+se3DjZr73McDp6f0SAKMbQj/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740773793; c=relaxed/simple;
	bh=AihhYJGwJTJyObdFZSI/rxytC55wEnFe8EzDy7l8A+0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CMugv3qpjieDzr8Q5vhSwUXFpBeDVGjUijoCJXTml6aTO9L8dXCg2ExRBsjcGhEBUU7MThUqEW+5qXn7d+nxh2GOZ2kD1xWUzz8F2t86jnG8Rv0Bdhndn8kUm7LVEZ6sTucyJfXy+heDcPgv6UhSVaC5oQfEQvKXy9KYGaSzsAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hY+6Y5hF; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hY+6Y5hF"
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-abf4b376f2fso37970966b.3;
        Fri, 28 Feb 2025 12:16:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740773789; x=1741378589; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6/OfFtkDCpNUsNNnB4udxCcQxzWSEZIHYYoj3YjYWKw=;
        b=hY+6Y5hFEJHkHGrLbAeX9hLOVUW/aKJr4A2z7+v+wIWAaS9TemxIuWRnL/Ja9kfCKw
         6gt+Ge5RwFobUWQWqqPeUstEYMavcDy/EnxHF4FTcLC3isMA3BK6DNrOK4KKHuvYaUW9
         wXgpZyAZh0Aii1ZRTxkx1U/YluCrc8easzSTN91qdB4HDgfe/A59MFLggloT+2onKw5Q
         sgLof/YYxc/N7fT9LP2NmCLhPxd19GnnTYWIZdQPIrwyK6dGfsL0uVtZzb5PgQlKkvBs
         DCkOf+0VwTBpg4gKecPvIinL0rBwn38FEf/tdGMyFaPajIGpb+qtJvdAyXKayUFkni6J
         edTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740773789; x=1741378589;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6/OfFtkDCpNUsNNnB4udxCcQxzWSEZIHYYoj3YjYWKw=;
        b=O8zG5LlGNxjbxO9GBO21PF+XWeT+mBx/NCaBjD49kOC+QO5ZCrezN/o2cOHHuBRNpz
         USt5D+7IOQ8fPEr4OhDma/a/T0AJOl/5WGu76OVRAu1vxUcDm7TmaRvWCotCamCPno14
         LmlG2xFLqlUaH4BdlOx3J/z3sAVWOgg8RujdsA+9ISSFcQ/NFveq8WLIbxbQ4Hpm5Kum
         Lk3ayRRH0Wmawzqo+4DVRo3NTjwaZx/IvhpBa/YV89jdw6yvggbQ9F5wrPyX1KPHP3Xd
         e038wb7buf6/L04CbTvS8uOllESuvQfmmgD31YTUCdwSMP0NAqMK5f9znX743EMqy3Y+
         OPhQ==
X-Forwarded-Encrypted: i=1; AJvYcCUJCYBUK3NPnnw30vy2CL0e722UsHvXvEq6EOC1wXNLWnooPRQQ7xzoe0oCtqvPIEKI4Y3hUzEC8g7JxhXneYc=@vger.kernel.org, AJvYcCUv/+JzfsnIoOd43GvScFoFEfRVBFlaY45ZS2KbsgoMI5VZqJxSb0J2+096QDuggBd1+dKDfFzU8DG04Nwred/J@vger.kernel.org, AJvYcCXiZiKYyqUm50hu+mHYemgJ/FLbCAzLXMbhOjNJEx/v69t6Fldxhzu3HlVzXJN1ZxeySyZ91SlFfjuAtPbH@vger.kernel.org
X-Gm-Message-State: AOJu0YwkhwJ4MRjxtAJy7cCOR/pGSBxjt3EHBszEUrqa1AV8uiBPUnoa
	wtMBWyc4Mw3zQq1ebe4EVk4UQgAbwhU+4a8UDHHOOGvvKRZJjbZ5
X-Gm-Gg: ASbGnctHyZ9A1E7Zqdyxct4IjChOdbuZco4AjhmyFQVqiy0XMExLUKTSKFAvtYk8wES
	mwvUByUZ8HBlElwNe/YbJcoq9/j1ZBovooe4YEQxQQeqffmrcXBN0vDJgkYmTzkeNw94/Zm5Gl1
	7yXxviECAVqjyy5YeL181j45bFzW1ofpByrqeerTAOACSKeaUa5+HnJI4EshA719nq9pdhavyHq
	nNmN57nDUBZ++d9xsaqHDIUq4nY+LDEGY8HPwCxxkR15Mhaz3G1tiFn8YbGKaSiR5FpmbafhESY
	oyrfQesZJ9oYto/WiwnWP0V6/LUgSdMK/6Q6gU0ugatY1N9KPdqbdTJcf/43dW1btRql6ov74c0
	LAM2nLTEM+aQGMkY2U3jRTkB/SH4bUdkSEx/TAEROKeLPwRmvkwSnsQ0YRKkHkg==
X-Google-Smtp-Source: AGHT+IEQAXatFYtUv180Nd/vAAtHbNFD7uOybxHOrydax27b/c3kzdKVO8+x7rEp/205E7ETT5lLSg==
X-Received: by 2002:a17:907:9620:b0:abe:f8c0:c1ab with SMTP id a640c23a62f3a-abf265d3be4mr498901466b.46.1740773789267;
        Fri, 28 Feb 2025 12:16:29 -0800 (PST)
Received: from corebook.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-abf0c755c66sm340812666b.136.2025.02.28.12.16.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Feb 2025 12:16:28 -0800 (PST)
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
Subject: [PATCH v8 net-next 09/15] netfilter: nf_flow_table_inet: Add nf_flowtable_type flowtable_bridge
Date: Fri, 28 Feb 2025 21:15:27 +0100
Message-ID: <20250228201533.23836-10-ericwouds@gmail.com>
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

This will allow a flowtable to be added to the nft bridge family.

Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>
Signed-off-by: Eric Woudstra <ericwouds@gmail.com>
---
 net/netfilter/nf_flow_table_inet.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/net/netfilter/nf_flow_table_inet.c b/net/netfilter/nf_flow_table_inet.c
index b0f199171932..80b238196f29 100644
--- a/net/netfilter/nf_flow_table_inet.c
+++ b/net/netfilter/nf_flow_table_inet.c
@@ -65,6 +65,16 @@ static int nf_flow_rule_route_inet(struct net *net,
 	return err;
 }
 
+static struct nf_flowtable_type flowtable_bridge = {
+	.family		= NFPROTO_BRIDGE,
+	.init		= nf_flow_table_init,
+	.setup		= nf_flow_table_offload_setup,
+	.action		= nf_flow_rule_bridge,
+	.free		= nf_flow_table_free,
+	.hook		= nf_flow_offload_inet_hook,
+	.owner		= THIS_MODULE,
+};
+
 static struct nf_flowtable_type flowtable_inet = {
 	.family		= NFPROTO_INET,
 	.init		= nf_flow_table_init,
@@ -97,6 +107,7 @@ static struct nf_flowtable_type flowtable_ipv6 = {
 
 static int __init nf_flow_inet_module_init(void)
 {
+	nft_register_flowtable_type(&flowtable_bridge);
 	nft_register_flowtable_type(&flowtable_ipv4);
 	nft_register_flowtable_type(&flowtable_ipv6);
 	nft_register_flowtable_type(&flowtable_inet);
@@ -109,6 +120,7 @@ static void __exit nf_flow_inet_module_exit(void)
 	nft_unregister_flowtable_type(&flowtable_inet);
 	nft_unregister_flowtable_type(&flowtable_ipv6);
 	nft_unregister_flowtable_type(&flowtable_ipv4);
+	nft_unregister_flowtable_type(&flowtable_bridge);
 }
 
 module_init(nf_flow_inet_module_init);
@@ -118,5 +130,6 @@ MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Pablo Neira Ayuso <pablo@netfilter.org>");
 MODULE_ALIAS_NF_FLOWTABLE(AF_INET);
 MODULE_ALIAS_NF_FLOWTABLE(AF_INET6);
+MODULE_ALIAS_NF_FLOWTABLE(AF_BRIDGE);
 MODULE_ALIAS_NF_FLOWTABLE(1); /* NFPROTO_INET */
 MODULE_DESCRIPTION("Netfilter flow table mixed IPv4/IPv6 module");
-- 
2.47.1

