Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39A66212D67;
	Tue, 10 Dec 2024 09:46:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733823987; cv=none; b=pex0NGPYSA3JVTjSHXp08iQkOxHO9m6VtwIFhACF5l4dS5+pf2x9Aw7iFKu+Rfr8GYAOTBX+iaC3o/m+i7XLAwQ90TcRjjRBhgcPQz/OPbFrknwGD+osMfKqDTuEAacTbe1V7Wr8ng13hhBw3WpK0OlW+Fl9X8kN80uRWKqAYjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733823987; c=relaxed/simple;
	bh=Xmg/u/sY6eLFrKn3iN8YG2bBcM9CQwqTudcQRkmzqU4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a+8Vu1fVwBL5tjLW/rbCv09YuIgrGR87wQG1wqp5EMufWge0DS+XEYAinDSBzbGIEkUZvkGbSt4Op2ECNAkR2f0U49iZrm7zOHRrjb61AyALL9uY0MTSRXaBS2SDP3Yay8QmVzIWBMacmoYQBdVXJrrrTHSDHspKOeDikl6YgMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FvwY5rnS; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FvwY5rnS"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-5d34030ebb2so7106062a12.1;
        Tue, 10 Dec 2024 01:46:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733823983; x=1734428783; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pk+qY6px5gG3FxqwFvW1Op3xt7LAoxtK3/4BHj1Cflg=;
        b=FvwY5rnSqqPHWNtMJrIF/NYUV+Xn1clSz93f8jSdzHy1wruqOQfHG1bdfP314j9LWf
         0WbYmIMPSH6xWaFlxfU2rtzKMo+n2xi1nMIpsfARJjjtE4hzNGJH090D40Ca8TAAndYw
         QWQuklkT7bkT/MoaWibcdLWJSGDQUPDETmB8zBKBlqrGrOcJLZBBu89b4NTo10rF63qw
         3VUUEFrTrIfX1xNFf9ZzGdZg08XT24HpPq3FR00PjWOktBazgYwnH9rafnZWdK2ouGkj
         hUYxIRAjMYKTH4B8iLSxdJ57XJ9q0CAJdztRGVnY4TlszJ9gvM54FtRcJZgue0aWEFlo
         Z7oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733823983; x=1734428783;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pk+qY6px5gG3FxqwFvW1Op3xt7LAoxtK3/4BHj1Cflg=;
        b=MKjtUHdfCjwbwvi+wlPaGnFsWpwEJj2E//R1WZSnI04eDCYV0fRL8JBBnFg4bhyXEy
         XFfxddPL0kPGyKnJxdg2mKWpJjD426/ELxA2CmXMh3KZwO9QZnRLa/VGyx+pP931iU6N
         k+houUr8PxIk+eF/yhBKbUQWZ68Bb0UoWy9IrNrAc36EwSv2cu4UKsWuUl/SvlhWN+uO
         xDNpi9FUSFZZeiGtsORWnjMvConrew6luUYm3x6Ux8MoSXDB6tk7ElTEln5x33B0i9ZB
         kvOyFP/flnxa/ty7bFMxXb47GtYE0YwPXwbKbmMECFpkCBlEWm8VmYWtEHndc4Amg3+7
         rPqw==
X-Forwarded-Encrypted: i=1; AJvYcCWGzI1fXxsnwqZEa9R3k/RAIkTQd2o8thOKstYVIOoGib5sAwZOCgDW6AObP4iur0/J8EkvuShSVyTk5GE=@vger.kernel.org, AJvYcCWyPfmU6WyDSek9NzWw73PKgr2c3rapUbsL+tQT6iFmNKBTU6Ufcvv4vlf/jE75rNhPRBYpDx/S0sLdmlk8Y08j@vger.kernel.org
X-Gm-Message-State: AOJu0Yy1w9eu+a30dkMCH3MysMWjhFxa35yaRpq/4MY6Sr+IxX9NqKN3
	q2ft4Fu6fS9smLhmDp09VzdnkSY0nUdpB+7Jj0puB03OgoTm5w4H
X-Gm-Gg: ASbGnctaHX7l4tAAMZLCXBX+CE0D87FAYEQpWoFPqBu2SH99rxIB/JBfv15W011F4K3
	UBUcxX/QSvg8CHU2KiGnQ+lh9mQ6xPR39bFHAhgRNJ1SDmqNmSyCXp0iRoIVy0olxIUJD91kBC1
	4xTCO6ABqybWzgZfIJ//CINMN8ZutQjBQo40n8BVnhxE9+wsQcv2PcfLfm/D8WWdkZBNXEdXS7j
	5aYBbujglFflj88e7YYB0d1Cj20h7jq5YiMLTSlE8hmpHHJctCuOMLTr+FcyIjsQVRil7CyzhaS
	4EvdYMPll/EvswgTMqrkJ/qmsgIa530fNC5SfWiInCQyyNxii4aWb6QJvTw4KmjWGCfYfMM=
X-Google-Smtp-Source: AGHT+IH4EN2bl4nM1hM4vW3lNE4AbT4jAUoKGNPh+jpctdHbiWVvzXPjIW3iNo8T8bSk3yNngjltIA==
X-Received: by 2002:a05:6402:3484:b0:5d1:2440:9b05 with SMTP id 4fb4d7f45d1cf-5d41862e405mr4691569a12.28.1733823983340;
        Tue, 10 Dec 2024 01:46:23 -0800 (PST)
Received: from corebook.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5d14b609e56sm7313936a12.40.2024.12.10.01.46.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Dec 2024 01:46:22 -0800 (PST)
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
Subject: [PATCH RFC v3 net-next 07/13] netfilter: nf_flow_table_inet: Add nf_flowtable_type flowtable_bridge
Date: Tue, 10 Dec 2024 10:44:55 +0100
Message-ID: <20241210094501.3069-8-ericwouds@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241210094501.3069-1-ericwouds@gmail.com>
References: <20241210094501.3069-1-ericwouds@gmail.com>
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

