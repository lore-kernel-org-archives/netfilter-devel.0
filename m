Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAB4222CBE6;
	Tue,  8 Apr 2025 14:28:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744122507; cv=none; b=FXN45w8IYPCzLIRtvkKYUUrnVfvY17BTOX4oSrUcP65wU8JK0K+o02+KWjV19pUgGaye1U+oerxwUQM1Ecap71x+gSnjwGgETpowqxSaghSGV5KNI91kq0OFo35kN4QbKG9xbcRMPvb/Zs3EjaVg5nSbph/QCW4mt5/48EU6pPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744122507; c=relaxed/simple;
	bh=AihhYJGwJTJyObdFZSI/rxytC55wEnFe8EzDy7l8A+0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=URStS9NjbNJcDeNxPBLvDPgcSgK3lDmYrih7x1mHyyN8VDUG7WtdV7huddX64YCEisN0l2F0n/TY8HUUWqoms1RI3Q6ONZJr4CSRLzHwo/0vomDCFDZHs5iEPJv9ZjtRkB3Tfqwfb9UVQY8x/LoYgZKc8PrkmaCZ4jQ9+J8f0Oc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VGMAv+uL; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VGMAv+uL"
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-5e5dce099f4so7233790a12.1;
        Tue, 08 Apr 2025 07:28:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744122504; x=1744727304; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6/OfFtkDCpNUsNNnB4udxCcQxzWSEZIHYYoj3YjYWKw=;
        b=VGMAv+uLLklqWckdPANqw2YJUWE2KQKbO7Z5sYhv7JGJ4MxQBd928GE+vkB0tbDWyz
         HKdxA97SZkipSyGvIYj43RG0an2+yjINAj3c62aqqoONbLYGQo8ZnRFWmb4O6luLeL2Q
         r2VI5IIm8YQ+i8bLmD4vrYEej8hAmGWu0B0WY4EWxVWx2PZ94Bf82DcFHXx+X/fBz8Ww
         KtibYcG+ZyPKxsBno4e7rwNxDUjm7jQGfUTLgSnB+WWVPj3ViVTiPGuXdACTUAHnX07T
         VqzsUeTeXFZc5XI6D+WCdedM12OpFgYrJFyeV16L3OoMrFHocT2yeudHP+brRP/wo0ZV
         aCvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744122504; x=1744727304;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6/OfFtkDCpNUsNNnB4udxCcQxzWSEZIHYYoj3YjYWKw=;
        b=Qg4jA00x4CCPJTjwPc1if2gfYXwhGFWOamT4jgFl48DbkqBHM5I8ozefp2r/NLi/6t
         1fgrZa4ph+3QFd0wSDePmvxvAwe6D8GFCk2iPWLWjupL0lO7LTCdTFyAR2MpC9Fq7Sdt
         lA5kox3I5lMLFN/18GBZRBBZFrqUGDZzo7SaGS4G720oIaYIqxlXTe4dj3R6W4N/u9AV
         Ko0PqFDaGXbGhHkH9VstmyHsKmJjzN/+3ThGZ1k76cEqCXnkvVJxZzclFRPS3UlNHOW3
         URxtj/DPr68qU701MGRGpRXiyFuEKrMsHuRRJAtHyHNjva2ns5BM41S6Q81Hpoc1sWlQ
         NnAQ==
X-Forwarded-Encrypted: i=1; AJvYcCXpTMnEOhfwLqWJlpY52jxExyEOLF3Cjb8NlkO9qwKvOLdtqI/VEAywJdEjDBl814aLNADRToWRHxjvIhF5ruM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxNom8fC58dgQs8imdtwip60f6vlTeGppNTgq+bW6kjnDzRoWWP
	YruUSmW+HZk51237H3CCtALwhTZAjwtGKnBS7Rh4/CVElV5wzDN5
X-Gm-Gg: ASbGnctA/5Owo6j4Vwl4o5TFjT+7TZNKErNw2adsp6p0jhv4PXLBUYxxpoLhXwKYLVx
	BG2AKZ6nJtUMLs4tvyWnA5fb/eOcbYRqBgRgoIRyHAjYcDsN/fAjXMEuDJGv1x6R8AukEkDxdr9
	jx14AXPNorCEGlnEN9kJEOpCx65nEkflyix6TP2o1K8G718c0qodp6lJrSqKaRte5ndtT2QODhg
	XunF73SL3YEOnz/DLbhawdBwL5XzOxXl9Zikfz2jPx4uNAGVSZ+QeuRDh6eWH35rKVlaOkk2mF3
	n8IHS69vCY3bZAum3O60QAmKtfLSHNL0/E0S2CFYoAumgAKtOi9IXGsMnv2aKVxGxuwFkoae1D7
	/yAAruDfYhdI2bOWgHJhCL/yMlXYGRvzcfg8ixX0W0I6RTdwKtTOJN7Vz+gfKnUwco558EvZM0A
	==
X-Google-Smtp-Source: AGHT+IE8DeF9/ROALbTtdtAvbb+dCnvx2F7Ufu1W76Y3vukns31S/rwSv+gn+OGIBluIbjgDwHlDpA==
X-Received: by 2002:a05:6402:510e:b0:5e6:17fb:d3c6 with SMTP id 4fb4d7f45d1cf-5f0b661a45bmr12658780a12.25.1744122503881;
        Tue, 08 Apr 2025 07:28:23 -0700 (PDT)
Received: from localhost.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5f1549b3fd0sm2236164a12.35.2025.04.08.07.28.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Apr 2025 07:28:22 -0700 (PDT)
From: Eric Woudstra <ericwouds@gmail.com>
To: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@nvidia.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Ahmed Zaki <ahmed.zaki@intel.com>,
	Alexander Lobakin <aleksander.lobakin@intel.com>
Cc: netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	bridge@lists.linux.dev,
	Eric Woudstra <ericwouds@gmail.com>
Subject: [PATCH v11 nf-next 4/6] netfilter: nf_flow_table_inet: Add nf_flowtable_type flowtable_bridge
Date: Tue,  8 Apr 2025 16:28:00 +0200
Message-ID: <20250408142802.96101-5-ericwouds@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250408142802.96101-1-ericwouds@gmail.com>
References: <20250408142802.96101-1-ericwouds@gmail.com>
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

