Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D841B21C9F8;
	Tue,  4 Feb 2025 19:50:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738698605; cv=none; b=BoCCwi4t+/BqvDGIBBcwjT9jp1csMdUNhuIcD0jbbv/nyu8LNiywsGJMeQFeyoQ9N+8x77w3UJ4yLCSjqZLglvRn4oK3dwx30I6qFDpI0abrxqX1Nz8L7IVfpSvRaAg6cb76D1BRkbaAdfZqo5VwCqp4DJrBw0TZXK7pIPgaXXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738698605; c=relaxed/simple;
	bh=Xmg/u/sY6eLFrKn3iN8YG2bBcM9CQwqTudcQRkmzqU4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qs4cugfb/IfVt4YuVGi41WBdhAbRGMXxW2Y97z7DHN2I6uS6Dc2jnesBHTPfNRBUny0sZIF4muCYDop7aefGbhyQNSsgDfrFoP1KipDlss2A0xo5Ejol09aCoKgKVAXIORtb+3KpTSUqImGfSl9hnEaCacrpeysgsmx7rzxnjIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=a0P0aXWi; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="a0P0aXWi"
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-ab74ecfdae4so142928766b.2;
        Tue, 04 Feb 2025 11:50:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738698601; x=1739303401; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pk+qY6px5gG3FxqwFvW1Op3xt7LAoxtK3/4BHj1Cflg=;
        b=a0P0aXWi46cnXHXjWr4XhG9fgJV1F/GvpR0OFIkh8HvGGLdN1gtoGH4XXF1/hv3ujO
         vewv9prDXE9EQfwG4FOz2MNMMeR1jwqlq5lzZiAe9iwNGBXEl3A08Ha64rbOfHkYsAiq
         1QfQvKpWuKkzka4fltVVo0ApvKgDwIyIB/4bJd18RZD92ok2/4shEBcEDjiWxyr7IfCO
         8La254MHx4bTcjr6yn7YiUfJ3Es54FZLiyNJbZco9YG22+pVgauHHU1YL/CGlzkFAaKO
         0IDzCeLKCTL3J1pKuDFXxuaGhMCiDL/upo3fyEkl0eoEE9bpdZwIpSGjrasz3vZZImwp
         ARnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738698601; x=1739303401;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pk+qY6px5gG3FxqwFvW1Op3xt7LAoxtK3/4BHj1Cflg=;
        b=eYbZXfgAciHSovJQstlOvhdrmXvELiV1+RiRadS0W8woIZtUM+bZ06TfuMSZEhY8au
         h3qUnpI8FxU0sBvSedQ9CSD4Lp4vOIsDMrtLRqknIJtSDNarN94g1CL2WbogSo+ICBnP
         rk6FTOXIRG3z6uLfmJKuEo2Nu+EuOc0rbWMYHhfaO6gfTT1nOGkP0wiQMRerbByzZolH
         ZDhWkD7HMnMpa/SfRPa13DVQA47g+/Arif4kWmM58HVLeV6i1+INNgpLe6Y4odpuTU5Z
         aHGpjbLz1fR63uJVLRbmhWdW3NhjttztfaIFwpaqOae9fH7DVT3s4tAEIjd+hf8Spxrz
         /s1w==
X-Forwarded-Encrypted: i=1; AJvYcCVs7V3FB8xas2M3yd1miMOuHh8mniloHFEclnUZ/l2WVg80pIur/DoJsD0/4q1WQXg7qoP2nRzP1AHKvug=@vger.kernel.org, AJvYcCWwnxqVZ+LvufqVMBJn7MEpA1h9H0eQ4meKz+esUJLlHfu82/6ELWbq+IfvSmQ8rjXbx+AAPOSg+J6SunqALscL@vger.kernel.org
X-Gm-Message-State: AOJu0Yz8aUHWAZSx9RbgTx1lV0oZhNdVgFopYbnIvoXsXtatWtLiNefa
	Q9AQ6/Ry4WtgfvmC9LLYxXBZGWHa8UTuDKOoNWHFa7nYnR2bbHo7
X-Gm-Gg: ASbGncsZg6Xlc/0rsa9BH+Y4nlbt0lc+MCUEw67KvTUKgC+s2oNfBUIP6WyVRFAc/+z
	a1HzUHDOKZJhJ3ozJR4WAD2JhSaTLiC8ncDuQpFu5V44wZA7+KTSH4NTdTHyf31jJEhuajqAf3r
	RPIpLgxwK2uQi0PFHO2Su5MXfS3+4S+XHSE0vWGY8z4ygCfKdFooVHyWaGTtplauUbh8riU8Ikw
	DOCU8MqtBi5uChSXf17aL/O5VUhh97MleoMwaCp6tr5VeXgPcrRuMdyOZsbJRG12sIoEkzLx3jO
	oWPk708Y2IsFrPIdd/CpmI7wZ/qMHEaGrs5lSUjc7HgXEc5oUnEDuvtlCIzX3VDw4+xL74YH7MZ
	Qw52jkRLPhB3YnQ42Dfrlycp8u6JW+/N5
X-Google-Smtp-Source: AGHT+IEajcS3ZyEn4iy3BF71r5OWuaA3wC0VPy1tuH9m7gdyTO3QjqxLaSnyY8eDmuFb6ii+jRnHzw==
X-Received: by 2002:a17:907:3f11:b0:ab2:d721:ed92 with SMTP id a640c23a62f3a-ab6cfdbe5a4mr2881889066b.45.1738698601046;
        Tue, 04 Feb 2025 11:50:01 -0800 (PST)
Received: from corebook.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab6e4a5635bsm964684466b.164.2025.02.04.11.50.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Feb 2025 11:50:00 -0800 (PST)
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
Subject: [PATCH v5 net-next 08/14] netfilter: nf_flow_table_inet: Add nf_flowtable_type flowtable_bridge
Date: Tue,  4 Feb 2025 20:49:15 +0100
Message-ID: <20250204194921.46692-9-ericwouds@gmail.com>
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
2.47.1

