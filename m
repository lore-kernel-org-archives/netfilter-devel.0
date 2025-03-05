Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A1D820C013;
	Wed,  5 Mar 2025 10:30:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741170618; cv=none; b=s88gnREYe3KNrZTDzjpfz1/H8+nD4F5lZafnwhImWV4Xw/+RIaMgB90Gn5TGMpFMFwXoJ9Xn8VHGhTdILdqtGLDtCOawa8wwBQZdqVB9pu3NpzjU4YdziYyRcFU3yJSOk0GTTRDaUIFmBGoleKVD8NinICAqEU7v39xKjQHULvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741170618; c=relaxed/simple;
	bh=AihhYJGwJTJyObdFZSI/rxytC55wEnFe8EzDy7l8A+0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kI0IQ7L0qCBuATOF/ewrUnYtgLE+Af7fAnwMzAS+k0kdUxKdflWw5xZkjVQSwRujyDIQrc2Cn0N59qBYLou4yZxRxUJznkQIT8+K2SRarhxWcqutz8/AZVdnG8LwOExD24JBZ9kR7PQHdZKcqybyaM3GRSj2cvN4XY7C3FEIZqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Jp9LZkJu; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Jp9LZkJu"
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-5e0b70fb1daso11538419a12.1;
        Wed, 05 Mar 2025 02:30:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741170615; x=1741775415; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6/OfFtkDCpNUsNNnB4udxCcQxzWSEZIHYYoj3YjYWKw=;
        b=Jp9LZkJukQPoHRa/P7gi9+r1Y02ughjN3PjyGAkaMo60lvzgnpmW0KMvI1qMBmNa9n
         KwDi2lZIEcwEZ3nfFtEmOUHfMaR9YcqmO3ivzy43Sm4SSt/ldD+i3nR7tBDk3UYN8ADm
         134KHnIVCwB7h9KjWRVViqaap/APS3/SaXJa9V3B7leC0mirudluxdkcIhpWK3/yGcQS
         WdYaQPdzW0jKkzlYt2rq0dW6h6d62Goc6sdHS5rxYWMfMK/QDscKZwQCt0rjMjQ3dyyE
         BqNVEUhJ4Qccb5/mmpbgiTgQ4EWLQfyVqphGqomlVkpNbQh3PvhFeJ04QJRmiIeUyNgk
         8uvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741170615; x=1741775415;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6/OfFtkDCpNUsNNnB4udxCcQxzWSEZIHYYoj3YjYWKw=;
        b=j9yZADQ4JOAd3R7rXmtLUjA0E+ciYUL63xfi5PdrOWblTIETo2oecuO51rY6fostSM
         LeDiXK3qFzdhxZeRGQYZDP7mb/xztL2hk+Q8Ako3+tS6vEPec7tWMtE14ghE2nEDgEvV
         ZH0V2OqW0lY+qDL/dlpJSOmCzecxic2k7m9Ly/rKxh3iuLwAc9yWPq4n/PPQy27zv4nV
         w9FbmvOlpAExtVPgBBLfW+Ngji6ZOGzkTI3GKPeAlj2kpwy0slA1bvz9A5JMsJDVo/tl
         rEgngL24ZNaV34huoTpQD97/ejPCk4EDVfYncZPm4g30/npsIa06nAjo68CGQLnPv5F/
         4+tg==
X-Forwarded-Encrypted: i=1; AJvYcCU6obe1WWCjzh9OOeXZeYgVXby5igtllm6cM9Zf8J6q2cnJunZy6k9ONkr7wo10aAQ58AUQcA7iqNLJLdUx@vger.kernel.org, AJvYcCVvsbGKZPdUBX//KydpeJIVnnAuABQsVlTSzVR6pga2QAmzIdAus/ddvqmS0S1xU5i93egdJH9ucO12oJUBV+vY@vger.kernel.org, AJvYcCWEwk7PElHWQWOCL80xY3otAyuftFEnJrxnoJ8MFK1cXQc6IHso3Cuy2B8I+XfJ0A/rHqSDuHzqvOCRgE58WVU=@vger.kernel.org
X-Gm-Message-State: AOJu0YwiaTNIcfWDJPhN3V74sGIoJfo/SRMDbzMfZAxvtjNNpQRc6mXE
	iLbAanmAqUQvPuEJZbiUh3uGHR4T7LJHK2Z3isVxSovIO0jDuAok
X-Gm-Gg: ASbGncvf/J/NPnQjqAxf6x3dqAi8G7YhsWeUtibal2d61E4bgU5vApL0rMZ/W2vHLha
	EPAoigr7qfCIINt55Nv4KgQCGvfXVX8UugX39szBcqmH4nwyDhkgefw3e0DeERFKQYDOBRUM2E+
	Wj8Aw/RoifNK/Zd0p5W50O9XgN4dw6qGVTrkku+0v/EY+QXZC2S1ASs8jvDkX4ykHN93KdRYi8o
	dsicEsv+utkWkncUHTeeI/HufNGNZLtP7A6v3DVlvBpGV09ON+8VevKlKAO77vGesbyHs2qlaL7
	FOZgTgJbPjbKEhQeEf5ykGMLExwBW4NZL4b99JfRGkOJa2TdVSsKN+awyD7eN3UhpQ+e7XlOH3j
	5JWLri3dUr8L4aheEDnVMNQXbOGDg2oChF98XZJ6A58vZFxauWDm176FtJS4dGA==
X-Google-Smtp-Source: AGHT+IE4FBEQwtKjza4fXvfpF7ocHLI/77Iaa2ed5/2y+GnUe2UR6+/DugyKaB64GhmbWBt7MA+dgw==
X-Received: by 2002:a17:907:9726:b0:ac1:da09:5d32 with SMTP id a640c23a62f3a-ac20d84621cmr283526366b.6.1741170614628;
        Wed, 05 Mar 2025 02:30:14 -0800 (PST)
Received: from corebook.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac1f7161a4esm247154266b.161.2025.03.05.02.30.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Mar 2025 02:30:14 -0800 (PST)
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
Subject: [PATCH v9 nf 09/15] netfilter: nf_flow_table_inet: Add nf_flowtable_type flowtable_bridge
Date: Wed,  5 Mar 2025 11:29:43 +0100
Message-ID: <20250305102949.16370-10-ericwouds@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250305102949.16370-1-ericwouds@gmail.com>
References: <20250305102949.16370-1-ericwouds@gmail.com>
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

