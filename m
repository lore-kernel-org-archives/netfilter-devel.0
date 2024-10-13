Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8553156673;
	Sun, 13 Oct 2024 18:55:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728845746; cv=none; b=s5dNTduaohNZx1Gr+zxhMujMrULU5Y8WU0A2SsNKtMz9L78YirX+QnVoIjAOICBrNAflpTIlPfzMLFBG6aQxykQ+k9ArDlqAZZeI0GGzYjRX7sMAKvk5ELrGNPGJs/AZGldSGWu7MCb86u/UW8qxSX9yQ+TYYbScFF1UyZ3xIm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728845746; c=relaxed/simple;
	bh=lJyh0xDXdmHktWavY1MmbrQ/vBL7nLzt7QdbMKOj4K8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J7dWe3vA6Jtwg6kMuAimOXcrys60h9v9AtjLN9foWmMsYQ9y6Jf3Zaes9WordPo+cNFanJK3KYySZavcZLKQR2SpPqrYkBImxtJrl7LA/FLfaJyNZDMVLr+KB8N/O0EWcPGzTsjP6LjNvO7trv2wKYEh1ldaRo//1bowGA16bpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZpSJoyak; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZpSJoyak"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-5c9634c9160so1137955a12.2;
        Sun, 13 Oct 2024 11:55:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728845743; x=1729450543; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D6bOSx9F0JYNp5qomZcy7h/raSRvVGKNY4mEoIJa6U4=;
        b=ZpSJoyak0EjfLePOBMNSsEHPOj2pdw3k3wYfU37Z9ahxF1i5wF5ovX8c7Wb3VrWhQ1
         8pAV41C5TBS0eAqFrhLbCGXyArDQcd0MTr9Tc52O3dv0kqdrpGrmuuFS8ojrP3RQ/Jhu
         NN9+UpGqcmZ+Lh04WfsLWP4+C6ysDOVNEXcoOgH3eYpbim/QQ5bfJILjjIsY3+mLCQw/
         wCjtNGoQFe0VX6oVMIbQcflkamoAQ8jU01L8qZqDI+/JnXgXfSeBibFdOWhdddGGIXsn
         pNZvQn9Pnz4SRTzBZhA+I9oa+Raa9BRwK/yDlVkALwZ2RHBiRgjKXhOr4m4FwIoeK+Rg
         GsIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728845743; x=1729450543;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=D6bOSx9F0JYNp5qomZcy7h/raSRvVGKNY4mEoIJa6U4=;
        b=aPBc1DuUfTPVGlxz9HgWopbUos/vTMqLLq8hqGC3krskwGaexw173m1Q3oof510uga
         YvqNGIi6c4wFivIZe4tI14MQMKTtRivbHS1aN7h34HpkFQHVoHVjx+LifM8lNEys090M
         jn549nPBSPXkA3i3B+oXbR+Fh7UnqOfOHCLsbUCqOF/9RJRsSMz0dz+qkeoKPR/dm51J
         K0pEkggdFkU6OyTdgQHY94rO6qhYcofncHCE5q9ZY97Z3OJ8nQqBVZ7a3vUEGqIdI34g
         EVH0e8OT0wiGUd42aPi5W/INyi/OgPFwYeMNy050WoC7I3OMIUkNWXnxfCuKOB6VZU9B
         Uzkw==
X-Forwarded-Encrypted: i=1; AJvYcCVJrNBPUZbtaZiR0hOUDVtQzAwcAKmo8tncr8RBzihRiBISPsp/RKIbtuAPXyYyn/m+I2afTpOSL9nFQbEyEkX2@vger.kernel.org, AJvYcCWmJ1dIUDkI6UcSdB1PSuDk9ht5A5Zf6WiFIM7h8cq0+Uuyw9puuuFEgu64uuddgcCMDCAfi9Zrgv973Qk=@vger.kernel.org
X-Gm-Message-State: AOJu0YyGaQN9pAtCCEKABfLTZepS7OJoV93gmg95Bdjr78+G2REai9Wx
	AJpNEaWdd8FF558gnGnhv6YxV/UUVOfg3ongG9sy+6P+6+06P0aZ
X-Google-Smtp-Source: AGHT+IHvTGJJwOKJ7kLklzvX+Gh+CAxx5/4phzgEMN5pvFmXb1du5QSwwE/bUW/IN4TfeZh8VQTOOg==
X-Received: by 2002:a17:907:d01:b0:a8d:6648:813f with SMTP id a640c23a62f3a-a99b93239cemr785241466b.3.1728845743054;
        Sun, 13 Oct 2024 11:55:43 -0700 (PDT)
Received: from corebook.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9a12d384b9sm13500866b.172.2024.10.13.11.55.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Oct 2024 11:55:42 -0700 (PDT)
From: Eric Woudstra <ericwouds@gmail.com>
To: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Roopa Prabhu <roopa@nvidia.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Jiri Pirko <jiri@resnulli.us>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	"Frank Wunderlich" <frank-w@public-files.de>,
	Daniel Golle <daniel@makrotopia.org>,
	Eric Woudstra <ericwouds@gmail.com>
Cc: netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	bridge@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: [PATCH RFC v1 net-next 08/12] netfilter: nf_flow_table_inet: Add nf_flowtable_type flowtable_bridge
Date: Sun, 13 Oct 2024 20:55:04 +0200
Message-ID: <20241013185509.4430-9-ericwouds@gmail.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241013185509.4430-1-ericwouds@gmail.com>
References: <20241013185509.4430-1-ericwouds@gmail.com>
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

