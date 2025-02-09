Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38D6C190072;
	Sun,  9 Feb 2025 11:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739099460; cv=none; b=WimoBYdqNkNiC16Irhq27ow/9XJ4ab7XnPX2XY54BEXmYxvrnV1ccWVnGy82N692QqY85iAeQu+m56CodMVIsuf2I0T56lIV6EEmaMTcL0EcXud8OmkzOBC8yX+Sq2YfFVOEQvvbyyns9K6LJsSYScd8M28Yet0ehkI0NCNn128=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739099460; c=relaxed/simple;
	bh=AihhYJGwJTJyObdFZSI/rxytC55wEnFe8EzDy7l8A+0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JfUDjW2zseL6cYnz1w4NRGMaombXGPbXEeECpWG3PCBU0msAaOqPj+UOK3r89p2SeMvtTLpuLTjFuQYMYqoovoUp+AF3zsD6D9RNDnInhz1VeHq3CC5yzhP3bXxr6gtk4aPB0wamOEEHpmLLTAMvEg6KW+GpqoGbX5mrzCfZ0TE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hr9dowNV; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hr9dowNV"
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-ab7430e27b2so674062066b.3;
        Sun, 09 Feb 2025 03:10:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739099456; x=1739704256; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6/OfFtkDCpNUsNNnB4udxCcQxzWSEZIHYYoj3YjYWKw=;
        b=hr9dowNVVBtsGmJcMrMcY4x0vt8/cFhaUshgKeq+Aa4LRENbxMY1wGoYEEysdgNRF0
         TLTSuZLujdUOOEmLv6E4qLBjbIjayBIsEDf8Wi1TdGqI4D4OY8gcr2bM+LiwlY7ayeKB
         StLB0+nua/r8mXm5X1XcESWro8rGQf3UZWEEyJ7Io5bNoAY5NqKRSkZMRwanGOzNkbjl
         9rESffqCNarc6leBEaszGFXmEB19OGEASeneIYbhiQpP59+m8IsSr03JuGGSqW6n7UQy
         0D9koYxYGlLyBuS95yWpmxwL4DTPvvt85xBgndi2z9u9jyUHjdtCqaJ1DjbCT8ord5Ti
         0BjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739099456; x=1739704256;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6/OfFtkDCpNUsNNnB4udxCcQxzWSEZIHYYoj3YjYWKw=;
        b=QdvfFv89f/2Tzv4nR3myJhwQ10sboS/vgkHXYKQ5XBV6jwImg6PAIgmW+O51+kUEzQ
         ORsYkhatYgJrHGJDnY0lME0JucY2i09DFvi9CY498PDHCfhLwZtBF8rbFUxjHJxsWpRL
         Mnw6MAeY8DMEj/Ir+zCzdCiJALFK1ma8NsyPEWj9igci1mHRM7SmD7UL/xN5KhhbXgHM
         XWbSD+GezB2VO8HB64IahrgoTdM64JkYMTqx/L7BwER/VSw0g23jQ97xWZZCMbcb/R1v
         nFncvJxaDcDotawRfXF0Bt2mmP9xkgtKeCT+xz/Sb+20whtF24qBh6jEpFCCW5ocfB/I
         nF4Q==
X-Forwarded-Encrypted: i=1; AJvYcCWMlvdcSKJBD3YiSDhdTD4GzXXPRNygM/cuoZux+fjLDv/H8pYA5AUg+XbDll0juAH4plE82+sxSWE/Rz0=@vger.kernel.org, AJvYcCXCHkVACvWht4bNmkPh2jJmFcyiiaqV93CxpUW+xv+GPrx8BHvDv5RT2wtfl8myQhsDeKeLko3NPy1gsCQ6HX+Z@vger.kernel.org
X-Gm-Message-State: AOJu0YyzxrubCpYAyqD7x6jlJeTMh2TuTjcLh8gCg/joweyxtmPk2Gah
	V+KGIGZglPf/zCvYakZJ71ibdQVTZ2vBf+ePe2zYi2eLOmlxK1l8
X-Gm-Gg: ASbGncur80fvNO6KFA11CD62ZuB4AZ25qjEM2kOpsLJr2Okfk7CT95Pv30Auyqh+1ZW
	5A7HT4iH3OH1soYR6VesJKmIdgKWG033LXQdTfE7epTye4BWfb7zsPxASZFryfSSaxJFqFOe5NF
	ADb5uPAzccpHSo3NpAgCJ/Ttq3VriZXZQysRpiu1OK4tINnjM+XNtaoGhC0jmrRZ8Z9zjwvQV7r
	L0HAEn76SFuWmXrjr2pUixuhi7gG0db2cecIBjio537UYjpO3XGWu50/aJbr6wCanpKeTC//PhF
	2FIfMP2jAJ56Exh2W2aVTgodFpyzPHIxT2DlHj94f6i45/P3F4J/3kFg7CY5wrRPx5hyXmJnTyN
	q8qPQ9DFdaWtNXOrLAXLsNJBldYWail6M
X-Google-Smtp-Source: AGHT+IF7fuTwyISchVVytHDMJeeoIfh3ZpQJUt8rRdvlwIphExmlssHSJ85LTIMEOJAJqtrSBebVEg==
X-Received: by 2002:a17:906:31cf:b0:ab7:8fcd:1f1b with SMTP id a640c23a62f3a-ab78fcd2196mr966938266b.7.1739099456462;
        Sun, 09 Feb 2025 03:10:56 -0800 (PST)
Received: from corebook.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab79afc7452sm357516366b.163.2025.02.09.03.10.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Feb 2025 03:10:56 -0800 (PST)
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
Subject: [PATCH v6 net-next 08/14] netfilter: nf_flow_table_inet: Add nf_flowtable_type flowtable_bridge
Date: Sun,  9 Feb 2025 12:10:28 +0100
Message-ID: <20250209111034.241571-9-ericwouds@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250209111034.241571-1-ericwouds@gmail.com>
References: <20250209111034.241571-1-ericwouds@gmail.com>
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

