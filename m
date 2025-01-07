Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5C711E4937;
	Tue,  7 Jan 2025 09:06:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736240777; cv=none; b=auGcBJn/mLXdUrwICtEsXwJHBA/iryqU8Ih5oUDCiwYd0WyXYTb1aslAKoMJDHGu+TnQvv0lEfjttTf9qYPeY8wfvYAztYuRqHAlwb6a2bZfpe4YiA6T2FBvcu5FDCODFT8Tlz2efPJBld75sq8G5pmxsztyXGXvTVfk3ZwwhWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736240777; c=relaxed/simple;
	bh=Xmg/u/sY6eLFrKn3iN8YG2bBcM9CQwqTudcQRkmzqU4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K/gqrEJ53BkXMsxvko/X8v33pNFszEQpY37sucP1v6oOyCnV0S3N1kJxaqobJtUJilwv7raASalqwlKoTkpU5zABrUiuMclo0Fs4mrtb+/bqlFJ+3preWbFKNbirodNDizAW+cxIJ/mkyyiDoEzz35QIt/BSNOeqFTU3yxI4XjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eqvW4nhs; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eqvW4nhs"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-aa6c0d1833eso3181670566b.1;
        Tue, 07 Jan 2025 01:06:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736240772; x=1736845572; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pk+qY6px5gG3FxqwFvW1Op3xt7LAoxtK3/4BHj1Cflg=;
        b=eqvW4nhssbGcYHRcGefSru9E9gQCOww2HALbaLnZl/B3+P/up4koW1/W2sAnyBl2oq
         MEWK1TmLgfoL41D8A3NnicFsiwkP0snydje2HQZYgsw6CapjOXmUXlex3D2DtDAWhmUk
         N2YrSB96pgbeJIC2R9DdxPWj8lYZk8la3SUWZrHD0WI6pxfWJ/IkK3XYPPqsOGa2Bm1r
         NmCSBgqXDP4j2kHkT6S0k0hpQbabyeWbTHNbAF04LoUgpSKtmqC1BMAE3RBhiLiRxpG1
         QkVGjG60sAPgSTODANVcDTO60Iat6ToJ/3pHEjmbQV08ko4NXnRxMrssppUsyNHsLh6Z
         gjoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736240772; x=1736845572;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pk+qY6px5gG3FxqwFvW1Op3xt7LAoxtK3/4BHj1Cflg=;
        b=n9qPzYgItGcFdvcvibZtRbvXd+5neW6pu6RhF7eGloM+qXcxIR92r0CzmsUUtJwZiW
         VEuO40tzCG/Ol6wddX5cbxv6lvyagvRax0zdSIjlz+NzMMwhGWuLZiwGXbH1JRLqopiw
         B6KoOIQaXlRzgAlRag0OSTddZbrW/jE6i8jySxdhT8okd0Mv1m4LBciRtnSW1vO0r0ce
         b0/gbk+GfOTFOEHqldWQb0XX8g/RFV7ujdk5IdPs0j83tySp8uMfeIPH4egPzHCwInyi
         BpFgV8Upi8W6p7uZoI/sR4bZGWd6Jybrbt/XNzC7VyKbjXu3fIQ0N9pV0/WjxDcwUuWn
         9ACg==
X-Forwarded-Encrypted: i=1; AJvYcCU55/c0c8IwN4o45mhvGnYeC46Zk9pq1RIUgJb7/1l/kd4G9Qzt+oyWaOZW6Dp2hR+ijw2NjUC2SXk18Gfu2MZ2@vger.kernel.org, AJvYcCWkOwkSQAXdpAW6Ejn5RmQSHdx/1EJG0xPN1onf46lYq7oEFXN0FH0VkrWiLv8fvei5xffFQ6/zrxIwPY0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxMG4XnEhkWlO5XkL3wOeh2cE/GpJv0WoIWX+U0CJKaosjTCPQU
	WqQLHtuJOnnDpxhTRfk62fxzzPo/LjAW06jg6oQD906rfSdf+NCH
X-Gm-Gg: ASbGnctjfp3pkPIIzQPi0eZDlyqBOOOZwObbB+k3SdewOPCAERgVneSRl4UmSUff94w
	73TxUyQ7NTfzvRjv2obnyLC0FO13OjcpU7jlwe8r6cJXdYQ+QLtKEso7sOJgE6r869MxjCBwBci
	0Vm5rXCwdLWsrGBVsh76wYg/DskMDdt2yp5J/A58lqas2rwh/dBWXUaZhAq02rJ6HHPS9+mIHsB
	sH/J7Uqn6kWs5v8ndelMUpKpCGC8dKB2RnvuJUkvkcCeEy5aJbWKfptlNZqfPK75GNNkKwnMq5B
	weYokvKXz6Ibk6ZeLvtLUzDUVQpO76x0Q0KSOYgdZbxqjK+C5t5n5VU3dFUeKrEiwYCldhppPQ=
	=
X-Google-Smtp-Source: AGHT+IHcdg7P37o5nMvJ75yJzAoKxUItlEfQvHhKvQ23cSiQG4/81rp2XgnxG7pSjApH8tUEJOEr7g==
X-Received: by 2002:a05:6402:35c7:b0:5d2:728f:d5f8 with SMTP id 4fb4d7f45d1cf-5d81de16998mr67591761a12.27.1736240771891;
        Tue, 07 Jan 2025 01:06:11 -0800 (PST)
Received: from corebook.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5d80676f3f9sm24005333a12.23.2025.01.07.01.06.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jan 2025 01:06:11 -0800 (PST)
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
Subject: [PATCH v4 net-next 07/13] netfilter: nf_flow_table_inet: Add nf_flowtable_type flowtable_bridge
Date: Tue,  7 Jan 2025 10:05:24 +0100
Message-ID: <20250107090530.5035-8-ericwouds@gmail.com>
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

