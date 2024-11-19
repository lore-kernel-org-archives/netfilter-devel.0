Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF3511C9B97;
	Tue, 19 Nov 2024 10:19:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732011572; cv=none; b=POPYCXQSPoUjWnciFDekrB72maPXQzFUqd1akr3FM5Wejlb++Jt9Sjkn57gPBWJnSDvNoLQPKk8M5nEARLMztsRCj6Okh+Uei8YqeS9EOnry67J7fAEG2qzEWVNdqbJxgDQES0cIhvAlTq+sJcDc2e36To6uZO1iXSM7aze5XUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732011572; c=relaxed/simple;
	bh=lJyh0xDXdmHktWavY1MmbrQ/vBL7nLzt7QdbMKOj4K8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ER1jI2tTBk4uOHr6l+nNLFTLhsuXp2g6fTDHwzXTUD5ODynZSIT6R7okA0nt07891iukMys1RgqRtBd96xGlNIjxyJWrhbSqveQMojSRBG/7m8paTo+CYn7sowADqV+ThFvFZP13v8wbu/dnDosP1k8EqcR1OKgJpSlUqprgSYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PM2hNU1z; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PM2hNU1z"
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-a9ec86a67feso137165266b.1;
        Tue, 19 Nov 2024 02:19:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732011569; x=1732616369; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D6bOSx9F0JYNp5qomZcy7h/raSRvVGKNY4mEoIJa6U4=;
        b=PM2hNU1zustoIXeTQ0u3SsnPW52LGEmDhe85a0IDlKJLoIgG47kVopF8rKPftIks8E
         6egz5QcBEKghugesxg6H9Yvu9tgEcR8U5ijDIQZZ2Cc01fyUiHbFtl6GMc9XT0HG/WmC
         skVrttHEuQjC2uIPHFgmSPPnJlSLSYzpNrWU3xi87wsfaqGTLYGkbnhfX5ghrRy6/FpH
         QXOAKVoCltxtdpxgr098IRpfZTw1wBY7+JNNAoujN6dGE5KcbS/EDjLHqilRgD1TWiiQ
         Qb2dmAoY/S+klSws6CoGfgVx39I2sopCA9rAAkI+lwooM1lZSx4D70JhK4mDh6B0zpFb
         UDBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732011569; x=1732616369;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=D6bOSx9F0JYNp5qomZcy7h/raSRvVGKNY4mEoIJa6U4=;
        b=V8s5x8FP/VpZnyNsVsOGI5W9acYZOQ3J/KSNCC8FvHBaR4lNNyNQ1i3mwIB9taC1gu
         MHOlGsIpnJU+wVaWbOTZEcnvaGNRm+v3vCw0YJOdOIlm9mtN4VGiBZMyrlbLYXcoRp1/
         d+3AXhTyMySscr+FFFUy18As71Ogqoq41qSJf/+tYZAWvoznhWDi+wjS822dBjkJ3GXh
         rSvSFGxo35l1z8W+1PVxA71JLWQFe4OrNLGQO3s7YVUyvqThgo9TFHCkhkcRgFW2dRm8
         +Qy9LSuzuZ9YdC0JdIsKc9gktBEpigthTe9juPS3H8TMCaDIc1qMaB3miN+Kll+wCpbU
         GPZg==
X-Forwarded-Encrypted: i=1; AJvYcCU+N/4rju3t4mwWImBgV6gyaLPg3tKS4QKfD5sRfRKJgZprV0FKvUGq7BMqf1sy2xTfoVwQ3l1s3VqkkkYCn9rf@vger.kernel.org, AJvYcCVt+/aIGt1fuG3FG2SIaYVCIKk3nYtA/Ex+NkfJZAaKH2v3rJTwtyUFm+LCatjl1Ng3a1W1oAybogwOhy8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwnKgemkUSza8Q7WPw1qxy8zTOikYssja41dIpx7ik+C80UHMmu
	mljXtBMkoRLJdfwNk/PwfRQtwtmXLROkGTV1xz+eC03s4TCUII6K
X-Google-Smtp-Source: AGHT+IG4oWs8UOYUh0SfCm6s9PZ7edWvV+3g/BCD/rQGn8EB4n9k2Znl8dCuVvZlTq+Io1pQtKbeBw==
X-Received: by 2002:a17:907:2682:b0:a99:fa01:2b72 with SMTP id a640c23a62f3a-aa483489f31mr1130230666b.33.1732011569157;
        Tue, 19 Nov 2024 02:19:29 -0800 (PST)
Received: from corebook.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa20e081574sm634875566b.179.2024.11.19.02.19.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Nov 2024 02:19:28 -0800 (PST)
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
Subject: [PATCH RFC v2 net-next 08/14] netfilter: nf_flow_table_inet: Add nf_flowtable_type flowtable_bridge
Date: Tue, 19 Nov 2024 11:19:00 +0100
Message-ID: <20241119101906.862680-9-ericwouds@gmail.com>
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

This will allow a flowtable to be added to the nft bridge family.

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
2.45.2

