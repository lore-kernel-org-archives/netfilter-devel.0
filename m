Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F44C1EA7E5;
	Tue, 25 Feb 2025 20:16:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740514599; cv=none; b=PeVcgkQsplMESYc+RfMtkxAamYg0KUzg4BDfdbkmor6/XbcP9bNK2BB8m4XaO8OzeO09fM9TeAFHhSTYCAJ7C53SID0bNRMSJhVK22ej+OUkn9Fazx2nEFZe7aap7540Wlt/9L5OlngN+s1FpnQZt8P03E6QUrS/V0F69JFdiEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740514599; c=relaxed/simple;
	bh=AihhYJGwJTJyObdFZSI/rxytC55wEnFe8EzDy7l8A+0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sYyyHC21iYDppyzjPow99tJOkq8HLRFMF+iBy3nWuvze1aMevyi6LvYYNOG7DIHaxoDpoqIErxc/NFQtkJ9/Uz/2KgGW0qamYvyNuOTunMfMa1xZWYKdFetuFUEWg/d1v6JAiSuJr9DFc1BqdFJOwapxjF7yh0FzpSoG1P8IS1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lD+zungb; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lD+zungb"
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-abb7f539c35so1171742666b.1;
        Tue, 25 Feb 2025 12:16:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740514595; x=1741119395; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6/OfFtkDCpNUsNNnB4udxCcQxzWSEZIHYYoj3YjYWKw=;
        b=lD+zungbhxNk7qDmVyyHtMprmtekP8uw7HK0kouHUl0WX9wOghALmj+Dy0kTk7zAnK
         8rM5ec1bFlP+KCfSiH0gymvYvDRkNaAXFwFxAODr2yW55NUr3Boc5kuE/G/z1vRhybOF
         wBD00XxAlFBJId15mg20DFb/MXTDwJSJ6AzO9nl6yNvGcCAZsi4vqrytNaAnY3d0extw
         KPswjU4hvDxQY6UAgLtlndKRCv8yAXBERI5gOhOLORuolrzDa0GhDfTTrK5D0nfvNaqG
         M8wxpP5mAgmZkkfUmlRLePs/AvSaWSqjqVISfxvFUsDgwM5ZaQ1ZHcjjPyuObXs8zYOW
         yB5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740514595; x=1741119395;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6/OfFtkDCpNUsNNnB4udxCcQxzWSEZIHYYoj3YjYWKw=;
        b=WmvzmBfbX3rAY/Jwuu0qSEpzGOFMvztjp7E7o3kDUAhoeVKJJIT2miFnUZuaEZMevh
         XxmRmBx2Tezs1iM40tag3LBFvZFt1KndYby1VPj0xIxU+Y0hKBEN1lkjnUf5SQK3g8qv
         yGuzN5kBc0D0wI4kuXvuPAJTXYw9PUlE+lynckEi/6CeyHO3CMIp9zAkCKCJ2JVF1tw8
         zPH92EDqeV3YaRjdcRudyUim4OtmdCJ75QqNZ7hJmPvqwQO2rBPZI/lqigAyDbZ76Mz0
         zBlHmAHL0uKOA1HZMYod6JelfdR3GEoAqFopHOtJV61EkthP1121pKVHEiv/MTrWY1yT
         hA/A==
X-Forwarded-Encrypted: i=1; AJvYcCVMWfWAx+fMYOQVbDDmvCq8BVfanKzFiXbvC0WSWtc25XLntIlld6VERaHqgKl5754K00f/MwRAczJmU+QZGE+a@vger.kernel.org, AJvYcCWgu1PG8kQfXwstEtF+s1qvp+xSa1nPM+H628yaroTXhvEf0BSH0b/PmP0E2i3CcAFSOnj+EguQUYGCWAg=@vger.kernel.org
X-Gm-Message-State: AOJu0YwBASvugI4hSJhpnCmxXwkZ+QLGEqIfQSqOHQ4qHe/kVpmIZpd1
	uR4dfM0+VWmVt5uPEzlGn6Mx+K6oL/ey2NjZ3NxeAPrjuYV3vuy7
X-Gm-Gg: ASbGnctEfYqLMDtR57yzIGsXJyO9nBvxAyCiLWcyEoZCo4dBTHk/U4TEh14tMOU2tww
	MlLDN69KWP9biVbYpZrVUf/7H44lMnlmfOwV546OuaanNFDseIJDYbwxt/yeqJcEiLqE1ArKV3g
	JjrXIQRfpdK1axlwjfRA0SViouizLy9wOwW8gz6Low90tX1CI8Ax9BoHGng+DxfXjdBThxBmPIw
	hBGi7w/vGS6fg/J11Mq1nFH5G6QzVtPBhKpNmw23/rpAuUZD7l8lwEjjNKmcveHaqCCS3J8QsYA
	+nq5hF9QSzpYNEMeIWkV3OHIkTS0liXqHdLDB6T3zJZYKVdtiK/3mqI2bi4w6SBIaNuq4/rhvII
	abu60VTWuqoD6Rve+4ScK0LJie/2q6QGWOhwxgpoIhrQ=
X-Google-Smtp-Source: AGHT+IGqtwnhdQCtSmqLRlPPBdMfue3nuq7Am6Qo/bcDgts/ZRrpNQ6gtoEj1aOcPx9OCd4I+DxgEQ==
X-Received: by 2002:a17:907:1ca4:b0:ab6:d575:9540 with SMTP id a640c23a62f3a-abed1076c86mr522915866b.50.1740514594765;
        Tue, 25 Feb 2025 12:16:34 -0800 (PST)
Received: from corebook.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-abed201218fsm194319666b.104.2025.02.25.12.16.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Feb 2025 12:16:34 -0800 (PST)
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
Subject: [PATCH v7 net-next 08/14] netfilter: nf_flow_table_inet: Add nf_flowtable_type flowtable_bridge
Date: Tue, 25 Feb 2025 21:16:10 +0100
Message-ID: <20250225201616.21114-9-ericwouds@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250225201616.21114-1-ericwouds@gmail.com>
References: <20250225201616.21114-1-ericwouds@gmail.com>
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

